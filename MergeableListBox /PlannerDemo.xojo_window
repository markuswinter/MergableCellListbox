#tag Window
Begin Window PlannerDemo
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   680
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   533488845
   MenuBarVisible  =   True
   MinHeight       =   500
   MinimizeButton  =   True
   MinWidth        =   740
   Placement       =   4
   Resizeable      =   True
   Title           =   "Calendar/Scheduler Demo"
   Visible         =   False
   Width           =   929
   Begin ListboxModule.ListboxMergable CalendarLB
      AltBackColor    =   &c00000000
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      BackColor       =   &c00000000
      Bold            =   False
      Border          =   True
      ChildLinesCellWidth=   False
      ChildrenTakeParentColor=   True
      ColumnCount     =   8
      ColumnsResizable=   True
      ColumnWidths    =   "50,*,*,*,*,*,*,*"
      CurrentColumn   =   -1
      CurrentRow      =   0
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   37
      DrawNodeLines   =   True
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   1
      GridLinesVertical=   1
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   622
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      IsActive        =   False
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      NodeLineColor   =   &cA2A2A200
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   True
      ScrollBarVertical=   True
      SelectionType   =   1
      ShowDropIndicator=   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   ""
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   38
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   889
      WrapByDefault   =   True
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
      Begin ListboxModule.MergedLBEF MergedLBEF1
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   False
         AutomaticallyCheckSpelling=   True
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         column          =   0
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "CalendarLB"
         Italic          =   False
         LastKey         =   ""
         Left            =   281
         LimitText       =   0
         LineHeight      =   0.0
         LineSpacing     =   0.0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         OriginalText    =   ""
         ReadOnly        =   False
         Row             =   0
         Scope           =   0
         ScrollbarHorizontal=   False
         ScrollbarVertical=   False
         Styled          =   True
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   False
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   254
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   80
         XPos            =   -1
         YPos            =   -1
      End
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   26
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Week View"
      TextAlign       =   1
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   14.0
      TextUnit        =   0
      Top             =   7
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   889
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  #If RBVersion >= 2011.02 
		    If PlannerMenu.Child(WindowMenu.Name) is NIL then PlannerMenu.Append WindowMenu.Clone
		  #else
		    If PlannerMenu.Child(WindowMenu.Name) is NIL then PlannerMenu.Append WindowMenu
		  #endIf
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EventDelete() As Boolean Handles EventDelete.Action
			Dim Row, Rows as Integer
			Call GetSelection(Row,Rows)
			If Rows = 0 then Return True
			Rows = rows + row -1
			
			CalendarLB.Cell(row,ClickedColumn) = ""
			CalendarLB.CellTag(row,ClickedColumn) = NIL
			CalendarLB.UnMergeCells(row,ClickedColumn)
			
			For Rows = Rows DownTo Row
			If Rows Mod 2 = 0 Then
			CalendarLB.CellBorderBottom(rows,ClickedColumn) = Listbox.BorderThinDotted
			Else
			CalendarLB.CellBorderBottom(rows,ClickedColumn) = Listbox.BorderThinSolid
			End if
			Next
			
			If Row Mod 2 = 0 Then
			CalendarLB.CellBorderTop(row,ClickedColumn) = Listbox.BorderThinSolid
			Else
			CalendarLB.CellBorderTop(row,ClickedColumn) = Listbox.BorderThinDotted
			End if
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EventEdit() As Boolean Handles EventEdit.Action
			Dim Row, Rows as Integer
			Call GetSelection(Row,Rows)
			CalendarLB.EditCell(row,ClickedColumn)
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EventExtendMerge() As Boolean Handles EventExtendMerge.Action
			MergeEvents
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EventNewEvent() As Boolean Handles EventNewEvent.Action
			CreateNewEvent
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_1() As Boolean Handles Tag_1.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_1").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_2() As Boolean Handles Tag_2.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_2").Tag.ColorValue
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_3() As Boolean Handles Tag_3.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_3").Tag.ColorValue
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			'
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_4() As Boolean Handles Tag_4.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_4").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_5() As Boolean Handles Tag_5.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_5").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = True
			
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_6() As Boolean Handles Tag_6.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_6").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_7() As Boolean Handles Tag_7.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_7").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Tag_8() As Boolean Handles Tag_8.Action
			Dim TopRow,Rows As Integer
			Call GetSelection(TopRow,Rows)
			CalendarLB.CellTag(TopRow,ClickedColumn) = _
			EventColorTag.Child("Tag_8").Tag.ColorValue
			
			CalendarLB.CellBold(TopRow,ClickedColumn) = False
			
			'Rows = CalendarLB.NextCell(TopRow,ClickedColumn, ListboxMergable.Direction_Down)
			'If Rows >= CalendarLB.ListCount Then Rows = TopRow - 1
			'If Rows < 0 then 
			'CalendarLB.ListIndex = -1
			'Else
			'CalendarLB.ListIndex = Rows
			'End if
			
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Function ConstructContextualMenu(base As MenuItem, X as Integer, Y As Integer) As Boolean
		  If CalendarLB.ActiveCell.Visible Then Return False
		  If Base.Count = 0 Then
		    #If RBVersion >= 2011.02 
		      EnableMenuItems
		    #endif
		    Dim ub as Integer = EventMenu.Count -1
		    For i as Integer = 0 to ub
		      #If RBVersion >= 2011.02 
		        Base.Append EventMenu.Item(i).Clone
		      #else
		        Base.Append EventMenu.Item(i)
		      #endif
		    Next
		    #If RBVersion < 2011.02 
		      EnableMenuItems
		    #endif
		    
		  end If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  
		  if EventColorTag.Count > 0 then 
		    Super.Constructor
		    Return
		  End if
		  
		  ' create the Color tag submenu
		  Dim P as Picture, Item as MenuItem
		  
		  Item = New MenuItem("Tag 1",&cFFE8EB)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.KeyboardShortcut = "1"
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_1"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 2",&c7FFF6F)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_2"
		  Item.KeyboardShortcut = "2"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 3",&cFFF559)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_3"
		  Item.KeyboardShortcut = "3"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 4",&cFFB189)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_4"
		  Item.KeyboardShortcut = "4"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 5",&cE3001A)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_5"
		  Item.KeyboardShortcut = "5"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 6",&cFF8AEE)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_6"
		  Item.KeyboardShortcut = "6"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 7",&cE9C2FF)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.KeyboardShortcut = "7"
		  Item.Name = "Tag_7"
		  EventColorTag.Append Item
		  
		  Item = New MenuItem("Tag 8",&cBBBAFF)
		  P = New Picture(16,16,32)
		  p.Graphics.ForeColor =  Item.Tag.ColorValue
		  P.Graphics.FillRect 0,0, 16, 16
		  Item.Icon = P
		  Item.AutoEnable = False
		  Item.Name = "Tag_8"
		  Item.KeyboardShortcut = "8"
		  EventColorTag.Append Item
		  
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateNewEvent()
		  ' Creates New event from selected cells
		  
		  Dim TopRow, Rows As Integer
		  Call GetSelection(TopRow,Rows)
		  If Rows > 1 Then CalendarLB.MergeCells(TopRow,ClickedColumn,rows,1)
		  CalendarLB.CellTag(TopRow,ClickedColumn) = me.DefaultEventColor
		  
		  CreatedViaNew = True
		  CalendarLB.EditCell(TopRow,ClickedColumn)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateNewEvent(Text as String, Day as DayOfWeek, StartTimeHrs as Double, DurationHrs As Double , ColorTag As Integer = -1)
		  ' creates new event from supplied data
		  Dim TopRow, Rows, column As Integer
		  
		  
		  TopRow = Round(StartTimeHrs*2.0)
		  Rows = Round(DurationHrs*2.0)
		  column = Integer(day)
		  
		  If rows > 1 Then CalendarLB.MergeCells(TopRow,column, rows,1)
		  
		  if ColorTag < 0 Then
		    CalendarLB.CellBold(TopRow,column) = False
		    CalendarLB.CellTag(TopRow,column) = me.DefaultEventColor
		  Else
		    CalendarLB.CellBold(TopRow,column) = ColorTag = 4
		    CalendarLB.CellTag(TopRow,column) = EventColorTag.Item(ColorTag).Tag.ColorValue
		  End if
		  
		  CalendarLB.Cell(TopRow,column) = MakeTimeSpan(TopRow,column)  + EndOfLine + Text
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSelection(ByRef TopRow as integer, ByRef Rows as Integer) As String()
		  ' Returns text from all the contiguously selected cells from the current column in a 
		  ' string array by cell for use in merging/extending events.
		  ' Sets TopRow to the first selected row (which may be less than listindex because 
		  ' of merged cells) and sets Rows to the number of contiguously selected rows
		  '
		  
		  Dim LB as ListboxModule.ListboxMergable = CalendarLB, OutStr() As String
		  
		  if LB.SelCount = 0 Or ClickedColumn < 0 then
		    TopRow = -1
		    Rows = 0
		    Return OutStr
		  End if
		  
		  Dim ub as Integer =  LB.ListCount -1
		  Dim row As Integer = LB.ListIndex, count, pos as Integer
		  TopRow = LB.CellTop(row,ClickedColumn)
		  Rows = 0
		  
		  Do
		    If NOT  LB.SelectedCell(row, ClickedColumn) Then Exit
		    Rows = Rows + lb.CellHeight(row, ClickedColumn)
		    OutStr.Append LB.Cell(row,ClickedColumn)
		    Row = LB.NextCell(row,ClickedColumn,lb.Direction_Down)
		  Loop Until row > ub
		   
		  Return OutStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSelectionType() As SelectionTypeValues
		  'Gets information on the currently selected cells
		  
		  
		  Dim LB as ListboxModule.ListboxMergable = CalendarLB
		  if LB.SelCount = 0 Or ClickedColumn < 0 then Return SelectionTypeValues.None
		  
		  Dim HasData as Boolean, ub as Integer =  LB.ListCount -1
		  
		  Dim row As Integer = LB.ListIndex, count as Integer
		  Do
		    If NOT  LB.SelectedCell(row, ClickedColumn) Then Exit
		    count = count + 1
		    If LB.Cell(row,ClickedColumn).LenB > 0 then
		      If count > 1 then Return SelectionTypeValues.Mixed
		      HasData = True
		    End if
		    Row = LB.NextCell(row,ClickedColumn,lb.Direction_Down)
		  Loop Until row > ub
		  
		  Select Case Count
		  Case 0 
		    Return SelectionTypeValues.None
		  Case 1
		    if HasData Then 
		      Return SelectionTypeValues.Existing
		    Else
		      Return SelectionTypeValues.SingleNew
		    End if
		    
		  Else 'count > 1
		    
		    if HasData Then 
		      Return SelectionTypeValues.Mixed
		    Else 
		      Return SelectionTypeValues.MutipleNew
		    End if
		    
		  end Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MakeTimeSpan(row As integer, column as Integer) As String
		  Static JoinArray() as String = Array("","")
		  Static D As New Date
		  
		  D.Hour = Row\2
		  D.Minute = (Row Mod 2) * 30
		  JoinArray(0) =  D.ShortTime
		  
		  row = row + CalendarLB.CellHeight(row,column) ' New API Cellheight: Returns the number of rows in the cell.
		  
		  D.Hour = Row\2
		  D.Minute = (Row Mod 2) * 30
		  JoinArray(1) =  D.ShortTime
		  
		  Dim Txt as String = Join(JoinArray,"-")
		  JoinArray(0) = ""
		  JoinArray(1) = ""
		  Return Txt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeEvents()
		  Dim TopRow, Rows, ub, pos As Integer
		  Dim Events() as String =  GetSelection(TopRow,Rows)
		  ub = Events.Ubound
		  If ub = -1 Then
		    CreateNewEvent
		    Return
		  End if
		  
		  Dim txt as String
		  
		  For i as Integer = 0 to ub
		    Txt = ReplaceLineEndings(Events(i),EndOfLine)
		    Pos = txt.InStrB(EndOfLine)
		    Events(i) = txt.MidB(Pos + Len(EndOfLine))
		  Next
		  
		  If Rows > 1 Then CalendarLB.MergeCells(TopRow,ClickedColumn,rows,1)
		  CalendarLB.Cell(TopRow,ClickedColumn) = MakeTimeSpan(TopRow,ClickedColumn) + EndOfLine+ Join(Events,EndOfLine)
		  CalendarLB.CellTag(TopRow,ClickedColumn) = DefaultEventColor
		  If ub > 0 then CalendarLB.EditCell(TopRow,ClickedColumn)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAnEvent(Row as Integer)
		  Row = CalendarLB.CellTop(Row,ClickedColumn)
		  Dim Rows as Integer = CalendarLB.CellHeight(row,ClickedColumn) + row -1
		  
		  CalendarLB.Cell(row,ClickedColumn) = ""
		  CalendarLB.CellTag(row,ClickedColumn) = NIL
		  CalendarLB.UnMergeCells(row,ClickedColumn)
		  
		  For Rows = Rows DownTo Row
		    If Rows Mod 2 = 0 Then
		      CalendarLB.CellBorderBottom(rows,ClickedColumn) = Listbox.BorderThinDotted
		    Else
		      CalendarLB.CellBorderBottom(rows,ClickedColumn) = Listbox.BorderThinSolid
		    End if
		  Next
		  
		  If Row Mod 2 = 0 Then
		    CalendarLB.CellBorderTop(row,ClickedColumn) = Listbox.BorderThinSolid
		  Else
		    CalendarLB.CellBorderTop(row,ClickedColumn) = Listbox.BorderThinDotted
		  End if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimeLabel(row As Integer) As String
		  ' Creates Time label in localized format
		  Static D As New Date
		  
		  D.Hour = Row\2
		  D.Minute = (Row Mod 2) * 30
		  
		  Return D.ShortTime
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AbortedEdit As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ClickedColumn As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Col0Pic As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		CreatedViaNew As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultEventColor As Color = &cB6FFE9
	#tag EndProperty

	#tag Property, Flags = &h0
		LastListindex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Today As Integer = -1
	#tag EndProperty


	#tag Enum, Name = DayOfWeek, Type = Integer, Flags = &h0
		Sunday =1
		  Monday = 2
		  Tuesday = 3
		  Wednesday = 4
		  Thursday = 5
		  Friday = 6
		Saturday = 7
	#tag EndEnum

	#tag Enum, Name = SelectionTypeValues, Type = Integer, Flags = &h0
		None
		  Existing
		  SingleNew
		  Mixed
		MutipleNew
	#tag EndEnum


