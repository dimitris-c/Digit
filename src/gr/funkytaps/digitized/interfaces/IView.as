package gr.funkytaps.digitized.interfaces
{
	import starling.display.DisplayObject;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public interface IView
	{
		function removeFromParent(dispose:Boolean=false):void;
		
		function tweenIn():void;
		
		function tweenOut(onComplete:Function=null, onCompleteParams:Array = null):void;
		
		function view():DisplayObject;
		
		function update(...args):void;
		
		function destroy():void;
	}
}