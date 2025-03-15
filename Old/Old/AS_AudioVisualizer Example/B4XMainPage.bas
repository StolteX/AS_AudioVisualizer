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
	Private AS_AudioVisualizer1 As AS_AudioVisualizer
	Private AS_AudioVisualizer2 As AS_AudioVisualizer
	Private AS_AudioVisualizer3 As AS_AudioVisualizer
	Private AS_AudioVisualizer4 As AS_AudioVisualizer
	Private AS_AudioVisualizer5 As AS_AudioVisualizer
	Private AS_AudioVisualizer6 As AS_AudioVisualizer
	Private AS_AudioVisualizer7 As AS_AudioVisualizer
	
End Sub

Public Sub Initialize
	
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("frm_main")
	
	B4XPages.SetTitle(Me,"AS_AudioVisualizer Example")
	
	Do While True
		Sleep(50)
		GenerateFakeFFTData
	Loop
	
End Sub


Sub GenerateFakeFFTData
	
	Dim fftData As List
	fftData.Initialize
	For i = 0 To 31
		fftData.Add(Rnd(0, 100) / 100.0)
	Next
	
	AS_AudioVisualizer1.Feed(fftData)
	AS_AudioVisualizer2.Feed(fftData)
	AS_AudioVisualizer3.Feed(fftData)
	AS_AudioVisualizer4.Feed(fftData)
	AS_AudioVisualizer5.Feed(fftData)
	AS_AudioVisualizer6.Feed(fftData)
	AS_AudioVisualizer7.Feed(fftData)
End Sub
