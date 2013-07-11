package gr.funkytaps.digitized.objects
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.display.Bitmap;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;

	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class Background extends AbstractObject
	{
//		[Embed(source="../../../../../assets/flash/images/stars_front1.png")]
//		public static const StarsFront1:Class;
//		
//		[Embed(source="../../../../../assets/flash/images/stars_front2.png")]
//		public static const StarsFront2:Class;
//		
//		[Embed(source="../../../../../assets/flash/images/stars_back1.png")]
//		public static const StarsBack1:Class;
//
//		[Embed(source="../../../../../assets/flash/images/stars_back2.png")]
//		public static const StarsBack2:Class;
		
		private var _sky1:Image;
		private var _sky2:Image;
		
		private var _speed:Number;
		
		private var _isFront:Boolean = false;
		
		public function Background(isFront:Boolean)
		{
			_isFront = isFront;
			super();
		}
		
		override protected function _init():void {
			var assets:AssetManager = Assets.manager;
			
			var atlas:TextureAtlas;
			
			var bmSky1:Texture;
			var bmSky2:Texture;
			if(_isFront){
				_speed = 4;
				atlas = assets.getTextureAtlas("stars_front");
				bmSky1 = atlas.getTexture("stars_front1.png");
				bmSky2 = atlas.getTexture("stars_front2.png");
			}
			else{
				_speed = 3;	
				atlas = assets.getTextureAtlas("stars_back");
				bmSky1 = atlas.getTexture("stars_back1.png");
				bmSky2 = atlas.getTexture("stars_back2.png");
			}
			_sky1 = new Image(bmSky1);
			//_sky1.blendMode = BlendMode.NONE;
			addChild(_sky1);

			_sky2 = new Image(bmSky2);
			//_sky2.blendMode = BlendMode.NONE;
			_sky2.y = -800;
			addChild(_sky2);
			
		}
		
		public function update():void
		{
			if(_sky1){			
				_sky1.y += _speed;
				if(_sky1.y == 800){
					_sky1.y = -800;
				}
			}
			if(_sky2){
				_sky2.y += _speed;
				if(_sky2.y == 800){
					_sky2.y = -800;
				}
			}
		}
	}
}