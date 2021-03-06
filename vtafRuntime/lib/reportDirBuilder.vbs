' Copyright 2004 ThoughtWorks, Inc. Licensed under the Apache License, Version
' 2.0 (the "License"); you may not use this file except in compliance with the
' License. You may obtain a copy of the License at
' http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law
' or agreed to in writing, software distributed under the License is
' distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
' KIND, either express or implied. See the License for the specific language
' governing permissions and limitations under the License.



'ProjectPath = "C:\Users\millesinghe\Desktop\Research\QTP\Report\FileBuilder"
'executionName = "ExecutionReport2014_02_19_13_21_23PM"

Dim fso, loggertxt, varWitertoReport:
 
Function createExectionReport() 

    dtMyDate =Year(Date) &"_"& Month(Date) &"_"&Day(Date)&"_"& Hour(Time)&"_"& Minute(Time)    &"_"& Second(Time)
	executionName = "ExecutionReport" & dtMyDate

	'InitializePropFiles(strPath& "\TestConfig.properties")

	
	set fso = CreateObject("Scripting.FileSystemObject")
	'Create a new folder
	newvtafreportPath = ProjectPath & "\vtafRuntime\testReports\vtafReport\" & executionName
	'msgbox newvtafreportPath
	
	fso.CreateFolder newvtafreportPath
	fso.CreateFolder newvtafreportPath & "\LogFile" 
	fso.CreateFolder newvtafreportPath & "\images" 
	'Set loggertxt = fso.CreateTextFile newvtafreportPath & "\LogFile\vtafsupportlog.txt", True
	sOriginFolder = ProjectPath & "\vtafRuntime\configs\ReportTemplete\"

	 sDestinationFolder = newvtafreportPath
	 'msgbox sOriginFolder
	 For Each sFile In fso.GetFolder(sOriginFolder).Files
	  If Not fso.FileExists(sDestinationFolder & "\" & fso.GetFileName(sFile)) Then
	   fso.GetFile(sFile).Copy sDestinationFolder & "\" & fso.GetFileName(sFile),True
	  End If
	 Next
	  Set varWitertoReport = fso.OpenTextFile(newvtafreportPath & "\LogFile\vtafsupportlog.txt", 8, true)
   
End Function

Function setLogger(str)
	 varWitertoReport.WriteLine(str)
End Function

