#tag Class
Private Class MergedCells
Inherits ItemInfo
	#tag Method, Flags = &h0
		Sub Constructor()
		  BeingEdited = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TopRow as Integer, LeftColumn as integer, Rows as integer, Columns as integer)
		  me.TopRow = TopRow
		  me.Columns = Columns
		  me.Rows = rows
		  me.LeftColumn = LeftColumn
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContainesRow(row as Integer) As Boolean
		  Return Row >= TopRow And Row <= TopRow + Rows - 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DeletOnUnmerge() As Boolean
		  Dim DoIt As Boolean = True
		  DeleteOnUnmerge(DoIt)
		  Return DoIt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MergeWithMerged(Tag As Variant, Byref TotallyIncluded as boolean) As Boolean
		  'checks for overlap with cells in the other MergedCells
		  ' If No overlap returns false
		  'Else enlarges this items defintion to a rectangular
		  'block the encompasses both areas and returns true
		  
		  If Not (Tag isA MergedCells) Then
		    Return FALSE
		  ElseIf Tag Is Self then
		     Return FALSE
		  End if
		  Dim Area As MergedCells = MergedCells(Tag)
		  TotallyIncluded = false
		  Dim MyLastCol as Integer = LeftColumn + Columns -1
		  Dim AreaLastCol As Integer = Area.LastColumn
		  
		  Dim MyLastRow as Integer = TopRow + rows -1
		  Dim AreaLastRow as Integer = Area.LastRow
		  
		  If Area.LeftColumn > MyLastCol Then Return False
		  If Area.TopRow > MyLastRow Then Return False
		  If AreaLastCol < LeftColumn Then Return false
		  If AreaLastRow < TopRow Then Return false
		  
		  TotallyIncluded = (Area.LeftColumn >= LeftColumn And AreaLastCol <= MyLastCol) _
		  AND (Area.TopRow >= TopRow AND AreaLastRow <= MyLastRow) 
		  If TotallyIncluded Then Return  True
		  
		  LeftColumn = Min(LeftColumn, Area.LeftColumn)
		  TopRow = Min(TopRow, Area.TopRow)
		  Rows = max(MyLastRow,AreaLastRow) - TopRow + 1
		  Columns = Max(MyLastCol, AreaLastCol) - LeftColumn + 1
		  
		  Area.TopRow = TopRow
		  Area.Rows = rows
		  Area.LeftColumn = LeftColumn
		  Area.Columns = Columns
		  Return True
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DeleteOnUnmerge(ByRef DoIt as Boolean)
	#tag EndHook


	#tag Property, Flags = &h0
		BeingEdited As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Columns As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FolderRowOffset As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		isSelected As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return LeftColumn + Columns -1
			End Get
		#tag EndGetter
		LastColumn As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return TopRow  + Rows -1
			End Get
		#tag EndGetter
		LastRow As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		LeftColumn As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Rows As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TopRow As Integer = -1
	#tag EndProperty


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
		#tag ViewProperty
			Name="Columns"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LeftColumn"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rows"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TopRow"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastColumn"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastRow"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isSelected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BeingEdited"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FolderRowOffset"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
