import { syntaxTree } from "@codemirror/language";
import { jsxTags, commonAttributes, tagAttributes, apis } from "./completionData";

function toOptions(list, type) {
  return list.map((item) => {
    if (typeof item === "string") {
      return { label: item, type };
    }
    const o = { label: item.name, type, detail: item.detail, info: item.info };
    if (item.values) {
      o.info = (o.info ? `${o.info} ` : "") + `可选: ${item.values.join(", ")}`;
    }
    return o;
  });
}

function findJsxOpenTagAncestor(state, pos) {
  let node = syntaxTree(state).resolveInner(pos, -1);
  for (let i = 0; i < 30 && node; i++) {
    if (node.name === "JSXOpenTag" || node.name === "JSXSelfClosingTag") {
      return node;
    }
    node = node.parent;
  }
  return null;
}

function readJsxTagName(state, openTagNode) {
  let ch = openTagNode.firstChild;
  while (ch) {
    if (ch.name === "JSXIdentifier" || ch.name === "JSXNamespacedName" || ch.name === "JSXMemberExpression") {
      return state.sliceDoc(ch.from, ch.to).toLowerCase();
    }
    ch = ch.nextSibling;
  }
  return null;
}

function scriptWidgetCompletions(context) {
  const { state, pos } = context;

  const dollarWord = context.matchBefore(/\$[\w$]*(?:\.[\w]*)?/);
  if (dollarWord && (dollarWord.from < pos || context.explicit)) {
    const text = dollarWord.text;
    const dot = text.indexOf(".");
    if (dot === -1) {
      const partial = text.slice(1).toLowerCase();
      const opts = apis
        .filter((a) => a.name.toLowerCase().startsWith("$" + partial) || a.name.toLowerCase().startsWith(text.toLowerCase()))
        .map((a) => ({ label: a.name, type: "variable", detail: "ScriptWidget API" }));
      if (opts.length) {
        return { from: dollarWord.from, options: opts, validFor: /^\$[\w$]*$/ };
      }
    } else {
      const base = text.slice(0, dot);
      const rest = text.slice(dot + 1);
      const api = apis.find((a) => a.name === base);
      if (api && api.methods && api.methods.length) {
        const from = dollarWord.from + dot + 1;
        const opts = api.methods
          .filter((m) => !rest || m.startsWith(rest))
          .map((m) => ({ label: m, type: "function" }));
        if (opts.length) {
          return { from, options: opts, validFor: /^[\w]*$/ };
        }
      }
    }
  }

  const tagOpen = context.matchBefore(/<\s*[\w.:]*$/);
  if (tagOpen) {
    const text = tagOpen.text;
    const rel = text.replace(/^<\s*/, "");
    const nameStart = tagOpen.from + text.length - rel.length;
    const partial = state.sliceDoc(nameStart, pos).toLowerCase();
    if (nameStart <= pos) {
      const opts = jsxTags
        .filter((t) => partial === "" || t.startsWith(partial))
        .map((t) => ({ label: t, type: "type", detail: "JSX" }));
      if (opts.length) {
        return { from: nameStart, options: opts, validFor: /^[\w.:]*$/ };
      }
    }
  }

  const openTag = findJsxOpenTagAncestor(state, pos);
  if (openTag) {
    const tagName = readJsxTagName(state, openTag);
    const lineFrom = state.doc.lineAt(pos).from;
    const lineText = state.sliceDoc(lineFrom, pos);

    const attrEq = lineText.match(/(\w+)\s*=\s*["']([^"']*)$/);
    if (attrEq && tagName) {
      const attrName = attrEq[1].toLowerCase();
      const partial = attrEq[2];
      const spec = (tagAttributes[tagName] || []).find((a) => a.name.toLowerCase() === attrName);
      if (spec && spec.values) {
        const from = pos - partial.length;
        const opts = spec.values
          .filter((v) => !partial || v.startsWith(partial))
          .map((v) => ({ label: v, type: "constant" }));
        if (opts.length) {
          return { from, options: opts, validFor: /^[^"']*$/ };
        }
      }
    }

    if (tagName && pos <= openTag.to) {
      const word = context.matchBefore(/[\w.-]+$/);
      if (word && word.from >= openTag.from && word.from < openTag.to) {
        const sliceBeforeWord = state.sliceDoc(openTag.from, word.from);
        if (/>/.test(sliceBeforeWord)) {
          return null;
        }
        const firstIdent = readJsxTagName(state, openTag);
        if (!firstIdent) {
          return null;
        }
        const afterTagName = sliceBeforeWord.includes(firstIdent) && sliceBeforeWord.trim().length > firstIdent.length + 1;
        if (afterTagName || /\s$/.test(state.sliceDoc(openTag.from, pos))) {
          const specific = tagAttributes[tagName] || [];
          const opts = [...toOptions(specific, "property"), ...toOptions(commonAttributes, "property")];
          return { from: word.from, options: opts, validFor: /^[\w.-]*$/ };
        }
      }
    }
  }

  return null;
}

export { scriptWidgetCompletions };
