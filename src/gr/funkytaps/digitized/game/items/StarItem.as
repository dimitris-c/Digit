package gr.funkytaps.digitized.game.items
{
	
	import gr.funkytaps.digitized.utils.Mathematics;
	
	import starling.display.Quad;
	
	public class StarItem extends Item
	{
		public var starID:int = 0;
		public var delayFactor:Number = 0.1;
		public var loopDelay:Number = 0.5;
		
		private var _tempQuad:Quad;
		
		public function StarItem()
		{
			super();
			initItem(false, true, ItemsType.ENEMY, 0, 2, 15);
		}
		
		override public function createItem():void {
			
			if (_itemType == ItemsType.ENEMY) {
				var r:int = Mathematics.getRandomInt(10, 20);
				_tempQuad = new Quad(r, r-5, 0xD64183);
				addChild(_tempQuad);
			}
			
			_itemCreated = true;
			_itemDestroyed = false;
			_itemCollided = false;
		}
				
	}
}