'  Convert Indent Tabs to Spaces or Spaces to Tabs
'
' Posted by: phdesigner | Date: 04/30/2008 05:17 | IP: IP Logged
'
' This script converts the indent from tabs to spaces or spaces to tabs.
'
' PSPad does have an internal tabs to spaces function under Edit > Special Conversion but this changes ALL tabs to spaces, my script only converts leading tabs on a line to spaces.
'
' Download zip by copy and pasting this into your browser:
' (http://www.phdesign.com.au/download/convertindent_1_0.zip)
'
' Or save this code as a ConvertIndent.vbs in PSPad\Script\VBScript folder


'********************************************************************
' Author: Paul Heasley
' Website: www.phdesign.com.au
' Copyright (C) 2007 Paul Heasley
' Date: 19 February 2007
' Purpose: Converts indentation from spaces to tabs or visa versa.
'
'********************************************************************

Const module_name = "ConvertIndent"
Const module_ver = "1.0"

Const intMaxLineLength = "999999"

Sub Init
addMenuItem "Convert Indent to Spaces", "", "Tab2Spaces"
addMenuItem "Convert Indent to Tabs", "", "Spaces2Tab"
End Sub

Sub Tab2Spaces
Dim aryLines
Dim intIndent, i, j

intIndent = GetIndentWidth
If Len(intIndent) = 0 Then Exit Sub
aryLines = Split(HandleSelText(""), vbCrLf)

For i = LBound(aryLines) To UBound(aryLines)
'Set a maximum line length to avoid infinite loop
For j = 1 To intMaxLineLength
If Mid(aryLines(i), j, 1) = vbTab Then
aryLines(i) = Left(aryLines(i), j - 1) & Space(intIndent) & Mid(aryLines(i), j + 1)
'Adjust for the new length of the string
j = j + (intIndent - 1)
ElseIf Mid(aryLines(i), j, intIndent) = Space(intIndent) Then
j = j + (intIndent - 1)
Else
Exit For
End If
Next
Next

HandleSelText Join(aryLines, vbCrLf)
End Sub

Sub Spaces2Tab
Dim aryLines
Dim intIndent, i, j

intIndent = GetIndentWidth
If Len(intIndent) = 0 Then Exit Sub
aryLines = Split(HandleSelText(""), vbCrLf)

For i = LBound(aryLines) To UBound(aryLines)
'Set a maximum line length to avoid infinite loop
For j = 1 To intMaxLineLength
If Mid(aryLines(i), j, intIndent) = Space(intIndent) Then
aryLines(i) = Left(aryLines(i), j - 1) & vbTab & Mid(aryLines(i), j + intIndent)
ElseIf Mid(aryLines(i), j, 1) <> vbTab Then
Exit For
End If
Next
Next

HandleSelText Join(aryLines, vbCrLf)
End Sub

Private Function GetIndentWidth
GetIndentWidth = InputBox("Enter Indent Width", module_name, "4")

If Not IsNumeric(GetIndentWidth) Then
MsgBox "Invalid indent width. Indent width must be numeric.", vbExclamation, module_name
GetIndentWidth = ""
End If
End Function

Private Function HandleSelText(strText)
Dim objEditor

On Error Resume Next

Set objEditor = newEditor()
objEditor.assignActiveEditor

If strText = "" Then
'Get selected text
HandleSelText = objEditor.selText
If HandleSelText = "" Then
'No text was select. Get all text and select it.
HandleSelText = objEditor.Text
objEditor.command "ecSelectAll"
End If
Else
'Set selected text
objEditor.selText strText
End If
End Function