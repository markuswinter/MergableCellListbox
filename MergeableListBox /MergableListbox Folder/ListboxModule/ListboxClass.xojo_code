#tag Class
Class ListboxClass
Inherits Listbox
	#tag Event
		Function CellBackgroundPaint(g As Graphics, row As Integer, column As Integer) As Boolean
		  
		  g.ForeColor = BackgroundColor(Row, me.Selected(row) , IsActive or ActiveCell.Visible)
		  
		  If NOT CellBackgroundPaint(g, row,column) Then 
		    g.FillRect 0,0, g.Width, g.Height
		  End if
		  
		  TmpBkgColor = g.ForeColor
		  
		  If row < ListCount AND Column = 0 AND Hierarchical And DrawNodeLines Then DrawHierLines(g,row)
		  
		  Return True
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  ExpandAll = false
		  If CellClick(row,column, X,Y) then Return True
		  ExpandAll = Hierarchical AND column = 0 AND Keyboard.OptionKey
		End Function
	#tag EndEvent

	#tag Event
		Function CellKeyDown(row as Integer, column as Integer, key as String) As Boolean
		  ExpandAll = False
		  #If RBVersion < 2009.5
		    
		    If Asc(key) = 13 And Keyboard.OptionKey Then
		      ActiveCell.SelText = EndOfLine
		      Return True
		    End if
		  #Else
		    
		    If Asc(key) = 13 AND ActiveCell IsA TextArea And NOT TextArea(ActiveCell).MultiLine Then
		      ActiveCell.SelText = EndOfLine
		      Return True
		    End
		  #endif
		  
		  Return CellkeyDown(row,column,key)
		End Function
	#tag EndEvent

	#tag Event
		Sub CellLostFocus(row as Integer, column as Integer)
		  Cell(row,column) = ReplaceLineEndings(Cell(row,column),EndOfLine)
		  CellLostFocus(row,column)
		End Sub
	#tag EndEvent

	#tag Event
		Function CellTextPaint(g As Graphics, row As Integer, column As Integer, x as Integer, y as Integer) As Boolean
		  #If UseCachedBkgColor
		    if SupressTextPaint Then 
		      SupressTextPaint = False
		      Return True
		    End if
		  #else
		    if SupressTextPaint(row,column) Then Return True
		  #Endif
		  
		  
		  #If UseCachedBkgColor
		    g.ForeColor = ContrastingColor(TmpBkgColor)
		  #else
		    If Selected(row) then
		      TmpBkgColor = g.ForeColorBackgroundColor(True, IsActive)
		    ElseIf row Mod 2 = 0  Then
		      If BackColor <> &c000000
		        TmpBkgColor = BackColor
		      else
		        TmpBkgColor = g.ForeColorBackgroundColor(False, IsActive)
		      End if
		    ElseIf AltBackColor <> &c000000 Then
		      TmpBkgColor = AltBackColor
		    ElseIf BackColor <> &c000000 Then
		      TmpBkgColor = BackColor
		    Else
		      TmpBkgColor = g.ForeColorBackgroundColor(False, IsActive)
		    End if
		    g.ForeColor = ContrastingColor(TmpBkgColor)
		  #endif
		  
		  Dim HOffset, AlignV, VOffset,LineSpacing as Integer, NormalPosition As Boolean,TxtHt As Integer = g.TextHeight
		  
		  IF Not WrapByDefault Or g.Height <= TxtHt + TxtHt Then LineSpacing = NoWrap
		  If CellTextPaint(g,row, column,x,y,AlignV,VOffset, LineSpacing) Then Return True
		  TxtHt = g.TextHeight
		  IF LineSpacing >= 0 and  g.Height <= TxtHt + LineSpacing + TxtHt Then LineSpacing = NoWrap
		  
		  Dim Txt As String = Super.Cell(row,column)
		  If Txt.LenB = 0 then Return True
		  
		  NormalPosition = VOffset = 0 and (AlignV = AlignDefault OR AlignV = AlignCenter)
		  
		  Static EOL as String = EndOfLine
		  Dim EOLPos as Integer =Txt.InStrB(EOL)
		  
		  If EOLPos = 0 And LineSpacing = NoWrap and  NormalPosition THEN Return FALSE
		  
		  
		  Dim AlignH as Integer = CellAlignment(row,Column)
		  IF AlignH = AlignDefault Then AlignH = ColumnAlignment(column)
		  
		  If AlignH = AlignDecimal THEN
		    If NormalPosition Then Return False
		    HOffset = CellAlignmentOffset(row,Column)
		    If HOffset = 0 then HOffset = ColumnAlignmentOffset(column)
		    
		    Select Case AlignV
		    Case AlignCenter, AlignDefault
		      Y = (g.Height-TxtHt)\2 + VOffset
		    Case AlignTop
		      Y = VOffset
		    Case AlignBottom
		      Y = g.Height - TxtHt  + VOffset
		    Else
		      Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for VertAlign: " +str(AlignV))
		    End Select
		    
		    If Y < 0 then 
		      Y = g.TextAscent
		    Else
		      Y = Y + g.TextAscent
		    End if
		    
		    Dim Pos as Integer = Txt.InStrB(".")
		    
		    If Pos > 0 then
		      X = g.Width - g.StringWidth(Txt.LeftB(Pos)) + HOffset - 1
		    Else
		      X = g.Width - g.StringWidth(Txt) + HOffset - 1
		    End If
		    
		    g.DrawString txt, X,Y 
		    
		    g.ForeColor = TmpBkgColor
		    g.FillRect g.Width -2,0, 2,RowHeight
		    
		    Return True
		    
		  End If
		  
		  HOffset = CellAlignmentOffset(row,Column)
		  If HOffset = 0 then HOffset = ColumnAlignmentOffset(column)
		  
		  If EOLPos > 0 then ' may need ellipsis for row that fits because of EOL
		    PaintText(g,Txt,g.Width,RowHeight,AlignV,AlignH,LineSpacing,HOffset,VOffset,EOLPos)
		    Return True
		    
		  ElseIf LineSpacing > NoWrap then' may Wrap
		    PaintText(g,Txt,g.Width,g.Height,AlignV,AlignH,LineSpacing,HOffset,VOffset,EOLPos)
		    Return True
		  End if
		  
		  If NormalPosition Then Return False
		  
		  Select Case AlignV
		  Case AlignDefault, AlignCenter
		    Y = (g.Height - TxtHt)\2  + g.TextAscent + VOffset
		  Case AlignTop
		    Y = g.TextAscent + VOffset
		  Case AlignBottom
		    Y = g.Height - TxtHt + g.TextAscent+ VOffset
		    
		  Else
		    Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for VertAlign: " +str(AlignV))
		  End Select
		  
		  Select Case AlignH
		  Case AlignDefault, AlignLeft
		    ' Do nothing
		  Case AlignCenter
		    X = (g.Width - g.StringWidth(Txt) - TextMargin )\2 + HOffset
		    if X < 0 Then X = 0
		  Case AlignRight
		    X = g.Width - g.StringWidth(Txt) - TextMargin + HOffset
		    if X < 0 Then X = 0
		  Else
		    Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH))
		    
		  End Select
		  
		  g.DrawString txt, X,Y, g.Width - TextMargin, True
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub ExpandRow(row As Integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  Dim ParentRow As integer = row
		  Dim ParentInfo As RowInfo = RowInfo(Super.RowTag(ParentRow))
		  ParentStack.Append ParentInfo
		  
		  ExpandRow(ParentRow)
		  Call ParentStack.Pop
		  'InvalidateCell(row,-1)
		  '
		  'Dim ub as integer = Info.ConnectionList.Ubound
		  '
		  'If ub = -1 then return
		  'Info.Connectionlist(ub) = Connection_None
		  '
		  'If NOT Info.isLastChild Then Return
		  '
		  'Dim MyIndent as Integer = Info.Indent
		  'Dim ParentIndent as Integer = MyIndent -1
		  '
		  'For Row = Row-1 DownTo 0
		  'InvalidateCell(row,-1)
		  'Select Case RowDepth(row)
		  'Case  ParentIndent
		  'RowInfo(Super.RowTag(row)).hasChildren = False
		  'Return
		  'Case MyIndent
		  'info = RowInfo(Super.RowTag(row))
		  'if info.Nodetype = Node_Other Then
		  'Info.ConnectionList(ub) = Connection_None
		  'Else
		  'Info.ConnectionList(ub) = Connection_Last
		  'Return
		  'End if
		  'Else
		  'Info.ConnectionList(ub) = Connection_None
		  'End Select
		  'Next
		  
		  
		  
		  Dim ParentIndent As Integer = ParentInfo.Indent
		  Dim ChildIndent As Integer = ParentIndent + 1
		  
		  Dim LastChild as Integer = -1, ub As Integer  = ListCount -1, Indent as Integer
		  
		  Dim tag as Variant, RowInfoList() as RowInfo
		  
		  While row < ub 
		    row = row + 1
		    Tag = Super.RowTag(row)
		    If Tag isA RowInfo Then
		      Indent = RowInfo(Tag).Indent
		    Else
		      Indent = 0
		    End if
		    
		    if Indent = ChildIndent Then 
		       LastChild = row
		    ElseIf Indent < ChildIndent Then
		      Exit
		    End If 
		  Wend
		  
		  If LastChild = -1 Then 
		    ParentInfo.HasChildren = False
		    Return
		  End if
		  
		  Dim ChildInfo As RowInfo, FoundLastChild as Boolean
		  
		  Dim FirstChild As Integer = ParentRow + 1
		  
		  For row = LastChild DownTo FirstChild
		    Tag = Super.RowTag(row)
		    If NOT Tag isA RowInfo Then Continue
		    
		    ChildInfo = RowInfo(Tag)
		    
		    Select Case ChildInfo.Indent 
		    Case Is <= ParentIndent
		      Exit
		    Case is > ChildIndent
		      Continue
		    End Select
		    
		    IF  FoundLastChild Then
		      ChildInfo.IsLastChild = False
		      ChildInfo.ConnectionList(ParentIndent) = Connection_Normal
		    Else
		      ChildInfo.IsLastChild = True
		      If ChildInfo.InhibitParentConnection Then 
		         ChildInfo.ConnectionList(ParentIndent) = Connection_None
		      Else
		        FoundLastChild = True
		        ChildInfo.ConnectionList(ParentIndent) = Connection_Last
		      End if
		      
		    End if
		  Next
		  
		  ParentInfo.HasChildren = FoundLastChild
		  
		  If ExpandAll Then
		    row = ParentRow
		    While row < ub
		      row = row + 1
		      Tag = Super.RowTag(row)
		      If Tag isA RowInfo Then
		        If RowInfo(Tag).Indent > ParentIndent Then 
		          Expanded(row)= true
		          ub = me.ListCount -1
		        Else
		          Exit
		        End if
		      Else
		      End If
		    Wend
		  End if
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  ExpandAll = False
		  If KeyDown(key) then 
		    Return True
		  ElseIf Hierarchical AND SelCount =1 And NOT ActiveCell.Visible Then
		    Return HierarchicalKeyDownHandler(Key, ListIndex)
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  Open
		  '@@@###@@@
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddFolder(Item As String)
		  If Not Hierarchical Then 
		    Super.AddRow Item
		    Return
		  End if
		  
		  Super.AddFolder Item
		  
		  Dim Info as RowInfo = GetAssignRowTagSubclass(LastIndex)
		  Info.NodeType = Node_Folder
		  
		  Dim ub as Integer = ParentStack.Ubound
		  If ub = -1 then Return ' Not in expand event
		  
		  Dim ParentInfo As RowInfo = ParentStack(ub)
		  
		  Info.NodeType = Node_Folder
		  Info.Indent = ParentInfo.Indent + 1
		  
		  
		  If Info.Indent = 1 Then
		    ReDim Info.ConnectionList(0)
		    Return
		  End if
		  
		  Dim ParentConnections() As Byte = ParentInfo.ConnectionList
		  ub = ParentConnections.Ubound
		  Dim MyConnections(-1) As Byte
		  ReDim MyConnections(ub + 1)
		  
		  For i as Integer = 0 to ub
		    MyConnections(i) = ParentConnections(i)
		  Next
		  
		  If ParentInfo.isLastChild Then
		    MyConnections(ub) = Connection_None
		  Else
		    MyConnections(ub) = Connection_Normal
		  End if
		  Info.ConnectionList = MyConnections
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRow(Item() As String)
		  Super.AddRow item
		  If Not Hierarchical Then Return
		  Dim ub as Integer = ParentStack.Ubound
		  If ub = -1 then Return ' Not in expand event
		  
		  Dim ParentInfo As RowInfo = ParentStack(ub)
		  Dim Info as RowInfo = GetAssignRowTagSubclass(LastIndex)
		  
		  Info.NodeType = Node_Item
		  Info.Indent = ParentInfo.Indent + 1
		  
		  If Info.Indent = 1 Then
		    ReDim Info.ConnectionList(0)
		    Return
		  End if
		  
		  Dim ParentConnections() As Byte = ParentInfo.ConnectionList
		  ub = ParentConnections.Ubound
		  Dim MyConnections(-1) As Byte
		  
		  ReDim MyConnections(ub + 1)
		  For i as Integer = 0 to ub
		    MyConnections(i) = ParentConnections(i)
		  Next
		  
		  ub = ub
		  If ParentInfo.isLastChild Then
		    MyConnections(ub) = Connection_None
		  Else
		    MyConnections(ub) = Connection_Normal
		  End if
		  Info.ConnectionList = MyConnections
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRow(ParamArray Item As String)
		  AddRow Item
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function BackgroundColor(isSelected as Boolean, Active as Boolean) As Color
		  If Not isSelected then Return ListBackgroundColor
		  
		  Dim BkgColor as Color
		  #if TargetCocoa
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Ptr
		    Declare Function alternateSelectedControlColor Lib "AppKit" Selector "alternateSelectedControlColor" ( obj As Ptr ) As Ptr
		    Declare Function secondarySelectedControlColor Lib "AppKit" Selector "secondarySelectedControlColor" ( obj As Ptr ) As Ptr
		    Declare Function colorUsingColorSpaceName Lib "AppKit" Selector "colorUsingColorSpaceName:" (obj As Ptr, name As Ptr) As Ptr
		    #If Target32Bit
		      Declare Function redComponent Lib "AppKit" Selector "redComponent" (obj As Ptr) As Single
		      Declare Function greenComponent Lib "AppKit" Selector "greenComponent" (obj As Ptr) As Single
		      Declare Function blueComponent Lib "AppKit" Selector "blueComponent" (obj As Ptr) As Single
		    #else
		      Declare Function redComponent Lib "AppKit" Selector "redComponent" (obj As Ptr) As Double
		      Declare Function greenComponent Lib "AppKit" Selector "greenComponent" (obj As Ptr) As Double
		      Declare Function blueComponent Lib "AppKit" Selector "blueComponent" (obj As Ptr) As Double
		    #Endif
		    
		    Static NSColor As Ptr = NSClassFromString("NSColor")
		    Static NSCalibratedRGBColorSpace As Ptr
		    If NSCalibratedRGBColorSpace = Nil Then
		      declare function CFBundleGetBundleWithIdentifier lib "CoreFoundation.framework" (bundleID as CFStringRef) as Ptr
		      Dim BundlePtr as ptr = CFBundleGetBundleWithIdentifier("com.apple.AppKit")
		      
		      soft declare function CFRetain lib "CoreFoundation.framework" (cf as Ptr) as ptr
		      Call CFRetain(BundlePtr)
		      
		      declare function CFBundleGetDataPointerForName lib "CoreFoundation.framework" (bundle as Ptr, symbolName as CFStringRef) as Ptr
		      NSCalibratedRGBColorSpace =  CFBundleGetDataPointerForName(BundlePtr,"NSCalibratedRGBColorSpace").Ptr(0)
		      
		      soft declare sub CFRelease lib "CoreFoundation.framework" (cf as Ptr)
		      
		      CFRelease(BundlePtr)
		      
		    End If
		    
		    Dim theColor As Ptr
		    If Active Then
		      theColor = alternateSelectedControlColor(NSColor)
		    Else
		      theColor = secondarySelectedControlColor(NSColor)
		    End If
		    
		    Dim rgbColor As Ptr = colorUsingColorSpaceName(theColor, NSCalibratedRGBColorSpace)
		    If rgbColor <> Nil Then
		      Dim red As Integer = redComponent(rgbColor) * 255.0
		      Dim green As Integer = greenComponent(rgbColor) * 255.0
		      Dim blue As Integer = blueComponent(rgbColor) * 255.0
		      BkgColor = RGB(red, green, blue)
		    Else
		      BkgColor = HighlightColor
		    End If
		  #else
		    BkgColor = HighlightColor
		    
		    #ElseIf TargetMacOS
		      
		      Declare function GetThemeBrushAsColor lib "Carbon" (inBrush as Integer, _
		      inDepth as Integer, _
		      inColorDev as Integer, _
		      outColor as ptr) as Integer
		      
		      dim oc as MemoryBlock = new MemoryBlock(6)
		      dim res as Integer
		      
		      If Active Then
		        If GetThemeBrushAsColor(-5, 32, 1, oc) <> 0 Then
		          BkgColor =  HighlightColor
		        else
		          BkgColor = RGB(oc.byte(0), oc.byte(2), oc.byte(4))
		        end if
		      Else
		        If GetThemeBrushAsColor(-4, 32, 1, oc) <> 0 Then
		          BkgColor = DarkBevelColor
		        else
		          BkgColor =  RGB(oc.byte(0), oc.byte(2), oc.byte(4))
		        End if
		      End if
		      
		    #Elseif TargetWin32
		       If Active then 
		        BkgColor = HighlightColor
		      Else
		        dim res as memoryblock
		        Declare Function GetSysColor Lib "user32" (nIndex As integer) As integer
		        res = newmemoryBlock(4)
		        res.long(0) = getsyscolor(0)
		        
		        BkgColor = rgb(res.byte(0),res.byte(1),res.byte(2))
		      End If
		    #else
		      
		      if Active Then
		        BkgColor =  HighlightColor
		      Else
		        BkgColor = FillColor
		      end if
		    #endif
		    
		    Return BkgColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BackgroundColor(Row as integer, isSelected as Boolean, Active as Boolean) As Color
		  
		  If Not isSelected Then
		    If (row Mod 2) = 0 Then
		      If BackColor <> &c000000 Then 
		        Return BackColor
		      Else 
		        Return BackgroundColor(isSelected, Active)
		      End if
		    ElseIf AltBackColor <> &c000000 Then
		      Return AltBackColor
		    ElseIf BackColor <> &c000000 Then
		      Return BackColor
		    Else
		      Return  ListBackgroundColor
		    End if
		    
		  Else 
		    Return BackgroundColor(isSelected, Active)
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellAlignment(row as Integer, column as integer, Assigns Alignment as integer)
		  if row >= 0 and column >= 0 then
		    Super.CellAlignment(row,column) = Alignment
		  End if
		  
		  Dim ubRow, ubCol,FirstRow, FirstCol As Integer
		  
		  
		  If column < 0 then
		    FirstCol = 0
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column
		    FirstCol = column
		  End if
		  
		  If row < 0 then
		    FirstRow = 0
		    ubRow = ListCount - 1
		  Else
		    ubRow = row
		    FirstRow = Row
		  End if
		  
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellAlignment(row,column) = Alignment
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellAlignmentOffset(row as Integer, column as integer, Assigns Offset as Integer)
		  if row >= 0 and column >= 0 then
		    Super.CellAlignmentOffset(row,column) = Offset
		  End if
		  
		  Dim ubRow, ubCol,FirstRow, FirstCol As Integer
		  
		  
		  If column < 0 then
		    FirstCol = 0
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column
		    FirstCol = column
		  End if
		  
		  If row < 0 then
		    FirstRow = 0
		    ubRow = ListCount - 1
		  Else
		    ubRow = row
		    FirstRow = Row
		  End if
		  
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellAlignmentOffset(row,column) = Offset
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBold(row As Integer, column As Integer, Assigns Value as Boolean)
		  If row >= 0 And column >= 0 then
		    Super.CellBold(row,column) = Value
		    Return
		  End if
		  Dim ubRow, ubCol,FirstRow, FirstCol As Integer
		  
		  
		  If column < 0 then
		    FirstCol = 0
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column
		    FirstCol = column
		  End if
		  
		  If row < 0 then
		    FirstRow = 0
		    ubRow = ListCount - 1
		  Else
		    ubRow = row
		    FirstRow = Row
		  End if
		  
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellBold(row,column) = Value
		    Next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderBottom(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, assigns BorderStyle As Integer)
		  If row >= 0 And column >= 0  and rows = 1 And columns = 1 then
		    Super.CellBorderBottom(row,column) = BorderStyle
		    Return
		    
		  End if
		  
		  Dim ubRow, ubCol, FirstRow,FirstCol As Integer
		  
		  If column < 0 then 
		    column = 0
		    ubCol = ColumnCount - 1
		  ElseIf columns < 0 then
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column + columns -1
		  End if
		  FirstCol = column
		  
		  If row < 0 then
		    row = 0
		    ubRow = ListCount - 1
		  ElseIf rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows - 1
		  End if
		  FirstRow = row
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellBorderBottom(row,column) = BorderStyle
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderLeft(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, assigns BorderStyle As Integer)
		  If row >= 0 And column >= 0 and rows = 1 And columns = 1 then
		    Super.CellBorderLeft(row,column) = BorderStyle
		    Return
		  End if
		  Dim ubRow, ubCol, FirstRow,FirstCol As Integer
		  
		  If column < 0 then
		    column = 0
		    ubCol = ColumnCount - 1
		  ElseIf columns < 0 then
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column + columns -1
		  End if
		  FirstCol = column
		  
		  If row < 0 then
		    row = 0
		    ubRow = ListCount - 1
		  ElseIf rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows - 1
		  End if
		  
		  FirstRow = row
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellBorderLeft(row,column) = BorderStyle
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderRight(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, assigns BorderStyle As Integer)
		  If row >= 0 And column >= 0 And rows = 1 And columns = 1 then
		    Super.CellBorderRight(row,column) = BorderStyle
		    Return
		  End if
		  Dim ubRow, ubCol, FirstRow,FirstCol As Integer
		  
		  
		  If column < 0 then
		    column = 0
		    ubCol = ColumnCount - 1
		  ElseIf columns < 0 then
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column + columns -1
		  End if
		  FirstCol = column
		  
		  If row < 0 then
		    row = 0
		    ubRow = ListCount - 1
		  ElseIf rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows - 1
		  End if
		  FirstRow = row
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellBorderRight(row,column) = BorderStyle
		    Next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderTop(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, assigns BorderStyle As Integer)
		  If row >= 0 And column >= 0 and rows = 1 And columns = 1 then
		    Super.CellBorderTop(row,column) = BorderStyle
		    Return
		  End if
		  
		  Dim ubRow, ubCol, FirstRow,FirstCol As Integer
		  
		  
		  If column < 0 then
		    column = 0
		    ubCol = ColumnCount - 1
		  ElseIf columns > 0 then
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column + columns -1
		  End if
		  FirstCol = Column
		  
		  If row < 0 then
		    row = 0
		    ubRow = ListCount - 1
		  Elseif rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows -1
		  End if
		  
		  FirstRow = Row
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellBorderTop(row,column) = BorderStyle
		    Next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellDefinition(row As Integer, column As Integer) As CellDefinition
		  Dim Data As New CellDefinition
		  
		  
		  Data.Alignment = CellAlignment(row,column)
		  Data.AlignmentOffset = CellAlignmentOffset(row,column)
		  Data.Bold =  CellBold(row,column)
		  Data.Italic = CellItalic(row,column)
		  Data.Underline = CellUnderline(row,column)
		  Data.BorderBottom = CellBorderBottom(row,column)
		  Data.Borderleft = CellBorderLeft(row,column)
		  Data.BorderRight = CellBorderRight(row,column)
		  Data.BorderTop = CellBorderTop(row,column)
		  Data.State = CellState(row,column)
		  Data.Type = CellType(row,column)
		  Data.Text = Cell(row,column)
		  Data.Tag = CellTag(row,column)
		  
		  Return Data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellDefinition(row As Integer, column As Integer, Assigns Data As CellDefinition)
		  Dim ubRow, ubCol As Integer
		   
		  If row = -1 then
		    row = 0
		    ubRow = ListCount -1
		  else
		    ubRow = row
		  End if
		  
		  if column = -1 then
		    column = 0
		    ubCol= ColumnCount -1
		  Else
		    ubCol = column
		  end if
		  
		  for row = row to ubRow
		    for column = column to ubCol
		      CellAlignment(row,column) = Data.Alignment
		      CellAlignmentOffset(row,column) = Data.AlignmentOffset
		      
		      CellBold(row,column) = Data.Bold 
		      CellItalic(row,column) = Data.Italic
		      CellUnderline(row,column) = Data.Underline
		      CellBorderBottom(row,column) = Data.BorderBottom
		      CellBorderLeft(row,column)= Data.Borderleft
		      CellBorderRight(row,column) = Data.BorderRight
		      CellBorderTop(row,column) = Data.BorderTop
		      CellState(row,column) = Data.State
		      CellType(row,column) = Data.Type
		      Cell(row,column) = Data.Text
		      CellTag(row,column) = Data.Tag
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CellFullDefinition(row As Integer, column As Integer) As CellDefinition
		  Dim Data As New CellDefinition
		  
		  Data.Alignment = Super.CellAlignment(row,column)
		  Data.AlignmentOffset = Super.CellAlignmentOffset(row,column)
		  Data.Bold = Super.CellBold(row,column)
		  Data.Italic = Super.CellItalic(row,column)
		  Data.Underline = Super.CellUnderline(row,column)
		  Data.BorderBottom = Super.CellBorderBottom(row,column)
		  Data.Borderleft = Super.CellBorderLeft(row,column)
		  Data.BorderRight = Super.CellBorderRight(row,column)
		  Data.BorderTop = Super.CellBorderTop(row,column)
		  Data.State = Super.CellState(row,column)
		  Data.Type = Super.CellType(row,column)
		  Data.Text = Super.Cell(row,column)
		  Data.Tag = Super.CellTag(row,column)
		  
		  Return Data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CellFullDefinition(row As Integer, column As Integer, Assigns Data As CellDefinition)
		   
		  Super.CellAlignment(row,column) = Data.Alignment
		  
		  Super.CellAlignmentOffset(row,column) = Data.AlignmentOffset
		  
		  Super.CellBold(row,column) = Data.Bold 
		  
		  Super.CellItalic(row,column) = Data.Italic
		  Super.CellUnderline(row,column) = Data.Underline
		  Super.CellBorderBottom(row,column) = Data.BorderBottom
		  Super.CellBorderLeft(row,column)= Data.Borderleft
		  Super.CellBorderRight(row,column) = Data.BorderRight
		  Super.CellBorderTop(row,column) = Data.BorderTop
		  Super.CellState(row,column) = Data.State
		  Super.CellType(row,column) = Data.Type
		  Super.Cell(row,column) = Data.Text
		  Super.CellTag(row,column) = Data.Tag
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellItalic(row As Integer, column As Integer, Assigns Value as Boolean)
		  If row >= 0 and column >= 0 then
		    Super.CellItalic(row,column) = Value
		    Return
		  End if
		  
		  
		  Dim ubRow, ubCol,FirstRow, FirstCol As Integer
		  
		  
		  If column < 0 then
		    FirstCol = 0
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column
		    FirstCol = column
		  End if
		  
		  If row < 0 then
		    FirstRow = 0
		    ubRow = ListCount - 1
		  Else
		    ubRow = row
		    FirstRow = Row
		  End if
		  
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellItalic(row,column) = Value
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellStyle(row As Integer, column As Integer) As CellStyle
		  Dim Data As New CellStyle
		  
		  Data.Alignment = CellAlignment(row,column)
		  Data.AlignmentOffset = CellAlignmentOffset(row,column)
		  Data.Bold = CellBold(row,column)
		  Data.Italic = CellItalic(row,column)
		  Data.Underline = CellUnderline(row,column)
		  Data.BorderBottom = CellBorderBottom(row,column)
		  Data.Borderleft = CellBorderLeft(row,column)
		  Data.BorderRight = CellBorderRight(row,column)
		  Data.BorderTop = CellBorderTop(row,column)
		  Data.Type = CellType(row,column)
		  
		  Return Data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellStyle(row As Integer, column As Integer, Assigns Data As CellStyle)
		  Dim ubRow, ubCol as Integer
		   If row = -1 Then
		    row = 0
		    ubRow = ListCount -1
		  Else
		    ubRow = Row
		  End if
		  
		  If column = -1 then
		    column = 0
		    ubCol = ColumnCount -1
		  Else
		    ubCol = column
		  End if
		  
		  For row = row to ubRow
		    For column = column to ubCol
		      Super.CellAlignment(row,column) = Data.Alignment
		      Super.CellAlignmentOffset(row,column) = Data.AlignmentOffset
		      Super.CellBold(row,column) = Data.Bold 
		      Super.CellItalic(row,column) = Data.Italic
		      Super.CellUnderline(row,column) = Data.Underline
		      Super.CellBorderBottom(row,column) = Data.BorderBottom
		      Super.CellBorderLeft(row,column)= Data.Borderleft
		      Super.CellBorderRight(row,column) = Data.BorderRight
		      Super.CellBorderTop(row,column) = Data.BorderTop
		      Super.CellType(row,column) = Data.Type
		    Next
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellTag(row as Integer, column as integer) As Variant
		  Dim V As Variant = Super.CellTag(row, column)
		  If V IsA ItemInfo Then
		    Return ItemInfo(V).Tag
		  Else
		    Return V
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellTag(row as Integer, column as integer, assigns Tag As Variant)
		  If Tag isA ItemInfo Then 
		    Super.CellTag(row, column) = tag
		    Return
		  End If
		  
		  Dim V As Variant = Super.CellTag(row, column)
		  If V IsA ItemInfo Then
		    ItemInfo(V).Tag = Tag
		  Else
		    Super.CellTag(row, column) = Tag
		  End if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellUnderline(row As Integer, column As Integer, Assigns Value as Boolean)
		  If row > 0 ANd column >= 0 then
		    Super.CellUnderline(row,column) = Value
		    Return
		  End if
		  
		  Dim ubRow, ubCol,FirstRow, FirstCol As Integer
		  
		  
		  If column < 0 then
		    FirstCol = 0
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column
		    FirstCol = column
		  End if
		  
		  If row < 0 then
		    FirstRow = 0
		    ubRow = ListCount - 1
		  Else
		    ubRow = row
		    FirstRow = Row
		  End if
		  
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      Super.CellUnderline(row,column) = Value
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CollapseAll()
		  If Not Hierarchical Then Return
		  
		  Dim V as Variant
		  
		  For row as Integer = ListCount-1 DownTo 0
		    V = Super.RowTag(row)
		    If V isA RowInfo AND RowInfo(V).Indent = 0 Then Expanded(row) = False
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  '@@@###@@@
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(Item As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  If Not Hierarchical Then 
		    Super.AddRow Item
		    Return
		  End if
		  
		  Super.AddFolder Item
		  
		  Dim Info as RowInfo = GetAssignRowTagSubclass(LastIndex)
		  Info.NodeType = Node_Folder
		  
		  Dim ub as Integer = ParentStack.Ubound
		  If ub = -1 then Return ' Not in expand event
		  
		  Dim ParentInfo As RowInfo = ParentStack(ub)
		  
		  Info.NodeType = Node_Folder
		  Info.Indent = ParentInfo.Indent + 1
		  
		  If NOT  DrawNodeLines Then Return
		  
		  If Info.Indent = 1 Then
		    ReDim Info.ConnectionList(0)
		    Return
		  End if
		  
		  Dim ParentConnections() As Byte = ParentInfo.ConnectionList
		  ub = ParentConnections.Ubound
		  Dim MyConnections(-1) As Byte
		  ReDim MyConnections(ub + 1)
		  
		  For i as Integer = 0 to ub
		    MyConnections(i) = ParentConnections(i)
		  Next
		  
		  If ParentInfo.isLastChild Then
		    MyConnections(ub) = Connection_None
		  Else
		    MyConnections(ub) = Connection_Normal
		  End if
		  Info.ConnectionList = MyConnections
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ContrastingColor(InputColor as Color) As Color
		  if (InputColor.Red*0.299 + InputColor.Green*0.587 + InputColor.Blue*0.114) > 128 then
		    Return &c000000
		  else
		    Return &cFFFFFE
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawHierLines(g as graphics, row As integer)
		  Dim Tag As Variant = Super.RowTag(row)
		  If Not(Tag IsA RowInfo) Then Return
		  Dim Info As RowInfo = RowInfo(Tag)
		  
		  
		  Dim MidY As Integer = RowHeight\2, X,Y as Integer
		  Dim EndY As Integer = g.Height -1
		  
		  g.ForeColor = NodeLineColor
		  #If TargetMacOS
		    g.PenWidth = 1.5
		  #endif
		  
		  Dim Indent As Integer = Info.Indent
		  If Info.NodeType = Node_Folder _
		    AND Info.HasChildren _
		    AND Expanded(row) Then
		    
		    X = HierDisclosureMidX(Info.Indent)
		    g.DrawLine X, midY + 2, X, EndY
		  End If
		  
		  If Indent = 0 Then Return
		  
		  Dim ConnectionList() as Byte = Info.ConnectionList
		  Dim ub As Integer = ConnectionList.Ubound
		  Dim Level As Integer
		  
		  
		  For Level = 0 to ub
		    
		    Select Case ConnectionList(level)
		    Case Connection_None
		      
		      'Do Nothing
		    Case Connection_Last
		      X = HierDisclosureMidX(Level)
		      g.DrawLine X, 0,X,MidY
		    Case Connection_Normal
		      X = HierDisclosureMidX(Level)
		      g.DrawLine X, 0,X,EndY
		    Else
		      Raise Error(New OutOfBoundsException, "DrawHierLines: Unknown Connection Type: "+Str(ConnectionList(level)))
		    End Select
		  Next
		  
		  If Info.InhibitParentConnection Then Return
		  Dim XEnd as Integer
		  
		  Select Case Info.NodeType
		  Case Node_Folder
		    g.DrawLine X, midY, X+8, midY
		  Case Node_Item, Node_Other
		    If ChildLinesCellWidth Then
		      g.DrawLine X, midY,X+ me.Column(0).WidthActual , MidY
		    Else
		      g.DrawLine X, midY,X+ 12 , MidY 'HierDisclosureMidX(Info.indent), midY
		    End if
		    
		  Else
		    Raise Error(New OutOfBoundsException, "DrawHierLines: Unknown Node Type: "+Str(Info.NodeType))
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function Error(RTException As RunTimeException, Msg as String, ErrNo As Integer = 0) As RunTimeException
		  RTException.Message = Msg
		  RTException.ErrorNumber = ErrNo
		  Return RTException
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExpandFully(row as integer = - 1)
		  If Not Hierarchical Then Return
		  
		  ExpandAll = True
		  
		  If ParentStack.Ubound  > -1 Then Return
		  
		  If row > -1 then
		    Expanded(row)= True
		  Else
		    For row = ListCount -1 DownTo 0
		      Expanded(row) = True
		    Next
		  End if
		  
		  ExpandAll = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetAssignCellTagSubclass(row As integer, column as integer) As ItemInfo
		  Dim V as Variant = Super.CellTag(row,column)
		  If V isA ItemInfo Then Return V
		  
		  Dim Info as ItemInfo = MakeCellTag(row,column)
		  If Info is NIL Then Info = New ItemInfo
		  Info.Tag = V
		  Super.CellTag(row,column) = Info
		  
		  Return Info
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetAssignRowTagSubclass(row As integer) As RowInfo
		  Dim V as Variant = Super.RowTag(row)
		  
		  If V isA RowInfo then Return V
		  
		  Dim Info as RowInfo = MakeRowTag(row)
		  If Info is NIL Then Info = New RowInfo
		  Info.Tag = V
		  Super.RowTag(row) = Info
		  
		  Return Info
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HierarchicalKeyDownHandler(key as String, SelectedRow as Integer) As Boolean
		  Dim Tag As Variant = Super.RowTag(SelectedRow)
		  If NOT (tag IsA RowInfo) Or RowInfo(tag).NodeType <> Node_Folder Then Return False
		  
		  Static SpaceBarKeyCode as Integer
		  if SpaceBarKeyCode = 0 then
		    While Keyboard.KeyName(SpaceBarKeyCode) <> "Space"
		      SpaceBarKeyCode = SpaceBarKeyCode +1
		    Wend
		  end if
		  
		  If Keyboard.OptionKey THEN
		    Select Case Asc(key)
		    Case 30
		      Expanded(SelectedRow) = False
		    Case 31
		      If NOt Expanded(SelectedRow) Then
		        If Keyboard.ShiftKey Then
		          ExpandFully(SelectedRow)
		        Else
		          Expanded(SelectedRow) = True
		        End If
		      End If
		    ELSE
		      If Keyboard.AsyncKeyDown(SpaceBarKeyCode) THEN
		        If Expanded(SelectedRow) Then
		          Expanded(SelectedRow) = False
		        Else
		          ExpandFully(SelectedRow)
		        End if
		      END IF
		    End Select
		    Return True
		  END IF
		  
		  IF Asc(key) = 32 Then 'SPACE
		    Expanded(SelectedRow) = NOT Expanded(SelectedRow) 
		    Return True
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function HierDisclosureMidX(Level as Integer) As Integer
		  
		  #if targetwin32 then
		    Static XOffset As Integer
		    If XOffset  > 0 Then Return 20 + (Level)*12 - Xoffset
		    If WinVersion >= WinVersions.XP Then
		      Xoffset = 11 'XP+
		    Else
		      Xoffset = 10 'Win2K
		    End if
		    Return 20 + (Level)*12 - Xoffset
		  #elseIf TargetCocoa
		    Return 20 + (Level)*12 - 11
		  #else
		    Return 20 + (Level)*12 - 11
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InhibitConnector(Row As Integer)
		  If Not (Hierarchical AND DrawNodeLines) Then Return 
		  
		  
		  If  ParentStack.Ubound = -1 Then
		    Dim err as New UnsupportedOperationException
		    err.Message = "InhibitConnector May only be called from the ExpandRow Event"
		    Raise Err
		    
		  ElseIf RowDepth(row) = 0 Then
		    Dim err as New OutOfBoundsException
		    err.Message = "InhibitConnector is valid only for rows with an ident Level > 0"
		    Raise Err
		  End if
		  
		  Dim V as Variant = Super.RowTag(row)
		  
		  If NOT V isA RowInfo Then 
		    Dim err as New RuntimeException
		    err.Message = "Unkown Error: InhibitConnector called on Row with undefined indent leve' "
		    Raise Err
		  End iF
		  
		  Dim Info as RowInfo = RowInfo(V)
		  
		  Info.InhibitParentConnection = True
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertFolder(row As Integer, text As String, indent As Integer=0)
		  Super.InsertFolder row, Text, indent
		  If Not Hierarchical Then Return
		  Dim Info as RowInfo = GetAssignRowTagSubclass(LastIndex)
		  Info.NodeType = Node_Folder
		  Info.Indent = indent
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRow(row As Integer, text As String, indent As Integer=0)
		  Super.InsertRow row, Text, indent
		  If Not Hierarchical Or indent = 0 Then Return
		  
		  Dim Info as RowInfo = GetAssignRowTagSubclass(LastIndex)
		  Info.Indent =  indent
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ListBackgroundColor() As Color
		  Dim theColor as Color
		  
		  #if TargetCocoa 
		    #if XojoVersion >= 2018.03 
		      If IsDarkMode Then Return &c15161500
		    #Endif
		    Return &cFFFFFF00
		    
		  #ElseIf TargetMacOS
		    Declare function GetThemeBrushAsColor lib "Carbon" (inBrush as Integer, _
		    inDepth as Integer, _
		    inColorDev as Integer, _
		    outColor as ptr) as Integer
		    
		    dim oc as MemoryBlock = new MemoryBlock(6)
		    dim res as Integer
		    If GetThemeBrushAsColor(10, 32, 1, oc) <> 0 Then
		      theColor = &CFFFFFF
		    else
		      theColor = RGB(oc.byte(0), oc.byte(2), oc.byte(4))
		    end if
		    
		  #Elseif TargetWin32
		    dim res as memoryblock
		    Declare Function GetSysColor Lib "user32" (nIndex As integer) As integer
		    res = newmemoryBlock(4)
		    res.long(0) = getsyscolor(5)
		    theColor = rgb(res.byte(0),res.byte(1),res.byte(2))
		  #else
		    theColor = &cFFFFFF
		  #endif
		  Return theColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NewCellTagSubclass() As ItemInfo
		  Dim Info as ItemInfo = MakeCellTag(-1,-1)
		  If Info is NIL Then Info = New ItemInfo
		  Return Info
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NewRowTagSubclass() As RowInfo
		  Dim Info as RowInfo = MakeRowTag(-1)
		  If Info is NIL Then Info = New RowInfo
		  Return Info
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Sub PaintText(g as graphics, Txt as String, gWidth as Integer, gHeight as integer, AlignV As Integer, AlignH as Integer, LineSpacing as integer, HOffset As Integer, VOffset as integer,  EOLPos As Integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  'If Txt.LenB = 0 then Return ' Do In Event to save jump
		  
		  Dim Pos,X,Y As Integer, TxtHt As Integer = g.TextHeight, Ascent As Integer = g.TextAscent
		  
		  gWidth = gWidth - TextMargin ' empirical adjustments for RB Listbox margins
		  
		  Static EOL as String = EndOfLine
		  
		  Dim StrWidth as Integer , TmpStr as String
		  
		  Static JoinArray() as String = Array("", Ellipsis)
		  
		  If TxtHt + LineSpacing +TxtHt > gHeight then LineSpacing = NoWrap
		  
		  If EOLPos = 0 Then
		    If LineSpacing >-1 Then
		      StrWidth = Ceil(g.StringWidth(txt))
		      If StrWidth <= gWidth Then LineSpacing = NoWrap
		    End if
		    
		  ElseIf LineSpacing < 0 then ' needs an Ellipsis on the end if it fits or not
		    
		    JoinArray(0) = txt.LeftB(EOLPos-1)
		    txt = Join(JoinArray,"")
		    JoinArray(0) = ""
		    StrWidth = Ceil(g.StringWidth(txt))
		    
		  End if
		  
		  
		  if LineSpacing <= NoWrap Then
		    If StrWidth = 0 then StrWidth = Ceil(g.StringWidth(txt))
		    
		    If gHeight <= TxtHt Then
		      Y= Ascent + VOffset
		    Else
		      Select Case AlignV
		      Case AlignDefault, AlignCenter
		        Y = (gHeight - TxtHt)/2 + Ascent + VOffset
		      Case AlignTop
		        Y= Ascent + VOffset
		      Case AlignBottom
		        Y = gHeight - TxtHt + Ascent + VOffset
		      Else
		        Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for VertAlign: " +str(AlignV))
		      end Select
		      
		       Select Case AlignH
		      Case AlignDefault, AlignLeft
		        X = HOffset
		        
		      Case AlignCenter
		        X = (gWidth - StrWidth)\2 + HOffset
		      Case AlignRight
		        X = gWidth - StrWidth + HOffset
		      Else
		        Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH))
		      End Select
		      If X < 0 then X = 0
		    End if
		    
		    g.DrawString txt,X,y,gWidth - X, true
		    Return
		  End If
		  
		  Dim Paragraphs() as String, ubPgraph, AvailableHt, AvailableWidth as Integer
		  
		  If VOffset < 0 then
		    AvailableHt = g.Height
		  Else
		    AvailableHt = gHeight- VOffset
		  End if
		  
		  If HOffset < 0 then
		    AvailableWidth = gWidth 
		  Else
		    AvailableWidth = gWidth- HOffset
		  End if
		  
		  
		  If EOLPos = 0 then
		    ReDim Paragraphs(0)
		    Paragraphs(0) = txt
		  Else
		     Paragraphs = Txt.SplitB(EOL)
		    ubPgraph = Paragraphs.Ubound
		  End if
		  
		  Const Space =32
		  Const Dash = 45
		  
		  Dim Lines() as String, isLineStart As Boolean
		  dim TotalHt,i, LeftCharPos, MidCharPos, RightCharPos, LnIdx,EllipsisWidth as Integer
		  
		  Dim MaxLines as Integer
		  
		  if AvailableHt > TxtHt then MaxLines = (AvailableHt+ LineSpacing)\(TxtHt+ LineSpacing) -1
		  
		  For i = 0 to ubPGraph
		    txt = Paragraphs(i)
		    isLineStart = True
		    Do
		      
		      StrWidth = Ceil(g.StringWidth(Txt))
		      
		      If  LnIdx = MaxLines And EllipsisWidth = 0 AND (i < ubPgraph Or StrWidth > AvailableWidth) Then
		        EllipsisWidth = Ceil(g.StringWidth(Ellipsis))
		        AvailableWidth = AvailableWidth - EllipsisWidth
		      End if
		      
		      If StrWidth <= AvailableWidth then
		        If isLineStart And AlignH <= AlignLeft Then
		          Lines.Append Txt
		        Else
		          Select Case AlignH
		          Case AlignDefault,AlignLeft
		            Lines.Append Txt.LTrim
		          Case AlignCenter
		            Lines.Append Txt.Trim
		          Case AlignRight
		            Lines.Append Txt.RTrim
		          Else
		            Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +Str(AlignH))
		          End Select
		        End if
		        LnIdx = LnIdx + 1
		        If LnIdx > MaxLines Then Exit For
		        Exit Do
		        
		      End If
		      
		      
		      'Find Point need to break
		      LeftCharPos = 1
		      RightCharPos = Txt.Len
		      
		      While RightCharPos <> LeftCharPos
		        MidCharPos = (LeftCharPos + RightCharPos)\2
		        If Ceil(g.StringWidth(Txt.Left(MidCharPos))) <= AvailableWidth then
		          LeftCharPos = MidCharPos + 1
		        Else
		          RightCharPos = MidCharPos
		        End if
		      Wend
		      LeftCharPos = LeftCharPos -1
		      
		      
		      If LeftCharPos <= 1 then
		        Lines.Append Txt.Left(1)
		        LnIdx = LnIdx + 1
		        If MaxLines < LnIdx Then Exit For
		        isLineStart = False
		        If txt.LenB = 0 Then Exit
		        txt = Txt.Mid(2)
		        Continue
		      End if
		      
		      RightCharPos = LeftCharPos
		      
		      
		      'Find first Char that may Break but if 0 then use original LeftCharPos
		      
		      Do
		        Select Case Asc(Txt.MidB(RightCharPos,1))
		        Case Space,Dash
		          If isLineStart And AlignH <= AlignLeft Then
		            Lines.Append Txt.Left(RightCharPos)
		            isLineStart = False
		          Else
		            Select Case AlignH
		            Case AlignDefault,AlignLeft
		              Lines.Append Txt.Left(RightCharPos).LTrim
		            Case AlignCenter
		              Lines.Append Txt.Left(RightCharPos).Trim
		            Case AlignRight
		              Lines.Append Txt.Left(RightCharPos).RTrim
		            Else
		              Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH))
		            End Select
		          End if
		          LnIdx = LnIdx + 1
		          
		          If LnIdx > MaxLines  Then Exit For
		          Txt = Txt.Mid(RightCharPos+ 1)
		          Exit Do
		        End Select
		        
		        RightCharPos = RightCharPos -1
		        If RightCharPos <= 0 then
		          If isLineStart And AlignH <= AlignLeft Then
		            Lines.Append Txt.Left(LeftCharPos)
		            isLineStart = False
		          Else
		            Select Case AlignH
		            Case AlignDefault,AlignLeft
		              Lines.Append Txt.Left(LeftCharPos).LTrim
		            Case AlignCenter
		              Lines.Append Txt.Left(LeftCharPos).Trim
		            Case AlignRight
		              Lines.Append Txt.Left(LeftCharPos).RTrim
		            Else
		              Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH))
		            End Select
		          End if
		          LnIdx = LnIdx + 1
		          If LnIdx > MaxLines Then Exit For
		          txt =Txt.Mid(LeftCharPos + 1)
		          Exit Do
		        End if
		      Loop
		      
		    Loop Until txt.LenB = 0
		    isLineStart = False
		  Next
		  LnIdx = LnIdx -1
		  ubPgraph = LnIdx
		  TotalHt = TxtHt *(LnIdx + 1) + LineSpacing*LnIdx
		  
		  if EllipsisWidth > 0 Then
		    JoinArray(0) = Lines(Lines.Ubound)
		    Lines(ubPgraph) = Join(JoinArray,"")
		    JoinArray(0) = ""
		    AvailableWidth = AvailableWidth + EllipsisWidth
		  End if
		  
		  Select Case AlignV
		  Case Listbox.AlignCenter, Listbox.AlignDefault
		    Y = (gHeight - TotalHt)\2 + VOffset
		  Case AlignTop
		    Y = VOffset
		  Case AlignBottom
		    Y = gHeight - TotalHt + VOffset 
		  Else
		    Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for VertAlign: " +str(AlignV))
		  End Select
		  If Y < 0 then
		    Y = Ascent
		  Else
		    Y = Y + Ascent
		  End if
		  
		  ubPGraph = Lines.Ubound
		  
		  Select case AlignH
		  Case Listbox.AlignLeft,Listbox.AlignDefault
		     if HOffset < 0 then HOffset = 0
		    For i = 0 to ubPGraph
		      g.DrawString Lines(i), HOffset ,Y
		      Y = Y + TxtHt + LineSpacing
		    Next
		    
		  CASE Listbox.AlignCenter
		    For i = 0 to ubPGraph
		      Txt = Lines(i)
		      StrWidth = Ceil(g.StringWidth(txt))
		      X = (gWidth - StrWidth)\2 + HOffset
		      If X < 0 Then
		        g.DrawString txt, 0 ,Y
		      Else
		        g.DrawString txt, X ,Y
		      End if
		      
		      Y = Y + TxtHt + LineSpacing
		    Next
		    
		    
		  Case Listbox.AlignRight
		    
		    For i = 0 to ubPGraph
		      Txt = Lines(i)
		      StrWidth = Ceil(g.StringWidth(txt))
		      X = gWidth - StrWidth
		      If X < 0 then X = 0
		      g.DrawString txt, X ,Y
		      
		      Y = Y + TxtHt + LineSpacing
		      
		    Next
		    
		  Else
		    Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(AlignH))
		    
		  End Select
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RealAddRow(Text As String)
		  Super.AddRow Text
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RealCellTag(row as Integer, column as Integer) As Variant
		  If Row >= ListCount Then Return NIL
		  Return Super.CellTag(row, column)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RealCellTag(row as Integer, column as Integer, Assigns Tag As Variant)
		  Super.CellTag(row, column) = tag
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RealInsertFolder(row As Integer, text As String, indent As Integer=0)
		  Super.InsertFolder row, Text, indent
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RealInsertRow(row As Integer, text As String, indent As Integer=0)
		  Super.InsertRow row, Text, indent
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RealRowTag(row as Integer) As Variant
		  Return Super.RowTag(row)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RealRowTag(row as Integer, Assigns Tag As variant)
		  Super.RowTag(row) = tag
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowColor(row as Integer) As Color
		  Dim V As Variant = Super.RowTag(row)
		  If V IsA RowInfo Then
		    Return RowInfo(V).RowColor
		  Else
		    Return &c000000
		  End if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RowColor(row as Integer, assigns theColor As Color)
		  Dim V As Variant = Super.RowTag(row)
		  If V IsA RowInfo Then
		    RowInfo(V).RowColor = theColor
		  Else
		    Dim Info as RowInfo = GetAssignRowTagSubclass(row)
		    Info.RowColor = theColor
		  End if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowDepth(row As Integer) As Integer
		  #if RBVersion >= 2014.0299999 
		     Return Super.RowDepth(row)
		  #else
		    If Not Hierarchical Then Return 0
		    
		    Dim V as Variant = Super.RowTag(row)
		    If V isA RowInfo Then
		      Return RowInfo(V).Indent
		    Else
		      Return 0
		    End if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowIsFolder(row As Integer) As Boolean
		  #if RBVersion >= 2014.0299999
		    Return Super.RowIsFolder(row)
		  #else
		    If Not Hierarchical Then Return False
		    Dim V as Variant = Super.RowTag(row)
		    Return V isA RowInfo AND RowInfo(V).NodeType = Node_Folder
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RowIsFolder(row As Integer, Assigns Value as Boolean)
		  If Not Hierarchical Then Return 
		  
		  Dim info as RowInfo
		  
		  #if RBVersion >= 2014.029999 Then
		    If Value = Super.RowIsFolder(row)  Then Return
		    Info  = GetAssignRowTagSubclass(Row)
		    
		    If Value Then
		      Info.NodeType = Node_Folder
		      Super.RowIsFolder(row)  = True
		      InvalidateCell(row,-1)
		      
		    Else
		      info.NodeType = Node_Item
		      Super.RowIsFolder(row)  = False
		      InvalidateCell(row,-1)
		    End if
		    
		    Return
		    
		  #else
		    Dim V As Variant = Super.RowTag(row)
		    If (V is NIL) Or  Not (V isA RowInfo) Then 
		      If NOT Value Then Return
		      Info = GetAssignRowTagSubclass(row)
		    Else
		      info = V
		    End if
		    
		    If Value Then
		       If Info.NodeType = Node_Folder Then 
		        Return
		      Else
		        Info.NodeType = Node_Folder
		      End if
		    ElseIf Info.NodeType = Node_Item Then
		      Return
		    Else
		      Info.NodeType = Node_Item
		    End if
		    
		    Dim CellInfo() as CellDefinition , ubCol as Integer = me.ColumnCount -1, col as Integer
		    ReDim CellInfo(ubCol)
		    For col = 0 to ubCol
		      CellInfo(col) = me.CellFullDefinition(row,col)
		    Next
		    
		    Dim RowPic as Picture = Super.RowPicture(row)
		    super.RemoveRow Row
		    If Info.NodeType =  Node_Folder Then
		      Super.InsertFolder row, "", Info.Indent
		    Else
		      Super.InsertRow row, "", Info.Indent
		    End if
		    Super.RowTag(row) = Info
		    For col = 0 to ubCol
		      me.CellFullDefinition(row, col) = CellInfo(col) 
		    Next
		    If NOT (RowPic is NIL)  then Super.RowPicture(row) = RowPic
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowTag(row as Integer) As Variant
		  Dim V As Variant = Super.RowTag(row)
		  If V IsA RowInfo Then
		    Return RowInfo(V).Tag
		  Else
		    Return V
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RowTag(row as Integer, assigns Tag As Variant)
		  Dim V As Variant = Super.RowTag(row)
		  If V IsA RowInfo Then
		    RowInfo(V).Tag = Tag
		  Else
		    Super.RowTag(row) = Tag
		  End if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function TextXOffset(row as integer,column as integer) As Integer
		  Dim offset as Integer
		  Const LevelIndent = 12
		  Const InitialHierOffset = 16
		  Const WidgetWidth = 20
		  
		  If column = 0 then 
		    If Hierarchical then
		      offset = InitialHierOffset
		      #if RBVersion >= 2014.02999999
		        offset = offset + RowDepth(row)*LevelIndent 
		      #else
		        Dim Tag As Variant = Super.RowTag(row)
		        If Tag IsA RowInfo Then offset = offset + RowInfo(tag).Indent*LevelIndent 
		      #endif
		    End if
		    If RowPicture(row) <> NIL Then offset = offset + WidgetWidth
		  End if
		  
		  Dim TypeCell As Integer = CellType(row,column)
		  
		  If TypeCell= TypeCheckbox _
		    Or (TypeCell = TypeDefault AND ColumnType(column) = TypeCheckbox) Then 
		    offset = Offset + WidgetWidth
		  End if
		  
		  Return Offset + TextMargin
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function WinVersion() As WinVersions
		  Static WinVer as WinVersions = WinVersions.NotWindows
		  
		  #If TargetWin32
		    IF WinVer = WinVersions.NotWindows Then
		      
		      Dim m As MemoryBlock
		      dim res as boolean
		      dim dwOSVersionInfoSize,wsuitemask,ret,i as integer
		      dim szCSDVersion,s as string
		      
		      Soft Declare Function GetVersionExA Lib "kernel32" (lpVersionInformation As ptr) As integer
		      Soft Declare Function GetVersionExW Lib "kernel32" (lpVersionInformation As ptr) As integer
		      
		      dim bUsingUnicode as Boolean = false
		      if System.IsFunctionAvailable( "GetVersionExW", "Kernel32" ) then
		        bUsingUnicode = true
		        m = newMemoryBlock(284) ''use this for osversioninfoex structure (2000+ only)
		        m.long(0) = m.size 'must set size before calling getversionex
		        ret = GetVersionExW(m) 'if not 2000+, will return 0
		        if ret = 0 then
		          m = newMemoryBlock(276)
		          m.long(0) = m.size 'must set size before calling getversionex
		          ret = GetVersionExW(m)
		          if ret = 0 then
		            // Something really strange has happened, so use the A version
		            // instead
		            bUsingUnicode = false
		            goto AVersion
		            WinVer = WinVersions.Unknown
		            
		          end
		        end
		      else
		        AVersion:
		        m = newMemoryBlock(156) ''use this for osversioninfoex structure (2000+ only)
		        m.long(0) = m.size 'must set size before calling getversionex
		        ret = GetVersionExA(m) 'if not 2000+, will return 0
		        if ret = 0 then
		          m = newMemoryBlock(148) ' 148 sum of the bytes included in the structure (long = 4bytes, etc.)
		          m.long(0) = m.size 'must set size before calling getversionex
		          ret = GetVersionExA(m)
		          if ret = 0 then
		            WinVer = WinVersions.Unknown
		            
		          end
		        end
		      end if
		      
		      Dim mmajorVersion as Integer = m.long(4)
		      Dim mminorVersion as Integer = m.long(8)
		      Dim mbuild  as Integer = m.long(12)
		      Dim mplatformId as Integer = m.long(16)
		      if mplatformId = 2 then 'NT
		        
		        if mMajorVersion = 6 then 
		          Select Case mminorVersion
		          Case 0
		            WinVer = WinVersions.Vista
		          Case 1
		            WinVer = WinVersions.Win7
		          Case 2
		            WinVer = WinVersions.Win8
		          Else
		            WinVer = WinVersions.After8
		          End Select
		          
		        elseif mmajorversion = 4 then 'NT4
		          'mOSName = "Windows NT 4.0"
		          WinVer = WinVersions.Pre2K
		        elseif mmajorVersion = 5 then
		          if mminorVersion = 0 then '2000
		            WinVer = WinVersions.Win2K
		          elseif mminorVersion = 1 then 'XP
		            WinVer = WinVersions.XP
		          elseif mminorVersion = 2 then '2003
		            'mOSName = "Windows 2003"
		            WinVer = WinVersions.Win2K
		          end if
		        Else
		          WinVer = WinVersions.Unknown
		        end
		      Else
		        WinVer = WinVersions.Pre2K
		      End if
		    End if
		  #Endif
		  
		  Return WinVer
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CellBackgroundPaint(g as graphics,row as integer, column as integer) As boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellKeyDown(row as Integer, column as Integer, key as String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellLostFocus(row as Integer, column as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellTextPaint(g as graphics, row as integer, column as integer, x as integer, y as Integer,  ByRef VertAlign As Integer, ByRef VOffset As integer, ByRef LineSpacing as integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ExpandRow(row as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event KeyDown(key as String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MakeCellTag(row as Integer, column As Integer) As ItemInfo
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MakeRowTag(row as Integer) As RowInfo
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SupressTextPaint(row as Integer,column As integer) As Boolean
	#tag EndHook


	#tag Property, Flags = &h0
		AltBackColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		BackColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		ChildLinesCellWidth As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ChildrenTakeParentColor As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected CustomEdit As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DrawNodeLines As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ExpandAll As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Active And Enabled And (Window.Focus is Me Or CustomEdit)
			  
			End Get
		#tag EndGetter
		IsActive As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected LastListIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastSelectCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NodeLineColor As Color = &cA2A2A2
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ParentStack() As RowInfo
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected SupressTextPaint As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected TmpBkgColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		WrapByDefault As Boolean = True
	#tag EndProperty


	#tag Constant, Name = AlignBottom, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AlignTop, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AlignVertDefault, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Connection_Last, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Connection_None, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Connection_Normal, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Node_Folder, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Node_Item, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Node_Other, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = NoWrap, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TextMargin, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = WinVersions, Type = Integer, Flags = &h1
		NotSet
		  NotWindows
		  Unknown
		  Pre2K
		  Win2K
		  XP
		  Vista
		  Win7
		  Win8
		After8
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridLinesHorizontal"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - None"
				"2 - ThinDotted"
				"3 - ThinSolid"
				"4 - ThickSolid"
				"5 - DoubleThinSolid"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridLinesVertical"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - None"
				"2 - ThinDotted"
				"3 - ThinSolid"
				"4 - ThickSolid"
				"5 - DoubleThinSolid"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasHeading"
			Visible=true
			Group="Appearance"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollbarHorizontal"
			Visible=true
			Group="Appearance"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollBarVertical"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowDropIndicator"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=true
			Group="Font"
			InitialValue="System"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextUnit"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inch"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoHideScrollbars"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnsResizable"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnableDrag"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnableDragReorder"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hierarchical"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectionType"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Single"
				"1 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnCount"
			Visible=true
			Group="Appearance"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnWidths"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialValue"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HeadingIndex"
			Visible=true
			Group="Appearance"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultRowHeight"
			Visible=true
			Group="Appearance"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Appearance"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AltBackColor"
			Visible=true
			Group="Appearance"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataSource"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataSource"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataField"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataField"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RequiresSelection"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ChildrenTakeParentColor"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WrapByDefault"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawNodeLines"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NodeLineColor"
			Visible=true
			Group="Behavior"
			InitialValue="&cA2A2A2"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ChildLinesCellWidth"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsActive"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_ScrollWidth"
			Group="Appearance"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_ScrollOffset"
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Type="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
