package gr.funkytaps.digitized.game.items
{
	import starling.events.Event;
	
	
	public class StarItem extends Item
	{
		
		public function StarItem()
		{
			super();
		}
		
		override public function hit():void {
			
			_itemParticleMovieclip = _itemParticlePool.object;
			if (_itemAnimated) _itemAnimated.visible = false;
			if (_itemParticleMovieclip) {
				_itemParticleMovieclip.x = 4;
				_itemParticleMovieclip.addEventListener(Event.COMPLETE, _removeParticle);
				_itemParticleMovieclip.visible = true;
				addChild(_itemParticleMovieclip);
				
				_juggler.add(_itemParticleMovieclip);
				
				_itemParticleMovieclip.play();
			}
			
			_itemCollided = true;
		}
		
		private function _removeParticle(event:Event):void
		{
			if (!_itemParticleMovieclip) return; 
			_itemParticleMovieclip.visible = true;
			_itemParticleMovieclip.removeFromParent();
			_juggler.remove(_itemParticleMovieclip);
			_itemParticlePool.object = _itemParticleMovieclip;
			
		}
		
		override public function createItem():void {
			super.createItem();
			
			if (_isAnimated) {
				_itemAnimated.pivotX = 0;
				_itemAnimated.pivotY = 0;
			}
		}
		
		private function _resetItemAnimated():void {
			_itemAnimated.visible = false;
			_itemAnimated.alpha = 1;
		}
		
				
	}
}