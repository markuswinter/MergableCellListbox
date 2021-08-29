#tag Class
Protected Class App
Inherits Application
	#tag MenuHandler
		Function WindowCalendar() As Boolean Handles WindowCalendar.Action
			PlannerDemo.Show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function WindowGeneralTest() As Boolean Handles WindowGeneralTest.Action
			TestWindow.Show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function WindowLotData() As Boolean Handles WindowLotData.Action
			LotTestingDemo.Show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function WindowTextFlow() As Boolean Handles WindowTextFlow.Action
			TextFlowDemo.Show
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
