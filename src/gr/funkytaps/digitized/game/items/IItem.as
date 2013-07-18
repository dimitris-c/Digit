package gr.funkytaps.digitized.game.items
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;

	public interface IItem
	{
		/**
		 * The bitmapData of the obstacle. Use this carefully
		 */		
		function get bitmapData():BitmapData;
		
		/**
		 * If <code>true</code> the obstacles only contains an Movieclip
		 * NOTE: Bothe @see isStatic and isAnimated can be <code>true</code>
		 */
		function get isAnimated():Boolean;
		
		/**
		 * If <code>true</code> the obstacles only contains an Image
		 *  NOTE: Bothe @see isAnimated and isStatic can be <code>true</code>
		 */		
		function get isStatic():Boolean;
		
		/**
		 * Returns a <code>String</code> representing the item's type.
		 * @see ItemTypes.
		 */		
		function get itemType():String;
		
		/**
		 * The speed of the obstacle.
		 */
		function get speed():Number;
		
		/**
		 * Return <code>true</code> of the item elements are created.
		 */
		function get created():Boolean;
		
		/**
		 * If <code>true</code> the obstacle has been destroyed
		 */		
		function get destroyed():Boolean;
		
		/**
		 *  Returns the score of the item that the hero should get. if any score.
		 */		
		function get score():Number;
		
		/**
		 * Creates the obstacle's elements. <br />
		 * Note: Call this function after you add the item to the display list.
		 */		
		function createItem():void;
		
		/**
		 * Returns itself as a DisplayObject. Useful fro adding interfaces to the display list. <br />
		 * <code> addChild(anInterfaceVariable.view()); </code> 
		 */		
		function view():DisplayObject;

		/**
		 * 
		 */		
		function get height():Number;
		
		function get width():Number;
		
		function get x():Number;
		
		function set x(value:Number):void;
		
		function get y():Number;
		
		function set y(value:Number):void;
		
		function get pivotX():Number;
		
		function set pivotX(value:Number):void;
		
		function get pivotY():Number;
		
		function set pivotY(value:Number):void;
		
		function get bounds():Rectangle;
		
		function get parent():DisplayObjectContainer;
		
		function addChild(child:DisplayObject):DisplayObject;
		
		function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle;
		
		function removeFromParent(dispose:Boolean=false):void;
		
		function toString():String;

	}
}