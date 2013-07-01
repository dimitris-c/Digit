package com.dimmdesign.utils
{
	import flash.display.Stage;

	public class StageRef
	{
		protected static var stage:Stage;
		
		public function StageRef()
		{
		}
		
		public static function init ($stage:Stage):void {
			stage = $stage;			
		}
		
		public static function getStage():Stage {
			return stage;
		}
		
	}
}