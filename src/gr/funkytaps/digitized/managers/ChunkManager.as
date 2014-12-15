package gr.funkytaps.digitized.managers
{
	import com.dimmdesign.core.IDestroyable;
	import com.dimmdesign.utils.MathUtils;
	import com.dimmdesign.utils.ObjectUtils;
	
	import flash.geom.Point;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.items.BombItem;
	import gr.funkytaps.digitized.game.items.IItem;
	import gr.funkytaps.digitized.game.items.Item;
	import gr.funkytaps.digitized.game.items.ItemsType;
	import gr.funkytaps.digitized.game.items.StarItem;
	import gr.funkytaps.digitized.game.particles.StarParticle;
	import gr.funkytaps.digitized.interfaces.IUpdateable;
	import gr.funkytaps.digitized.utils.Distance;
	import gr.funkytaps.digitized.utils.Mathematics;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class ChunkManager implements IUpdateable, IDestroyable
	{
		private var _gameView:GameView;
		
		private var _heroPoint:Point = new Point();
		private var _itemPoint:Point = new Point();
		
		private var _patterns:Array;
		private var _onlinePatterns:Array;
		
		private var CHUNK_OFFSET:Number;
		
		/**
		 * One juggler instead of each item having its own. 
		 */		
		private var _itemsJuggler:Juggler;
		
		private var _heroCollisionThreshold:int;
		
		private var _stageHeight:int = 0;
		private var _itemsDestructionValue:int = 0;
		
		private var _starsPool:ObjectPool;
		private var _energiesPool:ObjectPool;
		private var _bombsPool:ObjectPool;
		
		private var _starParticlePool:ObjectPool;
		
		private var _distance:Number;
		
		private var _collisionDistanceThreshold:Number;
		
		/**
		 * Contains the stars objects that are active on stage. 
		 */		
		private var _activeChunkElements:Vector.<IItem>;
		public function get activeStars():Vector.<IItem> { return _activeChunkElements; }
		
		private var _activeChunkLength:int;
		
		private var _timeToNextInterval:Number = 0;
		private var _nextIntervalOffset:Number = 4;
		
		private var _onBombCollision:Function;
		
		private var _bombExplosionParticleSystem:PDParticleSystem;
		
		public function ChunkManager(gameView:GameView, onBombCollision:Function = null)
		{
			_gameView = gameView;
			
			_onBombCollision = onBombCollision;
			
			_patterns = Assets.manager.getObject('chunks').patterns as Array;
			if (Assets.manager.getObject('chunks-online')) {
				_onlinePatterns = Assets.manager.getObject('chunks-online').patterns as Array;
				if (_onlinePatterns.length > 0) 
					_patterns =	_patterns.concat(_onlinePatterns);
			}
			
			_itemsJuggler = new Juggler();
			
			_activeChunkElements = new Vector.<IItem>;
			_stageHeight = Settings.HEIGHT;
			CHUNK_OFFSET = _stageHeight;
			_itemsDestructionValue = _stageHeight + 30;
			
			_starParticlePool = new ObjectPool(true);
			_starParticlePool.name = 'star-particles';
			_starParticlePool.allocate(100, StarParticle);
			
			_starsPool = new ObjectPool(true);
			_starsPool.name = 'stars'
			_starsPool.allocate(100, StarItem);
			_starsPool.initialize('initItem', [true, false, ItemsType.STAR, 1, 0.5, 10, Assets.manager.getTextures(ItemsType.STAR), _itemsJuggler, 18, _starParticlePool]);
			
			_energiesPool = new ObjectPool(true);
			_energiesPool.name = 'energies';
			_energiesPool.allocate(50, Item);
			_energiesPool.initialize('initItem', [true, false, ItemsType.ENERGY, 0.1, 0.5, 10, Assets.manager.getTextures(ItemsType.ENERGY), _itemsJuggler, 15]);
			
			_bombsPool = new ObjectPool(true);
			_bombsPool.name = 'bombs';
			_bombsPool.allocate(50, BombItem);
			_bombsPool.initialize('initItem', [false, true, ItemsType.BOMB, 0, 0.5, 15, null, _itemsJuggler, 0]);
			
			_heroCollisionThreshold = _gameView.hero.heroWidth >> 1;
			
			// precalculated since it's static. Each star item has a collision radius of 10.
			_collisionDistanceThreshold = (_heroCollisionThreshold - 15) * (_heroCollisionThreshold - 15);
			
			// Hack! It appears that if we run this directly on an enterframe (see collision detection on update method)
			// it slows things down
			SoundManager.playSoundFX('star-pickup', 0);
			SoundManager.playSoundFX('power-up', 0);
			SoundManager.playSoundFX('power-down', 0);
			
		}
		
		[Inline]
		private final function _buildChunkPattern():void {
			
			var chosenPattern:int = Mathematics.getRandomInt(0, _patterns.length-1);
			var pattern:Array = _patterns[chosenPattern].stars;
			
			var i:int = 0;
			var j:int = 0;
			var c:int = 0;
			var patternLength:int = pattern.length;
			var rowLength:uint = 0;
			var star:IItem; //_starsPool.object as IItem; // needed for the precalculation below
			var padding:int = -9; // negative padding for the stars
			var row:int = 0;
			var col:int = 0;
			
			// fast pre-calculation of the stars pattern width & height
//			var patternWidth:int = star.itemWidth * pattern[0].length;
//			var patternHeight:int = (star.itemHeight * patternLength) + 90;

//			var randomX:int = Mathematics.getRandomInt(15, Settings.WIDTH-patternWidth-15);

//			_starsPool.object = star;
//			star = null;
			if (patternLength > 0) {
				for (i = 0; i < patternLength; i++) 
				{
					rowLength = pattern[i].length;
					for (j = 0; j < rowLength; j++) 
					{
						if (pattern[i][j] == 0) continue; // skip zeros
						if (pattern[i][j] == 1) {
							star = _starsPool.object as IItem;
							star.recreateItem();
							star.alpha = 1;
							_gameView.gameContainer.addChild( star.view() );
							
//							star.setParticleSystem(_starParticlePool.object as MovieClip, null, _starParticlePool);
							_itemsJuggler.add(star.itemAnimated);
							star.itemAnimated.play();
							
							star.x = j * (star.itemWidth - 10) + 5;
							star.y = ( (i * (star.itemHeight - 10) + 15) ) - _stageHeight;
							
							_activeChunkElements[_activeChunkLength++] = star; // faster than push.
						}
					}
				}
			}
			
			var energies:Array = _patterns[chosenPattern].energies as Array;
			patternLength = energies.length;
			
			if (patternLength > 0) {
				var energy:IItem;
				for (i = 0; i < patternLength; i++) {
					energy = _energiesPool.object as IItem;
					energy.recreateItem();
					energy.x = energies[i].x;
					energy.y = (energies[i].y) - _stageHeight;
					
					_gameView.gameContainer.addChild( energy.view() );
					
					_itemsJuggler.add(energy.itemAnimated);
					
					_activeChunkElements[_activeChunkLength++] = energy;
				}
			}
			
			var bombs:Array = _patterns[chosenPattern].bombs as Array;
			patternLength = bombs.length;
			if (patternLength > 0) {
				var bomb:IItem;
				
				for (i = 0; i < patternLength; i++) {
					bomb = _bombsPool.object as IItem;
					bomb.recreateItem();
					bomb.x = bombs[i].x;
					bomb.y = bombs[i].y - _stageHeight;
					
					_gameView.gameContainer.addChild( bomb.view() );
					
					_itemsJuggler.add(bomb.itemAnimated);
					
					_activeChunkElements[_activeChunkLength++] = bomb;
				}
			}
			
//			_activeStarsLength = _activeChunkElements.length;
			
			// Bump the hero to the front of the display list
//			_gameView.gameContainer.setChildIndex(_gameView.hero, _gameView.gameContainer.numChildren-1);
			
		}
		
		[Inline]
		private final function _destroyItem(item:IItem, i:int):void {
			// remove the item from the array
			_activeChunkElements.splice(i, 1);
			_activeChunkLength--;
			// reset collided value
			item.collided = false;
			// remove itemAnimated of item from juggler
			if (item.isAnimated) {
				item.itemAnimated.stop();
				_itemsJuggler.remove(item.itemAnimated);
			}
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
		
		[Inline]
		private final function _createBombExplosion(x:Number, y:Number):void {
			_bombExplosionParticleSystem = new PDParticleSystem(Assets.manager.getXml('bomb-explosion'), Assets.manager.getTexture('particleTexture'));
			_bombExplosionParticleSystem.start(0.142);
			Starling.current.juggler.add(_bombExplosionParticleSystem);
			_gameView.gameContainer.addChild(_bombExplosionParticleSystem);
			_bombExplosionParticleSystem.x = x;
			_bombExplosionParticleSystem.y = y;
		}
		
		public function update (passedTime:Number = 0):void {
			
			if (!_gameView.hero.crashed) {
//				if (_activeChunkLength < 20) {
					if (_timeToNextInterval >= 4) {
//						var r:Number = Mathematics.getRandomInt(0, 100);
//						if (r >= 0 && r <= 80) _buildChunkPattern();
						_buildChunkPattern();
						_timeToNextInterval = 0;
					}
					_timeToNextInterval += passedTime;
//				}
			}
			
//			_activeChunkLength = _activeChunkElements.length;
			
			_itemsJuggler.advanceTime(passedTime);
			
			_heroPoint.x = _gameView.hero.x;
			_heroPoint.y = _gameView.hero.y;
			var i:int;
			
			for (i = _activeChunkLength-1; i >= 0; --i)
			{
				if (!_activeChunkElements[i]) continue;
				_activeChunkElements[i].y += _gameView.gameSpeed + _activeChunkElements[i].speed;
				
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
							_gameView.dashboard.updateScore( _activeChunkElements[i].itemValue + 1 );
						}
						
						if (!_gameView.hero.noEnergy) {
							if (_activeChunkElements[i].itemType == ItemsType.ENERGY ) {
								_activeChunkElements[i].hit();
								_gameView.hero.createEnergyPickup();
								_gameView.pauseEnergyDescrease = true;
								SoundManager.playSoundFX('power-up', 0.5);
								if (_gameView.currentEnergyRatio < 0.99) { 
									_gameView.gameJuggler.tween(_gameView, 0.45, {
										currentEnergyRatio:1,
										onUpdate:function():void {
											_gameView.dashboard.updateEnergyBar( _gameView.currentEnergyRatio );
										},
										onComplete:function():void {
											_gameView.pauseEnergyDescrease = false;
										},
										transition: Transitions.EASE_IN_OUT
									});
								}
							}
						}
							
						if (!_gameView.hero.crashed) {
							if (_activeChunkElements[i].itemType == ItemsType.BOMB) {
								// Crash hero and stop game
								_activeChunkElements[i].hit();
								_gameView.hero.crashed = true;
								_gameView.hero.visible = false;
//								_gameView.hero.crashHero();
								SoundManager.playSoundFX('power-down', 0.5);
								_createBombExplosion(_activeChunkElements[i].x, _activeChunkElements[i].y);
								
								if (_onBombCollision != null) _onBombCollision(_activeChunkElements[i]);
							}
						}
						
					}
				}
				
				if (_activeChunkElements[i].y > _itemsDestructionValue) {
					_destroyItem(_activeChunkElements[i], i);
				}
			}
			
		}
		
		public function destroy():void {
			
			_bombsPool.deconstruct();
			_bombsPool = null;
			if (_starParticlePool) {
				_starParticlePool.deconstruct();
				_starParticlePool = null;
			}
			_energiesPool.deconstruct();
			_energiesPool = null;
			
			_gameView = null;
			
			_heroPoint = null;
			_itemPoint = null;
			
			_itemsJuggler.purge();
			_itemsJuggler = null;
			
			_activeChunkLength = 0;
			_activeChunkElements.length = 0;
			_activeChunkElements = null;
			_bombExplosionParticleSystem = null;
		}
		
	}
}