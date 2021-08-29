#tag Window
Begin Window LotTestingDemo
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   580
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   1224615666
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   700
   Placement       =   4
   Resizeable      =   True
   Title           =   "Lot Testing Results"
   Visible         =   False
   Width           =   746
   Begin ListboxModule.ListboxMergable ListboxMergable1
      AltBackColor    =   &c00000000
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      BackColor       =   &c00000000
      Bold            =   False
      Border          =   True
      ChildLinesCellWidth=   False
      ChildrenTakeParentColor=   True
      ColumnCount     =   7
      ColumnsResizable=   True
      ColumnWidths    =   "180 ,*,*,*,*,110, 70"
      CurrentColumn   =   -1
      CurrentRow      =   0
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   25
      DrawNodeLines   =   True
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   2
      GridLinesVertical=   2
      HasHeading      =   False
      HeadingIndex    =   -1
      Height          =   520
      HelpTag         =   ""
      Hierarchical    =   True
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      IsActive        =   False
      Italic          =   False
      Left            =   16
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      NodeLineColor   =   &cA2A2A200
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      ShowDropIndicator=   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   41
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   713
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
         InitialParent   =   "ListboxMergable1"
         Italic          =   False
         LastKey         =   ""
         Left            =   272
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
         ScrollbarVertical=   True
         Styled          =   True
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   False
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   205
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
      Height          =   29
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   16
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Lot Testing Results For Product XYZ"
      TextAlign       =   1
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   14.0
      TextUnit        =   0
      Top             =   7
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   713
   End
End
#tag EndWindow

