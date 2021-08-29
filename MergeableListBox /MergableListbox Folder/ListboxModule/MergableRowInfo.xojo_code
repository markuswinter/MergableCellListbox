#tag Class
Private Class MergableRowInfo
Inherits RowInfo
	#tag Method, Flags = &h0
		Sub AppendBlock(Block as MergedCells)
		  IF MergedBlocks.IndexOf(Block) = -1 Then MergedBlocks.Append Block
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NodeMergedAcrossRows(ParentRow as Integer) As Boolean
		  For Each Block as MergedCells in MergedBlocks
		    If Block.Rows < 2 Or block.LastRow = ParentRow Then Continue
		    Return true
		  Next
		  
		  Return False
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveBlock(Block as MergedCells)
		  Dim idx As Integer = MergedBlocks.IndexOf(Block)
		  If idx > -1 Then MergedBlocks.Remove idx
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateForCollapsed(row as Integer, delta as integer)
		  Dim Block as MergedCells
		  
		  For Each Block  in MergedBlocks
		    If Block.TopRow = Row then Block.TopRow = row - delta
		    
		  Next
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim LastRow As Integer = -1
			  For Each Block As mergedCells in MergedBlocks
			    LastRow = Max(LastRow,Block.LastRow)
			  Next
			  
			  Return LastRow
			  
			End Get
		#tag EndGetter
		LastRow As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MergedBlocks() As MergedCells
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return LastRow - TopRow
			End Get
		#tag EndGetter
		Rows As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim FirstRow As Integer = 2147483647
			  For Each Block As mergedCells in MergedBlocks
			    FirstRow=Min(FirstRow,Block.TopRow)
			  Next
			  If FirstRow = 2147483647 Then
			    Return -1
			  Else
			    Return FirstRow
			  End if
			End Get
		#tag EndGetter
		TopRow As Integer
	#tag EndComputedProperty


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
			Name="LastRow"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TopRow"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rows"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
