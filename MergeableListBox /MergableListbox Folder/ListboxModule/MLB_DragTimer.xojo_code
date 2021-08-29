#tag Class
Private Class MLB_DragTimer
Inherits Timer
	#tag Event
		Sub Action()
		  If LBM.ActiveCell.Visible then 
		    me.Mode = ModeOff
		    LBM = NIL
		    Return
		  End if
		  
		  Dim Idx as Integer = LBM.ListIndex
		  
		  If ListIdx <> Idx OR SelCount <> LBM.SelCount Then 
		    If LBM.SelectionType = Listbox.SelectionMultiple Then 
		      LBM.InvalidateSelectedRows(-1)
		    Else
		      if ListIdx > -1 then   LBM.InvalidateRow(ListIdx)
		      If Idx > -1 then LBM.InvalidateRow(Idx)
		      ListIdx = LBM.ListIndex
		    End if
		    
		    ListIdx = Idx
		    SelCount  = LBM.SelCount
		    
		  End if
		  If System.MouseDown Then Return
		  me.Mode = ModeOff
		  LBM = NIL
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Start(LBM As ListboxMergable, Row as Integer)
		  me.LBM = LBM
		  me.Period =10
		  me.Mode = ModeMultiple
		  ListIdx = row
		  SelCount = Listbox(LBM).SelCount + 1
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		LBM As ListboxMergable
	#tag EndProperty

	#tag Property, Flags = &h0
		ListIdx As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		SelCount As Integer = -1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
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
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListIdx"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelCount"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
