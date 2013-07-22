package gr.funkytaps.digitized.game.items
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import gr.funkytaps.digitized.interfaces.IUpdateable;
	
	import starling.display.DisplayObject;
	import starling.display.MovieClip;

	public interface IItem extends IUpdateable
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
		 * Returns a number that defines the custom radius of the item for the collision detection 
		 */		
		function get collisionRadius():Number;
		
		/**
		 * Returns the item's width. Use this instead of the width property. 
		 */		
		function get itemWidth():Number;
		
		/**
		 * Returns the item's height. Use this instead of the height property. 
		 */
		function get itemHeight():Number;
		
		/**
		 * Returns the item's id. 
		 */		
		function get itemID():int;
		
		function set itemID(value:int):void;
		
		/**
		 * Returns the animated property of the item, use this in case you need this movieclip to juggler.  
		 */		
		function get itemAnimated():MovieClip;
		
		/**
		 * Initializes the item before. Call createItem to add the item to the stage.
		 * @param isAnimated - If <code>true</code> the item has a movieclip and will be animated.
		 * @param isStatic - If <code>true</code> the item has an image.
		 * @param itemType - The type of the item.
		 * @param itemScore - The score of the item.
		 * 
		 */		
		function initItem(isAnimated:Boolean, isStatic:Boolean, itemType:String, itemScore:Number, itemSpeed:Number, radius:Number):void;
		
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
		 * Destroys the contents of the item. 
		 */		
		function destroy():void;
		
		/**
		 * Call this with caution. Use the itemWidth instead but after you have called the createItem method. 
		 */		
		function get height():Number;
		
		/**
		 * Call this with caution. Use the itemWidth instead but after you have called the createItem method. 
		 */		
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
		
		function set alpha(value:Number):void;
		
		function get alpha():Number;
		
		function addChild(child:DisplayObject):DisplayObject;
		
		function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle;
		
		function removeFromParent(dispose:Boolean=false):void;
		
		function toString():String;

	}
}