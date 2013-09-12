package gr.funkytaps.digitized.managers
{
	import flash.geom.Point;
	
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
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class ChunkManager implements IUpdateable
	{
		private var _game:GameView;
		
		private var _heroPoint:Point = new Point();
		private var _itemPoint:Point = new Point();
		
		private var _patterns:Array;
		
		private var CHUNK_OFFSET:Number;
		
		/**
		 * One juggler instead of each item having its own. 
		 */		
		private var _itemsJuggler:Juggler;
		 
		private var _heroCollisionThreshold:int;
		
		private var _stageHeight:int = 0;
		
		private var _starsPool:ObjectPool;
		private var _energiesPool:ObjectPool;
		private var _bombsPool:ObjectPool;
		
		private var _starTextures:Vector.<Texture>;
		private var _energyTextures:Vector.<Texture>;
		private var _bombTextures:Vector.<Texture>;
		
		private var _starParticlePool:ObjectPool;
		
		private var _distance:Number;
		
		private var _collisionDistanceThreshold:Number;
		
		/**
		 * Contains the stars objects that are active on stage. 
		 */		
		private var _activeChunkElements:Vector.<IItem>;
		public function get activeStars():Vector.<IItem> { return _activeChunkElements; }

		private var _activeStarsLength:int;
		
		private var _timeSinceNextInterval:Number = 0;
		
		private var _onBombCollision:Function;

		public function ChunkManager(game:GameView, onBombCollision:Function = null)
		{
			_game = game;
			
			_onBombCollision = onBombCollision;
			
			_patterns = Assets.manager.getObject('chunks').patterns as Array;
			
			_itemsJuggler = new Juggler();
			
			_activeChunkElements = new Vector.<IItem>;
			_stageHeight = Settings.HEIGHT;
			
			_starTextures = new Vector.<Texture>;
			Assets.manager.getTextures(ItemsType.STAR, _starTextures);
			
			_starsPool = new ObjectPool(false);
			_starsPool.allocate(100, Item);
			_starsPool.initialize('initItem', [true, false, ItemsType.STAR, 1, 0.5, 10, _starTextures, _itemsJuggler]);
			
			_energyTextures = new Vector.<Texture>;
			Assets.manager.getTextures(ItemsType.ENERGY, _energyTextures);
			
			_energiesPool = new ObjectPool(false);
			_energiesPool.allocate(50, Item);
			_energiesPool.initialize('initItem', [true, false, ItemsType.ENERGY, 1, 0.5, 10, _energyTextures, _itemsJuggler]);
			
			_bombTextures = new Vector.<Texture>;
			Assets.manager.getTextures(ItemsType.BOMB, _bombTextures);
			
			_bombsPool = new ObjectPool(false);
			_bombsPool.allocate(50, Item);
			
			_bombsPool.initialize('initItem', [true, false, ItemsType.BOMB, 0, 0.5, 10, _bombTextures, _itemsJuggler]);
			
			_starParticlePool = new ObjectPool(false);
			_starParticlePool.allocate(100, StarParticle);
			
			_heroCollisionThreshold = (_game.hero.width >> 1);
			
			// precalculated since it's static. Each star item has a collision radius of 10.
			_collisionDistanceThreshold = (_heroCollisionThreshold - 20) * (_heroCollisionThreshold - 20);
			
			// Hack! It appears that if we run this directly on an enterframe (see collision detection on update method)
			// it slows things down
			SoundManager.playSoundFX('star-pickup', 0);
			
		}
		
		public final function buildChunkPattern():void {
			
			var chosenPattern:int = Mathematics.getRandomInt(0, _patterns.length-1);
			var pattern:Array = _patterns[chosenPattern].stars;
						
			var i:int = 0;
			var j:int = 0;
			var c:int = 0;
			var patternLength:int = pattern.length;
			var rowLength:uint = 0;
			var star:IItem = _starsPool.object as IItem; // needed for the precalculation below
			var padding:int = -9; // negative padding for the stars
			var row:int = 0;
			var col:int = 0;
			
			// fast pre-calculation of the stars pattern width & height
			var patternWidth:int = star.itemWidth * pattern[0].length;
			var patternHeight:int = (star.itemHeight * patternLength) + 90;
			
//			var randomX:int = Mathematics.getRandomInt(15, Settings.WIDTH-patternWidth-15);
			
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
						
						star.x = j * (star.itemWidth + padding);
						star.y = (i * (star.itemHeight + padding)) - _stageHeight;
						
						// delays the star.itemAnimated to be added to the juggler for an extra effect.
						_itemsJuggler.delayCall(_itemsJuggler.add, i * 0.1, star.itemAnimated);
						
						_activeChunkElements[_activeChunkElements.length] = star; // faster than push.
					}
				}
			}
			
			var energies:Array = _patterns[chosenPattern].energies as Array;
			patternLength = energies.length;
			var energy:IItem;
			
			for (i = 0; i < patternLength; i++) {
				energy = _energiesPool.object as IItem;
				energy.createItem();
				
				energy.x = energies[i].x;
				energy.y = energies[i].y - _stageHeight;
				
				_game.gameContainer.addChild( energy.view() );
				
				_itemsJuggler.delayCall(_itemsJuggler.add, i * 0.1, energy.itemAnimated);
				
				_activeChunkElements[_activeChunkElements.length] = energy;
			}
			
			
			var bombs:Array = _patterns[chosenPattern].bombs as Array;
			patternLength = bombs.length;
			var bomb:IItem;
			
			for (i = 0; i < patternLength; i++) {
				bomb = _bombsPool.object as IItem;
				bomb.createItem();
				bomb.setParticleSystem(null, new PDParticleSystem(Assets.manager.getXml('bomb-explosion'), Assets.manager.getTexture('particleTexture')));
				bomb.x = bombs[i].x;
				bomb.y = bombs[i].y - _stageHeight;
				
				_game.gameContainer.addChild( bomb.view() );
				
				_itemsJuggler.delayCall(_itemsJuggler.add, i * 0.1, bomb.itemAnimated);
				
				_activeChunkElements[_activeChunkElements.length] = bomb;
			}

			_activeStarsLength = _activeChunkElements.length;
			
			// Bump the hero to the front of the display list
			_game.gameContainer.setChildIndex(_game.hero, _game.gameContainer.numChildren-1);
 		}
		
		[Inline]
		private final function _destroyItem(item:IItem, i:int):void {
			// remove the item from the array
			_activeChunkElements.splice(i, 1);
			// reset collided value
			item.collided = false;
			// remove the item from the juggler
			_itemsJuggler.remove(item.itemAnimated);
			// destroy item
			item.destroy();
			// remove item from its parent container and dispose it.
			item.removeFromParent(true);
			// put item back to the pool
			if (item.itemType == ItemsType.STAR)
				_starsPool.object = item as IItem;
			
			if (item.itemType == ItemsType.ENERGY)
				_energiesPool.object = item as IItem;
			
			if (item.itemType == ItemsType.BOMB)
				_bombsPool.object = item as IItem;
		}
		
		public function update (passedTime:Number = 0):void {
			
			if (!_game.hero.crashed) {
				if (_timeSinceNextInterval >= 3) {
	//				var r:Number = Mathematics.getRandomInt(0, 100);
	//				if (r >= 0 && r <= 50) buildChunkPattern();
					buildChunkPattern();
					_timeSinceNextInterval = 0;
				}
				_timeSinceNextInterval += passedTime;
			}
			
			_activeStarsLength = _activeChunkElements.length;
			
			_itemsJuggler.advanceTime(passedTime);
			
			_heroPoint.x = _game.hero.x;
			_heroPoint.y = _game.hero.y;
			var i:int;
			
			for (i = _activeStarsLength-1; i >= 0; --i)
			{
				_activeChunkElements[i].y += _game.gameSpeed + _activeChunkElements[i].speed;
				
				// this gets updated if an item hasn't been collided
				// once it has we skip it
				if (!_activeChunkElements[i].collided) {
					_itemPoint.x = _activeChunkElements[i].x;
					_itemPoint.y = _activeChunkElements[i].y;
					_distance = Distance.calculateInt(_heroPoint.x, _itemPoint.x, _heroPoint.y, _itemPoint.y);
					
					if (_distance < _collisionDistanceThreshold) {
						
						if (_activeChunkElements[i].itemType == ItemsType.STAR ) {
							_activeChunkElements[i].hit();
							// we don't remove the item right way so run this once
							SoundManager.playSoundFX('star-pickup', 0.11);
							_game.dashboard.updateStars( _activeChunkElements[i].score );
						}
						
						if (!_game.hero.crashed) {
							if (_activeChunkElements[i].itemType == ItemsType.ENERGY ) {
								_activeChunkElements[i].hit();
								// TODO: 
							}
							
							if (_activeChunkElements[i].itemType == ItemsType.BOMB ) {
								// Crash hero and stop game
								_activeChunkElements[i].hit();
								_game.hero.visible = false;
//								_game.hero.crashHero();
								SoundManager.playSoundFX('power-down', 0.5);
								
								if (_onBombCollision != null) _onBombCollision(_activeChunkElements[i]);
							}
						}
					}
				}
				
				if (_activeChunkElements[i].y > _stageHeight) {
					_destroyItem(_activeChunkElements[i], i);
				}
			}
			
		}
		
	}
}