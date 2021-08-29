#tag Module
Protected Module ListboxModule
	#tag Note, Name = Licence
		Mergable Cell listbox Licence/Copyright Notice
		Copyright (c) 2021, Karen Atkocius
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	#tag EndNote


	#tag Constant, Name = Ellipsis, Type = String, Dynamic = False, Default = \"\xE2\x80\xA6", Scope = Protected
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"\xE2\x80\xA6"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"..."
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"..."
	#tag EndConstant

	#tag Constant, Name = UseCachedBkgColor, Type = Boolean, Dynamic = False, Default = \"true", Scope = Protected
	#tag EndConstant


	#tag Structure, Name = CellInfo, Flags = &h0
		TopRow As Integer
		  LeftColumn As Integer
		  Rows As Integer
		  Columns As integer
		isSelected As Boolean
	#tag EndStructure


	#tag Enum, Name = EditMode, Type = Integer, Flags = &h0
		Default
		  WithVerticalScrollBar
		Custom
	#tag EndEnum

	#tag Enum, Name = EventType, Type = Integer, Flags = &h21
		KeyDown
		  LostFocus
		  TextChange
		  ContextMenuBuild
		ContextMenuAction
	#tag EndEnum


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