#tag EndWindowCode

#tag Events CalendarLB
	#tag Event
		Sub Open()
		  ' Each listbox row is 1/2 hour and Column 0 is used for time lables and to display a "cursor" arrow
		  ' to show which half hour the cursor is on.
		  
		  
		  Dim TAB as String = Chr(9)
		  Dim Tab6 as String = TAB+" "+TAB+" "+TAB+" "+TAB+" "+TAB+" "+TAB+" " ' used to put something in each so borders will draw
		  
		  ' Let's add the rows before doing any formatting or text entry to see what is being done.
		  ' It would be faster, but less readable, to do it all in a single loop.
		  
		  Dim row As Integer
		  
		  for row = 0 to 47 ' 12AM to 12PM where 0 = 12AM, 1= 12:30AM etc
		    me.AddRow Tab6
		  Next
		  
		  ' Now let's add the time lables to column 0 and draw the borders. 
		  
		  
		  ' Vertical borders are the same regardless of row so let's do them as a batch
		  
		  me.CellBorderRight(-1,0) = me.BorderDoubleThinSolid ' Border Methods extended to able to set borders easier
		  me.CellBorderRight(0,1,-1,-1) = me.BorderThinSolid  ' see API... (0,1,47,7) would be equivalent
		  
		  me.ColumnAlignment(0) = me.AlignRight
		  me.Column(0).UserResizable = False
		  
		  
		  ' Time lables are shown only on the hour
		  ' Hour borders as solid. 1/2 hr borders are dotted
		  ' We want the column 0 hour time labels to be centered vertically on the bottom borders 
		  ' This means that we need to merge cells and the top row and last rows (midnight and noon) need to be 
		  ' handled as special cases
		  
		  ' As lables are in a localized format, need to determine the width required for column 0 as well
		  
		  Dim P as new Picture(1,1)
		  Dim g As Graphics = P.Graphics
		  Dim i as Integer, Hr As Double
		  
		  ' Text style for time lables in column 0 set in CellTextPaint as is vertical placement of the
		  ' label within the cell.
		  
		  g.TextFont = "Arial"
		  g.Bold = True
		  g.TextSize = 12
		  
		  
		  Dim MaxWidth as Double, LableTxt As string
		  LableTxt = TimeLabel(0)
		  
		  MaxWidth = g.StringWidth(LableTxt) + 2.0
		  me.Cell(0,0) = LableTxt
		  
		  me.CellBorderBottom(0,1,1,7) = me.BorderThinDotted ' Border Methods extended to able to set borders easier
		  
		  
		  for row  = 1 to 45  Step 2  
		    
		    me.CellBorderRight(row,0) = me.BorderDoubleThinSolid
		    me.MergeCells(row,0,2,1)
		    
		    LableTxt = TimeLabel(row + 1)
		    me.Cell(row,0) = LableTxt
		    MaxWidth = Max(MaxWidth , g.StringWidth(LableTxt)+ 2.0)
		    
		    me.CellBorderBottom(row, 1, 1, -1) = me.BorderThinSolid ' Border Methods extended to able to set borders easier
		    me.CellBorderBottom(row + 1,1,1,7) = me.BorderThinDotted 
		  Next
		  
		  me.CellBorderBottom(me.ListCount -1,0) = me.BorderThinSolid
		  
		  LableTxt = TimeLabel(0)' TimeLabel converts a row to a time String
		  
		  me.Cell(47,0) = LableTxt
		  me.CellBorderBottom(47, 1, 1, 7) = me.BorderThinSolid
		  
		  MaxWidth = Ceil( Max(MaxWidth, g.StringWidth(LableTxt) + 2) )
		  
		  me.Column(0).WidthActual = MaxWidth + 10
		  me.Column(0).WidthExpression = Str(Ceil(MaxWidth)+ 10)
		  
		  ' Now we need create the  listbox headers
		  
		  Dim D as New Date
		  Today = D.DayOfWeek
		  
		  D.Day = D.Day - D.DayOfWeek + 1
		  Label1.Text = "Week Beginning " + D.LongDate
		  
		  MaxWidth = 0
		  
		  ' Set g to listbox settings
		  g.Bold = True
		  g.TextSize = me.TextSize
		  
		  me.Heading(0) = " "
		  
		  For Day as Integer = 1 to 7
		    LableTxt = Trim(D.LongDate.Replace(Str(D.Year),"").ReplaceAll(","," "))
		    MaxWidth = Max(MaxWidth, g.StringWidth(LableTxt))
		    me.Heading(Day) = LableTxt
		    me.ColumnAlignment(Day) = me.AlignCenter
		    '#If RBVersion >= 2009.5 
		    ''me.ColumnType(Day) = me.TypeEditableTextArea
		    '#Else
		    ''me.ColumnType(Day) = me.TypeEditable
		    '#endif
		    D.Day = D.Day + 1
		  Next
		  
		  MaxWidth = Ceil(MaxWidth) + 30
		  
		  ' Now size the window and listbox
		  
		  Dim IdealWidth as Integer = 50+me.Column(0).WidthActual + 7*MaxWidth
		  If IdealWidth + 10 > Screen(0).AvailableWidth  Then
		    Self.Width = Screen(0).AvailableWidth - 10
		  Else
		    Self.Width = Min(Max(IdealWidth, 1000),Screen(0).AvailableWidth - 20)
		  End if
		  
		  ' Select a cell close to "now" to start with
		  
		  ClickedColumn = Today
		  D = New Date
		  if D.Minute >= 30 then
		    me.ScrollPosition = Max((D.Hour -2) * 2,0) 
		    me.ListIndex = D.Hour * 2 + 1
		  Else
		    me.ScrollPosition = Max((D.Hour-2) * 2 -1,0)
		    me.ListIndex = D.Hour* 2 
		  End if
		  
		  'Create some events: Cells are merged in the CreateNewEvent method if needed
		  
		  CreateNewEvent("Vacation Day!!!!" + EndOfLine + EndOfLine +"End Of a Long Weekend", _
		  DayOfWeek.Monday,8, 10,0)
		  
		  CreateNewEvent("Meeting to disscus new product development strategy. Bring 5 copies of literature", _
		  DayOfWeek.Tuesday,11.00, 4.5)
		  
		  CreateNewEvent("Lunch with Barbara at Bertucci's Italian Restaurant in Stoneham. Meet her there at noon", _
		  DayOfWeek.Wednesday,11.30,2,3)
		  
		  CreateNewEvent("Doctors appointment",DayOfWeek.Thursday, 14.00,3.0, 2)
		  
		  CreateNewEvent("Weekly Group meeting in Wellsely conference room",DayOfWeek.Thursday,8.30,1.5,4)
		  
		  CreateNewEvent("Manufacturing Team Meeting",DayOfWeek.Friday,7.30,2,7)
		  
		  CreateNewEvent("Incident Investigation",DayOfWeek.Friday,14.30,1.5,5)
		  
		  CreateNewEvent("Review New Drug Application With Consultant", DayOfWeek.Friday, 11.00,1,1)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function CellTextPaint(g as graphics, row as integer, column as integer, x as integer, y as Integer,  isSelected As Boolean,  ByRef VertAlign As Integer, ByRef VOffset As integer, ByRef LineSpacing as integer) As Boolean
		  
		  If column = 0 then ' Time lable column
		    g.TextFont = "Arial"
		    g.TextSize = 12
		    g.ForeColor =&c1C1692
		    g.Bold = True
		    
		    select Case Row ' need to chamge text alignment on first and last rows
		    Case 0 
		      VertAlign = me.AlignTop
		    Case 47
		      VertAlign = me.AlignBottom
		    End Select
		  End if 
		End Function
	#tag EndEvent
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  If column = 0 then ' do nothing
		    Return True
		    
		  ElseIf Keyboard.MenuShortcutKey Then ' Prevent discontinuous selection with control key
		    Return True
		    
		  ElseIf Keyboard.ShiftKey Then ' prevent selections across columns
		    Return column <> ClickedColumn
		    
		  Elseif IsContextualClick then
		    
		    If column <> ClickedColumn OR Not me.SelectedCell(row,column) Then
		      ClickedColumn = column
		      
		      me.ListIndex = row
		      Me.Refresh
		    End if
		    
		    #If RBVersion >= 2011.02 
		      EnableMenuItems
		      Dim Base as MenuItem = EventMenu.Clone
		    #else
		      Dim Base as MenuItem = EventMenu
		    #endif
		    
		    If NOT ConstructContextualMenu(base, X,Y) then Return True
		    Call Base.PopUp
		    Me.Refresh
		    Return True
		    
		    
		  ElseIf column = ClickedColumn AND me.SelectedCell(row,ClickedColumn) Then ' edit cell
		    CreatedViaNew = me.Cell(row,column).LenB = 0
		    
		    ' need to edit cells this way or change ColumnTypes on every column change.
		    ' I think this is simpler but doing it the RB standard way using columnType should work as well.
		    me.EditCell(row,column)
		    Return true
		    
		  End if
		  
		  ClickedColumn = column
		  me.InvalidateCell(-1, ClickedColumn) ' gives a smoother change of highlight for the merged cells
		  
		  
		End Function
	#tag EndEvent
	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  Return ConstructContextualMenu(base,X,Y)
		End Function
	#tag EndEvent
	#tag Event
		Sub CellGotFocus(row as Integer, column as Integer)
		  AbortedEdit = False
		  
		  ' Strip the First line (event Time) as that is not editable. 
		  ' It is determined by position and # of rows in the cell
		  
		  Dim txt as String = ReplaceLineEndings(me.Cell(row,column), EndOfLine)
		  
		  Dim Pos As Integer = txt.InStrB(EndOfLine)
		  me.ActiveCell.Text = txt.MidB(Pos + LenB(EndOfLine))
		  
		  'Assign the Event color to teh active cell
		  
		  Dim BkgColor as Color = me.CellTag(row,column).ColorValue
		  
		  If BkgColor <> &c000000 Then 
		    me.ActiveCell.BackColor = BkgColor 
		  Else ' is a new event
		    If column = Today Then ' Highlight the column for today
		      me.ActiveCell.BackColor = &cFFFCEA
		    Else ' Calender Background Color
		      me.ActiveCell.BackColor = &cF3F9FF 
		    End if
		  END IF
		End Sub
	#tag EndEvent
	#tag Event
		Function CellKeyDown(row as integer, column as integer, key as String) As Boolean
		  AbortedEdit = Asc(key) = 27 ' Lets us know to revert change in CellLostFocus event
		End Function
	#tag EndEvent
	#tag Event
		Sub CellLostFocus(row as Integer, column as Integer)
		  Dim txt as String =  me.cell(row,column)
		  
		  If Txt.LenB = 0 Or (AbortedEdit And CreatedViaNew) Then
		    RemoveAnEvent(row)
		  Else ' add the time span to the text And assign it to the cell
		    me.cell(row,column) = MakeTimeSpan(row,column) +EndOfLine +  me.cell(row,column)
		    If me.CellTag(row,column).ColorValue = &C000000 Then me.CellTag(row,column) = DefaultEventColor
		  End If
		  CreatedViaNew = False
		  
		   me.InvalidateCell(row,column) 'make sure the cell redraws
		  
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub EnableMenuItems()
		  
		  Select Case GetSelectionType
		  Case SelectionTypeValues.Existing
		    EventEdit.Enabled = True
		    EventDelete.Enabled = True
		    EventColorTag.Enabled = True
		    
		    For i as Integer = EventColorTag.Count -1 DownTo 0
		      EventColorTag.Item(i).Enabled = true
		    Next
		    
		  Case SelectionTypeValues.Mixed
		    EventExtendMerge.Enabled = True
		    
		  Case SelectionTypeValues.MutipleNew, SelectionTypeValues.SingleNew
		    EventNewEvent.Enabled = True
		    
		  End Select
		End Sub
	#tag EndEvent
	#tag Event
		Function CellBackgroundPaint(g as graphics,row as integer, column as integer,isSelected as Boolean) As boolean
		  If row >= me.ListCount then Return False
		  
		  If column = 0 Then ' Draw the gradient 
		    
		    If Col0Pic Is Nil then ' create a picture of the background instead of calulating the gradient each time
		      
		      'Use only the true row height to minimize unneeded drawing. Don't have to do that
		      ' as you can just use use the passed FullHeight, but this is a bit faster
		      
		      
		      #if  TargetPowerPC
		        Col0Pic = New Picture(g.Width,me.RowHeight + 2,32)
		      #else
		        Col0Pic = New Picture(g.Width,me.RowHeight,32)
		      #endif
		      
		      Dim gr as Graphics = Col0Pic.Graphics
		      Dim Column0Gradient() as Color = GradientMirroredColors(g.Width,&cC2E3FF,&cF3F9FF)
		      Dim ub As Integer = gr.Width -1
		      Dim Y2 as Integer  = gr.Height -1
		      
		      for i as Integer = 0 to ub
		        gr.ForeColor = Column0Gradient(i)
		        gr.DrawLine i, 0, i, Y2
		      Next
		      
		      
		    End if
		    
		    
		    Dim RealRow as Integer =  me.CurrentRow 'If row is merged CurrentRow gives you 'real' row...
		    ' again not really needed but is faster and the logic simpler.
		    
		    
		    #If TargetPowerPC
		      if row = RealRow then ' First row of cell
		        g.DrawPicture Col0Pic, 0,-1
		      Else ' second row of cell
		        g.DrawPicture Col0Pic, 0, me.RowHeight -1
		      End if
		    #else
		      If row = RealRow then ' First row of cell
		        g.DrawPicture Col0Pic, 0,0
		      Else ' second row of cell
		        g.DrawPicture Col0Pic, 0, me.RowHeight
		      End if
		    #endif
		    
		    if RealRow= me.ListIndex and column = 0 Then ' need to draw the cursor arrow
		      
		      Static Arrow as FigureShape
		      If Arrow is NIL Then ' create the cursor arrow if needed
		        Arrow = New FigureShape
		        Arrow.AddLine 0,-7,15,0
		        Arrow.AddLine 15,0, 0, 8
		        Arrow.AddLine 0, 7, 4,0
		        Arrow.Fill = 100.0
		        Arrow.FillColor = me.BackgroundColor(true,True)
		      End If
		      
		      'If doing a multiple row select using Shift UpArrow, need to erase last cursor
		      'because listbox does not redraw already highlighted rows
		      
		      
		      Static UpArrowKeyCode as Integer ' don't assume keycode same for all keyboards- look it up
		      if UpArrowKeyCode = 0 then
		        While Keyboard.KeyName(UpArrowKeyCode) <> "Up"
		          UpArrowKeyCode = UpArrowKeyCode + 1
		        Wend
		      End If
		      
		      If Keyboard.ShiftKey And Keyboard.AsyncKeyDown(UpArrowKeyCode) AND me.SelCount > 1 then _
		      me.InvalidateCell(LastListindex,-1)
		      
		      LastListindex = me.ListIndex ' save last cursor position
		      
		      
		      ' We know that the first and last cells are not merged but all others are 2 rows high
		      ' We use that to simplify the drawing logic.
		      
		      If Row = 0  Or RealRow = row then
		        g.DrawObject Arrow, g.Width - 20, g.TextHeight + 3 
		        
		      Else
		        g.DrawObject Arrow, g.Width - 20, me.RowHeight + g.TextHeight + 3
		      End if
		    End if
		    Return true
		    
		  ElseIf Column = ClickedColumn AND me.SelectedCell(row,column) Then ' use regular highlight color
		    Return False 
		    
		  ElseIf me.CellTag(row,column).ColorValue <> &c000000 Then' cell has a color assigned
		    g.ForeColor =  me.CellTag(row,column).ColorValue
		    
		  ElseIf column = Today Then ' Highlight the column for today
		    g.ForeColor = &cFFFCEA
		    
		  Else ' Calender Background Color
		    g.ForeColor = &cF3F9FF
		    
		  End if
		  
		  
		End Function
	#tag EndEvent
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  Dim SelCount as Integer = me.SelCount
		  Dim row, NextRow as Integer
		  
		  'Note: need to invalidate selected rows here on change of columns 
		  '     because of how I implememted  selected cell Highlighting.
		  '     In CellBackgroundPaint I suppresed the Highlight in all
		  '     columns but the cuurent "clicked" column. Other ways are possible
		  
		  Select Case Asc(key)
		  Case 28 ' Left Arrow
		    
		    If ClickedColumn <= 1 then
		      Return True
		    Else
		      me.InvalidateSelectedRows(ClickedColumn)
		      ClickedColumn = ClickedColumn - 1
		    End if
		    me.InvalidateSelectedRows(ClickedColumn)
		    
		  Case 29 ' Right Arrow
		    
		    If  ClickedColumn >= 7 then
		      Return True
		    Else
		      me.InvalidateSelectedRows(ClickedColumn)
		      ClickedColumn = ClickedColumn + 1
		    End if
		    me.InvalidateSelectedRows(ClickedColumn)
		  Case 9 ' Tab Key
		    
		    If me.ListIndex = -1 then
		      me.ListIndex = 0
		      ClickedColumn = 1
		      
		    ElseIf Keyboard.ShiftKey Then
		      
		      If me.ListIndex = 0 Then
		        me.InvalidateSelectedRows(ClickedColumn)
		        
		        If ClickedColumn > 1 Then
		          ClickedColumn = ClickedColumn - 1
		        Else
		          ClickedColumn = 7
		        End if
		        me.ListIndex = me.ListCount -1
		        
		      Else
		        me.ListIndex = me.ListIndex -1
		        
		      End if
		      
		    ElseIf me.ListIndex = me.ListCount -1  Then
		      
		      me.InvalidateSelectedRows(ClickedColumn)
		      If ClickedColumn < 7 Then
		        ClickedColumn = ClickedColumn + 1
		      Else
		        ClickedColumn = 1
		      End if
		      me.ListIndex = 0
		      
		    Else
		      
		      me.ListIndex = me.ListIndex + 1
		      
		    End if
		    
		    
		  Case 13 ' the return Key was pressed
		    
		    Dim TopRow,Rows As Integer
		    
		    Select Case GetSelectionType
		    Case SelectionTypeValues.Existing ' Hitting return while on an event edits it
		      
		      me.EditCell(me.ListIndex,ClickedColumn)
		      Return true
		      
		    Case SelectionTypeValues.Mixed 'for an event + additional cell selected increases the event duration
		      
		      MergeEvents
		      Return true
		      
		    Case SelectionTypeValues.MutipleNew, SelectionTypeValues.SingleNew ' else creates a new event
		      
		      CreateNewEvent
		      Return true
		      
		    End Select
		  End Select
		End Function
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ClickedColumn"
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Today"
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AbortedEdit"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultEventColor"
		Group="Behavior"
		InitialValue="&cB6FFE9"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CreatedViaNew"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LastListindex"
		Group="Behavior"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
