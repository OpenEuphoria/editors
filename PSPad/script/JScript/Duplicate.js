// from the pspad forum new excention thread
// created : 13.12.2007 // author : Michael Vlasov // // You may distribute this script freely, but please keep this header intact.
//*******************************************************************************
var module_name = "_Duplicate";
var module_ver = "1.0";
var module_title = "Duplicate selection or current line, if no selection";
var menuName = "Utilities";

function Init() {
    menuName = "&" + module_name;
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