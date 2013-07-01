package com.dimmdesign.ui
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UISimpleButton extends Sprite implements IDestroyable
	{
		
		protected var _normalStateImage:Bitmap;
		protected var _overStateImage:Bitmap;
		
		/**
		 * Creates a simple button with two states, roll over and roll out. 
		 * 
		 * 	<code>
		 * 			var overStateImage:Bitmap = new Bitmap(new BitmapData(100, 20, true, 0x000000));
		 *			var outStateImage:Bitmap = new Bitmap(new BitmapData(100, 20, true, 0xFF0000));
		 *			
		 * 			var tempButton:UISimpleButton = new UISimpleButton(overStateImage, outStateImage);
		 * 			addChild(tempButton);
		 * 
		 * 	</code>
		 * 
		 * @param normalStateImage
		 * @param overStateImage
		 * 
		 */		
		
		public function UISimpleButton(normalStateImage:Bitmap, overStateImage:Bitmap)
		{
			
			_normalStateImage = normalStateImage;
			if (overStateImage) _overStateImage = overStateImage;
			
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		protected function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			initButton ();
			
			if (_overStateImage) {
				addEventListener(MouseEvent.ROLL_OVER, _onRollOver); 
				addEventListener(MouseEvent.ROLL_OUT, _onRollOut); 
			}
		}
		
		protected function initButton ():void {
			
			_normalStateImage.alpha = 1;
			if (_overStateImage) _overStateImage.alpha = 0;
			
			addChild(_normalStateImage);
			if (_overStateImage) addChild(_overStateImage);
			
		}

		protected function _onRollOut(event:MouseEvent):void
		{
			setChildIndex(_normalStateImage, numChildren-1);
			
			TweenLite.killTweensOf( _normalStateImage );
			TweenLite.killTweensOf( _overStateImage );
			
			TweenLite.to(_normalStateImage, 0.35, {alpha:1, ease:Expo.easeOut});
			TweenLite.to(_overStateImage, 0.35, {alpha:0, delay:0.15, ease:Expo.easeOut});
			
		}

		protected function _onRollOver(event:MouseEvent):void
		{
			setChildIndex(_overStateImage, numChildren-1);
			
			TweenLite.killTweensOf( _normalStateImage );
			TweenLite.killTweensOf( _overStateImage );
			
			TweenLite.to(_normalStateImage, 0.35, {alpha:0, delay:0.15, ease:Expo.easeOut});
			TweenLite.to(_overStateImage, 0.35, {alpha:1, ease:Expo.easeOut});
		}
					
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, _onRollOver); 
			removeEventListener(MouseEvent.ROLL_OUT, _onRollOut); 
				
			TweenLite.killTweensOf( _normalStateImage );
			TweenLite.killTweensOf( _overStateImage );
			
			while (numChildren > 0) {
				var child:* = removeChildAt(0);
				if (child is Bitmap) child.bitmapData.dispose();
				child = null;
			}
				
			_normalStateImage = null;
			_overStateImage = null;
				
		}
	}
}