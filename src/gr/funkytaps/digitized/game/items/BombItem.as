package gr.funkytaps.digitized.game.items
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class BombItem extends Item
	{
		private var _bombRing:Image;

		private var _timeline:TimelineMax;
		
		public function BombItem()
		{
			super();
		}
		
		override public function initItem(isAnimated:Boolean, isStatic:Boolean, itemType:String, itemValue:Number, itemSpeed:Number, radius:Number, animatedTextures:Vector.<Texture>=null, juggler:Juggler=null, fps:Number=25, particlePool:ObjectPool = null):void {
			super.initItem(isAnimated, isStatic, itemType, itemValue, itemSpeed, radius, animatedTextures, juggler, fps);
			
			_bombRing = new Image(Assets.manager.getTexture('bomb-ring'));
			addChildAt(_bombRing, 0);
			
			_bombRing.pivotX = _bombRing.width >> 1;
			_bombRing.pivotY = _bombRing.height >> 1;
			
			_bombRing.scaleX = _bombRing.scaleY = 0;
			_bombRing.alpha = 1;
			
			animate();
		}
		
		public function animate():void {

			_timeline = new TimelineMax();
			_timeline.repeat = -1;
			_timeline.repeatDelay = 1;
			
			_timeline.append( TweenLite.to(_bombRing, 1.5, {scaleX:1, scaleY:1}) );
			_timeline.append( TweenLite.to(_bombRing, 0.55, {scaleX:1.2, scaleY:1.2, alpha:0}),  -0.55);
			
			_timeline.play();
		
		}
		
		override public function hit():void {
			super.hit();
			_bombRing.visible = false;
		}
		
		override public function recreateItem():void {
			super.recreateItem();
			
			_timeline.play();
			_bombRing.visible = true;
			
		}
		
		override public function destroy():void { 
			super.destroy();
			
			_timeline.stop();
			
			if (_bombRing) {
				_bombRing.visible = false;
//				_bombRing.removeFromParent(true);
//				_bombRing = null;
			}
		}
	}
}