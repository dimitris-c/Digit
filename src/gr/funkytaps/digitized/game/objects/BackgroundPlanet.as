package gr.funkytaps.digitized.game.objects
{
	import com.dimmdesign.core.IDestroyable;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.display.Image;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class BackgroundPlanet extends AbstractObject implements IDestroyable
	{
		
		private var _speedFactor:Number;
		
		private var _planetName:String; 

		private var _planet:Image;
		
		private var _planetWidth:Number;
		
		public function get planetWidth():Number { return _planetWidth; }
		
		private var _planetHeight:Number;
		
		public function get planetHeight():Number { return _planetHeight; }


		public function get speedFactor():Number	{ return _speedFactor; }

		public function set speedFactor(value:Number):void { _speedFactor = value; }

		public function get planetName():String { return _planetName; }

		public function BackgroundPlanet()
		{
			super();
		}

		/**
		 * Creates the planet image for the passed planet name. 
		 */		
		public function createPlanet(planetName:String, speedFactor:Number = 0.5):void {
			if (_planet) return;
			_planetName = planetName;
			_speedFactor = speedFactor;
			_planet = new Image(Assets.manager.getTexture( _planetName ));
			_planet.smoothing = TextureSmoothing.TRILINEAR;
			addChild(_planet);
			
			_planetWidth = this.width;
			_planetHeight = this.height;
		}

		public function destroy():void {
			_planetName = '';
			_planet.removeFromParent(true);
			_planet = null;
		}
		
	}
}