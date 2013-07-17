package gr.funkytaps.digitized.ui
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class GamePreloader extends Sprite implements IDestroyable
	{
		
		private var _progressBackground:Quad;
		private var _progressBar:Quad;
		
		private var _ratio:Number = 1;
		
		public function GamePreloader()
		{
			super();
			
			_progressBackground = new Quad(170, 2, 0x8A8A8A);
			addChild(_progressBackground);
			
			_progressBar = new Quad(170, 2, 0xFFFFFF);
			addChild(_progressBar);
			
			_progressBar.scaleX = _ratio;
			
		}
		
		public function get ratio():Number {
			return _ratio;
		}
		
		public function set ratio(value:Number):void {
			_ratio = value;
			_progressBar.scaleX = _ratio;
		}
		
		public function destroy():void
		{
			_progressBackground.removeFromParent(true);
			_progressBar.removeFromParent(true);
			_progressBackground = null;
			_progressBar = null;
		}
	}
}