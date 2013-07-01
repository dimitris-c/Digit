package com.dimmdesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	
	public function centerOnStage(stage:Stage, displayObject:DisplayObject, roundValues:Boolean = true)
	{
		
		displayObject.x = ((stage.stageWidth >> 1) - (displayObject.width >> 1)) | (roundValues) ? 0.5 : 0;
		displayObject.y = ((stage.stageHeight >> 1) - (displayObject.width >> 1)) | (roundValues) ? 0.5 : 0;
		
	}
	
}