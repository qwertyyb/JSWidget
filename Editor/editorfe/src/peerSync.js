/**
 * PeerJS session for ScriptWidget remote editing (single file).
 * Saves go through existing WKWebViewJavascriptBridge `event_editorSave`.
 */
import Peer from "peerjs";

let peer = null;
let conn = null;
let deps = null;
let onStateChange = null;

const ICE_SERVERS = [
  { urls: "stun:stun.l.google.com:19302" },
  { urls: "stun:stun1.l.google.com:19302" },
  { urls: "turn:81.71.162.5:3478", username: "coturn", credential: "coturn" },
];

const PEER_OPTIONS = {
  debug: 3,
  config: { iceServers: ICE_SERVERS },
};

function notifyState(state) {
  if (onStateChange) onStateChange(state);
}

export function setOnStateChange(cb) {
  onStateChange = cb;
}

export function setPeerDeps(d) {
  deps = d;
}

function getBridge() {
  return deps && deps.getBridge ? deps.getBridge() : typeof window !== "undefined" ? window.WKWebViewJavascriptBridge : null;
}

function log(msg) {
  console.log('[peerSync]', msg);
  if (deps && deps.log) deps.log(msg);
}

export function disconnectPeer() {
  if (conn) {
    try { conn.close(); } catch (_) {}
  }
  if (peer) {
    try { peer.destroy(); } catch (_) {}
  }
  peer = null;
  conn = null;
  notifyState('idle');
}

function attachConn(c) {
  conn = c;
  c.on("data", (data) => {
    log("received data: " + JSON.stringify(data).slice(0, 200));
    if (!data || typeof data !== "object") return;
    if (data.method === "save_content" && data.params && typeof data.params.content === "string") {
      const content = data.params.content;
      const bridge = getBridge();
      if (!bridge || !deps) {
        log("save_content: no bridge or deps");
        return;
      }
      deps.setContent(content);
      bridge.callHandler("event_editorSave", { value: content }, (response) => {
        const ok = response && response.result === "ok";
        log("save_content result: " + JSON.stringify(response));
        try {
          c.send({ id: data.id, result: { success: !!ok } });
        } catch (_) {}
      });
    }
  });
  c.on("close", () => {
    log("connection closed by remote");
    conn = null;
    notifyState('disconnected');
  });
  c.on("error", (err) => {
    log("connection error: " + (err && err.message));
  });
}

function pushCurrentScript() {
  if (!conn || !deps) return;
  const content = deps.getContent();
  const fileName = deps.getFileName ? deps.getFileName() : "main.jsx";
  log("pushing script to remote, length=" + content.length);
  try {
    conn.send({ method: "push_content", params: { content, fileName } });
  } catch (e) {
    log("push error: " + e.message);
  }
}

export function startPeerHost(onPeerId) {
  disconnectPeer();
  log("starting peer host...");
  notifyState('connecting');
  peer = new Peer(PEER_OPTIONS);
  peer.on("open", (id) => {
    log("host peer open, id=" + id);
    notifyState('hosting');
    if (onPeerId) onPeerId(id);
  });
  peer.on("connection", (c) => {
    log("incoming connection from remote");
    attachConn(c);
    c.on("open", () => {
      log("connection open, pushing script");
      notifyState('connected');
      pushCurrentScript();
    });
  });
  peer.on("error", (err) => {
    log("peer error: " + (err && err.message));
    notifyState('error');
  });
}

export function connectPeerTo(remotePeerId, onOpen, onError) {
  disconnectPeer();
  log("connecting to remote peer: " + remotePeerId);
  notifyState('connecting');
  peer = new Peer(PEER_OPTIONS);
  peer.on("open", () => {
    log("local peer open, now connecting to " + remotePeerId);
    const c = peer.connect(remotePeerId, { reliable: true });
    attachConn(c);
    c.on("open", () => {
      log("connected to remote peer, pushing script");
      notifyState('connected');
      pushCurrentScript();
      if (onOpen) onOpen();
    });
    c.on("error", (err) => {
      log("connection error: " + (err && err.message));
      if (onError) onError(err);
    });
  });
  peer.on("error", (err) => {
    log("peer error: " + (err && err.message));
    notifyState('error');
    if (onError) onError(err);
  });
}
