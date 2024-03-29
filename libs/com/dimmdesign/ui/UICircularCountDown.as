package com.dimmdesign.ui
{
	import com.dimmdesign.core.IDestroyable;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class UICircularCountDown extends Sprite implements IDestroyable
	{
		public static const COUNTDOWN_COMPLETED:String = "countDownCompleted";
		
		private var _pi:Number = Math.PI;
		
		private var _mainCircle:Sprite;
		private var _circle:Shape;
		private var _circleFill:Shape;
		
		private var _radius:Number = 35;
		private var _backgroundColour:Number = 0xCCCCCC;
		private var _backgroundAlpha:Number = 1;
		private var _circleFillColour:Number = 0x000000;
		
		private var _degree:Number = 0;
		private var _degreeChange:Number = 1;
		
		private var _countdownTime:Number = 10;
		
		private var _isRunning:Boolean = false;
		
		private var _currentPercent:Number;
		
		/**
		 * A circular countdown timer. 
		 * @param countdownTime The amount of time that the countdown should be completed. In seconds.
		 * @param circleRadius The radius of the circle to be drawn.
		 * @param backgroundColour The colour for the background circle shape. Default is light grey.
		 * @param fillColour The colour of the circular shape that indicates the percent of the countdown. Default is black.
		 */		
		public function UICircularCountDown(countdownTime:Number, circleRadius:Number, backgroundColour:Number = 0xCCCCCC, fillColour:Number = 0x000000)
		{
			super();
			
			_countdownTime = countdownTime;
			_radius = circleRadius;
			_backgroundColour = backgroundColour;
			_circleFillColour = fillColour;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		
		/**
		 * The current state of the countdown. True if the countdown is active otherwise is false.
		 */
		public function get isRunning():Boolean
		{
			return _isRunning;
		}

		/**
		 * The time for the circular countdown to be completed, in seconds.  
		 * 
		 */		
		public function get countdownTime():Number
		{
			return _countdownTime;
		}
		
		/**
		 * The time for the circular countdown to be completed, in seconds.
		 * @param value A number in seconds that represents the time of the countdown.
		 */
		public function set countdownTime(value:Number):void
		{
			_countdownTime = value;
			if (stage) { // check if the stage exists, the degree change is calculated based on the frameRate of the swf.
				// calculate the degree change based on the countdownTime.
				_degreeChange = 360 / stage.frameRate / _countdownTime;
			}
		}
		
		/**
		 * Starts the countdown, if is not running.
		 */		
		public function start ():void {
			
			if (!_isRunning) {
				_isRunning = true;
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
			
		}
		
		/**
		 * Stops the countdown, if is running.
		 */		
		public function stop ():void {
			
			if (_isRunning) {
				_isRunning = false;
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
			
		}
		
		/**
		 * Stops the countdown, if is running, and clear its graphics.
		 */		
		public function reset ():void {
			
			if (_isRunning) {
				_degree = 0;
				_updateCircularFill(0);
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
			
		}
		
		/**
		 * @private  
		 */		
		private function _onAddedToStage(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_degreeChange = 360 / stage.frameRate / _countdownTime;
			
			_createCircularCountDown();
			
		}
		
		private function _onEnterFrame(event:Event):void
		{
			_degree = _degree + _degreeChange;

			if (_degree > 360 ) {	
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
				_isRunning = false;
				_updateCircularFill( 360 );
				return;
			}
			
			_updateCircularFill( _degree );
		}
		
		
		private function _createCircularCountDown ():void {
			
			_mainCircle = new Sprite();
			
			_circle = new Shape();
			_circle.graphics.beginFill(_backgroundColour, _backgroundAlpha);
			_circle.graphics.drawCircle(0,1,_radius);
			_circle.graphics.endFill();
			_circle.x = 0;
			_circle.y = 0;
			
			_circleFill = new Shape();
			_circleFill.graphics.moveTo(0,0);
			_circleFill.graphics.lineTo(_radius,0);
			_circleFill.x = 0;
			_circleFill.y = 1;
			
			addChild(_mainCircle);
			_mainCircle.addChild(_circle);
			_mainCircle.addChild(_circleFill);
			
		}
		
		
		private function _updateCircularFill(t:Number):void {	
			// var radianAngle:Number = t * _pi / 180;
			var i:int;

			_circleFill.graphics.clear();
			_circleFill.graphics.moveTo(0,0);
			_circleFill.graphics.beginFill(_circleFillColour, 1);
			
			t = t | 0.5;
			
			for (i=0; i<=t; ++i) {
				var x:Number = (_radius) * Math.sin( i * _pi / 180 );
				var y:Number = -(_radius) * Math.cos( i * _pi / 180 );
				_circleFill.graphics.lineTo( x , y );
			}
			
			_circleFill.graphics.lineTo(0,0);
			_circleFill.graphics.endFill();
		}
		
		
		public function destroy():void
		{
			while (numChildren > 0 ) {
				var child:* = removeChildAt(0);
				if (child.numChildren > 0) {
					while (child.numChildren > 0) {
						child.removeChildAt(0);
					}
				}
				child = null;
			}
			
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			_circleFill = null;
			_circle = null;
			_mainCircle = null;
		}
	}
}