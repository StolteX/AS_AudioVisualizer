B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.45
@EndOfDesignText@
#Event: VisualizationUpdated
#DesignerProperty: Key: VisualizationType, DisplayName: Visualization Type, FieldType: String, DefaultValue: Bar, List: Bar|Line|Wave|Circular|Rainbow|MultiWave|Pulse
#DesignerProperty: Key: BarColor, DisplayName: Bar Color, FieldType: Color, DefaultValue: 0xFF007AFF
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object

	Private Canvas As B4XCanvas
	Private numBars As Int = 32 ' Anzahl der Balken in der Visualisierung
	Private visualizationType As String
	Private barColor As Int
	Private backgroundColor As Int
	Private rainbowColors() As Int
	Private secondaryColor As Int

	Public Amplitude As Double ' Amplitudenwert für die Visualisierung
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback

	Amplitude = 0
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	Tag = mBase.Tag
	mBase.Tag = Me
	InitRainbowColors
	Canvas.Initialize(mBase)

	visualizationType = Props.Get("VisualizationType")
	barColor = xui.PaintOrColorToColor(Props.Get("BarColor"))
	backgroundColor = xui.PaintOrColorToColor(Props.Get("BackgroundColor"))
	secondaryColor = xui.Color_ARGB(152, GetARGB(barColor)(1), GetARGB(barColor)(2), GetARGB(barColor)(3))
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	Canvas.Resize(Width, Height)
End Sub

Private Sub InitRainbowColors
	Dim numColors As Int = numBars
	Dim clr(numColors) As Int
	For i = 0 To numColors - 1
		clr(i) = xui.Color_ARGB(255, (i * 255 / numColors), 255, 255)
	Next
	rainbowColors = clr
End Sub

Public Sub UpdateAmplitude(NewAmplitude As Double)
	Amplitude = NewAmplitude
	DrawVisualizer
End Sub

Private Sub DrawVisualizer()
	Canvas.ClearRect(Canvas.TargetRect)
	mBase.Color = backgroundColor

	Dim RawData As List
	RawData.Initialize
	For i = 0 To numBars - 1
		RawData.Add(Amplitude)
	Next

	Select visualizationType
		Case "Bar"
			DrawBarVisualizer(RawData)
		Case "Line"
			DrawLineVisualizer(RawData)
		Case "Wave"
			DrawFilledWaveVisualizer(RawData)
		Case "Circular"
			DrawCircularVisualizer(RawData)
		Case "Rainbow"
			DrawRainbowVisualizer(RawData)
		Case "MultiWave"
			DrawFilledMultiWaveVisualizer(RawData)
		Case "Pulse"
			DrawPulseVisualizer(RawData)
	End Select

	Canvas.Invalidate
End Sub

Private Sub DrawFilledWaveVisualizer(RawData As List)
	Dim maxHeight As Float = mBase.Height
	Dim midHeight As Float = maxHeight / 2

	Dim Path As B4XPath
	Path.Initialize(0, midHeight)
	For i = 0 To numBars - 1
		Dim x As Float = i * (mBase.Width / numBars)
		Dim y As Float = midHeight + (RawData.Get(i) - 0.5) * (maxHeight * 0.8)
		Path.LineTo(x, y)
	Next
	Path.LineTo(mBase.Width, maxHeight)
	Path.LineTo(0, maxHeight)
	Path.LineTo(0, midHeight)
	Canvas.DrawPath(Path, secondaryColor, True, 0)
	Canvas.DrawPath(Path, barColor, False, 2dip)
End Sub

Private Sub DrawFilledMultiWaveVisualizer(RawData As List)
	Dim maxHeight As Float = mBase.Height
	Dim midHeight As Float = maxHeight / 2

	Dim Path As B4XPath
	Path.Initialize(0, midHeight)
	For i = 0 To numBars - 1
		Dim x As Float = i * (mBase.Width / numBars)
		Dim y As Float = midHeight + (RawData.Get(i) - 0.5) * (maxHeight * 0.8)
		Path.LineTo(x, y)
	Next
	Path.LineTo(mBase.Width, maxHeight)
	Path.LineTo(0, maxHeight)
	Path.LineTo(0, midHeight)
	Canvas.DrawPath(Path, secondaryColor, True, 0)
	Canvas.DrawPath(Path, barColor, False, 2dip)

	Dim secondPath As B4XPath
	secondPath.Initialize(0, midHeight)
	For i = 0 To numBars - 1
		Dim x As Float = i * (mBase.Width / numBars)
		Dim y As Float = midHeight - (RawData.Get(i) - 0.5) * (maxHeight * 0.8)
		secondPath.LineTo(x, y)
	Next
	secondPath.LineTo(mBase.Width, maxHeight)
	secondPath.LineTo(0, maxHeight)
	secondPath.LineTo(0, midHeight)
	Canvas.DrawPath(secondPath, secondaryColor, True, 0)
	Canvas.DrawPath(secondPath, barColor, False, 2dip)
