package gr.funkytaps.digitized.game.items
{
	import flash.display.BitmapData;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class Item extends Sprite implements IItem
	{
		
		protected var _isAnimated:Boolean;
		
		protected var _isStatic:Boolean;
		
		protected var _itemType:String;
		
		protected var _itemSpeed:Number;
		
		protected var _itemCreated:Boolean;
		
		protected var _itemDestroyed:Boolean;
		
		protected var _itemScore:Number;
		
		public function Item()
		{
			super();
		}
		
		public function initItem(isAnimated:Boolean, isStatic:Boolean, itemType:String, itemScore:Number):void {
			_isAnimated = isAnimated;
			
		}
		
		public function createItem():void
		{
			
		}
		
		public function get bitmapData():BitmapData { return null; }
		
		public function get isAnimated():Boolean { return _isAnimated; }
		
		public function get isStatic():Boolean { return _isStatic; }
		
		public function get itemType():String { return _itemType; }
		
		public function get speed():Number { return _itemSpeed; }
		
		public function get created():Boolean { return _itemCreated; }
		
		public function get destroyed():Boolean { return _itemDestroyed; }
		
		public function get score():Number { return _itemScore; }
		
		public function view():DisplayObject { return this as DisplayObject; }
		
		public function toString():String
		{
			return 'Item: ' + _itemType;
		}
	}
}