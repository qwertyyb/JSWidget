(function () {
  // ── i18n ──
  const I18N = {
    en: {
      home_desc: 'Edit scripts on your phone from the computer',
      card_connect_title: 'Connect to Phone',
      card_connect_desc: 'Tap "Wait for PC" in the app, copy the Peer ID, then paste it below',
      card_wait_title: 'Wait for Phone',
      card_wait_desc: 'Generate a Peer ID, then tap "Enter PC ID" in the app and paste it',
      placeholder_peer_id: 'Paste Peer ID',
      btn_connect: 'Connect',
      btn_create: 'Create Connection',
      btn_back: '← Back',
      status_waiting: 'Waiting for phone to connect…',
      status_connecting: 'Connecting…',
      btn_copy: 'Copy',
      btn_copied: 'Copied',
      conn_connected: 'Connected',
      conn_disconnected: 'Disconnected',
      sync_synced: 'Synced',
      sync_dirty: 'Unsynced',
      sync_error: 'Sync Failed',
      btn_save: 'Save to Phone',
      btn_disconnect: 'Disconnect',
      overlay_title: 'Connection Lost',
      overlay_desc: 'The phone has closed the connection',
      btn_go_home: 'Back to Home',
      alert_connect_fail: 'Connection failed: ',
      alert_create_fail: 'Creation failed: ',
    },
    zh: {
      home_desc: '在电脑上编辑手机中的脚本',
      card_connect_title: '连接到手机',
      card_connect_desc: '在手机 App 内选择「等待电脑连接」，复制 Peer ID 后粘贴到下方',
      card_wait_title: '等待手机连接',
      card_wait_desc: '生成一个 Peer ID，在手机 App 内选择「输入电脑 ID」并粘贴此 ID',
      placeholder_peer_id: '粘贴 Peer ID',
      btn_connect: '连接',
      btn_create: '创建连接',
      btn_back: '← 返回',
      status_waiting: '等待手机连接…',
      status_connecting: '正在连接…',
      btn_copy: '复制',
      btn_copied: '已复制',
      conn_connected: '已连接',
      conn_disconnected: '已断开',
      sync_synced: '已同步',
      sync_dirty: '未同步',
      sync_error: '同步失败',
      btn_save: '保存到手机',
      btn_disconnect: '断开',
      overlay_title: '连接已断开',
      overlay_desc: '手机端已关闭连接',
      btn_go_home: '返回主页',
      alert_connect_fail: '连接失败: ',
      alert_create_fail: '创建失败: ',
    },
  };

  function detectLang() {
    const saved = localStorage.getItem('sw_editor_lang');
    if (saved && I18N[saved]) return saved;
    const nav = (navigator.language || '').toLowerCase();
    if (nav.startsWith('zh')) return 'zh';
    return 'en';
  }

  let currentLang = detectLang();

  function t(key) {
    return (I18N[currentLang] && I18N[currentLang][key]) || I18N.en[key] || key;
  }

  function applyI18n() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
      el.textContent = t(el.dataset.i18n);
    });
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
      el.placeholder = t(el.dataset.i18nPlaceholder);
    });
    document.documentElement.lang = currentLang === 'zh' ? 'zh-CN' : 'en';
    langToggle.textContent = currentLang === 'zh' ? '中文' : 'EN';
  }

  const langToggle = document.getElementById('lang-toggle');
  langToggle.addEventListener('click', () => {
    currentLang = currentLang === 'zh' ? 'en' : 'zh';
    localStorage.setItem('sw_editor_lang', currentLang);
    applyI18n();
    refreshDynamicText();
  });

  // ── DOM refs ──
  const homePanel = document.getElementById('home-panel');
  const waitPanel = document.getElementById('wait-panel');
  const connectingPanel = document.getElementById('connecting-panel');
  const editorPanel = document.getElementById('editor-panel');
  const disconnectedOverlay = document.getElementById('disconnected-overlay');

  const inputPeerId = document.getElementById('input-peer-id');
  const btnConnect = document.getElementById('btn-connect');
  const btnCreate = document.getElementById('btn-create');
  const btnBackWait = document.getElementById('btn-back-wait');
  const btnBackConnecting = document.getElementById('btn-back-connecting');
  const peerIdText = document.getElementById('peer-id-text');
  const btnCopyId = document.getElementById('btn-copy-id');
  const qrWrap = document.getElementById('qr-wrap');

  const connIndicator = document.getElementById('conn-indicator');
  const connLabel = document.getElementById('conn-label');
  const btnSave = document.getElementById('btn-save');
  const btnDisconnect = document.getElementById('btn-disconnect');
  const syncStatus = document.getElementById('sync-status');
  const syncDot = document.getElementById('sync-dot');
  const syncLabel = document.getElementById('sync-label');
  const editorRoot = document.getElementById('editor-root');
  const btnGoHome = document.getElementById('btn-go-home');

  let peer = null;
  let conn = null;
  let monacoEditor = null;
  let rpcId = 1;
  let lastSyncedContent = '';
  let currentSyncState = 'synced';
  let currentConnState = 'connected';

  const ICE_SERVERS = [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' },
    { urls: 'turn:81.71.162.5:3478', username: 'coturn', credential: 'coturn' },
  ];
  const PEER_OPTIONS = { debug: 3, config: { iceServers: ICE_SERVERS } };

  function refreshDynamicText() {
    syncLabel.textContent = t('sync_' + currentSyncState);
    connLabel.textContent = t('conn_' + currentConnState);
  }

  function showPage(page) {
    [homePanel, waitPanel, connectingPanel, editorPanel].forEach(p => p.classList.add('hidden'));
    page.classList.remove('hidden');
  }

  function setSyncState(state) {
    currentSyncState = state;
    syncStatus.className = 'sync-status ' + state;
    syncDot.className = 'sync-dot ' + state;
    syncLabel.textContent = t('sync_' + state);
  }

  function cleanupPeer() {
    if (conn) { try { conn.close(); } catch (_) {} }
    if (peer) { try { peer.destroy(); } catch (_) {} }
    peer = null;
    conn = null;
  }

  function goHome() {
    cleanupPeer();
    disconnectedOverlay.classList.add('hidden');
    showPage(homePanel);
    btnSave.disabled = true;
    qrWrap.innerHTML = '';
    peerIdText.textContent = '';
    inputPeerId.value = '';
    lastSyncedContent = '';
  }

  function onConnected() {
    currentConnState = 'connected';
    showPage(editorPanel);
    connIndicator.className = 'conn-indicator connected';
    connLabel.textContent = t('conn_connected');
    btnSave.disabled = false;
  }

  function onDisconnectedByRemote() {
    conn = null;
    currentConnState = 'disconnected';
    btnSave.disabled = true;
    connIndicator.className = 'conn-indicator disconnected';
    connLabel.textContent = t('conn_disconnected');
    disconnectedOverlay.classList.remove('hidden');
  }

  function loadMonacoTypes() {
    return fetch('./scriptwidget.d.ts').then(r => r.text());
  }

  function getMonacoTheme() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'vs-dark' : 'vs';
  }

  function bootMonaco(initialValue) {
    lastSyncedContent = initialValue || '';
    if (monacoEditor) {
      monacoEditor.setValue(initialValue || '');
      setSyncState('synced');
      return;
    }
    const vsPath = 'https://cdn.jsdelivr.net/npm/monaco-editor@0.50.0/min/vs';
    require.config({ paths: { vs: vsPath } });
    require(['vs/editor/editor.main'], () => {
      monaco.languages.typescript.typescriptDefaults.setCompilerOptions({
        allowNonTsExtensions: true,
        allowJs: true,
        jsx: monaco.languages.typescript.JsxEmit.React,
        jsxFactory: 'ScriptWidget.createElement',
        target: monaco.languages.typescript.ScriptTarget.ES2020,
        moduleResolution: monaco.languages.typescript.ModuleResolutionKind.NodeJs,
      });
      loadMonacoTypes().then(dts => {
        monaco.languages.typescript.typescriptDefaults.addExtraLib(dts, 'file:///scriptwidget.d.ts');
      }).catch(() => {});

      const modelUri = monaco.Uri.parse('file:///main.tsx');
      const model = monaco.editor.createModel(initialValue || '', 'typescript', modelUri);
      monacoEditor = monaco.editor.create(editorRoot, {
        model,
        theme: getMonacoTheme(),
        automaticLayout: true,
      });
      monacoEditor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, () => sendSave());

      monacoEditor.onDidChangeModelContent(() => {
        const current = monacoEditor.getValue();
        setSyncState(current === lastSyncedContent ? 'synced' : 'dirty');
      });

      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
        if (monacoEditor) {
          monaco.editor.setTheme(e.matches ? 'vs-dark' : 'vs');
        }
      });

      setSyncState('synced');
    });
  }

  function sendSave() {
    if (!conn || !monacoEditor) return;
    const id = rpcId++;
    const content = monacoEditor.getValue();
    conn.send({ id, method: 'save_content', params: { content, fileName: 'main.tsx' } });
  }

  btnSave.addEventListener('click', sendSave);

  function handleData(data) {
    if (!data || typeof data !== 'object') return;
    if (data.method === 'push_content' && data.params && typeof data.params.content === 'string') {
      bootMonaco(data.params.content);
      onConnected();
    }
    if (data.result && typeof data.result === 'object' && 'success' in data.result) {
      if (data.result.success) {
        lastSyncedContent = monacoEditor ? monacoEditor.getValue() : '';
        setSyncState('synced');
      } else {
        setSyncState('error');
      }
    }
  }

  function attachConn(c) {
    conn = c;
    c.on('data', handleData);
    c.on('close', onDisconnectedByRemote);
    c.on('error', (e) => console.error('conn error', e));
  }

  btnConnect.addEventListener('click', () => {
    const id = inputPeerId.value.trim();
    if (!id) return;
    showPage(connectingPanel);
    peer = new Peer(PEER_OPTIONS);
    peer.on('open', () => {
      const c = peer.connect(id, { reliable: true });
      attachConn(c);
      c.on('open', () => {});
    });
    peer.on('error', (e) => {
      alert(t('alert_connect_fail') + (e && e.message));
      goHome();
    });
  });

  btnCreate.addEventListener('click', () => {
    showPage(waitPanel);
    peer = new Peer(PEER_OPTIONS);
    peer.on('open', (id) => {
      peerIdText.textContent = id;
      const qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + encodeURIComponent(id);
      const img = document.createElement('img');
      img.src = qrUrl;
      img.alt = 'Peer ID QR';
      qrWrap.innerHTML = '';
      qrWrap.appendChild(img);
    });
    peer.on('connection', (c) => {
      attachConn(c);
      c.on('open', () => {});
    });
    peer.on('error', (e) => {
      alert(t('alert_create_fail') + (e && e.message));
      goHome();
    });
  });

  btnCopyId.addEventListener('click', () => {
    const id = peerIdText.textContent;
    if (id && navigator.clipboard) {
      navigator.clipboard.writeText(id);
      btnCopyId.textContent = t('btn_copied');
      setTimeout(() => { btnCopyId.textContent = t('btn_copy'); }, 1500);
    }
  });

  btnBackWait.addEventListener('click', goHome);
  btnBackConnecting.addEventListener('click', goHome);
  btnDisconnect.addEventListener('click', goHome);
  btnGoHome.addEventListener('click', goHome);

  const params = new URLSearchParams(window.location.search);
  const peerFromUrl = params.get('peer');
  if (peerFromUrl) {
    inputPeerId.value = peerFromUrl;
    btnConnect.click();
  }

  // Apply initial locale
  applyI18n();
})();
