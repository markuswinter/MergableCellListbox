#tag Class
Class ListboxMergable
Inherits ListboxClass
Implements MergeableLB
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  CellAction(row,column)
		End Sub
	#tag EndEvent

	#tag Event
		Function CellBackgroundPaint(g as graphics,row as integer, column as integer) As boolean
		  CurrentRow = row
		  CurrentColumn = Column
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  if (LastHt <> Height Or LastWidth <> Width) Then ' Listbox Resized
		    LastHt = Height
		    LastWidth = Width
		    If CustomEdit Or ActiveCell.Visible Then SetFocus
		  End if
		  
		  If row >= ListCount Then _
		  Return CellBackgroundPaint(g, row, column,False)
		  
		  Dim RealTag as Variant = RealCellTag(row,column)
		  If  NOT ( RealTag isA MergedCells) Then 
		    Return CellBackgroundPaint(g, row, column,Selected(row))
		  End if
		  
		  SupressTextPaint = True
		  Dim Block As MergedCells = MergedCells(RealCellTag(row,Column))
		  'If Block.BeingEdited Then Return True
		  
		  Dim ThisRowSelected As Boolean = Selected(row)
		  Dim idx As Integer
		  
		  
		  Dim Xoffset,r as integer
		  Dim BlockFirstCol As Integer = Block.LeftColumn
		  Dim BlockColumns As Integer = Block.Columns
		  Dim BlockLastCol As Integer = BlockFirstCol + BlockColumns - 1
		  Dim BlockTop As Integer = Block.TopRow
		  Dim BlockRows As Integer = Block.Rows
		  Dim BlockLastRow  as Integer = BlockTop + BlockRows -1
		  Dim isSelected as Boolean = Block.isSelected
		  
		  Block.isSelected = False
		  If BlockRows > 1 Then
		    
		    for r = BlockTop to BlockLastRow
		      If  Super.Selected(r) Then
		        Block.isSelected = True
		        Exit
		      End iF
		    Next
		  Else
		    Block.isSelected = ThisRowSelected
		  End
		  
		  isSelected = Block.isSelected
		  
		  Dim FullWidth as Integer
		  For col as Integer = column - 1 DownTo BlockFirstCol
		    FullWidth = FullWidth + Column(col).WidthActual
		  Next
		  XOffset = FullWidth
		  
		  For col as Integer = column To BlockLastCol
		    FullWidth = FullWidth + Column(col).WidthActual
		  Next
		  
		  Dim Yoffset as Integer = (row-BlockTop)*RowHeight
		  
		  Dim FullHeight as Integer = Block.Rows*RowHeight
		  
		  g.ForeColor = BackgroundColor(BlockTop, isSelected, IsActive)
		  
		  'If isSelected Then
		  'g.ForeColor = BackgroundColor(isSelected, IsActive)
		  'ElseIf BlockTop Mod 2 = 0 Then
		  'If  BackColor <> &c000000 Then
		  'g.ForeColor = BackColor
		  'Else
		  'g.ForeColor = ListBackgroundColor
		  'End if
		  'ElseIf AltBackColor <> &c000000 Then
		  'g.ForeColor = AltBackColor
		  'ElseIf BackColor <> &c000000 Then
		  'g.ForeColor = BackColor
		  'Else
		  'g.ForeColor = ListBackgroundColor
		  'End if
		  
		  Dim BkgColor as Color = g.ForeColor
		  
		  'Dim gNew as Graphics = g.Clip(-Xoffset , -Yoffset, g.Width+Xoffset, g.Height + Yoffset)
		  Dim gNew as Graphics = g.Clip(-Xoffset , -Yoffset, FullWidth,  FullHeight)
		  gNew.forecolor = g.forecolor
		  gNew.TextFont = g.TextFont
		  gNew.TextSize = g.TextSize
		  gNew.Bold = g.Bold
		  gNew.Italic = g.Italic
		  gNew.Underline = g.Underline
		  
		  If NOT CellBackgroundPaint(gNew, BlockTop, BlockFirstCol,isSelected) Then 
		    g.foreColor = gNew.ForeColor
		    g.FillRect 0,0, g.Width, g.Height
		  End if
		  
		  ' -------------- Start the TextPaint -------------------------
		  If row = -1 Or row >= me.ListCount Then Return True
		  
		  Dim RealBkgColor As Color  =  gNew.forecolor
		  #if UseCachedBkgColor Then
		    BkgColor = gNew.forecolor
		  #endif
		  g.forecolor = ContrastingColor(BkgColor)
		  
		  If Super.CellBold(BlockTop, BlockFirstCol) then
		    g.Bold = True
		  Else
		    g.Bold = Bold
		  End if
		  If Super.CellItalic(BlockTop, BlockFirstCol) then
		    g.Italic = True
		  Else
		    g.Italic = Italic
		  End if
		  
		  If Super.CellUnderline(BlockTop, BlockFirstCol) then
		    g.Underline = true
		  Else
		    g.Underline = Underline
		  End if
		  'g.textfont = TextFont
		  'me.TextSize = me.TextSize
		  
		  
		  Dim TxtOffset As Integer = TextXOffset(BlockTop, BlockFirstCol)
		  Xoffset =  Xoffset - TxtOffset
		  FullWidth = FullWidth - TxtOffset -2 '2 is diff between g.width for backgroundpaint and textpaint
		  
		  
		  Dim X, HAlign, HOffset, Y, AlignV, VOffset,LineSpacing as Integer,TxtHt As Integer = g.TextHeight
		  
		  IF Not WrapByDefault Or FullHeight <= TxtHt + TxtHt Then LineSpacing = NoWrap
		  
		  Y  = (FullHeight - g.TextHeight)\2 + g.TextAscent
		  gNew = g.Clip(-Xoffset, -Yoffset, FullWidth, FullHeight)
		  gNew.forecolor = g.forecolor
		  gNew.TextFont = g.TextFont
		  gNew.TextSize = g.TextSize
		  gNew.Bold = g.Bold
		  gNew.Italic = g.Italic
		  gNew.Underline = g.Underline
		  
		  ' This was to precalculate X for TextPaint event ... But not sure it's worth the cycles
		  
		  'Dim CellText as String = Super.Cell(BlockTop,BlockFirstCol)
		  '
		  'If CellText.LenB = 0 then 
		  'CAll CellTextPaint(gNew, BlockTop, BlockFirstCol, X,Y, FullWidth,FullHeight,isSelected,_
		  'AlignV,VOffset, LineSpacing)
		  'Return True
		  'End if
		  
		  
		  'HAlign = Super.CellAlignment(BlockTop,BlockFirstCol)
		  'IF HAlign = AlignDefault Then HAlign = ColumnAlignment(column)
		  '
		  'HOffset = Super.CellAlignmentOffset(BlockTop,BlockFirstCol)
		  'If HOffset = 0 then HOffset = ColumnAlignmentOffset(column)
		  '
		  'Dim DecPos As Integer
		  '
		  'Select Case HAlign
		  'Case AlignLeft, AlignDefault
		  'If HOffset < 0 then
		  'X = 0
		  'Else
		  'X = HOffset
		  'End if
		  'Case AlignCenter
		  'X = (FullWidth - Ceil(g.StringWidth(CellText))\2) + HOffset
		  'If X < 0 then X = 0
		  'Case AlignRight
		  'X = FullWidth - Ceil(g.StringWidth(CellText)) + HOffset
		  'Case AlignDecimal
		  'DecPos = CellText.InStrB(".")
		  'if DecPos = 0 then
		  'X = FullWidth - Ceil(g.StringWidth(CellText)) + HOffset -1
		  'Else
		  'X = FullWidth - Ceil(g.StringWidth(CellText.LeftB(DecPos)))+ HOffset -1
		  'End if
		  'End Select
		  '
		  
		  If CellTextPaint(gNew, BlockTop, BlockFirstCol, X,Y,isSelected, AlignV,VOffset, LineSpacing) Then
		    Return True
		  End if
		  
		  ' This was done above
		  Dim CellText as String = Super.Cell(BlockTop,BlockFirstCol)
		  
		  If CellText.LenB = 0 then Return True
		  
		  
		  HAlign = Super.CellAlignment(BlockTop,BlockFirstCol)
		  IF HAlign = AlignDefault Then HAlign = ColumnAlignment(column)
		  
		  HOffset = Super.CellAlignmentOffset(BlockTop,BlockFirstCol)
		  If HOffset = 0 then HOffset = ColumnAlignmentOffset(column)
		  
		  
		  If HAlign = AlignDecimal Then
		    Select Case AlignV
		    Case AlignDefault, AlignCenter
		      Y = (FullHeight - TxtHt)\2 + VOffset
		    Case AlignTop
		      Y = VOffset
		    Case AlignBottom
		      Y = FullHeight - TxtHt + VOffset
		    Else
		      Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for VertAlign: " +str(AlignV))
		    End Select
		    
		    If Y < 0 then
		      Y = gNew.TextAscent
		    Else
		      Y = Y + gNew.TextAscent
		    End If
		    Dim Pos As Integer = CellText.InStrB(".")
		    if Pos = 0 then
		      X = FullWidth - Ceil(g.StringWidth(CellText)) + HOffset -1
		    Else
		      X = FullWidth - Ceil(g.StringWidth(CellText.LeftB(pos)))+ HOffset -1
		    End if
		    gNew.DrawString CellText, X,Y
		    gNew.ForeColor = RealBkgColor
		    gNew.FillRect FullWidth-2,0, 7, FullHeight
		    
		    Return true
		  End if
		  
		  Static EOL as String = EndOfLine
		  Dim Pos as Integer = CellText.InStrB(EOL)
		  
		  If Pos > 0 then ' has Paragraphs so needs an Ellipsis repardless of length so pass to Wrap method
		    PaintText(gNew,CellText, FullWidth,FullHeight,AlignV,HAlign,LineSpacing,HOffset, VOffset,Pos)
		    Return True
		  ElseIf LineSpacing >= 0 or FullHeight >= TxtHt + LineSpacing + TxtHt Then ' may wrap so pass to wrap method
		    PaintText(gNew,CellText, FullWidth,FullHeight,AlignV,HAlign,LineSpacing,HOffset, VOffset,Pos)
		    Return True
		  End if
		  
		  
		  'Must be a single line
		  
		  
		  Dim StrWidth As Integer
		  FullHeight = FullHeight - VOffset
		  
		  Select Case HAlign
		  Case AlignDefault, AlignLeft
		    X = HOffset
		    
		  Case AlignCenter
		    StrWidth = Ceil(g.StringWidth(CellText))
		    X = (FullWidth - StrWidth)\2 + HOffset
		  Case AlignRight
		    StrWidth = Ceil(g.StringWidth(CellText))
		    X = FullWidth - StrWidth + HOffset
		  Else
		    Raise Error(New OutOfBoundsException, CurrentMethodName +": undefined value for HorizAlign: " +str(HAlign))
		    
		  End Select
		  If X < 0 then X = 0
		  
		  Select Case AlignV
		  Case AlignDefault, AlignCenter
		    Y = (FullHeight - TxtHt)/2 + VOffset
		  Case AlignTop
		    Y=  VOffset
		  Case AlignBottom
		    Y = FullHeight - TxtHt+ VOffset
		  Else
		    Dim err as New OutOfBoundsException
		    Err.Message = CurrentMethodName + ": undefined value for VertAlign: " +str(AlignV)
		    Raise Err
		  end Select
		  
		  If Y < 0 then 
		    Y =  gNew.TextAscent 
		  Else
		    Y = Y +  gNew.TextAscent 
		  End if
		  
		  gNew.DrawString CellText,X,Y,FullWidth- X, true
		  
		  Return true
		End Function
	#tag EndEvent

	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  
		  Dim Tag As Variant
		  
		  If SelCount > 0 And not Selected(row) Then
		    Dim found, r as Integer
		    r = ListIndex
		    While found < SelCount
		      if Selected(r) Then
		        Tag = RealRowTag(r)
		        
		        If  Tag IsA MergableRowInfo Then
		          InvalidateBlocks(MergableRowInfo(Tag).MergedBlocks)
		          
		          Dim rBlk,col, ubRows, ubCol As Integer, Block, Blocks() As MergedCells
		          Blocks = MergableRowInfo(Tag).MergedBlocks
		          For each Block in  Blocks
		            ubRows = Block.LastRow
		            ubCol = Block.LastColumn
		            For rBlk = Block.TopRow To ubRows
		              For col = Block.LeftColumn To ubCol
		                Super.InvalidateCell(rBlk,col)
		              Next
		            Next
		          Next
		          
		        End if
		        
		        found = found + 1
		      End if
		      r = r + 1
		    Wend
		  End if
		  Tag= RealCellTag(row,column)
		  
		  If NOT (Tag IsA MergedCells) THEN
		    Tag = RealRowTag(row)
		    If  (Tag IsA MergableRowInfo) Then
		      'InvalidateBlocks(MergableRowInfo(Tag).MergedBlocks)
		      Dim rBlk,col, ubRows, ubCol As Integer, Block, Blocks() As MergedCells
		      Blocks = MergableRowInfo(Tag).MergedBlocks
		      For each Block in  Blocks
		        ubRows = Block.LastRow
		        ubCol = Block.LastColumn
		        For rBlk = Block.TopRow To ubRows
		          For col = Block.LeftColumn To ubCol
		            Super.InvalidateCell(rBlk,col)
		          Next
		        Next
		      Next
		    End if
		    
		    If CellClick(row,column,x,y) Then Return True
		    
		    If selected(row) _
		      and (CellType(row,column) >= TypeEditable _
		      OR (CellType(row,column) = TypeDefault and ColumnType(column) >= TypeEditable)) Then
		      EditCell(row,column)
		      Return True
		    End if
		    Return False
		  end if
		  
		  
		  Dim TypeCell as Integer
		  
		  Dim Block As MergedCells = MergedCells(Tag)
		  
		  Dim ub as Integer = column -1
		  
		  for r as Integer = Block.LeftColumn to ub
		    X = X + Column(r).WidthActual
		  next
		  
		  Y = Y+ (row -Block.TopRow)*RowHeight
		  
		  TypeCell = Super.CellType(Block.TopRow,Block.LeftColumn)
		  If TypeCell = TypeDefault Then TypeCell = ColumnType(Block.LeftColumn)
		  
		  If CellClick(Block.TopRow,Block.LeftColumn,x,y) Then
		    Return True
		  ElseIf Keyboard.ShiftKey Then
		    If Not Selected(row) Then
		      Dim ubRows as Integer = Block.LastRow
		      For Row = Block.TopRow DownTo ubRows
		        InvalidateCell(row,-1)
		      Next
		    End if
		    Return False
		    
		  ElseIf Keyboard.MenuShortcutKey Then
		    Dim ubRows as Integer = Block.LastRow
		    For Row = Block.TopRow DownTo ubRows
		      InvalidateCell(row,-1)
		    Next
		    Return False
		  Elseif X < TextXOffset(Block.TopRow,Block.LeftColumn)-4 then
		    Return False ' Need to store fake CellType if support Check + edit... Hier?
		  ElseIf  Block.isSelected then
		    If TypeCell >= TypeEditable Then
		      EditCell(Block.TopRow,Block.LeftColumn)
		      Return True
		    End if
		    
		  Else
		    Dim TopRow as Integer = Block.TopRow
		    SupressChange = True
		    For Blockrow as integer= Block.LastRow DownTo TopRow
		      Selected(Blockrow) = Not Selected(Blockrow)
		      Selected(Blockrow) = Not Selected(Blockrow)
		    Next
		    SupressChange = False
		    
		    ListIndex = row
		    Return True
		  End if
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub CellGotFocus(row as Integer, column as Integer)
		  EditingStatus = EditStatus.Normal
		  CellGotFocus(row,column)
		End Sub
	#tag EndEvent

	#tag Event
		Function CellKeyDown(row as Integer, column as Integer, key as String) As Boolean
		  Return CellKeyDown(row, column, key)
		End Function
	#tag EndEvent

	#tag Event
		Sub CellLostFocus(row as Integer, column as Integer)
		  EditingStatus = EditStatus.NotEditing
		  CellLostFocus(row,column)
		End Sub
	#tag EndEvent

	#tag Event
		Sub CellTextChange(row as Integer, column as Integer)
		  CellTextChange(row,column)
		End Sub
	#tag EndEvent

	#tag Event
		Function CellTextPaint(g as graphics, row as integer, column as integer, x as integer, y as Integer,  ByRef VertAlign As Integer, ByRef VOffset As integer, ByRef LineSpacing as integer) As Boolean
		  CurrentRow = row
		  CurrentColumn = Column
		  If CellTextPaint(g,row,column,X,Y,Selected(row), VertAlign, VOffset,LineSpacing) Then Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Change()
		  
		  If SupressChange Then Return
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking False
		  
		  Dim Tag As Variant
		  
		  If ListIndex = LastListIndex And LastSelectCount = SelCount Then
		    RaiseEvent Change
		    Return
		  End if
		  
		  LastScrollposition = ScrollPosition
		  LastSelectCount = SelCount
		  LastListIndex = ListIndex
		  
		  Dim ub as Integer = SelectedBlocks.Ubound, i, row, idx, count,SelectedRows,RTop as Integer, BlockList(), Block As MergedCells
		  Dim isSelected as Boolean, RowsToInvalidate() as Integer
		  
		  for i = ub DownTo 0
		    isSelected = false
		    Block = SelectedBlocks(i)
		    RTop = Block.TopRow
		    For row = Block.LastRow DownTo Rtop
		      if Selected(row) Then
		        isSelected = true
		        Exit
		      end if
		    Next
		    
		    If not isSelected then SelectedBlocks.Remove(i)
		    
		    If isSelected <> Block.IsSelected then
		      Block.isSelected = isSelected
		      InvalidateBlock(Block)
		    End if
		    
		  Next
		  
		  
		  ub = ListCount -1
		  SelectedRows = SelCount
		  row = ListIndex
		  
		  Do
		    if Selected(row) then
		      count = Count +1
		      Tag = RealRowTag(row)
		      If Tag IsA MergableRowInfo Then
		        BlockList = MergableRowInfo(tag).MergedBlocks
		        For Each Block in BlockList
		          Idx = SelectedBlocks.IndexOf(Block)
		          If Idx = -1 then
		            SelectedBlocks.Append Block
		            Block.isSelected = true
		            InvalidateBlock(Block)
		            
		          ElseIf NOT Block.isSelected Then
		            Block.isSelected = true
		            InvalidateBlock(Block)
		          End if
		        Next
		      End If
		    End if
		    row = row + 1
		  Loop until row > ub or Count >= SelectedRows
		  RaiseEvent Change
		End Sub
	#tag EndEvent

	#tag Event
		Sub Close()
		  EFNoScroll = NIL
		  EFScroll = NIL
		  If theTimer <> NIl then
		    theTimer.LBM = NIL
		    theTimer = NIL
		  End if
		  Close
		End Sub
	#tag EndEvent

	#tag Event
		Sub CollapseRow(row As Integer)
		  CollapseRow(row)
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim ParentRow as Integer = row
		  
		  Dim ParentInfo As MergableRowInfo = MergableRowInfo(RealRowTag(ParentRow))
		  Dim ParentLevel as Integer = ParentInfo.Indent, ChildLevel as integer
		  Dim ub as Integer = me.ListCount -1
		  
		  If NOT ParentInfo.NodeMergedAcrossRows(ParentRow) Then
		    
		    Dim NextNode As Integer = -1
		    for row =  ParentRow + 1 to ub
		      ChildLevel = me.RowDepth(row)
		      If  ChildLevel <= ParentLevel Then
		        NextNode = row
		        Exit
		        
		      End if
		    Next
		    
		    If NextNode = -1 Then Return
		    
		    Dim Delta as Integer = NextNode - ParentRow -1
		    
		    Dim Tag as Variant 
		    For  row = NextNode to ub
		      Tag = RealRowTag(row)
		      If Tag IsA MergableRowInfo then MergableRowInfo(Tag).UpdateForCollapsed(row,Delta)
		    Next
		    
		    Return
		  End if
		  
		  '------------------
		  Dim ubRows As Integer = ListCount -1
		  If Row = ubRows then Return
		  
		  
		  Dim FirstRow As Integer = ParentInfo.lastRow + 1
		  Dim Info As Rowinfo, LastRow As Integer, idx as Integer, selectedRows() As Boolean
		  
		  
		  Dim LastParentRow, column, ubcol as Integer
		  ubcol = ColumnCount -1
		  LastParentRow = ParentInfo.LastRow
		  Dim MergedRows as Integer = LastParentRow - ParentRow
		  
		  Dim RowInfoList(), RowData As MergableRowInfo, Cells(-1,-1) as CellDefinition
		  if LastParentRow > ParentRow Then
		    ReDim Cells(MergedRows -1,ubcol)
		    
		    For row = ParentRow + 1 To LastParentRow
		      selectedRows.Append Selected(row)
		      RowData = MergableRowInfo(RealRowTag(row))
		      RowData.Indent = ParentLevel
		      
		      Call RowData.ConnectionList.Pop
		      RowInfoList.Append RowData
		      For column = 0 to ubCol
		        Cells(LastParentRow-Row,column) =  me.CellFullDefinition(row,column)
		      next
		    next
		  End if
		  
		  LastRow = -1
		  
		  For row = FirstRow To ubRows
		    Info = RowInfo(RealRowTag(row))
		    If Info is NIL or Info.Indent <= ParentLevel Then
		      LastRow = Row -1
		      If LastRow < FirstRow Then LastRow = -1
		      Exit
		    End if
		  Next
		  
		  Dim RowIdx As Integer
		  If LastRow < FirstRow then ' No children
		    If MergedRows > 0 then
		      row = LastParentRow + 1
		      For Each RowData In RowInfoList
		        RealInsertRow(row,"", ParentLevel)
		        RealRowTag(row) = RowData
		        If selectedRows(RowIdx) Then Selected(row) = True
		        for column = 0 to ubCol
		          me.CellFullDefinition(row,column) = Cells(RowIdx, column)
		        next
		        Row = row +1
		        RowIdx = RowIdx + 1
		      Next
		    End if
		    Return
		  End if
		  
		  Dim Tag as Variant,MergedBlocks(), Block as MergedCells
		  
		  For row  = FirstRow DownTo LastRow
		    Tag = RealRowTag(row)
		    If Selected(Row) Then
		      If Tag IsA MergableRowInfo Then
		        RowData = MergableRowInfo(Tag)
		        MergedBlocks = RowData.MergedBlocks
		        
		        For Each Block in MergedBlocks
		          idx = SelectedBlocks.IndexOf(Block)
		          If idx > -1 then SelectedBlocks.Remove idx
		        Next
		      End if
		    End if
		    
		  Next
		  
		  Dim RowstoBeDeleted as Integer = LastRow-LastParentRow
		  
		  For row = LastRow + 1 To ubRows
		    Tag = RealRowTag(row)
		    If Tag IsA MergableRowInfo Then
		      MergedBlocks = MergableRowInfo(Tag).MergedBlocks
		    Else
		      Continue
		    End If
		    If MergedBlocks.Ubound = -1 then Continue
		    For Each Block in MergedBlocks
		      If Block.TopRow = Row  Then
		        Block.TopRow = Row - RowstoBeDeleted
		      End if
		    Next
		  Next
		  
		  If MergedRows < 1 then Return
		  InvalidateCell(ParentRow,-1)
		  RowIdx = 0
		  row = LastRow + 1
		  For Each RowData In RowInfoList
		    RealInsertRow(row,"", ParentLevel)
		    RealRowTag(row) = RowData
		    for column = 0 to ubCol
		      me.CellFullDefinition(row,column) = Cells(RowIdx, column)
		    next
		    If selectedRows(RowIdx) Then Selected(row) = True
		    Row = row +1
		    RowIdx = RowIdx + 1
		  Next
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function CompareRows(row1 as Integer, row2 as Integer, column as Integer, ByRef result as Integer) As Boolean
		  Dim Cell1Left, Cell2Left as Integer,Merged As Integer
		  Dim Tag as Variant = RealCellTag(Row1,column)
		  
		  If Tag Isa MergedCells Then
		    Merged = 1
		    Cell1Left = MergedCells(Tag).LeftColumn
		  Else
		    Cell1Left = column
		  End if
		  
		  Tag = RealCellTag(Row2,column)
		  
		  If Tag IsA MergableRowInfo Then
		    If Merged = 1 Then
		      Merged = 3
		    Else
		      Merged = 2
		    End if
		    Cell2Left = MergedCells(Tag).LeftColumn
		  Else
		    Cell2Left = column
		  End if
		  
		  Return CompareRows(row1, Cell1Left, row2, Cell2Left, Merged, column, result)
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  Return ConstructContextualMenu(base,x,y)
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuAction(hitItem as MenuItem) As Boolean
		  Return ContextualMenuAction(hitItem)
		End Function
	#tag EndEvent

	#tag Event
		Sub ExpandRow(row as integer)
		  
		  Dim ParentRow as Integer = row
		  Dim ParentInfo As MergableRowInfo = RealRowTag(row)
		  
		  Dim LastRow as Integer = ParentInfo.LastRow
		  
		   If LastRow <= row then 
		    ExpandRow(row)
		    Return
		  End if
		  
		  Dim FirstRow As Integer= Row + 1
		  
		  Dim ubCol As Integer = ColumnCount -1
		  Dim ubRows As Integer = LastRow-FirstRow
		  Dim Cells(-1,-1) as CellDefinition
		  ReDim Cells(ubRows,ubCol)
		  Dim RowInfoList(), RInfo As MergableRowInfo
		  Dim column As Integer,SelectedRows() as Boolean
		  
		  Dim Rowidx as Integer
		  
		  For row = FirstRow To LastRow
		    SelectedRows.Append Selected(row)
		    RowInfoList.Append MergableRowInfo(RealRowTag(row))
		    For column = 0 to ubCol
		      Cells(Rowidx,column) =  me.CellFullDefinition(row,column)
		    next
		    Rowidx = Rowidx + 1
		  next
		  
		  For row = LastRow DownTo FirstRow
		    Super.RemoveRow row
		  next
		  
		  For row = FirstRow To LastRow
		    Super.AddRow ""
		  Next
		  Rowidx = 0
		  InvalidateCell(ParentRow,-1)
		  For row = FirstRow To LastRow
		    RInfo = RowInfoList(Rowidx)
		    RealRowTag(row) = RInfo
		    RInfo.Indent = ParentInfo.Indent + 1
		    RInfo.NodeType = Node_Other
		    RInfo.ConnectionList.Append 0
		    For column = 0 to ubCol
		      me.CellFullDefinition(row,Column) = Cells(RowIdx, column)
		    Next
		    If SelectedRows(Rowidx) Then Selected(row) = True
		    RowIdx = RowIdx + 1
		  Next
		  RaiseEvent ExpandRow(ParentRow)
		End Sub
	#tag EndEvent

	#tag Event
		Sub GotFocus()
		  CustomEdit = True
		  RaiseEvent GotFocus
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key as String) As Boolean
		  If KeyDown(key) then 
		    Return True
		  ElseIf SelCount <> 1 OR Not Hierarchical Or RowIsFolder(ListIndex) then
		    Return False
		  End if
		  
		  Dim Tag as Variant = RealCellTag(ListIndex, 0)
		  
		  If Not (Tag IsA MergedCells) Then Return False
		  
		  Dim Block As MergedCells = MergedCells(tag)
		  
		  If RowIsFolder(Block.TopRow) Then 
		    
		    If HierarchicalKeyDownHandler(key, Block.TopRow) then
		      InvalidateBlock(Block)
		      Return True
		    End if
		  End if
		  
		End Function
	#tag EndEvent

	#tag Event
		Function MakeCellTag(row as Integer, column As Integer) As ItemInfo
		  Dim Tag as MergedCells = MakeCellTag(row, column)
		  
		  If Tag Is NIL then
		    Return New MergedCells
		  Else
		    Return Tag
		  End if
		End Function
	#tag EndEvent

	#tag Event
		Function MakeRowTag(row as Integer) As RowInfo
		  Dim Tag as MergableRowInfo = MakeRowTag(row)
		  
		  If Tag Is NIL then
		    Return New MergableRowInfo
		  Else
		    Return Tag
		  End if
		End Function
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  If MouseDown(x,y) then Return True
		  
		  If EditingStatus <> EditStatus.NotEditing And RowFromXY(x,y) =-1 then 
		    me.SetFocus
		  End if
		  
		  If ResizeMergableColumn(x,y) Then 
		    Return True
		  Else
		    ResizingColumn = -1
		    If NOT ActiveCell.Visible then
		      Dim Row as Integer = RowFromXY(x,y)
		       If Row >-1 then theTimer.Start(me, row)
		    End if
		  End if
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  
		  If MouseDrag(x,y) Or (NOT HasHeading) or (Y > HeaderHeight ) OR ResizingColumn = -1 then Return
		  
		  Dim NewWidth as integer = X - ResizeStart
		  If NewWidth <= ResizeMin then 
		    NewWidth = ResizeMin
		    me.MouseCursor = RightResizeCursor
		  Elseif NewWidth >= ResizeMax Then
		    NewWidth = ResizeMax
		    me.MouseCursor = LeftResizeCursor
		  Else
		    me.MouseCursor = System.Cursors.SplitterEastWest
		    
		  End if
		  
		  
		  If NewWidth = Column(ResizingColumn).WidthActual Then Return
		  InvalidateBlocks(ResizeInvalidBlocks)
		  Column(ResizingColumn).WidthActual = NewWidth
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  If ResizingColumn >=0 then
		    me.MouseCursor = NIL 
		    InvalidateBlocks(ResizeInvalidBlocks)
		    ResizingColumn = -1
		    ReDim ResizeInvalidBlocks(-1)
		  End if
		  MouseUp(x,y)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  If ActiveCell.Visible Then Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  '@@@###@@@
		  'HeaderType(-1) = HeaderTypes.NotSortable
		  Open
		  LastHt = Height
		  LastWidth = Width
		  LastListIndex = ListIndex
		  LastScrollposition = ScrollPosition
		  LastSelectCount = SelCount
		  theTimer = New MLB_DragTimer
		End Sub
	#tag EndEvent

	#tag Event
		Function SortColumn(column As Integer) As Boolean
		  For row as Integer = me.ListCount -1 DownTo 0
		    me.Expanded(row) = false
		  Next
		End Function
	#tag EndEvent

	#tag Event
		Function SupressTextPaint(row as Integer,column As integer) As Boolean
		  Return RealCellTag(row,column) isA MergedCells
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddFolder(Text As String)
		  Super.AddFolder text
		  Dim ub As Integer = ParentStack.Ubound
		  if ub = -1  then Return
		  Insertlogic(LastIndex)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRow(Text As String)
		  Super.AddRow Text
		  Dim ub As Integer = ParentStack.Ubound
		  if ub = -1 Or LastIndex = ListCount -1 then Return
		  Insertlogic(LastIndex)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Cell(row as Integer, column as integer) As String
		  if row >0 and column >= 0 Then
		    
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  
		  Return Super.Cell(row,column)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cell(row as Integer, column as integer, Assigns text As String)
		  if row >= 0 and column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.Cell(row,column) = text
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellAlignment(row as Integer, column as integer) As Integer
		  
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellAlignment(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellAlignment(row as Integer, column as integer, Assigns Alignment as integer)
		  if row >= 0 and column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.CellAlignment(row,column) = Alignment
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellAlignmentOffset(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellAlignmentOffset(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellAlignmentOffset(row as Integer, column as integer, Assigns Offset as Integer)
		  if row >= 0 and column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.CellAlignmentOffset(row,column) = Offset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellBold(row as Integer, column as integer) As Boolean
		  
		  if row >= 0 and column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Return Super.CellBold(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBold(row as Integer, column as integer, Assigns Value As Boolean)
		  
		  if column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.CellBold(row,column) = Value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellBorderBottom(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,Column)
		  If Tag IsA MergedCells Then row = MergedCells(tag).LastRow
		  Return Super.CellBorderBottom(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderBottom(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, Assigns BorderStyle As Integer)
		  Dim Tag As Variant
		  Dim Block As MergedCells
		  
		  If row >= 0 and column >= 0 AND rows = 1 And columns = 1  then
		    Tag = RealCellTag(row,Column)
		    If (Tag IsA MergedCells) Then Block = MergedCells(Tag)
		    
		    If Block is Nil Then
		      Super.CellBorderBottom(row,column) = BorderStyle
		      Return
		    ElseIf NOT ((Row = Block.TopRow AND column = Block.LeftColumn) OR Row = Block.LastRow)  Then
		      Return
		    End IF
		    
		    row = Block.LastRow
		    Dim ubCol As Integer = Block.LastColumn
		    
		    For column = Block.LeftColumn To ubCol
		      Super.CellBorderBottom(row,column) = BorderStyle
		    Next
		    Return
		  End if
		  
		  
		  Dim ubRow, ubCol,FirstCol, FirstRow, BlockCol, ubBlock ,BlockLeft As Integer, AllColumns as Boolean
		  
		  If column < 0 then
		    column = 0
		    ubCol = ColumnCount - 1
		    AllColumns = True
		  Elseif columns < 0 then
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
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      
		      Tag = RealCellTag(row,Column)
		      If (Tag IsA MergedCells) Then
		        Block = MergedCells(Tag)
		        If row <> Block.LastRow Then Continue
		      Else
		        Super.CellBorderBottom(row,column) = BorderStyle
		        Continue
		      End if
		      
		      ubBlock = Block.LastColumn
		      BlockLeft = Block.LeftColumn
		      
		      If AllColumns Or (BlockLeft >= FirstCol AND ubBlock <= ubCol) then
		        Super.CellBorderBottom(Row,column) = BorderStyle
		      Else
		        For BlockCol = BlockLeft To ubBlock
		          Super.CellBorderBottom(row,BlockCol) = BorderStyle
		        Next
		      End IF
		    Next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellBorderLeft(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,Column)
		  If Tag IsA MergedCells Then 
		    column = MergedCells(tag).LeftColumn
		    row = MergedCells(tag).TopRow
		  End if
		  
		  Return Super.CellBorderLeft(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderLeft(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, Assigns BorderStyle As Integer)
		  Dim Tag As Variant
		  Dim Block As MergedCells
		  
		  If row >= 0 and column >= 0 And rows = 1 And columns = 1  then
		    Tag = RealCellTag(row,Column)
		    If (Tag IsA MergedCells) Then Block = MergedCells(Tag)
		    
		    If Block is Nil Then
		      Super.CellBorderLeft(row,column) = BorderStyle
		      Return
		    ElseIf column <> Block.LeftColumn Then
		      Return
		    End IF
		    
		    Dim ubRow As Integer = Block.LastRow
		    Column = Block.LeftColumn
		    
		    For row = Block.topRow To ubRow
		      Super.CellBorderLeft(row,column) = BorderStyle
		    Next
		    Return
		  End if
		  
		  
		  Dim ubRow, ubCol, BlockRow,BlockTop,BlockLastCol, ubBlock, FirstRow, FirstCol As Integer, AllRows as Boolean
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
		    AllRows = true
		    row = 0
		    ubRow = ListCount - 1
		  Elseif rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows -1
		  End if
		  
		  FirstRow = Row
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      
		      Tag = RealCellTag(row,Column)
		      If (Tag IsA MergedCells) Then
		        Block = MergedCells(Tag)
		      Else
		        Super.CellBorderLeft(row,column) = BorderStyle
		        Continue
		      End if
		      
		      BlockTop = Block.TopRow
		      ubBlock = Block.LastRow
		      
		      If column = Block.LeftColumn then
		        If AllRows OR (BlockTop >= FirstRow AND ubBlock <= ubRow) Then
		          Super.CellBorderLeft(Row,column) = BorderStyle
		        Else
		          For BlockRow = BlockTop To ubBlock
		            Super.CellBorderLeft(BlockRow,column) = BorderStyle
		          Next
		        End IF
		      End if
		    Next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellBorderRight(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,Column)
		  If Tag IsA MergedCells Then 
		    column = MergedCells(tag).LastColumn
		    row = MergedCells(tag).TopRow
		  End if
		  Return Super.CellBorderRight(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderRight(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, Assigns BorderStyle As Integer)
		  Dim Tag As Variant
		  Dim Block As MergedCells
		  
		  If row >= 0 and column >= 0 and rows = 1 And columns = 1  then
		    Tag = RealCellTag(row,Column)
		    If (Tag IsA MergedCells) Then Block = MergedCells(Tag)
		    
		    If Block is Nil Then
		      Super.CellBorderRight(row,column) = BorderStyle
		      Return
		    ElseIf NOT ((Row = Block.TopRow AND column = Block.LeftColumn) OR column = Block.LastColumn) Then
		      Return
		    End IF
		    
		    Dim ubRow As Integer = Block.LastRow
		    Column = Block.LastColumn
		    
		    For row = Block.topRow To ubRow
		      Super.CellBorderRight(row,column) = BorderStyle
		    Next
		    Return
		  End if
		  
		  
		  Dim ubRow, ubCol, BlockRow,BlockLastCol, ubBlock, FirstRow, FirstCol As Integer, AllRows as Boolean
		  
		  
		  If column < 0 then
		    ubCol = ColumnCount - 1
		    column = 0
		  Elseif columns < 0 then
		    ubCol = ColumnCount - 1
		  Else
		    ubCol = column + columns -1
		  End if
		  FirstCol = column
		  
		  If row < 0 then
		    AllRows = true
		    row = 0
		    ubRow = ListCount - 1
		  ElseIf rows < 0 then
		    ubRow = ListCount - 1
		  Else
		    ubRow = row + rows -1
		  End if
		  
		  FirstRow = row
		  
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  for row = FirstRow To ubRow
		    For column = FirstCol To ubCol
		      
		      Tag = RealCellTag(row,Column)
		      If (Tag IsA MergedCells) Then
		        Block = MergedCells(Tag)
		        If column <> Block.LastColumn then Continue
		      Else
		        Super.CellBorderRight(row,column) = BorderStyle
		        Continue
		      End if
		      
		      ubBlock = Block.LastRow
		      BlockRow = Block.topRow
		      
		      If AllRows or ( BlockRow >= FirstRow AND ubBlock <= ubRow) Then
		        Super.CellBorderRight(Row,column) = BorderStyle
		      Else
		        For BlockRow = BlockRow To ubBlock
		          Super.CellBorderRight(BlockRow,column) = BorderStyle
		        Next
		      End IF
		      
		    Next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellBorderTop(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,Column)
		  
		  If Tag IsA MergedCells Then 
		    row = MergedCells(tag).TopRow
		    Column = MergedCells(tag).leftColumn
		  End If
		  
		  Return Super.CellBorderTop(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellBorderTop(row as Integer, column as integer, rows as integer = 1, columns as integer = 1, Assigns BorderStyle As Integer)
		  Dim Tag As Variant
		  Dim Block As MergedCells
		  
		  If row >= 0 and column >= 0 and rows = 1 And columns = 1  then
		    Tag = RealCellTag(row,Column)
		    If (Tag IsA MergedCells) Then Block = MergedCells(Tag)
		    
		    If Block is Nil Then
		      Super.CellBorderTop(row,column) = BorderStyle
		      Return
		      
		    ElseIf Row <> Block.TopRow  Then
		      Return
		    End IF
		    
		    row = Block.TopRow
		    Dim ubCol As Integer = Block.LastColumn
		    
		    For column = Block.LeftColumn To ubCol
		      Super.CellBorderTop(row,column) = BorderStyle
		    Next
		    Return
		  End if
		  
		  
		  Dim ubRow, ubCol,uvBlock, BlockLeft, BlockCol,BlockLastCol,ubBlock, FirstCol, FirstRow As Integer, AllColumns as Boolean
		  
		  
		  If column < 0 then
		    column = 0
		    ubCol = ColumnCount - 1
		    AllColumns = True
		  Elseif columns < 0 then
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
		    ubRow = row + rows -1
		  End if
		  
		  FirstRow = row
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  for row = row To ubRow
		    For column = FirstCol To ubCol
		      
		      Tag = RealCellTag(row,Column)
		      If (Tag IsA MergedCells) Then
		        Block = MergedCells(Tag)
		        If row <> Block.TopRow Then Continue
		      Else
		        Super.CellBorderTop(row,column) = BorderStyle
		        Continue
		      End if
		      
		      ubBlock = Block.LastColumn
		      BlockLeft = Block.LeftColumn
		      
		      If AllColumns Or (BlockLeft >= FirstCol AND ubBlock <= ubCol) then
		        Super.CellBorderTop(Row,column) = BorderStyle
		      Else
		        For BlockCol = BlockLeft To ubBlock
		          Super.CellBorderTop(row,BlockCol) = BorderStyle
		        Next
		      End IF
		    Next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellCheck(row as Integer, column as integer) As Boolean
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellCheck(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellCheck(row as Integer, column as integer, Assigns isChecked as Boolean)
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Super.CellCheck(row,column) = isChecked
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellHeight(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    Return MergedCells(Tag).Rows
		  Else
		    Return 1
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellInfo(row as integer, column As integer) As ListboxModule.CellInfo
		  Dim RealTag as Variant = RealCellTag(row,column)
		  Dim theData as ListboxModule.CellInfo
		  
		  
		  If RealTag IsA MergedCells Then
		    Dim MC as MergedCells
		    MC = MergedCells(RealTag)
		    theData.TopRow = MC.TopRow
		    theData.Rows = MC.Rows
		    theData.LeftColumn = MC.LeftColumn
		    theData.Columns = MC.Columns
		    theData.isSelected = MC.isSelected
		  Else
		    theData.TopRow = Row
		    theData.Rows = column
		    theData.LeftColumn = 1
		    theData.Columns = 1
		  End if
		  
		  Return theData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellItalic(row as Integer, column as integer) As Boolean
		  
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  
		  Return Super.CellItalic(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellItalic(row as Integer, column as integer, Assigns Value As Boolean)
		  
		  if row >= 0 and column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.CellItalic(row,column) = Value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellLeft(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    Return MergedCells(Tag).LeftColumn
		  Else
		    Return Column
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellState(row as Integer, column as integer) As CheckBox.CheckedStates
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellState(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellState(row as Integer, column as integer, Assigns State as CheckBox.CheckedStates)
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Super.CellState(row,column) = State
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellTop(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    Return MergedCells(Tag).TopRow
		  Else
		    Return row
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellType(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellType(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellType(row as Integer, column as integer, Assigns Type as Integer)
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Super.CellType(row,column) = Type
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellUnderline(row as Integer, column as integer) As Boolean
		  
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    row = MergedCells(Tag).TopRow
		    column =  MergedCells(Tag).LeftColumn
		  End if
		  Return Super.CellUnderline(row,column)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellUnderline(row as Integer, column as integer, Assigns Value As Boolean)
		  
		  if row >= 0 AND column >= 0 then
		    Dim Tag As Variant = RealCellTag(row,column)
		    
		    If Tag IsA MergedCells Then
		      row = MergedCells(Tag).TopRow
		      column =  MergedCells(Tag).LeftColumn
		    End if
		  End if
		  Super.CellUnderline(row,column) = Value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellWidth(row as Integer, column as integer) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  If Tag IsA MergedCells Then
		    Return MergedCells(Tag).Columns
		  Else
		    Return 1
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteAllRows()
		  ReDim SelectedBlocks(-1)
		  Super.DeleteAllRows
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EditCell(row as Integer, column As integer)
		  me.SetFocus
		  
		  Dim theMode as EditMode = EditingMode(row,Column)
		  
		  Dim Tag as Variant = RealCellTag(row,Column)
		  Dim IsMerged as Boolean =  (Tag isA MergedCells) 
		  Dim Block as MergedCells
		  
		  if theMode = EditMode.WithVerticalScrollBar Then
		    EditScrollBar = Not (EFScroll is NIL)
		    If Not EditScrollBar Then theMode = EditMode.Custom
		  Else
		    EditScrollBar = False
		  End if
		  
		  If IsMerged Then
		    If EF is NIL then
		      me.ListIndex = row
		      EditingStatus = EditStatus.NotEditing
		      Return
		    End if
		    Block = Tag
		    Block.BeingEdited = True
		    EditingStatus = EditStatus.Merged
		    
		  ElseIf EF is NIL Then
		    EditingStatus = EditStatus.Normal
		    super.EditCell(row,column)
		    Return
		    
		  ElseIf theMode = EditMode.Custom Or EditScrollBar then
		    Block= New MergedCells(row,column,1,1)
		    Block.BeingEdited = True
		    Block.isSelected = Selected(row)
		    EditingStatus = EditStatus.Custom
		    
		  Else
		    EditingStatus = EditStatus.Normal
		    super.EditCell(row,column)
		    Return
		  End if
		  
		  Dim OriginalSupressValue as Boolean = SupressChange
		  
		  SupressChange = True
		  
		  ' Make sure as much of the block is visible vertically as possible
		  
		  If Block.TopRow < ScrollPosition  Then
		    ScrollPosition = Block.TopRow
		    me.ListIndex = Block.TopRow
		  Elseif not Block.isSelected Then 
		    me.ListIndex = Block.LastRow
		    me.ListIndex = Block.TopRow
		  Else
		    Dim FirstSelectedRow as Integer = Block.TopRow, BlockLastRow as Integer = Block.LastRow
		    for row = ListIndex To BlockLastRow
		      If Selected(row) then 
		        FirstSelectedRow = row
		        Exit
		      End If
		    Next
		    me.ListIndex = Block.LastRow
		    me.ListIndex = FirstSelectedRow
		    If Block.TopRow < ScrollPosition Then ScrollPosition = Block.TopRow
		    
		  End if
		  me.ListIndex = -1
		  SupressChange = OriginalSupressValue
		  
		  ListIndex = Block.TopRow
		  
		  Dim col, ubCol, EFWidth as Integer
		  Dim EFLeft,EFRight, EFTop, EFBottom as Integer
		  Block.BeingEdited = True
		  
		  
		  Dim BorderOffSet as Integer
		  If Border Then BorderOffSet = 1
		  
		  ' Get Widths
		  ubCol = Block.LeftColumn -1
		  for col = 0 to ubCol
		    EFLeft = EFLeft + Column(col).WidthActual
		  Next
		  
		  'if off Screen left Scroll into view
		  If EFLeft < ScrollPositionX then
		    ScrollPositionX = EFLeft
		    EFLeft = 0
		  Else
		    EFLeft = EFLeft - ScrollPositionX
		  End if
		  
		  Dim WidgetOffset as Integer = TextXOffset(Block.TopRow,Block.LeftColumn) - 4
		  
		  EFLeft =  EFLeft + WidgetOffset + BorderOffSet 
		  
		  ubCol = Block.LastColumn
		  
		  EFWidth = - WidgetOffset 
		  For col = Block.LeftColumn To ubCol
		    EFWidth = EFWidth + column(col).WidthActual
		  Next
		  
		  Dim ContentAreaTop, ContentAreaWidth,ContentAreaBottom As Integer
		  Const ContentAreaLeft = 1
		  
		  
		  If HasHeading Then
		    ContentAreaTop = HeaderHeight + BorderOffSet
		  Else
		    ContentAreaTop = BorderOffSet
		  End If
		  
		  ContentAreaWidth = Width
		  
		  While Super.RowFromXY(ContentAreaWidth,ContentAreaTop) = -1
		    ContentAreaWidth = ContentAreaWidth -1
		  Wend
		  
		  ContentAreaWidth =  ContentAreaWidth  + 1
		  
		  If EFWidth >= ContentAreaWidth Then
		    EFWidth = ContentAreaWidth
		    EFLeft =  0
		  ElseIf EFLeft + EFWidth > ContentAreaWidth Then
		    Dim Delta As Integer = (EFLeft + EFWidth) - ContentAreaWidth
		    ScrollPositionX = ScrollPositionX + Delta
		    EFLeft = EFLeft - Delta + 1
		  End if
		  
		  EFTop = RowHeight*(Block.TopRow - ScrollPosition) + ContentAreaTop -1
		  
		  ContentAreaBottom = Height
		  Dim BottomRow as Integer = Super.RowFromXY(1,ContentAreaBottom)
		  
		  While BottomRow = -1
		    ContentAreaBottom = ContentAreaBottom -1
		    BottomRow = Super.RowFromXY(1,ContentAreaBottom)
		  Wend
		  
		  Dim theBorder as Integer = Super.CellBorderBottom(Block.lastRow, Block.leftColumn)
		  If theBorder = BorderDefault AND Block.LastRow+ 1 < ListCount Then _
		  theBorder =  Super.CellBorderTop(Block.lastRow + 1, Block.leftColumn)
		  If theBorder = BorderDefault Then theBorder = GridLinesHorizontal
		  
		  If BottomRow <= Block.LastRow Then
		    EF.Height = ContentAreaBottom- EFTop + 1
		  ElseIf theBorder = BorderDoubleThinSolid then
		    EF.Height = Block.Rows*RowHeight -2
		  ElseIf theBorder > BorderNone then
		    EF.Height = Block.Rows*RowHeight -1
		  Else
		    EF.Height = Block.Rows*RowHeight
		  End if
		  
		  theBorder = Super.CellBorderTop(Block.TopRow, Block.leftColumn)
		  If theBorder = BorderDefault AND Block.TopRow >0 Then _
		  theBorder =  Super.CellBorderBottom(Block.TopRow - 1, Block.LeftColumn)
		  If theBorder = BorderDefault Then theBorder = GridLinesHorizontal
		  
		  Select Case theBorder
		  Case BorderDoubleThinSolid, BorderThickSolid
		    EFTop = EFTop + 2
		    EF.Height = EF.Height - 2
		  Case BorderThinSolid
		    EFTop = EFTop + 1
		    EF.Height = EF.Height - 1
		  End Select
		  
		  theBorder = Super.CellBorderLeft(Block.TopRow, Block.leftColumn)
		  If theBorder = BorderDefault AND Block.LeftColumn > 0 Then _
		  theBorder =  Super.CellBorderRight(Block.TopRow, Block.LeftColumn - 1)
		  If theBorder = BorderDefault Then theBorder = GridLinesVertical
		  
		  If theBorder = BorderDoubleThinSolid Then
		    EFWidth = EFWidth-1
		    EFLeft = EFLeft + 1
		  End if
		  
		  theBorder = Super.CellBorderRight(Block.TopRow, Block.LastColumn)
		  If theBorder = BorderDefault AND Block.LastColumn + 1 < ColumnCount Then _
		  theBorder =  Super.CellBorderRight(Block.TopRow, Block.LastColumn + 1)
		  If theBorder = BorderDefault Then theBorder = GridLinesVertical
		  
		  If theBorder = BorderDoubleThinSolid Then EFWidth = EFWidth -1
		  
		  EF.Top = EFTop + me.Top
		  EF.Left = EFLeft + me.Left 
		  EF.Width = EFWidth -1
		  EF.Row = Block.TopRow
		  EF.column = Block.LeftColumn
		  
		  
		  Dim HAlign as Integer = Super.CellAlignment(Block.TopRow,  Block.LeftColumn)
		  if HAlign = AlignDefault Then
		    Ef.Alignment = ColumnAlignment(Block.LeftColumn)
		  Else
		    Ef.Alignment = HAlign
		  End if
		  
		  'If BackColor <> &c000000 Then
		  'EF.BackColor = BackColor
		  'Else
		  'EF.BackColor = ListBackgroundColor
		  'End if
		  
		  If Block.TopRow Mod 2 = 0 Then
		    If  BackColor <> &c000000 Then
		      EF.BackColor = BackColor
		    Else
		      EF.BackColor = ListBackgroundColor
		    End if
		  ElseIf AltBackColor <> &c000000 Then
		    EF.BackColor = AltBackColor
		  ElseIf BackColor <> &c000000 Then
		    EF.BackColor = BackColor
		  Else
		    EF.BackColor = ListBackgroundColor
		  End if
		  
		  
		  EF.OriginalText = cell(Block.TopRow, Block.LeftColumn)
		  EF.Text = EF.OriginalText
		  Ef.TextColor = TextColor
		  Ef.TextFont = TextFont
		  Ef.TextSize = TextSize
		  Ef.Bold = CellBold(row,column) Or Bold
		  Ef.Italic = CellItalic(row,column) OR Italic
		  Ef.Underline = CellUnderline(row,column) OR Underline
		  
		  CellGotFocus(Block.TopRow, Block.LeftColumn)
		  
		  EF.Enabled = True
		  EF.Visible = True
		  EF.SelectAll
		  EF.SetFocus
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EFEvent(theEvent As EventType, EF As  MergedLBEF) As Boolean
		  Select Case theEvent
		  Case EventType.KeyDown
		    If CellKeyDown(EF.Row, EF.column, EF.LastKey) Then Return True
		    
		    Select Case Asc(Ef.LastKey)
		    Case 13 ' Return then
		      Super.Cell(EF.Row, EF.column) = ReplaceLineEndings(Ef.Text, EndOfLine)
		      SetFocus
		      Return True
		    Case 9 ' tab
		      SetFocus ' SetFocusNext
		      Return True
		    Case 27 'Esc
		      SetFocus
		    End
		  Case EventType.TextChange
		    CellTextChange(EF.Row, EF.column)
		    
		  Case EventType.LostFocus
		    Dim Tag as Variant
		    
		    #pragma BreakOnExceptions Off
		    Try
		      Tag = RealCellTag(EF.Row, EF.column)
		    Catch err as NilObjectException
		      'Nil object exception happens if window closed while edititing. This takes care of it
		      Return True
		    End Try
		    
		    #pragma BreakOnExceptions Default
		    
		    EditingStatus = EditStatus.NotEditing
		    CustomEdit = False
		    
		    If Tag IsA MergedCells Then MergedCells(tag).BeingEdited = False
		    
		    Super.Cell(EF.Row, EF.column) = ReplaceLineEndings(Ef.Text, EndOfLine)
		    
		    CellAction(EF.Row, EF.column)
		    CellLostFocus(EF.Row, EF.column)
		    EF.Text = ""
		    EF.OriginalText = ""
		    Super.InvalidateCell(-1,-1)
		    
		  Case EventType.ContextMenuBuild '
		    Return ConstructContextualMenu(EF.aMenuItem,Ef.XPos, Ef.YPos)
		    
		  Case EventType.ContextMenuAction
		    Return ContextualMenuAction(EF.aMenuItem)
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InhibitConnector(Row As Integer)
		  If Not (Hierarchical AND DrawNodeLines) Then Return
		  
		  Dim Tag As Variant = RealCellTag(row,0)
		  If NOT Tag IsA MergedCells Then
		    Super.InhibitConnector(row)
		    Return
		  End if
		  
		  If  ParentStack.Ubound = -1 Then
		    Dim err as New UnsupportedOperationException
		    err.Message = "InhibitConnector May only be called from the ExpandRow Event"
		    Raise Err
		    
		  ElseIf RowDepth(row) = 0 Then
		    Dim err as New OutOfBoundsException
		    err.Message = "InhibitConnector is valid only for rows with an ident Level > 0"
		    Raise Err
		  End if
		  
		  Dim Block as MergedCells = MergedCells(Tag)
		  
		  Dim LastRow as Integer = Block.LastRow, Info as MergableRowInfo
		  
		  For row  = Block.TopRow to LastRow  
		    info = RealRowTag(row)
		    Info.InhibitParentConnection = True
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertFolder(row as integer, text As string = "", indent as integer = 0)
		  if row >= ListCount Or row = 0 Then ' can't be in middle of Merged Cells
		    Super.InsertFolder row,text, indent
		    Return
		  Else
		    Super.InsertFolder row,text, indent
		    Insertlogic(row)
		  End if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Insertlogic(row as integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim NewRow As Integer = row
		  
		  Dim OldRow as Integer = row +1
		  If OldRow = ListCount Then Return
		  
		  Dim Block,MergedBlocks() As MergedCells, col,ubcol as Integer
		  Dim RowData As MergableRowInfo
		  Dim Tag as Variant 
		  
		  Tag = RealRowTag(OldRow)
		  
		  If Tag IsA MergableRowInfo Then
		    
		    MergedBlocks = MergableRowInfo(Tag).MergedBlocks
		    
		    For Each Block in MergedBlocks
		      
		      If Block.TopRow = NewRow then Continue ' No Change to Block, Not in New Row
		      ' row inserted within Block
		      If RowData Is NIL then RowData = MergableRowInfo(GetAssignRowTagSubclass(row))
		      RowData.AppendBlock Block
		      
		      Block.Rows = Block.Rows + 1
		      
		      col = Block.LeftColumn
		      
		      RealCellTag(NewRow, col) = Block
		      Super.CellType(NewRow, col) = TypeNormal
		      Super.CellBorderTop(NewRow,col) = BorderNone
		      
		      ubcol = Block.LastColumn
		      
		      For col = Block.LeftColumn + 1 To ubcol
		        RealCellTag(NewRow, col) = Block
		        Super.CellType(NewRow, col) = TypeNormal
		        Super.CellBorderLeft(NewRow,col) = BorderNone
		        Super.CellBorderTop(NewRow,col) = BorderNone
		      Next
		    Next
		  End If
		  
		  For row = ListCount-1 DownTo OldRow
		    Tag = RealRowTag(row)
		    If Tag IsA MergableRowInfo Then
		      MergedBlocks = MergableRowInfo(Tag).MergedBlocks
		    Else
		      Continue
		    End If
		    If MergedBlocks.Ubound = -1 Then Continue
		    
		    For Each Block in MergedBlocks
		      If Block.TopRow = row -1 then Block.TopRow = Row
		    Next
		    'InvalidateBlocks(MergedBlocks)
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRow(row as integer, text As string = "", indent as integer = 0)
		  Super.InsertRow row,text, indent
		  if row >= ListCount Or row = 0 Then ' can't be in middle of Merged Cells
		    Return
		  Else
		    Insertlogic(row)
		  End if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvalidateBlock(Block as MergedCells)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  Dim ubRow, ubCol, row, col as Integer
		  ubRow = Block.TopRow + Block.Rows -1
		  ubCol = Block.LeftColumn + Block.Columns -1
		  
		  For row = Block.TopRow To ubRow
		    Super.InvalidateCell(row,-1)
		    'For col = Block.LeftColumn To ubCol
		    'Super.InvalidateCell(row,col)
		    'Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvalidateBlocks(MergedBlocks() as MergedCells)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim row, ubRows As Integer ',col, ubCol As Integer
		  For each Block as mergedCells in  MergedBlocks
		    ubRows = Block.LastRow
		    'ubCol = Block.LastColumn
		    For row = Block.TopRow To ubRows
		      Super.InvalidateCell(row,-1)
		      'For col = Block.LeftColumn To ubCol
		      'Super.InvalidateCell(row,col)
		      'Next
		    Next
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvalidateBlocks(MergedBlocks() as MergedCells,SelectedState as Boolean)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim row, ubRows As Integer ',col, ubCol As Integer
		  For each Block as mergedCells in  MergedBlocks
		    Block.isSelected = SelectedState
		    ubRows = Block.LastRow
		    'ubCol = Block.LastColumn
		    For row = Block.TopRow To ubRows
		      Super.InvalidateCell(row,-1)
		      'For col = Block.LeftColumn To ubCol
		      'Super.InvalidateCell(row,col)
		      'Next
		    Next
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidateCell(row as Integer, column As Integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  If row < 0 or Column < 0 then
		    If row < -1 then Row = -1
		    If Column < -1 then Column= -1
		    Super.InvalidateCell(row,column)
		    Return
		  End if
		  DIm Tag as Variant = RealCellTag(row,column)
		  If Not Tag IsA MergedCells then
		    Super.InvalidateCell(row,column)
		    Return
		  End if
		  
		  Dim ubRow, ubCol,col as Integer
		  Dim Block as MergedCells = MergedCells(tag)
		  ubRow = Block.LastRow
		  ubCol = Block.LastColumn
		  
		  For row  = Block.TopRow To ubRow
		    For col = Block.LeftColumn To ubCol
		      Super.InvalidateCell(row,col)
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidateRow(row as Integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  If row = -1 then Return
		  Dim Tag as Variant = RealRowTag(row)
		  
		  If NOT Tag IsA MergableRowInfo Then 
		    Super.InvalidateCell(row,-1)
		    Return
		  End if
		  
		  Dim MergedBlocks() as MergedCells = MergableRowInfo(tag).MergedBlocks
		  
		  Dim ubRows As Integer ' col, ubCol As Integer
		  
		  For each Block as mergedCells in  MergedBlocks
		    ubRows = Block.LastRow
		    'ubCol = Block.LastColumn
		    For row = Block.TopRow To ubRows
		      Super.InvalidateCell(row,-1)
		      'For col = Block.LeftColumn To ubCol
		      'Super.InvalidateCell(row,col)
		      'Next
		    Next
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidateSelectedRows(column As integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim SelectedCount As Integer = SelCount, count,row, ub as Integer, BlockList as mergedCells
		  If SelCount = 0 then Return
		  ub = ListCount -1
		  
		  Dim Tag as Variant
		  
		  row = ListIndex
		  Super.InvalidateCell(row,Column)
		  
		  do
		    If Selected(row) then
		      count = count + 1
		      Super.InvalidateCell(row,column)
		      Tag = RealRowTag(row)
		      If Tag IsA MergableRowInfo Then InvalidateBlocks MergableRowInfo(Tag).mergedblocks
		    end if
		    row = row + 1
		  Loop Until row >ub or count >=SelectedCount
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeCells(TopRow as Integer, LeftColumn as integer, Rows as integer, Columns as integer)
		  If TopRow < 0 Or TopRow + Rows > ListCount Or Rows <= 0 _
		  OR LeftColumn < 0 Or LeftColumn + Columns > ColumnCount or Columns <= 0 _
		  Then raise Error(New OutOfBoundsException, "MergeCells: Merged Area too big")
		  
		  Dim RowData,ParentData As MergableRowInfo, AcceptableIndent as Integer
		  Dim CheckIndent as Boolean
		  
		  Dim Block As MergedCells = MergedCells(NewCellTagSubclass)
		  Block.Constructor(TopRow, LeftColumn, Rows,Columns)
		  
		  
		  Dim Done, TotallyIncluded As Boolean
		  Dim TypeCell,ubCol,ubRows, row, col,  HAlign, HAlignOffset, Idx As Integer
		  Dim Txt as String, Tag, CurrentTag as Variant
		  Dim CheckState As CheckBox.CheckedStates
		  Txt = Cell(TopRow,LeftColumn)
		  Tag = CellTag(TopRow,LeftColumn)
		  TypeCell = Super.CellType(TopRow,LeftColumn)
		  CheckState = Super.CellState(TopRow,LeftColumn)
		  HAlign = Super.CellAlignment(TopRow,LeftColumn)
		  HAlignOffset = Super.CellAlignment(TopRow,LeftColumn)
		  
		  Dim ubParent As Integer
		  ubParent = ParentStack.Ubound
		  Dim InExpandRowEvent as Boolean = ubParent > -1
		  If InExpandRowEvent Then ParentData = MergableRowInfo(ParentStack(ubParent))
		  Do
		    Done = True
		    TopRow = Block.TopRow
		    LeftColumn = Block.LeftColumn
		    ubCol = LeftColumn + Block.Columns - 1
		    ubRows = TopRow + Block.Rows - 1
		    If Hierarchical AND Rows > 1 Then
		      RowData = MergableRowInfo(GetAssignRowTagSubclass(row))
		      CheckIndent = True
		      If InExpandRowEvent Then
		        AcceptableIndent = ParentData.Indent +1
		      ElseIf RowData IsA MergableRowInfo Then
		        If RowData.NodeType = Node_Folder Then
		          if Expanded(TopRow) Then
		            AcceptableIndent = RowData.Indent + 1
		          Else
		            AcceptableIndent = RowData.Indent 
		          End if
		        Else
		          AcceptableIndent = RowData.Indent
		        End If
		      Else
		        AcceptableIndent = 0
		      End if
		    Else
		      CheckIndent = False
		      AcceptableIndent = 0
		    End if
		    
		    For row = TopRow to ubRows
		      RowData = MergableRowInfo(GetAssignRowTagSubclass(row))
		      If Row > TopRow AND CheckIndent Then
		        If RowData.Indent <> AcceptableIndent Then _ 
		        Raise Error(New TypeMismatchException,"MergeCells: Can not merge cells with incompatable Indent levels")
		        If RowData.Nodetype = Node_Folder Then
		          if RowData.LastRow > -1 AND ubRows > RowData.LastRow Then _
		          Raise Error(New TypeMismatchException, "MergeCells: Can Not Merge an Internal Folder")
		        ElseIf LeftColumn = 0 then
		          RowData.Nodetype = Node_Other
		        End if
		      End if
		      
		      RowData.AppendBlock Block
		      For col = LeftColumn to ubCol
		        CurrentTag = RealCellTag(row, col)
		        If Block.MergeWithMerged(CurrentTag, TotallyIncluded) Then
		          RowData.RemoveBlock CurrentTag
		          Idx = SelectedBlocks.IndexOf(CurrentTag)
		          If Idx > -1 Then SelectedBlocks.Remove Idx
		          If Not TotallyIncluded Then
		            Done = False
		            Exit For Row
		          End if
		        End if
		        Super.Cell(row, col) = ""
		        Super.CellType(row, col) = TypeNormal
		        RealCellTag(row, col) = Block
		        
		        If row <> ubRows  Then Super.CellBorderBottom(row,col) = BorderNone
		        If row <> TopRow then Super.CellBorderTop(row,col) = BorderNone
		        If col <> ubCol Then Super.CellBorderRight(row,col) = BorderNone
		        If col <> LeftColumn then Super.CellBorderLeft(row,col) = BorderNone
		      Next
		    Next
		  Loop Until Done
		  
		  Block.Tag = tag
		  Super.Cell(TopRow, LeftColumn) = Txt
		  Super.CellType(TopRow, LeftColumn) = TypeCell
		  Super.CellState(TopRow, LeftColumn) =CheckState
		  Super.CellAlignment(TopRow,LeftColumn)=HAlign
		  Super.CellAlignmentOffset(TopRow,LeftColumn)=HAlignOffset
		  
		  ubCol = Block.LastColumn
		  ubRows = Block.LastRow
		  
		  Dim Border1 as Integer = Super.CellBorderLeft(Block.TopRow, Block.LeftColumn)
		  Dim Border2 as Integer = Super.CellBorderRight(Block.TopRow, Block.LastColumn)
		  
		  For row = Block.TopRow +1 to ubRows
		    CellBorderLeft(row,LeftColumn) = Border1
		    CellBorderRight(row,ubCol) = Border2
		  Next
		  
		  Border1 = Super.CellBorderTop(Block.TopRow, Block.LeftColumn)
		  Border2 = Super.CellBorderBottom(Block.LastRow, Block.LeftColumn)
		  
		  for col = LeftColumn +  1 To ubCol
		    CellBorderTop(TopRow,col) = Border1
		    CellBorderBottom(ubRows,col) = Border2
		  Next
		  
		  //-----------------------------------------------
		   If  Not Hierarchical  Or LeftColumn > 0 Then Return
		  //-----------------------------------------------
		  
		  
		  
		   If Block.Rows <= 1 Then 
		    RowData = MergableRowInfo(RealRowTag(TopRow))
		    RowData.InhibitParentConnection = False
		    Return
		  End If
		  
		  TopRow = Block.TopRow
		  Dim LastRow As Integer = Block.LastRow
		  
		  Dim ConnectingRow as Integer, isLastChild as Boolean
		  
		  If Rows Mod 2 = 0 Then ' Even Can't put connector in middle
		    ConnectingRow = TopRow
		  Else ' Odd 
		    ConnectingRow = TopRow + Rows\2
		  End if
		  
		  For Row = TopRow To LastRow
		    RowData = MergableRowInfo(RealRowTag(Row))
		    If RowData.IsLastChild Then isLastChild = True
		    If RowData.NodeType = Node_Folder Then ConnectingRow = Row
		  Next
		  
		  If isLastChild Then
		    For Row = TopRow To LastRow
		      RowData = MergableRowInfo(RealRowTag(Row))
		      RowData.IsLastChild = True
		      If RowData.Indent > 0 then
		        Select Case row
		        Case is > ConnectingRow 
		          RowData.InhibitParentConnection = true
		          RowData.ConnectionList(RowData.Indent-1) = Connection_None
		        Case ConnectingRow
		          RowData.InhibitParentConnection = False
		          RowData.ConnectionList(RowData.Indent-1) = Connection_Last
		        Else
		          RowData.InhibitParentConnection = true
		          RowData.ConnectionList(RowData.Indent-1) = Connection_Normal
		        End Select
		        
		      Else
		        RowData.InhibitParentConnection = row <> ConnectingRow
		      End if
		      
		    Next
		    
		  Else
		    For Row = TopRow To LastRow
		      RowData = MergableRowInfo(RealRowTag(Row))
		      RowData.IsLastChild = False
		      If RowData.Indent > 0 then
		        RowData.ConnectionList(RowData.Indent-1) = Connection_Normal
		      End if
		      
		      RowData.InhibitParentConnection = row <> ConnectingRow
		      
		    Next
		    
		  End if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextCell(row as Integer, column as integer, Direction As Integer, DoInvalidate as Boolean = False) As Integer
		  Dim Tag As Variant = RealCellTag(row,column)
		  
		  
		  If Tag IsA MergedCells Then
		    Dim Block as MergedCells = MergedCells(Tag)
		    Dim LastRow, Lastcol as Integer
		    Lastcol = Block.LastColumn
		    LastRow = Block.lastRow
		    
		    If DoInvalidate Then
		      
		      #pragma DisableAutoWaitCursor
		      #pragma DisableBackgroundTasks
		      #pragma DisableBoundsChecking
		      #pragma NilObjectChecking False
		      #pragma StackOverflowChecking FALSE
		      
		      for row  = Block.topRow to Lastrow
		        for column = Block.LeftColumn To LastCol
		          Super.InvalidateCell(row,column)
		        Next
		      Next
		       
		    End if
		    
		    Select Case Direction
		    Case Direction_Right
		      Return LastCol +1
		    Case Direction_Left
		      Return Block.LeftColumn -1
		    Case Direction_Up
		      Return Block.TopRow -1
		      
		    Case Direction_Down
		      Return Block.LastRow +1
		    Else
		      Raise NEw OutOfBoundsException
		    End Select
		    
		  Else
		    if DoInvalidate Then Super.InvalidateCell(row,column)
		    
		    Select Case Direction
		    Case Direction_Right
		      Return column +1
		    Case Direction_Left
		      Return column -1
		    Case Direction_Up
		      Return row -1
		    Case Direction_Down
		      Return row +1
		    Else
		      Raise NEw OutOfBoundsException
		    End Select
		    
		  End if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RegisterEF(theEF As MergedLBEF)
		  If theEF.ScrollBarVertical Then
		    EFScroll = theEF
		  Else
		    EFNoScroll = theEF
		  End If
		  
		  theEF.Visible = False
		  // Part of the MergeableLB interface.
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRow(row as integer)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  
		  Dim Tag as Variant, Block As MergedCells, ReplacementRow,Col,ubcol, idx as integer, RowData As MergableRowInfo
		  Dim MergedBlocks() As MergedCells, RowSelected as Boolean = Selected(row)
		  Dim RowToBeDeleted as Integer = row
		  Tag = RealRowTag(RowToBeDeleted)
		  
		  If Tag IsA MergableRowInfo Then
		    RowData = MergableRowInfo(Tag)
		    MergedBlocks = RowData.MergedBlocks
		    
		    For Each Block in MergedBlocks
		      If Block.Rows = 1 Then '  Whole Block on that row so it will be  deleted
		        RowData.RemoveBlock Block
		        If Selected(RowToBeDeleted) Then
		          idx = SelectedBlocks.IndexOf(Block)
		          If idx > -1 then SelectedBlocks.Remove idx
		        End if
		      Else
		        ReplacementRow = RowToBeDeleted + 1
		        If Block.TopRow = RowToBeDeleted then ' Deleteing head of merged cells.. Should I ummerge instead?
		          col = Block.LeftColumn
		          Block.TopRow = ReplacementRow
		          Super.Cell(ReplacementRow, col) = Super.cell(RowToBeDeleted,col)
		          Super.CellType(ReplacementRow, col) = Super.CellType(RowToBeDeleted, col)
		          Super.CellState(ReplacementRow, col) =Super.CellState(RowToBeDeleted, col)
		          Super.CellAlignment(ReplacementRow,col)=Super.CellAlignment(RowToBeDeleted,col)
		          Super.CellAlignmentOffset(ReplacementRow,col)=Super.CellAlignmentOffset(RowToBeDeleted,col)
		          Super.CellBorderTop(ReplacementRow,col)=Super.CellBorderTop(RowToBeDeleted,col)
		          RealCellTag(ReplacementRow,col) = Block
		          ubcol = Block.LastColumn
		          For col = col +1 to ubcol
		            Super.CellBorderTop(ReplacementRow,col)=Super.CellBorderTop(RowToBeDeleted,col)
		          Next
		          
		        ElseIF RowToBeDeleted = Block.LastRow Then
		          ReplacementRow = RowToBeDeleted -1
		          ubcol = Block.LastColumn
		          For col = Block.LeftColumn to ubcol
		            Super.CellBorderBottom(ReplacementRow,col)=Super.CellBorderBottom(RowToBeDeleted,col)
		          Next
		        End if
		        Block.Rows = Block.Rows-1
		      End if
		    Next
		  End if
		  
		  Dim ubRows as Integer = ListCount -1
		  For row = RowToBeDeleted + 1 To ubRows
		    Tag = RealRowTag(row)
		    If Tag IsA MergableRowInfo Then
		      MergedBlocks = MergableRowInfo(Tag).MergedBlocks
		    Else
		      Continue
		    End If
		    If MergedBlocks.Ubound = -1 then Continue
		    For Each Block in MergedBlocks
		      If Block.TopRow = Row Then
		        Block.TopRow = Row -1
		      End if
		    Next
		  Next
		  'InvalidateCell(-1,-1)
		  Super.RemoveRow RowToBeDeleted
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ResizeMergableColumn(x as integer, Y as Integer) As Boolean
		  If Not ColumnsResizable OR Not HasHeading Or Y >= HeaderHeight Then 
		    ResizingColumn = -1
		    Return False
		  End if
		  
		  Dim RightX, ColWidth As integer, ubCol As integer = ColumnCount -1
		  Dim Found as Boolean
		  
		  If Border Then 
		    ResizeStart = 1 - ScrollPositionX
		  else
		    ResizeStart = - ScrollPositionX
		  End if
		  For ResizingColumn = 0 to ubCol
		    ColWidth = Column(ResizingColumn).WidthActual
		    RightX = ResizeStart + ColWidth
		    
		    If Abs( RightX -X) <= 3 Then 
		      
		      If NOT Column(ResizingColumn).UserResizable Then 
		        ResizingColumn = -1
		        Return false
		      Else
		        Found = True
		        RightX = ResizingColumn
		        While RightX < ubCol
		          RightX = RightX + 1
		          If Column(RightX).WidthActual = 0 Then 
		            ResizingColumn = RightX
		          Else
		            Exit For
		          End if
		          
		        Wend
		      End if
		      
		    ElseIf RightX > X Then
		      Return False
		    End if
		    
		    ResizeStart = RightX
		    
		  NExt
		  
		  If Not Found then Return false
		  
		  Dim FixedMode as Boolean, StrExp As String
		  For Col as Integer = 0 to ubCol
		    StrExp = Column(col).WidthExpression
		    If StrExp.InStrB("*") > 0 Or StrExp.Trim.LenB = 0 Then 
		      FixedMode = True
		      Exit
		    End if
		  Next
		  
		  If FixedMode AND ResizingColumn = ubCol Then 
		    ResizingColumn = -1
		    Return False
		  End if
		  
		  ResizeMax = Column(ResizingColumn).MaxWidthActual
		  if ResizeMax < 0 then 
		    If FixedMode Then
		      ResizeMax = Column(ResizingColumn).WidthActual + Column(ResizingColumn + 1).WidthActual
		    Else
		      ResizeMax = 2147483647
		    End if
		    ResizeMin = Max(Column(ResizingColumn).MinWidthActual, 0)
		  End if
		  Dim ubRows as integer 
		  
		  If HasHeading Then
		    If Border Then
		      ubRows = Ceil((Height - HeaderHeight -2.0)/RowHeight) + ScrollPosition
		    Else
		      ubRows = Ceil((Height - HeaderHeight)/RowHeight) + ScrollPosition
		    End if
		  ElseIf Border Then
		    ubRows = Ceil((Height -2.0)/RowHeight) + ScrollPosition
		  Else
		    ubRows = Ceil(Height/RowHeight) + ScrollPosition
		  End if
		  
		  ubRows = Min(ubRows, ListCount - ScrollPosition-1)
		  
		  Dim Tag as Variant, Block As MergedCells
		  
		  Dim NextCol as Integer = ResizingColumn + 1 
		  Dim PrevCol as Integer = ResizingColumn - 1
		  
		  Dim DoNextColumn as Boolean = NextCol < ColumnCount
		  Dim DoPrevColumn as Boolean = PrevCol > -1
		  
		  For row as Integer = ScrollPosition to ubRows
		    Tag = RealCellTag(row,ResizingColumn)
		    
		    If DoPrevColumn Then
		      Tag = RealCellTag(row,PrevCol)
		      If Tag IsA MergedCells Then
		        Block = MergedCells(tag)
		        If ResizeInvalidBlocks.IndexOf(Block) = -1 Then ResizeInvalidBlocks.Append Block
		      End If
		    End if
		    
		    If Tag IsA MergedCells Then
		      Block = MergedCells(tag)
		      If ResizeInvalidBlocks.IndexOf(Block) = -1 Then ResizeInvalidBlocks.Append Block
		    End If
		    
		    If DoNextColumn Then
		      Tag = RealCellTag(row,NextCol)
		      If Tag IsA MergedCells Then
		        Block = MergedCells(tag)
		        If ResizeInvalidBlocks.IndexOf(Block) = -1 Then ResizeInvalidBlocks.Append Block
		      End If
		    End if
		  Next
		  If ResizeInvalidBlocks.Ubound = -1 Then 
		    ResizingColumn = -1
		    Return False
		  Else
		    Return True
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectedCell(row As integer, column As Integer) As Boolean
		  Dim RealTag as Variant = RealCellTag(row,column)
		  
		  If RealTag IsA MergedCells Then
		    Return MergedCells(RealTag).isSelected
		  Else
		    Return Selected(Row)
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnMergeBlock(Block As MergedCells)
		  #pragma DisableAutoWaitCursor
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #pragma NilObjectChecking False
		  #pragma StackOverflowChecking FALSE
		  Dim TopRow As Integer = Block.TopRow
		  Dim LastRow as Integer = Block.LastRow
		  
		  Dim LeftColumn As Integer = Block.LeftColumn
		  Dim LastColumn as integer = Block.LastColumn
		  
		  Dim TypeCell as Integer = Super.CellType(TopRow, LeftColumn)
		  Dim CkState as CheckBox.CheckedStates = Super.CellState(TopRow,LeftColumn)
		  Dim RowData as MergableRowInfo, Tag as Variant 
		  Dim DeleteCellTag as Boolean = Block.DeletOnUnmerge
		  For Row as Integer= TopRow to LastRow
		    RowData = MergableRowInfo(GetAssignRowTagSubclass(row))
		    If RowData.NodeType = Node_Other Then RowData.NodeType = Node_Item
		    RowData.RemoveBlock Block
		    For column as integer = LeftColumn to LastColumn
		      If DeleteCellTag Then RealCellTag(row,column) = CellTag(row,column)
		      If column > LeftColumn Then Super.CellBorderLeft(row,column) = BorderDefault
		      If Row > TopRow Then Super.CellBorderTop(row,column) = BorderDefault
		      Super.CellType(row,column) = TypeDefault
		    Next
		  Next
		  
		  Super.CellTag(TopRow,LeftColumn) = Block.Tag
		  Super.CellType(TopRow,LeftColumn) = TypeCell
		  Super.CellState(TopRow, LeftColumn) =CkState
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnMergeCells(row as Integer, column as Integer)
		  Dim ubRow, StartCol, ubCol as Integer, Tag as Variant
		  
		  If row = -1 Then
		    ubRow = ListCount -1
		    row = 0
		  Else
		    ubRow =row
		  End if
		  
		  If column = -1 then
		    ubCol = ColumnCount -1
		    StartCol = 0
		  else
		    ubCol = column
		    StartCol = column
		  End if
		  
		  For row = row to ubRow
		    column = StartCol
		    do
		      Tag = RealCellTag(row, column)
		      If Tag isA MergedCells Then
		        UnMergeBlock(Tag)
		        column = MergedCells(tag).LastColumn
		      End IF
		      column = column + 1
		    Loop until column >= ubCol
		  Next
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CellAction(row as integer, column as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellBackgroundPaint(g as graphics,row as integer, column as integer,isSelected as Boolean) As boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellGotFocus(row as Integer, column as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellKeyDown(row as integer, column as integer, key as String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellLostFocus(row as Integer, column as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellTextChange(row as Integer, column as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellTextPaint(g as graphics, row as integer, column as integer, x as integer, y as Integer,  isSelected As Boolean,  ByRef VertAlign As Integer, ByRef VOffset As integer, ByRef LineSpacing as integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Change()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Close()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CollapseRow(row as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CompareRows(Row1 as integer, Cell1Left As Integer, Row2 As Integer, Cell2Left as integer, MergedState As Integer, column As Integer, ByRef result as integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ContextualMenuAction(hitItem as MenuItem) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event EditingMode(row as Integer, column as Integer) As EditMode
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ExpandRow(row As integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GotFocus()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event KeyDown(Key As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MakeCellTag(row as Integer, column As Integer) As MergedCells
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MakeRowTag(row as Integer) As MergableRowInfo
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDown(x as integer, y as integer) As boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDrag(x as integer, y as integer) As boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseUp(x as integer, y as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  If EditingStatus = EditStatus.Merged Then
			    Return EF
			  ElseIf EditScrollbar then
			    If NOT (EFScroll Is NIL) Then Return EFScroll
			  ElseIf EditingStatus = EditStatus.Custom Then
			    If NOT (EFNoScroll Is NIL) Then Return EFNoScroll
			    If  NOT (EFScroll Is NIL) then Return EFScroll
			  End if
			  
			  Return Listbox(me).ActiveCell
			  
			  
			End Get
		#tag EndGetter
		ActiveCell As TextEdit
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		CurrentColumn As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentRow As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private EditingStatus As EditStatus
	#tag EndProperty

	#tag Property, Flags = &h21
		Private EditScrollBar As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Dim theEF As MergedLBEF
			  
			  If EditScrollBar Then
			    If EFScroll is NIL Then 
			      Return EFNoScroll
			    Else
			      Return EFScroll
			    End if
			  ElseIf EFNoScroll Is NIL Then
			    Return EFScroll
			  Else
			    Return EFNoScroll
			  End if
			End Get
		#tag EndGetter
		Private EF As MergedLBEF
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private EFNoScroll As MergedLBEF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private EFScroll As MergedLBEF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HasBackColor As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastHt As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastListIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastScrollposition As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastSelectCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResizeInvalidBlocks() As MergedCells
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResizeMax As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResizeMin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResizeStart As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResizingColumn As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SelectedBlocks() As MergedCells
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SupressChange As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private theTimer As MLB_DragTimer
	#tag EndProperty


	#tag Constant, Name = Direction_Down, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Direction_Left, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Direction_Right, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Direction_Up, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant


	#tag Enum, Name = EditStatus, Type = Integer, Flags = &h21
		NotEditing
		  Normal
		  Merged
		Custom
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
			Name="CurrentRow"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentColumn"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
