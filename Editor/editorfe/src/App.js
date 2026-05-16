import { useCodeMirror, EditorState, EditorView } from '@uiw/react-codemirror';
import { javascript } from '@codemirror/lang-javascript';
import { oneDark } from './darkTheme';
import React, { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import './App.css';
import prettier from "prettier/standalone";
import parserBabel from "prettier/parser-babel";
import { scriptWidgetCompletions } from './autoCompletion';
import { autocompletion } from "@codemirror/autocomplete";
import {
  setPeerDeps,
  disconnectPeer,
  startPeerHost,
  connectPeerTo,
  setOnStateChange,
} from './peerSync';

export default function App() {
  const [count, setCount] = useState(0);
  const editor = useRef();
  const [readonly, setReadonly] = useState(false);
  const readOnlyRef = useRef(false);
  const viewRef = useRef(null);
  const fileNameRef = useRef('main.jsx');
  const bridgeRef = useRef(null);

  const [peerState, setPeerState] = useState('idle');
  const [peerIdText, setPeerIdText] = useState('');
  const [connectInput, setConnectInput] = useState('');
  const [showConnectInput, setShowConnectInput] = useState(false);

  useEffect(() => {
    readOnlyRef.current = readonly;
  }, [readonly]);

  const isDarkTheme = () => {
    const metas = document.getElementsByTagName("META");
    const meta = metas.length > 1 ? metas[1].content : '';
    return meta.includes("theme:dark") === true;
  }

  const getContent = useCallback(() => {
    const v = viewRef.current;
    if (!v) return '';
    return v.state.doc.toString();
  }, []);

  const setContent = useCallback((text) => {
    const v = viewRef.current;
    if (!v) return;
    const tr = v.state.update({ changes: { from: 0, to: v.state.doc.length, insert: text } });
    v.dispatch(tr);
  }, []);

  const insertContent = useCallback((text) => {
    const v = viewRef.current;
    if (!v) return;
    const start = v.state.selection.main.from;
    v.dispatch(v.state.update({ changes: { from: start, insert: text } }));
    v.dispatch(v.state.update({ selection: { anchor: start + text.length } }));
  }, []);

  const formatCode = useCallback(() => {
    const v = viewRef.current;
    if (!v) return;
    const code = v.state.doc.toString();
    const formatted = prettier.format(code, {
      parser: "babel",
      plugins: [parserBabel],
    });
    const tr = v.state.update({ changes: { from: 0, to: v.state.doc.length, insert: formatted } });
    v.dispatch(tr);
  }, []);

  const handleStartHost = useCallback(() => {
    startPeerHost((peerId) => {
      setPeerIdText(peerId || '');
    });
  }, []);

  const handleConnectTo = useCallback(() => {
    const trimmed = connectInput.trim();
    if (!trimmed) return;
    setShowConnectInput(false);
    setConnectInput('');
    connectPeerTo(trimmed, () => {}, () => {});
  }, [connectInput]);

  const handleDisconnect = useCallback(() => {
    disconnectPeer();
    setPeerIdText('');
  }, []);

  useEffect(() => {
    setOnStateChange((state) => {
      if (state === 'idle' || state === 'disconnected' || state === 'error') {
        setPeerState('idle');
        setReadonly(false);
        setPeerIdText('');
      } else if (state === 'connecting') {
        setPeerState('connecting');
      } else if (state === 'hosting') {
        setPeerState('hosting');
        setReadonly(true);
      } else if (state === 'connected') {
        setPeerState('connected');
        setReadonly(true);
      }
    });
  }, []);

  const extensions = useMemo(() => {
    const items = [
      javascript({ jsx: true }),
      autocompletion({ override: [scriptWidgetCompletions] }),
      EditorView.updateListener.of((v) => {
        if (v.docChanged) {
          viewRef.current = v.view;
        }
      }),
      EditorState.readOnly.of(readonly),
    ];
    if (isDarkTheme()) {
      items.push(oneDark);
    }
    return items;
  }, [readonly]);

  const { setContainer, view } = useCodeMirror({
    container: editor.current,
    extensions,
    value: '',
  });

  useEffect(() => {
    viewRef.current = view;
  }, [view]);

  const isBridgeValid = () => {
    if (window.webkit) return true;
    return false;
  }

  const setupWKWebViewJavascriptBridge = (callback) => {
    if (window.WKWebViewJavascriptBridge) {
      // eslint-disable-next-line no-undef
      return callback(WKWebViewJavascriptBridge);
    }
    if (window.WKWVJBCallbacks) {
      return window.WKWVJBCallbacks.push(callback);
    }
    if (window.webkit) {
      window.WKWVJBCallbacks = [callback];
      window.webkit.messageHandlers.iOS_Native_InjectJavascript.postMessage(null)
    }
    console.log('Can not create valid bridge')
  }

  const initialize = () => {
    console.log('initialize');

    setupWKWebViewJavascriptBridge(function (bridge) {
      bridgeRef.current = bridge;

      setPeerDeps({
        getBridge: () => bridgeRef.current,
        getContent,
        setContent,
        getFileName: () => fileNameRef.current,
        log: (t) => console.log('[peer]', t),
      });

      function log(text) {
        console.log(text);
        bridge.callHandler('event_printLog', {
          value: text
        }, function (response) {
          console.log(`log resopnse : ${response}`)
        })
      }

      bridge.registerHandler('editor_setValue', function (data, responseCallback) {
        log(`editor set value event received : ${data.value}`);
        if (data.fileName) {
          fileNameRef.current = String(data.fileName);
        }
        setContent(data.value);
        responseCallback({ result: 'ok' })
      })
      bridge.registerHandler('editor_insertValue', function (data, responseCallback) {
        log(`editor insert value event received : ${data.value}`);
        if (readOnlyRef.current) {
          responseCallback({ result: 'failed', message: 'readonly' })
          return;
        }
        insertContent(data.value);
        responseCallback({ result: 'ok' })
      })
      bridge.registerHandler('editor_getValue', function (data, responseCallback) {
        const value = getContent();
        responseCallback({
          result: 'ok',
          'value': value
        });
      })
      bridge.registerHandler('editor_setReadonly', function (data, responseCallback) {
        let value = data.readonly;
        if (value === undefined) { value = false; }
        setReadonly(value)
        responseCallback({
          result: 'ok',
          'readonly': value
        });
      })
      bridge.registerHandler('editor_formatCode', function (data, responseCallback) {
        formatCode()
        responseCallback({
          result: 'ok',
        });
      })

      bridge.callHandler('event_editorReady', {}, function (response) { })
    })
  }

  useEffect(() => {
    if (editor.current) {
      setContainer(editor.current);
      initialize();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [setContainer]);

  const renderPeerBanner = () => {
    if (peerState === 'idle') return null;

    if (peerState === 'connecting') {
      return (
        <div className="peer-banner">
          <span className="status-text">Connecting…</span>
        </div>
      );
    }
    if (peerState === 'hosting') {
      return (
        <div className="peer-banner">
          <span className="status-text">Waiting for PC — ID: {peerIdText}</span>
          <button className="btn-action" onClick={() => {
            if (navigator.clipboard) navigator.clipboard.writeText(peerIdText);
          }}>Copy ID</button>
          <button className="btn-disconnect" onClick={handleDisconnect}>Stop</button>
        </div>
      );
    }
    return (
      <div className="peer-banner">
        <span className="status-text">Remote editing active</span>
        <button className="btn-disconnect" onClick={handleDisconnect}>Disconnect</button>
      </div>
    );
  };

  const [showPeerMenu, setShowPeerMenu] = useState(false);

  const renderPeerControls = () => {
    if (peerState !== 'idle') return null;

    if (showConnectInput) {
      return (
        <div className="peer-banner disconnected">
          <input
            type="text"
            value={connectInput}
            onChange={e => setConnectInput(e.target.value)}
            placeholder="Paste Peer ID"
            style={{ flex: 1, padding: '4px 8px', borderRadius: 4, border: 'none', fontSize: 13 }}
            autoFocus
          />
          <button className="btn-connect" onClick={handleConnectTo}>Connect</button>
          <button className="btn-action" onClick={() => setShowConnectInput(false)}>Cancel</button>
        </div>
      );
    }

    if (showPeerMenu) {
      return (
        <div className="peer-banner disconnected">
          <span className="status-text">Remote Edit</span>
          <button className="btn-connect" onClick={() => { setShowPeerMenu(false); handleStartHost(); }}>Wait for PC</button>
          <button className="btn-action" onClick={() => { setShowPeerMenu(false); setShowConnectInput(true); }}>Enter PC ID</button>
          <button className="btn-disconnect" onClick={() => setShowPeerMenu(false)}>Cancel</button>
        </div>
      );
    }
    return null;
  };

  if (isBridgeValid()) {
    return (
      <div className="editor-wrapper">
        {renderPeerBanner()}
        {renderPeerControls()}
        <div className='editor' ref={editor} />
        {peerState === 'idle' && !showPeerMenu && !showConnectInput && (
          <button
            className="fab-remote"
            onClick={() => setShowPeerMenu(true)}
            title="Remote editing"
          >⇄</button>
        )}
      </div>
    );
  } else {
    return <div className='app'>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}> Click me </button>
      <button onClick={() => setContent(`count = ${count}`)}> Set Content </button>
      <button onClick={() => setReadonly(true)}> Set Readonly </button>
      <button onClick={() => insertContent('</')}> insert content </button>
      <button onClick={() => formatCode()}> format </button>
      <div className='editor' ref={editor} />
    </div>
  }
}
