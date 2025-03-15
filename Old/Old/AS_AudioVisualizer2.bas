B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.45
@EndOfDesignText@


Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object

	Private cvs As B4XCanvas
	Private FFT As xFFT
	Private NumBars As Int = 32
	Private NoiseThreshold As Double = 0.01
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback

End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	Tag = mBase.Tag
	mBase.Tag = Me

	FFT.Initialize
	
	cvs.Initialize(mBase)
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)

End Sub

Public Sub UpdateWithDB(dBValue As Double)
	Dim amplitude As Double = DBToAmplitude(dBValue)
    
	' FFT-Daten simulieren mit dem dB-Wert
	Dim fftData(NumBars) As Double
	For i = 0 To NumBars - 1
		fftData(i) = amplitude * (Rnd(50, 100) / 100) ' Leichte Variationen für Realismus
	Next

	' Zeichne die Balken mit dem umgerechneten Wert
	DrawSpectrum(fftData)
End Sub

Private Sub DBToAmplitude(dB As Double) As Double
	Dim amplitude As Double = 1.1 * Power(10, dB / 20)
	amplitude = Max(0, Min(1, amplitude))

	Return amplitude
End Sub


Private Sub DrawSpectrum(fftData() As Double)
	cvs.ClearRect(cvs.TargetRect)

	Dim barWidth As Float = mBase.Width / NumBars
	Dim maxAmplitude As Float = mBase.Height * 0.8

	For i = 0 To NumBars - 1
		Dim index As Int = i * fftData.Length / NumBars
		Dim sample As Double = fftData(index)

		If sample < NoiseThreshold Then
			sample = 0
		Else
			sample = (sample - NoiseThreshold) / (1 - NoiseThreshold)
		End If

		' Gaussian-Multiplier für eine natürliche Frequenzverteilung
		Dim exponent As Double = -Power((2 * i / NumBars - 1), 2) / 0.2
		Dim gaussianMultiplier As Double = Power(cE, exponent) ' cE = Euler-Zahl (≈2.718)

		sample = sample * gaussianMultiplier

		' Höhe der Balken berechnen
		Dim barHeight As Float = 10 + (maxAmplitude * sample)
		Dim left As Float = i * barWidth
		Dim top As Float = mBase.Height - barHeight  ' Balken von unten aufbauen
		Dim right As Float = left + barWidth * 0.8 ' Breite des Balkens

		' Balken zeichnen
		Dim rect As B4XRect
		rect.Initialize(left, top, right, mBase.Height) ' Unten auf mBase.Height setzen
		cvs.DrawRect(rect, xui.Color_White, True, 0)
	Next

	cvs.Invalidate
End Sub

