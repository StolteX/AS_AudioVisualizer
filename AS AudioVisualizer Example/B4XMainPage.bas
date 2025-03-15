B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	Private recorder As AudioRecorder
	Private recording As Boolean

	Private AS_AudioVisualizer1 As AS_AudioVisualizer
	Private B4XComboBox1 As B4XComboBox
	Private B4XComboBox2 As B4XComboBox
End Sub

Public Sub Initialize
	
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("frm_main")
	
	B4XComboBox1.SetItems(Array As String("Spectrum","Waveform","FilledWave"))
	B4XComboBox2.SetItems(Array As String("1.0","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2.0"))
	
End Sub


Private Sub xlbl_Start_Click
	Dim FileName As String = "recording.m4a"
	Dim Dir As String = File.DirTemp
	recorder.Initialize(Dir,FileName, 44100, True, 16, False)
	recorder.As(NativeObject).SetField("meteringEnabled", True)
	recorder.Record
	recording = True
	Dim nRecorder As NativeObject = recorder
	Do While recording
		nRecorder.RunMethod("updateMeters", Null)
		Sleep(40)
		If recording Then
			'Log(nRecorder.RunMethod("averagePowerForChannel:", Array(0)).AsNumber)
			Dim dbValue As Double = nRecorder.RunMethod("averagePowerForChannel:", Array(0)).AsNumber
			AS_AudioVisualizer1.UpdateWithDB(dbValue)
		End If

	Loop
End Sub

Private Sub xlbl_Stop_Click
	recording = False
	recorder.Stop
End Sub

Private Sub B4XComboBox1_SelectedIndexChanged (Index As Int)
	AS_AudioVisualizer1.VisualizationType = B4XComboBox1.GetItem(Index)
End Sub

Private Sub B4XComboBox2_SelectedIndexChanged (Index As Int)
	AS_AudioVisualizer1.Sensitivity = B4XComboBox2.GetItem(Index)
End Sub