End Sub

Private Sub DrawBarVisualizer(RawData As List)
	Dim barWidth As Float = mBase.Width / numBars
	Dim maxHeight As Float = mBase.Height

	For i = 0 To numBars - 1
		Dim barHeight As Float = RawData.Get(i) * maxHeight
		Dim x As Float = i * barWidth
		Dim rect As B4XRect
		rect.Initialize(x, maxHeight - barHeight, x + barWidth - 2dip, maxHeight)
		Canvas.DrawRect(rect, barColor, True, 0)
	Next
End Sub

Private Sub DrawLineVisualizer(RawData As List)
	Dim midHeight As Float = mBase.Height / 2 ' Basislinie bleibt konstant in der Mitte
	Dim prevX As Float = 0
	Dim prevY As Float = midHeight ' Startpunkt in der Mitte

	For i = 0 To numBars - 1
		Dim x As Float = i * (mBase.Width / (numBars - 1)) ' Letzte Bar am Ende setzen
		Dim yOffset As Float = (RawData.Get(i) - 0.5) * (mBase.Height / 2) ' Ausschläge nach oben/unten
		Dim y As Float = midHeight + yOffset ' Wellenform bleibt mittig

		' Die erste und letzte Bar müssen exakt auf der Mittellinie sein
		If i = 0 Or i = numBars - 1 Then
			y = midHeight
		End If

		' Zeichne eine fließende Linie
		Canvas.DrawLine(prevX, prevY, x, y, barColor, 2dip)

		prevX = x
		prevY = y
	Next
End Sub

Private Sub DrawCircularVisualizer(RawData As List)
	Dim centerX As Float = mBase.Width / 2
	Dim centerY As Float = mBase.Height / 2
	Dim radius As Float
	radius = Min(centerX, centerY) / 1.5

	Dim angleIncrement As Float = 360 / numBars
	For i = 0 To numBars - 1
		Dim angle As Float = i * angleIncrement
		Dim radian As Float = angle * cPI / 180

		Dim barHeight As Float = RawData.Get(i) * (mBase.Width / 4)

		Dim x1 As Float = centerX + CosD(angle) * radius
		Dim y1 As Float = centerY + SinD(angle) * radius

		Dim x2 As Float = centerX + CosD(angle) * (radius + barHeight)
		Dim y2 As Float = centerY + SinD(angle) * (radius + barHeight)

		Canvas.DrawLine(x1, y1, x2, y2, barColor, 2dip)
	Next

	Canvas.Invalidate
End Sub

Private Sub DrawRainbowVisualizer(RawData As List)
	Dim barWidth As Float = mBase.Width / numBars
	Dim maxHeight As Float = mBase.Height
	For i = 0 To numBars - 1
		Dim barHeight As Float = RawData.Get(i) * maxHeight
		Dim x As Float = i * barWidth
		Dim rect As B4XRect
		rect.Initialize(x, maxHeight - barHeight, x + barWidth - 2dip, maxHeight)
		Canvas.DrawRect(rect, rainbowColors(i), True, 0)
	Next
End Sub

Sub DrawPulseVisualizer(RawData As List)
	Dim maxHeight As Float = mBase.Height
	Dim centerY As Float = maxHeight / 2
	For i = 0 To numBars - 1
		Dim x As Float = i * (mBase.Width / numBars)
		Dim pulseHeight As Float = RawData.Get(i) * centerY
		Canvas.DrawLine(x, centerY - pulseHeight, x, centerY + pulseHeight, barColor, 2dip)
	Next
End Sub

#Region Properties

Public Sub getNumberOfBars As Int
	Return numBars
End Sub

#End Region

#Region Functions

'int ot argb
Private Sub GetARGB(Color As Int) As Int() 'ignore
	Private res(4) As Int
	res(0) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff000000), 24)
	res(1) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff0000), 16)
	res(2) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff00), 8)
	res(3) = Bit.And(Color, 0xff)
	Return res
End Sub

#End Region
