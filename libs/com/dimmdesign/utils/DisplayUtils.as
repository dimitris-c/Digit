package com.dimmdesign.utils
{
	import com.dimmdesign.core.IDestroyable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	
	public class DisplayUtils
	{
		
		
		/**
		 * Removes all the children of the passed display object container.
		 * @param target The display object container to remove its children.
		 * @param recursive If true it will remove all children and grandchildren going.
		 * 
		 */		
		public static function removeAllChildren(target:*, recursive:Boolean = false, destroy:Boolean = false):void {

			if ((target is Loader) || !(target is DisplayObjectContainer))
				return;
			
			const targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;
		
			while(targetContainer.numChildren) {
				var c:* = targetContainer.removeChildAt(0);
				DisplayUtils.destroyChild(c, recursive, destroy);
				
			}
						
		}

		public static function destroyChild(target:*, recursive:Boolean = false, destroy:Boolean = false):* {

			if (destroy && (target is IDestroyable)) {
				const child:IDestroyable = target as IDestroyable;
				child.destroy();
			}
			
			if (recursive)
				DisplayUtils.removeAllChildren(target, recursive, destroy);
		}
		
		/**
		 * Creates a bitmap from the given source, eg. a sprite, movieclip, and returns the bitmap  
		 * @param source A IBitmapDrawable object, eg sprite.
		 * @param width The desired width for the bitmap
		 * @param height The desired height for the bitmap
		 * @return If successful it will return a new bitmap.
		 * 
		 */		
		public static function createBitmap (source:IBitmapDrawable, width:Number, height:Number, transparent:Boolean = true,  matrix:Matrix = null):Bitmap {
			var bitmapData:BitmapData = new BitmapData(width, height, transparent, 0);
			bitmapData.draw(source, ((matrix) ? matrix.clone() : null), null, null, null, true);
			
			var bitmap:Bitmap = new Bitmap(bitmapData.clone(), "never", true);
			bitmapData.dispose();
			bitmapData = null;
			return bitmap;
		}
		
		/**
		 * Tints the colour of the passed display object. 
		 * @param source The DisplayObject for the colour change
		 * @param colour The desired colour.
		 * 
		 */		
		public static function tintColour (source:DisplayObject, colour:uint):void {
			var colourTrans:ColorTransform = new ColorTransform();
			colourTrans.color = colour;
			source.transform.colorTransform = colourTrans;
		}
		
	}
}