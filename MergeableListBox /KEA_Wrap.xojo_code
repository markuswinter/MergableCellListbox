#tag Module
Protected Module KEA_Wrap
	#tag Method, Flags = &h0
		Function ContrastingTextColor(InputColor as Color) As Color
		  if (InputColor.Red*0.299 + InputColor.Green*0.587 + InputColor.Blue*0.114) > 128 then
		    Return &c000000
		  else
		    Return &cFFFFFE
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextBlock(Extends g as graphics , Paragraphs() as String,AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0)
		  g.DrawTextBlock(Paragraphs,0,0,g.Width, g.Height, AlignH, AlignV, LineSpacing)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextBlock(Extends g as graphics , Paragraphs() as String, x as integer, y as Integer , Width as Integer, Height as integer, AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim ubPGraph as Integer = Paragraphs.Ubound
		  
		  if ubPGraph < 0 Then
		    Return 
		  ElseIf(ubPGraph = 0 and Paragraphs(0).LenB = 0) then
		    ReDim Paragraphs(-1)
		    Return
		  End if
		  
		  If AlignH < 0 Or AlignH > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "DrawTextBlock: AlignH = " + str(AlignH)
		  ElseIf AlignV < 0 Or AlignV > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "DrawTextBlock: AlignV = " + str(AlignV)
		  End if
		  
		  Dim TextHt As Integer = g.TextHeight
		  Dim MinDrawHt As Integer = TextHt
		  Dim  StrWidth,pos  As Integer, Text As String
		  
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  
		  If LineSpacing < 0 OR Height < TextHt + LineSpacing +MinDrawHt  Then ' must draw single line
		    Text = Paragraphs(0) 
		    StrWidth = Ceil(g.StringWidth(Text))
		    If Paragraphs.Ubound > 0 and StrWidth < Width Then 
		      Text = Text + Ellipsis
		      StrWidth = Ceil(g.StringWidth(Text))
		    End if
		    
		    Select Case AlignH
		    Case AlignLeft, AlignDefault 
		      'X = X
		    Case AlignCenter
		      X = X + (Width -StrWidth)\2
		      
		    Case AlignRight
		      X = X + Width -StrWidth
		      
		    Else
		      Dim Err as new OutOfBoundsException
		      Err.Message = CurrentMethodName + ": undefined value for HorizAlign: " +str(AlignH)
		      Raise Err
		      
		    End Select
		    
		    If X < 0 then X = 0
		    
		    Select Case AlignV
		    Case AlignCenter, AlignDefault
		      g.DrawString Text,X, Y +(Height - TextHt)\2 + g.TextAscent, Width, TRUE
		    Case AlignTop
		      g.DrawString Text,X,Y+ g.TextAscent, Width, TRUE
		    Case AlignBottom
		      g.DrawString Text,X,Y + Height - TextHt + g.TextAscent, Width, TRUE
		    Else
		      Dim Err as new OutOfBoundsException
		      Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		      Raise Err
		      
		      
		    End Select
		    Return 
		  End if
		  
		  Const Space =32
		  Const Dash = 45
		  Dim X0 as Integer = X
		  Dim Lines() as String, isLastLine As Boolean
		  dim TotalHt,i, LeftCharPos, MidCharPos, RightCharPos as Integer
		  
		  ubPGraph = Paragraphs.Ubound
		  
		  Dim NeedsEllipsis As Boolean
		  
		  
		  For i = 0 to ubPGraph
		    Text = Paragraphs(i)
		    Do
		      TotalHt = TotalHt + TextHt' add TextHeight
		      If TotalHt > Height Then
		        TotalHt = TotalHt - TextHt
		        NeedsEllipsis = True
		        TotalHt = TotalHt + LineSpacing
		        Exit For
		      End if
		      
		      TotalHt = TotalHt + LineSpacing
		      
		      StrWidth = Ceil(g.StringWidth(Text))
		      
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      
		    Loop Until Text.LenB = 0
		  Next
		  TotalHt = TotalHt - LineSpacing
		  
		  if NeedsEllipsis Then
		    
		    Static JoinArr() as String = Array("",Ellipsis)
		    Dim NewWidth As Integer = Width - Ceil(g.StringWidth(Ellipsis))
		    Text = Lines(Lines.Ubound)
		    While text.LenB > 0 and g.StringWidth(Text) > NewWidth
		      Text = Text.Left(text.Len -1)
		    Wend
		    JoinArr(0) = text
		    Lines(Lines.Ubound) = Join(JoinArr,"")
		    JoinArr(0) = ""
		  End if
		  
		  Dim Ascent As Integer =  g.TextAscent
		  Select Case AlignV
		  Case AlignCenter, AlignDefault
		    Y = Max(Y + (Height - TotalHt)\2,Y) 
		  Case AlignTop
		    Y = Y 
		  case AlignBottom
		    Y = Max(Y,Y + Height - TotalHt) 
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		    
		  End Select
		  
		  ubPGraph = Lines.Ubound
		  
		  Select case AlignH
		  Case AlignLeft, AlignDefault
		    For i = 0 to ubPGraph
		      g.DrawString Lines(i).LTrim, X0 ,Y+ Ascent,Width, TRUE
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  CASE AlignCenter
		    '
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      If StrWidth > Width Then
		        g.DrawString Text, X0 ,Y+ Ascent,Width, TRUE
		      ElseIf ubPGraph = 0 then
		        X = X0 + (Width - StrWidth)\2
		        If X < 0 then X=0
		        g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      Else
		        g.DrawString Text, X0 +(Width - StrWidth)\2 ,Y+ Ascent,Width, TRUE
		      End if
		      Y = Y + TextHt + LineSpacing
		    Next
		  Case AlignRight
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      X= x0+ Width - StrWidth
		      if X < 0 then X = 0
		      g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for HorizAlign: " +str(AlignH)
		    Raise Err
		    
		  End Select
		  
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextBlock(Extends g as graphics , Text as String,AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0)
		  g.DrawTextBlock(Text,0,0,g.Width, g.Height, AlignH, AlignV, LineSpacing)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextBlock(Extends g as graphics , Text as String, x as integer, y as Integer , Width as Integer, Height as integer, AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0)
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  If Text.LenB = 0 then Return 
		  
		  If AlignH < 0 Or AlignH > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "DrawTextBlock: AlignH = " + str(AlignH)
		  ElseIf AlignV < 0 Or AlignV > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "DrawTextBlock: AlignV = " + str(AlignV)
		  End if
		  
		  Dim TextHt As Integer = g.TextHeight
		  Dim MinDrawHt As Integer = TextHt
		  Dim  StrWidth,pos  As Integer
		  
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  Text = ReplaceLineEndings(Text,EOL)
		  Dim Paragraphs() as String = Text.SplitB(EOL)
		  
		  
		  If LineSpacing < 0 OR Height < TextHt + LineSpacing +MinDrawHt  Then ' must draw single line
		    Text = Paragraphs(0) 
		    StrWidth = Ceil(g.StringWidth(Text))
		    
		    If Paragraphs.Ubound > 0 and StrWidth < Width Then 
		      Text = Text + Ellipsis
		      StrWidth = Ceil(g.StringWidth(Text))
		    End if
		    
		    Select Case AlignH
		    Case AlignLeft, AlignDefault 
		      'X = X
		    Case AlignCenter
		      X = X + (Width -StrWidth)\2
		    Case AlignRight
		      X = X + Width -StrWidth
		      
		    Else
		      Dim  Err as New OutOfBoundsException
		      Err.Message = CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH)
		      Raise Err
		      
		    End Select
		    
		    If X < 0 then X = 0
		    
		    Select Case AlignV
		    Case AlignCenter, AlignDefault
		      g.DrawString Text,X, Y +(Height - TextHt)\2 + g.TextAscent, Width, TRUE
		    Case AlignTop
		      g.DrawString Text,X,Y+ g.TextAscent, Width, TRUE
		    Case AlignBottom
		      g.DrawString Text,X,Y + Height - TextHt + g.TextAscent, Width, TRUE
		    Else
		      Dim  Err as New OutOfBoundsException
		      Err.Message = CurrentMethodName +": undefined value for VertAlign: " +str(AlignV)
		      Raise Err
		    End Select
		    Return 
		  End if
		  
		  Const Space =32
		  Const Dash = 45
		  Dim X0 as Integer = X
		  Dim Lines() as String, isLastLine As Boolean
		  dim TotalHt,i,ubPGraph, LeftCharPos, MidCharPos, RightCharPos as Integer
		  
		  ubPGraph = Paragraphs.Ubound
		  
		  Dim NeedsEllipsis As Boolean
		  
		  
		  For i = 0 to ubPGraph
		    Text = Paragraphs(i)
		    Do
		      TotalHt = TotalHt + TextHt' add TextHeight
		      If TotalHt > Height Then
		        TotalHt = TotalHt - TextHt
		        NeedsEllipsis = True
		        TotalHt = TotalHt + LineSpacing
		        Exit For
		      End if
		      
		      TotalHt = TotalHt + LineSpacing
		      
		      StrWidth = Ceil(g.StringWidth(Text))
		      
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      
		    Loop Until Text.LenB = 0
		  Next
		  TotalHt = TotalHt - LineSpacing
		  
		  if NeedsEllipsis Then
		    
		    Static JoinArr() as String = Array("",Ellipsis)
		    Dim NewWidth As Integer = Width - Ceil(g.StringWidth(Ellipsis))
		    Text = Lines(Lines.Ubound)
		    While text.LenB > 0 and g.StringWidth(Text) > NewWidth
		      Text = Text.Left(text.Len -1)
		    Wend
		    JoinArr(0) = text
		    Lines(Lines.Ubound) = Join(JoinArr,"")
		    JoinArr(0) = ""
		  End if
		  
		  Dim Ascent As Integer =  g.TextAscent
		  Select Case AlignV
		  Case AlignCenter, AlignDefault
		    Y = Max(Y + (Height - TotalHt)\2,Y) 
		  Case AlignTop
		    Y = Y 
		  Case AlignBottom
		    Y = Max(Y,Y + Height - TotalHt) 
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		    
		  End Select
		  
		  ubPGraph = Lines.Ubound
		  
		  Select case AlignH
		  Case AlignLeft,AlignDefault
		    For i = 0 to ubPGraph
		      g.DrawString Lines(i).LTrim, X0 ,Y+ Ascent,Width, TRUE
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  CASE AlignCenter
		    '
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      If StrWidth > Width Then
		        g.DrawString Text, X0 ,Y+ Ascent,Width, TRUE
		      ElseIf ubPGraph = 0 then
		        X = X0 + (Width - StrWidth)\2
		        If X < 0 then X=0
		        g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      Else
		        g.DrawString Text, X0 +(Width - StrWidth)\2 ,Y+ Ascent,Width, TRUE
		      End if
		      Y = Y + TextHt + LineSpacing
		    Next
		  Case  AlignRight
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      X= x0+ Width - StrWidth
		      if X < 0 then X = 0
		      g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for HorizAlign: " +str(AlignH)
		    Raise Err
		  End Select
		  
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FlowTextBlock(Extends g as graphics , Paragraphs() as String,AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0) As String()
		  Return g.FlowTextBlock(Paragraphs,0,0,g.Width, g.Height, AlignH, AlignV, LineSpacing)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FlowTextBlock(Extends g as graphics , Paragraphs() as String, x as integer, y as Integer , Width as Integer, Height as integer, AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0) As String()
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim ubPGraph as Integer = Paragraphs.Ubound
		  
		  if ubPGraph < 0 Then
		    Return Paragraphs
		   ElseIf(ubPGraph = 0 and Paragraphs(0).LenB = 0) then
		    ReDim Paragraphs(-1)
		    Return Paragraphs
		  End if
		  
		  If AlignH < 0 Or AlignH > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "FlowTextBlock: AlignH = " + str(AlignH)
		  ElseIf AlignV < 0 Or AlignV > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "FlowTextBlock: AlignV = " + str(AlignV)
		  End if
		  
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  
		  Dim TextHt As Integer = g.TextHeight
		  Dim MinDrawHt As Integer = TextHt
		  Dim  StrWidth,pos  As Integer, Text As String
		  
		  Const Space =32
		  Const Dash = 45
		  Dim X0 as Integer = X
		  Dim Lines() as String
		  dim TotalHt,i, LeftCharPos, MidCharPos, RightCharPos as Integer
		  Dim  HasExtraLines As Boolean
		  
		  ubPGraph = Paragraphs.Ubound
		  
		  For i = 0 to ubPGraph
		    Text = Paragraphs(i)
		    Do
		      TotalHt = TotalHt  + TextHt' add TextHeight
		      if TotalHt >Height Then
		        HasExtraLines = True
		        TotalHt = TotalHt - TextHt
		        TotalHt = TotalHt  + LineSpacing
		        Exit For
		      end if
		      TotalHt = TotalHt  + LineSpacing
		      StrWidth = Ceil(g.StringWidth(Text))
		      
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      'TotalHt = TotalHt + LineSpacing
		    Loop Until Text.LenB = 0
		  Next
		  
		  TotalHt = TotalHt - LineSpacing
		  
		  If HasExtraLines Then
		    Paragraphs(0) = Text
		    Dim Idx As Integer
		    For i = i + 1 to ubPGraph
		      Idx = Idx + 1
		       Paragraphs(Idx) = Paragraphs(i)
		    Next
		    ReDim Paragraphs(Idx)
		  End if
		  
		  Dim Ascent as Integer = g.TextAscent
		  Select Case AlignV
		  Case AlignCenter, AlignDefault
		    Y = Y + max((Height - TotalHt)\2,0) 
		  Case AlignTop
		    Y = Y 
		  Case AlignBottom
		    Y = Y + Max(Height - TotalHt, 0)
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		    
		  End Select
		  
		  ubPGraph = Lines.Ubound
		  
		  Select case AlignH
		  Case AlignLeft, AlignDefault
		    For i = 0 to ubPGraph
		      g.DrawString Lines(i).LTrim, X0 ,Y+Ascent,Width, TRUE
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  CASE AlignCenter
		    '
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      If StrWidth > Width Then
		        g.DrawString Text, X0 ,Y+Ascent,Width, TRUE
		      ElseIf ubPGraph = 0 then
		        X = X0 + (Width - StrWidth)\2
		        If X < 0 then X=0
		        g.DrawString Text, X ,Y+Ascent,Width, TRUE
		      Else
		        g.DrawString Text, X0 +(Width - StrWidth)\2 ,Y+Ascent,Width, TRUE
		      End if
		      Y = Y + TextHt + LineSpacing
		    Next
		  Case AlignRight
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      X= x0+ Width - StrWidth
		      if X < 0 then X = 0
		      g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      
		      Y = Y + TextHt + LineSpacing
		    Next
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		    
		  End Select
		  
		  
		  Return Paragraphs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FlowTextBlock(Extends g as graphics , Text as String,AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0) As String()
		  Return g.FlowTextBlock(Text,0,0,g.Width, g.Height, AlignH, AlignV, LineSpacing)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FlowTextBlock(Extends g as graphics , Text as String, x as integer, y as Integer , Width as Integer, Height as integer, AlignH As integer = 0, AlignV As Integer = 0,LineSpacing as integer = 0) As String()
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  Dim Paragraphs(-1) as string
		  If Text.LenB = 0 then Return Paragraphs
		  
		  If AlignH < 0 Or AlignH > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "FlowTextBlock: AlignH = " + str(AlignH)
		  ElseIf AlignV < 0 Or AlignV > 3 then
		    Dim err As New OutOfBoundsException
		    Err.Message = "FlowTextBlock: AlignV = " + str(AlignV)
		  End if
		  
		  Dim TextHt As Integer = g.TextHeight
		  Dim MinDrawHt As Integer = TextHt
		  Dim  StrWidth,pos  As Integer
		  
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  Text = ReplaceLineEndings(Text,EOL)
		  Paragraphs() = Text.SplitB(EOL)
		  
		  Const Space =32
		  Const Dash = 45
		  Dim X0 as Integer = X
		  Dim Lines() as String
		  dim TotalHt,i,ubPGraph, LeftCharPos, MidCharPos, RightCharPos as Integer
		  Dim  HasExtraLines As Boolean
		  
		  ubPGraph = Paragraphs.Ubound
		  
		  For i = 0 to ubPGraph
		    Text = Paragraphs(i)
		    Do
		      TotalHt = TotalHt  + TextHt' add TextHeight
		      if TotalHt >Height Then
		        HasExtraLines = True
		        TotalHt = TotalHt - TextHt
		        TotalHt = TotalHt  + LineSpacing
		        Exit For
		      end if
		      TotalHt = TotalHt  + LineSpacing
		      StrWidth = Ceil(g.StringWidth(Text))
		      
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      'TotalHt = TotalHt + LineSpacing
		    Loop Until Text.LenB = 0
		  Next
		  
		  TotalHt = TotalHt - LineSpacing
		  
		  If HasExtraLines Then
		    Paragraphs(0) = Text
		    Dim Idx As Integer
		    For i = i + 1 to ubPGraph
		      Idx = Idx + 1
		       Paragraphs(Idx) = Paragraphs(i)
		    Next
		    ReDim Paragraphs(Idx)
		  End if
		  
		  Dim Ascent as Integer = g.TextAscent
		  Select Case AlignV
		  Case AlignCenter, AlignDefault
		    Y = Y + max((Height - TotalHt)\2,0) 
		  Case AlignTop
		    Y = Y 
		  Case AlignBottom
		    Y = Y + Max(Height - TotalHt, 0)
		  Else
		    Dim  Err as New OutOfBoundsException
		    Err.Message = CurrentMethodName +": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		    
		  End Select
		  
		  ubPGraph = Lines.Ubound
		  
		  Select case AlignH
		  Case AlignLeft, AlignDefault
		    For i = 0 to ubPGraph
		      g.DrawString Lines(i).LTrim, X0 ,Y+Ascent,Width, TRUE
		      Y = Y + TextHt + LineSpacing
		    Next
		    
		  CASE AlignCenter
		    '
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      If StrWidth > Width Then
		        g.DrawString Text, X0 ,Y+Ascent,Width, TRUE
		      ElseIf ubPGraph = 0 then
		        X = X0 + (Width - StrWidth)\2
		        If X < 0 then X=0
		        g.DrawString Text, X ,Y+Ascent,Width, TRUE
		      Else
		        g.DrawString Text, X0 +(Width - StrWidth)\2 ,Y+Ascent,Width, TRUE
		      End if
		      Y = Y + TextHt + LineSpacing
		    Next
		  Case AlignRight
		    For i = 0 to ubPGraph
		      Text = Lines(i).Trim
		      StrWidth = Ceil(g.StringWidth(Text))
		      X= x0+ Width - StrWidth
		      if X < 0 then X = 0
		      g.DrawString Text, X ,Y+ Ascent,Width, TRUE
		      
		      Y = Y + TextHt + LineSpacing
		    Next
		  Else
		    Dim Err as new OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for HorizAlign: " +str(AlignH)
		    Raise Err
		    
		  End Select
		  
		  
		  Return Paragraphs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GradientMirroredColors(Pixels as Integer, EdgeColor as Color, CenterColor as Color) As Color()
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  Dim i as Integer, StartRatio, EndRatio as Double
		  Dim Colors() As Color, ub As Integer = Pixels -1
		  ReDim Colors(ub)
		  Dim EdgeRed, EdgeGreen, EdgeBlue, CenterRed, CenterGreen, CenterBlue as Double
		  
		  EdgeRed = EdgeColor.Red
		  EdgeGreen = EdgeColor.Green
		  EdgeBlue = EdgeColor.Blue
		  
		  CenterRed = CenterColor.Red
		  CenterGreen = CenterColor.Green
		  CenterBlue = CenterColor.Blue
		  
		  Dim MidPt As Integer, theColor As Color
		  MidPt = Pixels\2
		  Pixels = Pixels -1
		  
		  for i = 0 to MidPt
		    StartRatio = (MidPt-i)/MidPt 
		    EndRatio = i/MidPt
		    theColor = RGB( _
		    Round(CenterRed * EndRatio + EdgeRed * StartRatio), _
		    Round(CenterGreen * EndRatio + EdgeGreen * StartRatio),_
		    Round(CenterBlue * EndRatio + EdgeBlue * StartRatio) )
		    
		    Colors(i) = theColor
		    Colors(Pixels-i) = theColor
		  Next
		  
		  Return Colors
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Registration(ExactRegisteredName As String, RegistrationCode as String)
		  C = RegistrationCode
		  N = ExactRegisteredName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WrapTextBlock(Extends g as graphics , Text as String, LineSpacing As Integer = 0) As String()
		  Return g.WrapTextBlock(Text,g.Width,g.Height,LineSpacing)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WrapTextBlock(Extends g as graphics , Text as String, Width as Integer, Height As Integer, LineSpacing As Integer = 0) As String()
		  If Height <= 0 then Return g.WrapTextLines(text,Width)
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim Lines() as String
		  
		  If Text.LenB = 0 then Return lines
		  
		  Dim TextHt As Integer = g.TextHeight
		  Dim MinDrawHt As Integer = TextHt
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  Text = ReplaceLineEndings(Text,EOL)
		  Dim Paragraphs() as String = Text.SplitB(EOL)
		  dim ubPGraph, Pos, LeftCharPos, MidCharPos, RightCharPos,StrWidth as Integer
		  
		  If LineSpacing < 0 Or Height < MinDrawHt + LineSpacing + MinDrawHt Then ' must draw single line
		    Text = Paragraphs(0)
		    StrWidth = Ceil(g.StringWidth(Text))
		    If Paragraphs.Ubound > 0 and StrWidth < Width Then Text = Text + "..."
		    Return Array(text)
		  End if
		  
		  Const Space =32
		  Const Dash = 45
		  
		  ubPGraph = Paragraphs.Ubound
		  
		  Dim TotalHt as Integer
		  
		  For i as integer = 0 to ubPGraph
		    Text = Paragraphs(i)
		    Do
		      TotalHt = TotalHt + TextHt ' add TextHeight
		      
		      If TotalHt > Height Then
		        TotalHt = TotalHt - TextHt
		        Exit For
		      End if
		      
		      TotalHt = TotalHt + LineSpacing
		      StrWidth = Ceil(g.StringWidth(Text))
		      
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      
		    Loop Until Text.LenB = 0
		  Next
		  
		  Return lines
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WrapTextLines(Extends g as graphics , Text as String, Width As Integer = 0) As String()
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim Lines() as String
		  
		  If Text.LenB = 0 then Return lines
		  
		  If Width <= 0 then Width = g.Width
		  
		  Static EOL as String
		  If EOL.LenB = 0 then
		    EOL = EndOfLine
		    '@@@###@@@
		  End if
		  
		  Text = ReplaceLineEndings(Text,EOL)
		  Dim Paragraphs() as String = Text.SplitB(EOL)
		  
		  Const Space =32
		  Const Dash = 45
		  
		  dim ubPGraph, LeftCharPos, MidCharPos, RightCharPos,StrWidth as Integer
		  ubPGraph = Paragraphs.Ubound
		  
		  For i as integer = 0 to ubPGraph
		    
		    Text = Paragraphs(i)
		    Do
		      StrWidth = Ceil(g.StringWidth(Text))
		      If StrWidth <= Width Then
		        lines.Append Text
		        Exit Do
		      End if
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Text.Len
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Text.Left(MidCharPos))) <= Width then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Text.Left(1)
		        Text = Text.Mid(2)
		        If Text.LenB = 0 Then Exit
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Text.MidB(RightCharPos,1))
		        Case Space,Dash
		          Lines.Append Text.Left(RightCharPos)
		          Text = Text.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          Lines.Append Text.Left(LeftCharPos)
		          Text =Text.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		        
		      Loop
		    Loop Until Text.LenB = 0
		  Next
		  
		  Return lines
		End Function
	#tag EndMethod


	#tag Note, Name = License
		Mergable Cell listbox Licence/Copyright Notice
		Copyright (c) 2010, Karen Atkocius
		
		
		License Agreement
		
		This developer's software license ("License") contains rights and restrictions associated
		with the use of the Mergable Cell Listbox classes amd nodules written by Karen Atkocius
		for use within REALStudio ("Software"). The Software is comprised of the provided source code,
		and any "online" or electronic documentation, as applicable.
		
		By downloading an electronic copy or installing the software, you ("You" or "User") are
		indicating your acceptance of the terms, conditions, and disclaimers set forth in this
		agreement ("Agreement"). Written assent is not a prerequisite to the validity or
		enforceability of this Agreement.
		
		Grant of License
		
		Software Internal Use and Development License Grant. Subject to the terms and condition
		of this Agreement. Karen Atkocius grants you a non-exclusive, non-transferable, per-developer.
		limited license to reproduce internally and use internally the Software with REALStudio
		for the purpose of value-add integration when designing, developing, testing your
		(commercial or non-commercial) Programs.
		
		Software Distribution.
		
		Subject to the terms and conditions of this Agreement,
		Karen Atkocius grants you a non-exclusive, non-transferable, limited license
		without fees to reproduce and distribute any compiled application using the
		supplied classes and modules. You may not redistribute the source code provided.
		You may not redistribute the source code itself in any form.
		
		License Key.
		
		For encrypted versions of the software You agree not to share your license key with anyone.
		
		Restrictions
		
		Software is confidential and copyrighted. Title to Software and all associated intellectual
		property rights are retained by Karen Atkocius.
		
		This Agreement expressly prohibits the (public or private) distribution or display of
		Software in an indexed library or collection of code, or any use (public or private) that
		distributes or displays Software for purposes of providing a central source of code
		for others' use.
		
		Copyright Notice
		
		Karen Atkocius (c) 2010 Keatk@Verizon.net USA. All rights reserved.
		
		DISCLAIMER OF WARRANTY
		
		THE SOFTWARE IS PROVIDED "AS IS" AND Karen Atkocius DISCLAIMS AND EXCLUDES ALL WARRANTIES.
		UNLESS SPECIFIED IN THIS AGREEMENT, ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND
		WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
		PURPOSE OR NON-INFRINGEMENT ARE DISCLAIMED, EXCEPT TO THE EXTENT THAT THESE DISCLAIMERS
		ARE HELD TO BE LEGALLY INVALID.
		
		LIMITATION OF LIABILITY
		
		TO THE EXTENT NOT PROHIBITED BY LAW, IN NO EVENT WILL Karen Atkocius BE LIABLE FOR ANY
		LOST REVENUE, PROFIT OR DATA, OR FOR SPECIAL, INDIRECT, CONSEQUENTIAL, INCIDENTAL
		OR PUNITIVE DAMAGES, HOWEVER CAUSED REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF
		OR RELATED TO THE USE OF OR INABILITY TO USE SOFTWARE, EVEN IF Karen Atkocius
		HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
		
		Termination
		
		This Agreement is effective until terminated. You may terminate this Agreement at any time
		by destroying all copies of Software. This Agreement will terminate immediately without
		notice from Karen Atkocius if you fail to comply with any provision of this Agreement.
		Either party may terminate this Agreement immediately should any Software become,
		or in either party's opinion be likely to become, the subject of a claim of infringement
		of any intellectual property right. Upon Termination, you must destroy all copies of Software.
		
		Severability
		
		If any provision of this Agreement is held to be unenforceable, this Agreement will
		remain in effect with the provision omitted, unless omission would frustrate the intent
		of the parties, in which case this Agreement will immediately terminate.
		
		Integration
		
		This Agreement is the entire agreement between you and Karen Atkocius relating to its
		subject matter. It supersedes all prior or contemporaneous oral or written communications,
		proposals, representations and warranties and prevails over any conflicting or additional
		terms of any quote, order, acknowledgment, or other communication between the parties
		relating to its subject matter during the term of this Agreement. No modification of this
		Agreement will be binding, unless in writing and signed by an authorized representative
		of each party.
		
		
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private C As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private N As String
	#tag EndProperty


	#tag Constant, Name = AlignBottom, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = AlignCenter, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = AlignDefault, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = AlignLeft, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = AlignRight, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = AlignTop, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Ellipsis, Type = String, Dynamic = False, Default = \"...", Scope = Protected
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"\xE2\x80\xA6"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"..."
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"..."
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
