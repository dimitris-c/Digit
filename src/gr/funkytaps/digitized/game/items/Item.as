package gr.funkytaps.digitized.game.items
{
	import flash.display.BitmapData;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class Item extends Sprite implements IItem
	{
		protected var _itemID:int;
		
		protected var _isAnimated:Boolean;
		
		protected var _isStatic:Boolean;
		
		protected var _itemType:String;
		
		protected var _itemSpeed:Number;
		
		protected var _itemCreated:Boolean;
		
		protected var _itemDestroyed:Boolean;
		
		protected var _itemCollided:Boolean;
		
		protected var _itemScore:Number;
		
		protected var _itemAnimated:MovieClip;
		
		protected var _animatedTextures:Vector.<Texture>;

		protected var _itemStatic:Image;
		
		protected var _staticTexture:Texture;
		
		protected var _itemWidth:Number;
		
		protected var _itemHeight:Number;
		
		protected var _collisionRadius:Number;
		
		protected var _juggler:Juggler;
		
		private var _itemParticleMovieclip:MovieClip;
		
		public function get itemParticleMovieclip():MovieClip { return _itemParticleMovieclip; }

		private var _itemParticleSystem:PDParticleSystem;

		public function get itemParticleSystem():PDParticleSystem { return _itemParticleSystem; }
		
		private var _itemParticlePool:ObjectPool;
		
		public function get itemParticlePool():ObjectPool { return _itemParticlePool; }

		public function Item()
		{
			super();
		}
		
		public function initItem(isAnimated:Boolean, isStatic:Boolean, itemType:String, itemScore:Number, itemSpeed:Number, radius:Number, animatedTextures:Vector.<Texture> = null, juggler:Juggler = null):void {
			_isAnimated = isAnimated;
			_isStatic = isStatic;
			_itemType = itemType;
			_itemScore = itemScore;
			_itemSpeed = itemSpeed;
			_collisionRadius = radius;
			
			if (_isAnimated) {
				_juggler = juggler;
				_animatedTextures = animatedTextures;
				if (!_animatedTextures) {
					Assets.manager.getTextures(_itemType, _animatedTextures);
				}
				_itemWidth = _animatedTextures[0].width;
				_itemHeight = _animatedTextures[0].height;
			}
			
			if (_isStatic) {
				_staticTexture = Assets.manager.getTexture(_itemType);
				_itemWidth = _staticTexture.width;
				_itemHeight = _staticTexture.height;
			}
			
			if (_isAnimated && _isStatic) throw new Error('You cannot have both _isAnimated and _isStatic set to true');
			
		}
		
		public function createItem():void
		{
			if (_isAnimated) {
				_itemAnimated = new MovieClip(_animatedTextures, 25);
				_itemAnimated.loop = true;
				_itemAnimated.play();
				
				addChild(_itemAnimated);
				
				_itemWidth = _itemAnimated.width;
				_itemHeight = _itemAnimated.height;
			}
			
			if (_isStatic) {
				_itemStatic = new Image(_staticTexture);
				addChild(_itemAnimated);
				
				_itemWidth = _itemAnimated.width;
				_itemHeight = _itemAnimated.height;

			}
			
			_itemCreated = true;
			_itemDestroyed = false;
			_itemCollided = false;
		}
		
		public function setParticleSystem(movieClip:MovieClip, particleSystem:PDParticleSystem = null, fromPool:ObjectPool = null):void {
			if (movieClip && particleSystem) throw new Error("You can't set both a movieClip and a PartileSystem. Please choose one");
			if (fromPool) _itemParticlePool = fromPool;
			if (movieClip) {
				_itemParticleMovieclip = movieClip;
				_itemParticleMovieclip.loop = false;
				_itemParticleMovieclip.visible = false;
				addChild(_itemParticleMovieclip);
				_itemParticleMovieclip.stop();
				_itemParticleMovieclip.addEventListener(Event.COMPLETE, _onParticleSystemCompleted);
				return;
			}
			
			if (_itemParticleSystem) {
				_itemParticleSystem = particleSystem;
				_itemParticleSystem.x = _itemWidth >> 1;
				_itemParticleSystem.y = _itemHeight >> 1;
				_itemParticleSystem.stop();
				_juggler.add(_itemParticleSystem);
				addChild(_itemParticleSystem);
				_itemParticleSystem.addEventListener(Event.COMPLETE, _onParticleSystemCompleted);
			}
		}
		
		private function _onParticleSystemCompleted(event:Event):void
		{
			_destroyParticleSystem();
		}
		
		public function hit():void {
			_itemCollided = true;
			
			if (_itemAnimated) {
				_itemAnimated.visible = false;
				_itemAnimated.stop();
				_juggler.remove(_itemAnimated);
			}
			if (_itemStatic) _itemStatic.visible = false;
			
			if (_itemParticleMovieclip) {
				_itemParticleMovieclip.visible = true;
				_itemParticleMovieclip.play();
				_juggler.add(_itemParticleMovieclip);
			}
			
			if (_itemParticleSystem) {
				_itemParticleSystem.start(0.1);
			}
			
		}
		
		public function destroy():void {
			
			_destroyParticleSystem();
			
			if (_isAnimated) {
				if (_itemAnimated) {
					_itemAnimated.removeFromParent(true);
				}
				_itemAnimated = null;
			}
			
			if (_isStatic) {
				_itemStatic.removeFromParent(true);
				_itemStatic = null;
			}
			
			_itemCollided = false;
			_itemDestroyed = true;
		}
		
		/**
		 * Checks to see what current system we have either a MovieClip or PDParticleSystem and destroys it. 
		 */
		[Inline]
		private final function _destroyParticleSystem():void {
			if (_itemParticleMovieclip) {
				if (_itemParticlePool) _itemParticlePool.object = _itemParticleMovieclip;
				_itemParticleMovieclip.stop();
				_itemParticleMovieclip.removeFromParent(true);
				_juggler.remove(_itemParticleMovieclip);
				_itemParticleMovieclip = null;
				return;
			}
			
			if (_itemParticleSystem) {
				if (_itemParticlePool) _itemParticlePool.object = _itemParticleSystem;
				_itemParticleSystem.removeEventListener(Event.COMPLETE, _onParticleSystemCompleted);
				_itemParticleSystem.stop(true);
				_itemParticleSystem.removeFromParent(true);
				_juggler.remove(_itemParticleSystem);
				_itemParticleSystem = null;
			}
		}
		
		public function update(passedTime:Number = 0):void {
			// nothing here??
		}
		
		public function get juggler():Juggler { return _juggler; }

		public function get animatedTextures():Vector.<Texture> { return _animatedTextures }
		
		public function set animatedTextures(value:Vector.<Texture>):void { _animatedTextures = value; }

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
		
		public function set destroyed(value:Boolean):void { destroyed = value; }
		
		public function get collided():Boolean { return _itemCollided; }
		
		public function set collided(value:Boolean):void { _itemCollided = value; }
		
		public function get score():Number { return _itemScore; }
		
		public function get itemHeight():Number { return _itemHeight; }
		
		public function get itemWidth():Number { return _itemWidth; }
		
		public function view():DisplayObject { return this as DisplayObject; }
		
		public function toString():String
		{
			return '[Item: ' + _itemType + ', id:' + _itemID + ']';
		}
	}
}