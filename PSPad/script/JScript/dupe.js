// JavaScript Document
//*******************************************************************************
//	filename   : dupe.js
//	description: duplicate selected text or lines
//	created    : 5.19.2010
//	author     : ne1
//
//	You may distribute this script freely, but please keep this header intact.
//*******************************************************************************
var MODULE_NAME  = "_duplicate";
var MODULE_VER   = "0.1";
var MODULE_TITLE = "duplicate selected text or lines";
function Init() {
    menuName = "&" + MODULE_NAME;
//     subMenu = "&" + "Edit";
    subMenu = "";
    addMenuItem(menuName, subMenu, "main", "CTRL+ALT+D");
}

function main()
{
	var	ed = neweditor();
	ed.assignActiveEditor();
	var text = new String(ed.lineText());
	var curx = ed.caretX();
	var symb = ed.selText();

  ed.selText(symb)
  ed.selText(symb)

}

