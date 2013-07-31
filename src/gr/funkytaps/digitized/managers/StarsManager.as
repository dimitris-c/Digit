package gr.funkytaps.digitized.managers
{
	import flash.geom.Point;
	import flash.media.SoundTransform;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.items.IItem;
	import gr.funkytaps.digitized.game.items.Item;
	import gr.funkytaps.digitized.game.items.ItemsType;
	import gr.funkytaps.digitized.game.particles.StarParticle;
	import gr.funkytaps.digitized.interfaces.IUpdateable;
	import gr.funkytaps.digitized.utils.Distance;
	import gr.funkytaps.digitized.utils.Mathematics;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.animation.Juggler;
	import starling.display.MovieClip;
	import starling.textures.Texture;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class StarsManager implements IUpdateable
	{
		private var _game:GameView;
		
		private var _heroPoint:Point = new Point();
		private var _itemPoint:Point = new Point();
		
		private var _patterns:Array;
		
		/**
		 * One juggler instead of each item having its own. 
		 */		
		private var _starsJuggler:Juggler;
		
		private var _heroCollisionThreshold:int;
		
		private var _stageHeight:int = 0;
		
		private var _starsPool:ObjectPool;
		
		private var _starsTextures:Vector.<Texture>;
		
		private var _starParticlePool:ObjectPool;
		
		private var _distance:Number;
		
		private var _collisionDistanceThreshold:Number;
		
		/**
		 * Contains the stars objects that are active on stage. 
		 */		
		private var _activeStars:Vector.<IItem>;
		public function get activeStars():Vector.<IItem> { return _activeStars; }

		private var _activeStarsLength:int;
		
		private var _timeSinceNextInterval:Number = 0;

		public function StarsManager(game:GameView)
		{
			_game = game;
			
			_patterns = Assets.manager.getObject('starspatterns').patterns as Array;
			
			_starsJuggler = new Juggler();
			
			_activeStars = new Vector.<IItem>;
			_stageHeight = Settings.HEIGHT;
			
			_starsTextures = new Vector.<Texture>;
			Assets.manager.getTextures(ItemsType.STAR, _starsTextures);
			
			_starsPool = new ObjectPool(false);
			_starsPool.allocate(100, Item);
			_starsPool.initialize('initItem', [true, false, ItemsType.STAR, 1, 0.5, 10, _starsTextures, _starsJuggler]);
			
			_starParticlePool = new ObjectPool(false);
			_starParticlePool.allocate(100, StarParticle);
			
			_heroCollisionThreshold = (_game.hero.width >> 1);
			
			// precalculated since it's static. Each star item has a collision radius of 10.
			_collisionDistanceThreshold = (_heroCollisionThreshold + 10) * (_heroCollisionThreshold + 10);
		
			// Hack! It appears that if we run this directly on an enterframe (see collision detection on update method)
			// it slows things down
			SoundManager.playSoundFX('star-pickup', 0);
		}
		
		public final function buildStarPattern():void {
			
			var chosenPattern:int = Mathematics.getRandomInt(0, _patterns.length-1);
			var pattern:Array = _patterns[chosenPattern];
						
			var i:int = 0;
			var j:int = 0;
			var c:int = 0;
			var patternLength:int = pattern.length;
			var rowLength:uint = 0;
			var star:IItem = _starsPool.object as IItem;
			var padding:int = 1;
			var row:int = 0;
			var col:int = 0;
			
			// fast pre-calculation of the stars pattern width & height
			var patternWidth:int = star.itemWidth * pattern[0].length;
			var patternHeight:int = (star.itemHeight * patternLength) + 30;
			
			var randomX:int = Mathematics.getRandomInt(15, Settings.WIDTH-patternWidth-15);
			
			_starsPool.object = star;
			star = null;
			
			for (i = 0; i < patternLength; i++) 
			{
				rowLength = pattern[i].length;
				for (j = 0; j < rowLength; j++) 
				{
					if (pattern[i][j] == 0) continue; // skip zeros
					if (pattern[i][j] == 1) {
						star = _starsPool.object as IItem;
						star.alpha = 1;
						star.itemID = i;
						_game.gameContainer.addChild( star.view() );
						star.createItem();
						star.setParticleSystem(_starParticlePool.object as MovieClip, null, _starParticlePool);
						
						star.x = j * (star.itemWidth + padding) + randomX;
						star.y = (i * (star.itemHeight + padding)) - patternHeight;
						
						// delays the star.itemAnimated to be added to the juggler for an extra effect.
						_starsJuggler.delayCall(_starsJuggler.add, i * 0.1, star.itemAnimated);
						
						_activeStars[_activeStars.length] = star; // faster than push.
					}
				}
			}

			_activeStarsLength = _activeStars.length;
			
			// Bump the hero to the front of the display list
			_game.gameContainer.setChildIndex(_game.hero, _game.gameContainer.numChildren-1);
 		}
		
		[Inline]
		private final function _destroyItem(item:IItem, i:int):void {
			// remove the item from the array
			_activeStars.splice(i, 1);
			// reset collided value
			item.collided = false;
			// remove the item from the juggler
			_starsJuggler.remove(item.itemAnimated);
			// destroy item
			item.destroy();
			// remove item from its parent container and dispose it.
			item.removeFromParent(true);
			// put item back to the pool
			_starsPool.object = item as IItem;
		}
		
		private var prevTime:Number;
		public function update (passedTime:Number = 0):void {
			
			if (_timeSinceNextInterval >= 2) {
				if (_starsPool.usageCount <= 55) { // limit the creation of stars to 60
					var r:Number = Mathematics.getRandomInt(0, 100);
					if (r >= 0 && r <= 40) buildStarPattern();
				}
				_timeSinceNextInterval = 0;
			}
			_timeSinceNextInterval += passedTime;
			
			_activeStarsLength = _activeStars.length;
			
			_starsJuggler.advanceTime(passedTime);
			
			_heroPoint.x = _game.hero.x;
			_heroPoint.y = _game.hero.y;
			var i:int;
			
			for (i = _activeStarsLength-1; i >= 0; --i) 
			{
				_activeStars[i].y += _game.gameSpeed + _activeStars[i].speed;
				
				// this gets updated if an item hasn't been collided
				// once it has we skip it
				if (!_activeStars[i].collided) {
					_itemPoint.x = _activeStars[i].x;
					_itemPoint.y = _activeStars[i].y;
					_distance = Distance.calculateInt(_heroPoint.x, _itemPoint.x, _heroPoint.y, _itemPoint.y);
					
					if (_distance < _collisionDistanceThreshold) {
						_activeStars[i].hit();
						// we don't remove the item right way so run this once
						SoundManager.playSoundFX('star-pickup', 0.5);
						_game.dashboard.updateStars( _activeStars[i].score );
					}
				}
				
				if (_activeStars[i].y > _stageHeight) {
					_destroyItem(_activeStars[i], i);
				}
			}
			
		}
		
	}
}