#tag WindowCode
	#tag Constant, Name = CoulterPass, Type = String, Dynamic = False, Default = \"Details\tPASS\tPASS\tPASS\tPASS", Scope = Private
	#tag EndConstant

	#tag Constant, Name = CoulterSummaryData, Type = String, Dynamic = False, Default = \"\t2.449\t2.368\t2.429\t2.390\t2.409\t1.53%", Scope = Private
	#tag EndConstant

	#tag Constant, Name = CoulterVialData, Type = String, Dynamic = False, Default = \"\t2.449\t2.368\t2.429\t2.390\r\t2.452\t2.380\t2.436\t2.405\r\t2.449\t2.363\t2.428\t2.382\r\t2.447\t2.360\t2.424\t2.384\r\t0.10%\t0.46%\t0.25%\t0.53%", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasFAIL, Type = String, Dynamic = False, Default = \"Details\tPASS\tPASS\tFAIL\tPASS", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasPass, Type = String, Dynamic = False, Default = \"Details\tPASS\tPASS\tPASS\tPASS", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasSummaryFail, Type = String, Dynamic = False, Default = \"\t255.7\t315.4\t242.5\t292.2\t276\t12.1%", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasSummaryPass, Type = String, Dynamic = False, Default = \"\t275.5\t300.7\t272.3\t289.7\t285\t4.62%", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasVialDataFail, Type = String, Dynamic = False, Default = \"\t255.7\t315.4\t210.3\t292.2\r\t255.5\t313.7\t257.6\t299.9\r\t255.5\t310.3\t250.0\t294.6\r\t256.1\t322.3\t252.4\t282.2\r\t0.12%\t1.61%\t8.96%\t2.55%", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SuspensionGasVialDataPass, Type = String, Dynamic = False, Default = \"\t265.7\t300.4\t270.3\t282.2\r\t272.5\t289.7\t267.6\t299.9\r\t283.5\t310.3\t273.0\t294.6\r\t280.1\t302.3\t278.4\t282.2\r\t2.89%\t2.82%\t1.69%\t3.09%", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events ListboxMergable1
	#tag Event
		Sub Open()
		  #If TargetLinux ' Something wrong with drawing node lines on Linuz... OK other platforms
		    me.DrawNodeLines = False
		  #endif
		  
		  ' Add "lots" Randomly creating "Lot Numbers" and testing date and randomly chose which "failed".
		  ' All the data for the "testing' is added in expand rows.
		  ' Testing data is srored as string constants ina real app this woudl come from some sort if DB
		  
		  Dim R as New Random
		  
		  Dim D as New Date
		  Const SecPerDay = 8640 '24*60*60
		  Dim EndSec as Double = D.TotalSeconds
		  
		  for col as Integer = me.ColumnCount -1 DownTo 0
		    me.ColumnAlignment(col) = me.AlignCenter
		  next
		  
		  For i as Integer = 0 to 30
		    me.AddFolder "Lot: "+ Format(R.inRange(0,500),"0000") +"-"+ Format(R.inRange(0,349),"000") + Chr(R.InRange(65,90))
		    
		    me.CellBorderBottom(i,-1) = me.BorderThinSolid ' enhanced border assignment
		    me.CellAlignment(i,0) = me.AlignLeft
		    
		    me.MergeCells(i,0,1,5) ' Merge the First 5 cells on each row to display the lot number 
		    
		    D.TotalSeconds = EndSec - R.InRange(0, 730)*SecPerDay
		    me.Cell(i,5) = D.AbbreviatedDate
		    
		    If R.InRange(1,5) = 3 then ' fail some lots
		      me.Cell(i,6) = "FAIL"
		    Else
		      me.Cell(i,6) = "PASS"
		    End if
		    me.CellBold(i,6) = True
		    me.CellBold(i,0) = True
		  next
		  
		  For i as Integer = 1 to 4
		    me.Column(i).MinWidthExpression = "100" ' don't let those colums get too small.
		  Next
		  
		  
		  ' examd some rows for show
		  
		  me.Expanded(4) = true
		  me.Expanded(5) = true
		  me.Expanded(9) = true
		  
		  me.Expanded(1) = true
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function CellTextPaint(g as graphics, row as integer, column as integer, x as integer, y as Integer,  isSelected As Boolean,  ByRef VertAlign As Integer, ByRef VOffset As integer, ByRef LineSpacing as integer) As Boolean
		  'Make Failed results a shade of red and italic
		  
		  If me.Cell(row,column) = "FAIL" Or me.CellTag(row,column) = "FAIL" Then 
		    g.forecolor = &cF31027
		    g.Italic = True
		  End if
		  
		End Function
	#tag EndEvent
	#tag Event
		Function CellBackgroundPaint(g as graphics,row as integer, column as integer,isSelected as Boolean) As boolean
		  
		  If row >= me.ListCount Then ' is after last row do do't do anuything
		    Return False 
		  ElseIf isSelected AND column < 5 Then ' For a selected row Highlight only columns 0-4
		    Return False 
		  End if
		  
		  ' set background color depending on indent level and field
		  
		  Select Case me.RowDepth(row)
		  Case 0
		    g.ForeColor = me.BackgroundColor(row,false, me.isActive)
		  Case 1 
		    g.ForeColor = &cFDFFE2
		  Case 2
		    If me.Cell(row,column) = "Details" then ' use Indent level 3 background color
		      g.ForeColor = &cE6FFEE
		    Else
		      g.ForeColor = &cF0F8FF
		    End if
		  Case 3
		    If me.CellTag(row,column) = "Comment" Then
		      g.ForeColor = &cF6FFF5 ' slightly different color to indicate that it is editable
		    Else
		      g.ForeColor = &cE6FFEE
		    End if
		  End Select
		  
		End Function
	#tag EndEvent
	#tag Event
		Sub ExpandRow(row As integer)
		  Static TAB as String = Chr(9)
		  
		  Dim isCoulter, IsFail As Boolean
		  
		  Select Case me.RowDepth(row)
		  Case 0 'opening the top level to show tests done on the lot and their status
		    
		    'add first test
		    me.AddFolder "Test: Post Reconstition Particle Size"
		    me.MergeCells(me.LastIndex,0,1,6) ' merging cells for test name
		    
		    me.CellAlignment(me.LastIndex, 0) = me.AlignLeft
		    me.Cell(me.LastIndex, 6) = "PASS"
		    me.CellBold(me.LastIndex, 6) = true
		    me.CellBold(me.LastIndex, 0) = true
		    
		    'add second test
		    me.AddFolder "Test: Suspension Gas"
		    me.MergeCells(me.LastIndex,0,1,6) ' Merging Cells for test name
		    
		    me.CellAlignment(me.LastIndex, 0) = me.AlignLeft
		    
		    If me.Cell(row,6) = "FAIL" Then ' the lot has failed and we arbitraily say the last test failed
		      me.Cell(me.LastIndex, 6) = "FAIL"
		    Else
		      me.Cell(me.LastIndex, 6) = "PASS"
		    End if
		    
		    me.CellBold(me.LastIndex, 6) = true
		    me.CellBold(me.LastIndex, 0) = true
		    
		  Case 1 ' opening the summary by vial tested for an individual test
		    
		    isCoulter = me.Cell(row, 0).Instr("Size") > 0
		    IsFail =  Not isCoulter And me.Cell(row,6) = "FAIL"  ' check if this test failed
		    
		    me.AddRow "" 
		    me.Cell(me.LastIndex,0) = "Analyst:" +EndOfLine+ EndOfLine+  "Karen Somebody"
		    
		    me.CellBorderTop(me.LastIndex,-1) = me.BorderThinSolid ' enhanced border drawing
		    me.CellBorderBottom(me.LastIndex,-1) = me.BorderThinSolid ' enhanced border drawing
		    
		    ' results title and units for test
		    
		    If isCoulter then
		      me.Cell(me.LastIndex,1) = "Results Summary (µm)"
		    Else
		      me.Cell(me.LastIndex,1) = "Results Summary (µg/mL)"
		    End if
		    
		    me.CellAlignment(me.LastIndex, 0) = me.AlignLeft
		    me.CellBold(me.LastIndex, 1) = True
		    me.MergeCells(me.LastIndex, 1, 1,6) ' MergedCells for Vial Summary data title and units
		    
		    me.AddRow ""
		    me.Cell(me.LastIndex, -1) = TAB+"Vial 1" + TAB+"Vial 2" + TAB+"Vial 3" + TAB+"Vial 4" + TAB+"Average" +TAB+"% RSD"
		    
		    me.CellBold(me.LastIndex, -1) = True' Enhanced text attribute assignment
		    me.CellBorderBottom(me.LastIndex, -1) = me.BorderThinSolid ' enhanced border drawing
		    
		    me.CellBorderRight(me.LastIndex, 4) = me.BorderThinSolid
		    
		    me.AddRow "" ' add the summarty by vial data
		    
		    if isCoulter Then ' this test always passes
		      me.Cell(me.LastIndex,-1) = CoulterSummaryData ' put data for that test onto cells
		      
		    Elseif IsFail Then 
		      me.CellTag(me.LastIndex,6) = "FAIL"
		      me.Cell(me.LastIndex,-1) = SuspensionGasSummaryFail ' put the failed vial average data into he cells
		      
		    Else
		      me.Cell(me.LastIndex,-1) = SuspensionGasSummaryPass ' assign the good data to teh cells
		    End if
		    
		    me.CellBold(me.LastIndex,5) = True
		    me.CellBold(me.LastIndex,6) = True
		    
		    me.MergeCells(me.LastIndex -2, 0, 3,1) ' Merge Cells For analyst name
		    
		    me.CellBorderRight(me.LastIndex-2, 0) = me.BorderThinSolid
		    me.CellBorderRight(me.LastIndex, 4) = me.BorderThinSolid
		    
		    me.InhibitConnector(me.LastIndex-2) ' Stops the node connector to this row from being drawn... Looks better
		    
		    
		    me.AddFolder "" ' folder to open level with individual results for each vial
		    
		    'Put PASS or FAIL for each vial average into teh appropriate Cells
		    
		    If isCoulter Then ' This test always passes
		      me.Cell(me.LastIndex,-1) = CoulterPass
		    ElseIf IsFail Then
		      me.Cell(me.LastIndex,-1) = SuspensionGasFAIL
		    Else
		      me.Cell(me.LastIndex,-1) = SuspensionGasPass
		    End if
		    
		    me.CellBold(me.LastIndex,-1) = True
		    me.CellBorderTop(me.LastIndex,-1) = me.BorderThinSolid ' enhanced border drawing
		    
		    me.CellAlignment(me.LastIndex, 0) = me.AlignLeft
		    me.CellBorderRight(me.LastIndex, 0) = me.BorderThinSolid
		    me.CellBorderRight(me.LastIndex, 4) = me.BorderThinSolid
		    
		    me.MergeCells(me.LastIndex-1, 5, 2,1) ' MergeCells for Average of Vials result
		    me.MergeCells(me.LastIndex-1, 6, 2,1) ' MergeCells for %RSD of Vials result
		    
		    me.CellBorderBottom(me.LastIndex,-1) = me.BorderThinSolid ' enhanced border drawing
		    
		    
		  Case 2 ' opening individual vial replicate results detail level
		    
		    isCoulter = me.Cell(row-3,1).InStrB("g/mL") = 0 ' determine which test this is
		    IsFail = Not isCoulter and me.Cell(Row,3) = "FAIL" ' and if it has failed
		    
		    
		    ' assign the individual vial replicate result data to cells. Stored as string where fields 
		    ' are tab delimited and records are line delimited
		    
		    Dim Data() as String ' String array to hold vial replicate data and vial RSD data
		    
		    if isCoulter Then ' Data for thus test (apways passes)
		      Data = ReplaceLineEndings(CoulterVialData,EndOfLine).SplitB(EndOfLine)
		      
		    ElseIf IsFail Then ' Data for 2nd test soetimes passes and soemtimes does not
		      Data = ReplaceLineEndings(SuspensionGasVialDataFail,EndOfLine).SplitB(EndOfLine)
		    Else
		      Data = ReplaceLineEndings(SuspensionGasVialDataPass,EndOfLine).SplitB(EndOfLine)
		    End If
		    
		    me.AddRow "" 
		    
		    me.Cell(me.LastIndex,-1) = Data(0)  ' assign 1st replicates
		    
		    me.cell(me.LastIndex,0) = "Replicates"
		    me.CellBold(me.LastIndex,0) = True
		    me.CellBorderRight(me.LastIndex,0) = me.BorderThinSolid
		    
		    me.cell(me.LastIndex,5) = "Comments"
		    me.CellBold(me.LastIndex,5) = True
		    me.CellBorderLeft(me.LastIndex,5) = me.BorderThinSolid
		    me.CellBorderBottom(me.LastIndex,5) = me.BorderThinSolid
		    me.MergeCells(me.LastIndex,5,1,2)
		    
		    me.AddRow ""
		    me.Cell(me.LastIndex,-1) = Data(1) ' assign 2nd replicates
		    
		    me.AddRow ""
		    me.Cell(me.LastIndex,-1) = Data(2) ' assign 3rd replicates
		    
		    me.AddRow ""
		    me.Cell(me.LastIndex,-1) = Data(3) ' ' assign 4th replicates
		    
		    me.AddRow ""
		    me.Cell(me.LastIndex,-1) = Data(4) ' assign RSD data
		    
		    me.cell(me.LastIndex,0) = "% RSD"
		    me.CellBold(me.LastIndex,-1) = True
		    me.CellBorderRight(me.LastIndex,0) = me.BorderThinSolid
		    
		    me.MergeCells(me.LastIndex-4,0,4,1) ' merge the ceplocate title cell to span all 4 reps
		    me.InhibitConnector(me.LastIndex-4) ' Don't draw a connector to this row
		    
		    me.CellBold(me.LastIndex,0) = True
		    me.CellBorderTop(me.LastIndex,-1) = me.BorderThinSolid ' enhanced cell border assignment
		    
		    me.MergeCells(me.LastIndex-3,5,4,2)' merge comment area into single cell
		    
		    'me.CellType(me.LastIndex-3,5) = me.TypeEditable ' This would require Cell to be selected
		                                                     ' before editing. I want it to be edited immediately
		                                                     ' on a single click so I edit it in CellClick
		    
		    ' add the comment. Assigning "Comment" to the cell tag is key to triggering editing in CellClick
		    
		    If IsFail then 
		      me.Cell(me.LastIndex-3,5) = "Vial 3 Failed Intra-Vial RSD spec and Lot failed inter-Vial RSD Spec"
		      me.CellTag(me.LastIndex,3) = "FAIL"
		      me.CellTag(me.LastIndex-3,5) = "Comment"
		    Else
		      me.Cell(me.LastIndex-3,5) = "None"
		      me.CellTag(me.LastIndex-3,5) = "Comment"
		      
		      
		    End if
		    me.CellBorderLeft(me.LastIndex,5) = me.BorderThinSolid 
		    me.CellBorderBottom(me.LastIndex,-1) = me.BorderDoubleThinSolid ' enhanced cell border assignment
		  End Select
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub CellGotFocus(row as Integer, column as Integer)
		  'set BackColor of active cell to that of the actual cell 
		  me.ActiveCell.BackColor = &cF6FFF5
		End Sub
	#tag EndEvent
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  ' initiating edit on cell click rather than just making the cell editiable
		  ' because I want to edit  comments on a single click without having to select that row first
		  If column >=5 AND me.CellTag(row,column) = "Comment" Then
		    me.EditCell(row,column)
		    Return True
		  End if
		  
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
#tag EndViewBehavior
