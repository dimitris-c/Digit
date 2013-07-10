package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.interfaces.IView;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class GameWorld extends Sprite
	{
//		[Embed(source="../../../../../assets/ss.xml",mimeType="application/octet-stream")]
//		private static var AnimData:Class;
//		
//		[Embed(source="../../../../../assets/ss.png")]
//		private static var AnimTexture:Class;	
		
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const GAME_OVER_STATE:int = 2;
		
		private var _curView:IView;
		
		private var _assets:AssetManager;
		
		public function GameWorld()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_assets = new AssetManager();
			_assets.verbose = 1.0;
			_assets.enqueue("atlases/stars_front.png");
			_assets.enqueue("atlases/stars_back.png");
			_assets.enqueue("atlases/blue.png");
			_assets.enqueue("atlases/splat.png");
			_assets.enqueue("atlases/ss.png");
			_assets.loadQueue(onProgress);
			
			Assets.assets = _assets;
			_assets = null;
			
//			var ssTexture:Texture = Texture.fromBitmap(new AnimTexture());
//			var ssData:XML = XML(new AnimData());
//			Assets.atlas = new TextureAtlas(ssTexture, ssData);
			
			//implement state logic
			
		}
		
		private function onProgress(progress:Number):void
		{
			trace("progress="+progress);
			
			if (progress==1.0) {
				trace(Assets.assets.getTextureNames(""));
//				
				_curView = new GameView();
				addChild(Sprite(_curView));
				addEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		private function update(event:Event):void
		{
			if(_curView){				
				_curView.update();
			}
		}
	}
}