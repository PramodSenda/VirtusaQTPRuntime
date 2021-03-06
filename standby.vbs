' Copyright 2004 ThoughtWorks, Inc. Licensed under the Apache License, Version
' 2.0 (the "License"); you may not use this file except in compliance with the
' License. You may obtain a copy of the License at
' http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law
' or agreed to in writing, software distributed under the License is
' distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
' KIND, either express or implied. See the License for the specific language
' governing permissions and limitations under the License.


Option Explicit

'qtApp = QTP app
'Test_Path = QTP Test project path 
'CurrentDirectory = This file path 
'qtTest =QTP test -sys var
'qtRefVbs =Associate function library - sys var 
Dim qtApp, Test_Path, CurrentDirectory, qtTest, Config, qtRefVbs

'QtLib = QTP required lib file
'QtObjectmap = QTP required QtObjectmap file
'QtBusinessLib = QTP required businessLib file
'QtTestData = QTP required testData file
'QtTestPlan = QTP required testPlan file
'QtTestSuites = QTP required testSuites file
Dim QtLib, QtObjectmap, QtBusinessLib, QtTestPlan, QtTestSuites, strTrustPath

'objFolder = obj Folder var
'colFiles = collection of files
'objFile =  obj File var
Dim objFolder, colFiles, objFile

Set qtApp = CreateObject("QuickTest.Application")
dim fso: set fso = CreateObject("Scripting.FileSystemObject")
' directory in which this script is currently running
CurrentDirectory = fso.GetAbsolutePathName(".")

qtApp.Launch
qtApp.Visible = True
Test_Path = CurrentDirectory
qtApp.Open Test_Path,False
Set qtTest = qtApp.Test
Set qtRefVbs = qtTest.Settings.Resources.Libraries
qtRefVbs.RemoveAll

' File ref dirs
setDirPath

'import vbs files
getFileContent QtLib
getFileContent QtObjectmap
getFileContent QtBusinessLib
'getFileContent QtTestData
isFileExist QtTestPlan

getFileContent QtTestSuites
msgbox "Associated Function Libraries are Imported Successfully."
'qtTest.Run

'perfectClose

Function isFileExist(pathfile)
	If (fso.FileExists(pathfile)) Then
	   importVbsFiles pathfile
	Else
	   msgbox "Test plan doesn't exist."
	End If
End Function

'Dir paths set for runtime vbs files which needs to import for Associate function library
'@return none
Function setDirPath()
	QtLib = CurrentDirectory & "\vtafRuntime\lib"
	QtObjectmap = CurrentDirectory & "\vtafRuntime\objectMaps"
	QtBusinessLib = CurrentDirectory & "\vtafRuntime\businessLib"
	'QtTestData = CurrentDirectory & "\vtafRuntime\testData"
	InitializePropFiles(CurrentDirectory& "\TestConfig.properties")
	QtTestPlan = CurrentDirectory & "\vtafRuntime\testPlans\" &  strTrustPath &".vbs"
	QtTestSuites = CurrentDirectory & "\vtafRuntime\testSuites"
End Function

'Get files from a specific dir path
'@param vbsfilepath dir path
'@return none
Function getFileContent(vbsfilepath)
	Set objFolder = fso.GetFolder(vbsfilepath)
	Set colFiles = objFolder.Files
	For Each objFile in colFiles
		Dim filedir
		filedir = vbsfilepath &"\" & objFile.Name
		importVbsFiles filedir
	Next
End Function

'importVbsFiles file to the Associate function library
'@param vbsfile file
'@return none
Function importVbsFiles(vbsfile)
	qtRefVbs.Add vbsfile,-1
End Function

Function InitializePropFiles(fileName)
	DIM fso
	SET fso = CreateObject ("Scripting.FileSystemObject")
	DIM strConfigLine,fConFile,EqualSignPosition, strLen, VariableName, VariableValue, propattrib, propvalue
	SET fConFile = fso.OpenTextFile(fileName)
	Set Config = CreateObject("Scripting.Dictionary")
	WHILE NOT fConFile.AtEndOfStream
	  strConfigLine = fConFile.ReadLine
	  strConfigLine = TRIM(strConfigLine)
	'msgbox strConfigLine
	propattrib=split(strConfigLine, "=")(0)
	propvalue=split(strConfigLine, "=")(1)

	If  propattrib = "testPlan" Then
			strTrustPath = propvalue
	End If
	WEND
	fConFile.Close

End Function

Function perfectClose()
	qtTest.Close
	qtApp.Quit

	Set qtRefVbs =  Nothing
	Set qtTest = Nothing
	Set qtApp = Nothing
End Function