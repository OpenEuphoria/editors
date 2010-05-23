// from the pspad forum new excention thread
// created : 13.12.2007 // author : Michael Vlasov // // You may distribute this script freely, but please keep this header intact.
//*******************************************************************************
var MODULE_NAME = "_Duplicate";
var MODULE_VER = "1.0";
var MODULE_TITLE = "Duplicate selection or current line, if no selection";
function Init() {
    menuName = "&" + MODULE_NAME;
    addMenuItem(menuName, "", "main", "CTRL+D");
}
function main() {
    var ed = newEditor();
    ed.assignActiveEditor();
    var selection = ed.selText();
    if (selection != "") {
        ed.selText(selection + selection);
    } else {
        selection = ed.lineText();
        var saveCaretX = ed.caretX();
        ed.caretX(selection.length + 1);
        ed.selText("\r\n" + selection);
        ed.caretX(saveCaretX);
    }
}