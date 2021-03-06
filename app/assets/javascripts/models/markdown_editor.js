//= require codemirror
//= require codemirror/addons/mode/overlay
//= require codemirror/addons/display/placeholder
//= require codemirror/addons/selection/mark-selection
//= require codemirror/modes/markdown
//= require codemirror/modes/gfm
//= require ot-text
//= require sharedb-client
//= require sharedb-codemirror
//= require reconnecting-websocket

class MarkdownEditor {
  constructor(opts) {
    ShareDB.types.map['json0'].registerSubtype(OTText.type);

    this.doc = this.connect().get('documents', opts.doc);
    this.editor = CodeMirror.fromTextArea(opts.el, {
      mode: "gfm",
      viewportMargin: Infinity,
      lineWrapping: true
    });

    this.broadcast();
  }

  connect() {
    const socket = new ReconnectingWebSocket(App.env.SHAREDB_URL);
    const connection = new ShareDB.Connection(socket);

    socket.onopen = (event) => { App.bus.$emit("changeTextEditorVisibility", true); };
    socket.onclose = (event) => { App.bus.$emit("changeTextEditorVisibility", false); };
    socket.onerror = (event) => { App.bus.$emit("changeTextEditorVisibility", false); };

    return connection;
  }

  broadcast() {
    ShareDBCodeMirror.attachDocToCodeMirror(this.doc, this.editor, {
      key: 'content',
      verbose: App.env.SHAREDB_OUTPUT
    });
  }
}
