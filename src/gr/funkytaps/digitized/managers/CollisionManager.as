package gr.funkytaps.digitized.managers
{
	import flash.geom.Point;
	
	import gr.funkytaps.digitized.game.items.IItem;
	import gr.funkytaps.digitized.interfaces.IUpdateable;
	import gr.funkytaps.digitized.views.GameView;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class CollisionManager implements IUpdateable
	{
		private var _game:GameView;
		
		private var _heroCollisionThreshold:Number = 0;
		private var _heroPoint:Point = new Point();
		private var _itemPoint:Point = new Point();
		private var _obstaclePoint:Point = new Point();
		
		private var _chance:Number = 0;
		
		public function CollisionManager(game:GameView)
		{
			_game = game;
			
			_heroPoint.x = _game.hero.x;
			_heroPoint.y = _game.hero.y;
			
			_heroCollisionThreshold = _game.hero.pivotY - 20;
		}
		
		private function _heroAndItems():void {
			if (_game.starsManager.activeStars.length == 0) return;
			
			var items:Vector.<IItem> = _game.starsManager.activeStars;
			var i:int = 0;
			var item:IItem;
			
			for (i = items.length-1; i >= 0; --i) 
			{
				item = items[i];
				_heroPoint.x = _game.hero.x;
				_heroPoint.y = _game.hero.y;
				_itemPoint.x = item.x;
				_itemPoint.y = item.y;
				
				if (Point.distance(_heroPoint, _itemPoint) < _heroCollisionThreshold + item.collisionRadius) {
					_game.dashboard.updateStars( item.score );
					item.removeFromParent(true);
					items.splice(i, 1);
					SoundManager.playSoundFX('star-pickup', 0.4);
				}
				
			}
			
		}
		
		private function _heroAndObstacles():void {
			_heroPoint.x = _game.hero.x;
			_heroPoint.y = _game.hero.y;
			
			
		}
	
		public function update(passedTime:Number = 0):void {
			
			if (_chance & 1) 
				_heroAndItems();
			else
				_heroAndObstacles();
			
			_chance++;
		}
	}
}