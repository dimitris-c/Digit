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
	import com.dimmdesign.utils.DrawUtils;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * OgilvyOne's classic circular preloader animation, converted from timeline animation to code.
	 * Default colour is black.
	 */	
	public class UICircularLoader extends Sprite implements IDestroyable
	{
		private var _colour:Number;
		
		private var _circularShapeHolder:Sprite;
		private var _solidCircleShape:Shape;
		private var _gradientCircleShape:Shape;
		
		private var _stepsCount:Number = 0;
		private var _step:Number = 15;
		
		public function UICircularLoader(colour:Number = 0x000000)
		{
			super();
			
			_colour = colour;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_configUI();
			
		}
		
		/**
		 * Starts the animation.
		 */		
		public function startAnimating():void {
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		/**
		 * Stops the animation.
		 */	
		public function stopAnimating():void {
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		/**
		 * @private methods 
		 */		
		
		private function _configUI():void {
			
			_circularShapeHolder = new Sprite();
						
			_solidCircleShape = new Shape();
			_solidCircleShape.graphics.beginFill(_colour, 1);
			DrawUtils.drawSolidArc(_solidCircleShape, 0, 0, 13, 20, 180, 180, 100);
			_solidCircleShape.graphics.endFill();
			
			_gradientCircleShape = new Shape();
			_gradientCircleShape.graphics.beginGradientFill(GradientType.LINEAR, [_colour, _colour], [1, 0], [120, 150]);
			DrawUtils.drawSolidArc(_gradientCircleShape, 0, 0, 13, 20, 181, -180, 100);
			_gradientCircleShape.graphics.endFill();
						
			_circularShapeHolder.addChild(_solidCircleShape);
			_circularShapeHolder.addChild(_gradientCircleShape);
			
			addChild(_circularShapeHolder);
			
		}
		
		private function _onEnterFrame(event:Event):void
		{
			if (_circularShapeHolder) { // sanity check
				if (_stepsCount >= 360) _stepsCount = 0;
				_circularShapeHolder.rotation = _stepsCount;
				_stepsCount = _stepsCount + _step;
			}
			else {
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
		}
				
		/**
		 * @inherited 
		 */		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			while(numChildren > 0) {
				var child:* = removeChildAt(0);
				while(child.numChildren > 0) {
					child.removeChildAt(0);
				}
				child = null;
			}
			
			_solidCircleShape = null;
			_gradientCircleShape = null;
			_circularShapeHolder = null;
		}
	}
}