// JavaScript Document
//*******************************************************************************
//	filename   : sel_word.js
//	description: Select word under cursor 
//	created    : 06.10.2006
//	author     : Serge Balance
//
//	You may distribute this script freely, but please keep this header intact.
//*******************************************************************************
var MODULE_NAME  = "Select Word";
var MODULE_VER   = "0.5";
var MODULE_TITLE = "Select current word";
function Init() {
    menuName = "&" + MODULE_NAME;
    subMenu = "&" + "Edit";
    addMenuItem(menuName, subMenu, "main", "CTRL+SHIFT+W");
}

function main() {
var	ed = neweditor();
ed.assignActiveEditor();
var line = new String(ed.lineText());
var curx = ed.caretX();
var cury = ed.caretY();
var cursymb, i, begPos, endPos;
var len = line.length;
i = curx - 1; //positions in line begin from 1 not from 0
while ((line.charAt(i).match(/\w/)) && (i<len)) {
	i++;
}
endPos = i - 1; //cicle ended when i point for one position over edge
i = curx - 1;
while ((line.charAt(i).match(/\w/)) && (i>=0)) {
	i--;
}
begPos = i + 1; //cicle ended when i point for one position under edge
ed.caretX(begPos + 1); //return to string index (from 1, not from 0 as in String)
len = endPos - begPos + 1; // substract that belong low edge, not low edge itself
//ed.command(ecSelRight);
for (i=0; i<len; i++) {
	ed.command("ecSelRight");
}
}
