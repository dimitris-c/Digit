package gr.funkytaps.digitized.game.items
{
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.display.MovieClip;

	public class StarItem extends Item
	{
		public var starID:int = 0;
		public var delayFactor:Number = 0.1;
		public var loopDelay:Number = 0.5;
		
		public function StarItem()
		{
			super();
			initItem(true, false, ItemsType.STAR, 1, 2, 10);
		}
		
		override public function createItem():void
		{
			if (_isAnimated) {
				_itemAnimated = new MovieClip(Assets.manager.getTextures(_itemType), 25);
				_itemAnimated.play();
				
				addChild(_itemAnimated);
				
				_itemWidth = _itemAnimated.width;
				_itemHeight = _itemAnimated.height;
				
			}
			
			_itemCreated = true;
			_itemDestroyed = false;
		}
		
	}
}