package gr.funkytaps.digitized.managers
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.items.IItem;
	import gr.funkytaps.digitized.game.items.Item;
	import gr.funkytaps.digitized.game.items.ItemsType;
	import gr.funkytaps.digitized.game.items.StarItem;
	import gr.funkytaps.digitized.interfaces.IUpdateable;
	import gr.funkytaps.digitized.utils.Distance;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.animation.Juggler;
	import starling.display.Sprite;

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
		
		/**
		 * One juggler instead of each item having its own. 
		 */		
		private var _starsJuggler:Juggler;
		
		private var _heroCollisionThreshold:int;
		
		private var _stageHeight:int = 0;
		
		private var _starsPool:ObjectPool;
		
		private var _distance:Number;
		
		private var _collisionDistanceThreshold:Number;
		
		/**
		 * Contains the stars objects that are active on stage. 
		 */		
		private var _activeStars:Vector.<IItem>;
		public function get activeStars():Vector.<IItem> { return _activeStars; }

		private var _activeStarsLength:int;
		
		public function StarsManager(game:GameView)
		{
			_game = game;
			
			_starsJuggler = new Juggler();
			
			_activeStars = new Vector.<IItem>;
			_stageHeight = Settings.HEIGHT;
			
			_starsPool = new ObjectPool(false);
			_starsPool.allocate(60, Item);
			_starsPool.initialize('initItem', [true, false, ItemsType.STAR, 1, 0.8, 10]);
			_heroCollisionThreshold = (_game.hero.width >> 1);
			
			// precalculated since its static. Each star item has a collision radius of 10
			_collisionDistanceThreshold = (_heroCollisionThreshold + 10) * (_heroCollisionThreshold + 10);
			
		}
		
		public final function _buildStarPattern():void {
			
			var pattern:Array = Assets.manager.getObject('starspatterns').pattern2 as Array;
						
			var i:int = 0;
			var j:int = 0;
			var patternLength:int = pattern.length;
			var rowLength:uint = 0;
			var rowArray:Array = [];
			var star:IItem;
			var padding:int = 1;
			var row:int = 0;
			var col:int = 0;
			var patternWidth:int = 0;
			var patternHeight:int = 0;
			
			for (i = 0; i < patternLength; i++) 
			{
				rowArray = pattern[i];
				rowLength = rowArray.length;
				for (j = 0; j < rowLength; j++) 
				{
					if (rowArray[j] == 0) continue;
					if (rowArray[j] == 1) {
						star = _starsPool.object as IItem;
						star.itemID = i;
						_game.gameContainer.addChild( star.view() );
						star.createItem();
						
						star.x = j * (star.itemWidth + padding);
						star.y = i * (star.itemHeight + padding) - 500;
						
						patternHeight += star.itemHeight + padding;
						
						// delays the star.itemAnimated to be added to the juggler for an extra effect.
						_starsJuggler.delayCall(_starsJuggler.add, i * 0.1, star.itemAnimated);
						
						_activeStars.push(star);
					}
				}
				
				patternWidth += star.itemWidth + padding;
			}

			_activeStarsLength = _activeStars.length;
			
			// Bump the hero to the front of the display list
			_game.gameContainer.setChildIndex(_game.hero, _game.gameContainer.numChildren-1);
 		}
		
		private final function _destroyItem(item:IItem, index:int):void {
			// remove item from its parent container and dispose it.
			item.removeFromParent(true);
			// put item back to the pool
			_starsPool.object = item as IItem;
			_activeStars.splice(index, 1);
		}
		
		public function update (passedTime:Number = 0):void {
			
			_activeStarsLength = _activeStars.length;
			if (_activeStarsLength == 0) return;
			
			if (_starsJuggler) _starsJuggler.advanceTime(passedTime);
			
			_heroPoint.x = _game.hero.x;
			_heroPoint.y = _game.hero.y;
			
			for (var i:int = _activeStarsLength-1; i >= 0; --i) 
			{
				_activeStars[i].y += _game.gameSpeed + _activeStars[i].speed;
				
				_itemPoint.x = _activeStars[i].x;
				_itemPoint.y = _activeStars[i].y;
				_distance = Distance.calculate(_heroPoint.x, _itemPoint.x, _heroPoint.y, _itemPoint.y);
				
				if (_distance < _collisionDistanceThreshold) {
					SoundManager.stopSound('star-pickup');
					_game.dashboard.updateStars( _activeStars[i].score );
					_destroyItem(_activeStars[i], i);
					SoundManager.playSoundFX('star-pickup', 0.4);
					continue;
				}
				
				if (_activeStars[i].y > _stageHeight) {
					_destroyItem(_activeStars[i], i);
				}
			}
			
		}
		
	}
}