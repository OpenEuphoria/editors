/*******************************************************************************
  Filename:     clip_append.js

  Created:      Mon, 04 November 2007 20:04:28 GMT
  Created by:   Jan Schreiber (a.k.a. MrSpock)

*******************************************************************************/

// Constants:
var module_name = "clip_append";
var module_ver = "1.0";
var module_title = "clip_append";
var menu_name = "Utilities";

function Init()
{
  addMenuItem("Append to clipboard", menu_name, "append", "Ctrl+Alt+c");
  //addMenuItem("Edit script", menu_name, "openScript");
}

function append()
{
  var obj1 = newEditor();
  try
  {
    obj1.assignActiveEditor();
  }
  catch(e)
  {
    return;
  }
  var inpString = obj1.SelText();
  var clipString = getClipboardText();
  setClipboardText(clipString+inpString);
}

// function openScript()
// {
//   var obj1 = newEditor();
//   try
//   {
//     obj1.openFile(moduleFileName(module_name));
//   }
//   catch(e)
//   {
//     echo("Error opening file!");
//   }
// }
