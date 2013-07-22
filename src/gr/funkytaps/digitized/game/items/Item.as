package gr.funkytaps.digitized.game.items
{
	import flash.display.BitmapData;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class Item extends Sprite implements IItem
	{
		protected var _itemID:int;
		
		protected var _isAnimated:Boolean;
		
		protected var _isStatic:Boolean;
		
		protected var _itemType:String;
		
		protected var _itemSpeed:Number;
		
		protected var _itemCreated:Boolean;
		
		protected var _itemDestroyed:Boolean;
		
		protected var _itemScore:Number;
		
		protected var _itemAnimated:MovieClip;
		
		protected var _itemStatic:Image;
		
		protected var _itemWidth:Number;
		
		protected var _itemHeight:Number;
		
		protected var _collisionRadius:Number;
		
		
		public function Item()
		{
			super();
		}
		
		public function initItem(isAnimated:Boolean, isStatic:Boolean, itemType:String, itemScore:Number, itemSpeed:Number, radius:Number):void {
			_isAnimated = isAnimated;
			_isStatic = isStatic;
			_itemType = itemType;
			_itemScore = itemScore;
			_itemSpeed = itemSpeed;
			_collisionRadius = radius;
			
			if (_isAnimated && _isStatic) throw new Error('You cannot have both _isAnimated and _isStatic set to true');
			
		}
		
		public function createItem():void
		{
			if (_isAnimated) {
				_itemAnimated = new MovieClip(Assets.manager.getTextures(_itemType), 25);
				_itemAnimated.loop = true;
				_itemAnimated.play();
				
				addChild(_itemAnimated);
				
				_itemWidth = _itemAnimated.width;
				_itemHeight = _itemAnimated.height;
			}
			
			if (_isStatic) {
				_itemStatic = new Image(Assets.manager.getTexture(_itemType));
				addChild(_itemAnimated);
				
				_itemWidth = _itemAnimated.width;
				_itemHeight = _itemAnimated.height;

			}
			
			_itemCreated = true;
			_itemDestroyed = false;
		}
	
		public function destroy():void {
			if (_isAnimated) {
				_itemAnimated.removeFromParent(true);
				_itemAnimated = null;
			}
			
			if (_isStatic) {
				_itemStatic.removeFromParent(true);
				_itemStatic = null;
			}
			_itemDestroyed = true;
		}
		
		public function update(passedTime:Number = 0):void {
			// nothing here??
		}
		
		public function get itemAnimated():MovieClip { return _itemAnimated; }
		
		public function get itemID():int { return _itemID; }
		
		public function set itemID(value:int):void { _itemID = value; }
		
		public function get collisionRadius():Number { return _collisionRadius; }
		
		public function get bitmapData():BitmapData { return null; }
		
		public function get isAnimated():Boolean { return _isAnimated; }
		
		public function get isStatic():Boolean { return _isStatic; }
		
		public function get itemType():String { return _itemType; }
		
		public function get speed():Number { return _itemSpeed; }
		
		public function get created():Boolean { return _itemCreated; }
		
		public function get destroyed():Boolean { return _itemDestroyed; }
		
		public function get score():Number { return _itemScore; }
		
		public function get itemHeight():Number { return _itemHeight; }
		
		public function get itemWidth():Number { return _itemWidth; }
		
		public function view():DisplayObject { return this as DisplayObject; }
		
		public function toString():String
		{
			return '[Item: ' + _itemType + ']';
		}
	}
}