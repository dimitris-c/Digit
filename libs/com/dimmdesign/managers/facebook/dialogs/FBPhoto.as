package com.dimmdesign.managers.facebook.dialogs
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
	import com.dimmdesign.managers.display.LoaderRequest;
	import com.dimmdesign.managers.facebook.FBManager;
	import com.dimmdesign.ui.UICircularLoader;
	import com.dimmdesign.ui.UICircularPieLoader;
	import com.dimmdesign.utils.BitmapUtils;
	import com.dimmdesign.utils.DrawUtils;
	import com.dimmdesign.utils.Web;
	import com.facebook.graph.Facebook;
	import com.greensock.TweenLite;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class FBPhoto extends Sprite implements IDestroyable
	{
		private static const VIEW_ON_FB_LINK:String = 'https://www.facebook.com/photo.php?fbid=';
		private var _photoDetails:Object;
		
		private var _background:Shape;
		
		private var _width:Number;
		private var _height:Number;
		private var _backgroundColour:Number;
		
		private var _id:String;
		
		private var _from:Object;
		private var _photoName:String;
		
		private var _source:String;
		private var _picture:String;
		private var _images:Array;
		
		private var _imageLoader:Loader;
		
		private var _photoLoader:UICircularLoader;
		private var _photoHolder:Sprite;
		private var _photoImage:Bitmap;
		private var _resizedPhotoImage:Bitmap;
		
		private var _imageLoaderReq:LoaderRequest;
		
		private var _customContextMenu:ContextMenu;
		
		public function FBPhoto(id:String, width:Number = 180, height:Number = 120, backgroundColour:uint = 0x999999)
		{
			super();
			
			_id = id;
			_width = width;
			_height = height;
			_backgroundColour = backgroundColour;
			
			scrollRect = new Rectangle(0, 0, width, height);
			
			addEventListener(Event.ADDED_TO_STAGE,_onAddedToStage);
			
		}
		
		/**
		 * All the details of the photo.  
		 */
		public function get photoDetails():Object { return _photoDetails; }
		
		/**
		 * The id of the photo 
		 */		
		public function get id():String { return _id; }
		
		/**
		 * The from object has two parameters, <b>name</b> and <b>id</b>, and represents the publisher of the photo. 
		 */		
		public function get from():Object {	return _from; }

		/**
		 * The name of the photo. 
		 */
		public function get photoName():String { return _photoName; }

		/**
		 * The source of the photo. A url for the large size of the photo. 
		 */		
		public function get source():String { return _source; }

		/**
		 * The picture of the photo. A url for the thumbnail.
		 */
		public function get picture():String {	return _picture; }

		/**
		 * An array containing objects of the photo in different sizes.
		 * Each object of the array contains the following <b>width</b>, <b>height</b> and the <b>url</b> of the image.  
		 */		
		public function get images():Array { return _images; }
		

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_background = new Shape();			
			DrawUtils.drawRectangleShape(_background.graphics, 0, 0, _width, _height, _backgroundColour);
			addChild(_background);
			
			addEventListener(MouseEvent.ROLL_OVER, _onRollOverOutStates);
			addEventListener(MouseEvent.ROLL_OUT, _onRollOverOutStates);
			
			FBManager.accessToken = 'AAACEdEose0cBAOBp0VrX6FMH9pnJPZB4gGSZAy1ZAbwAZAphepFqVrPt2ZCWdSRAUzVDwSjAL1p9G3qtWcgv37cZAmgIjU2OsMZB9zuwP38ZCgZDZD';
			
			if (FBManager.accessToken) var params:Object ={}; params.access_token = FBManager.accessToken;
			
			Facebook.api(id, _onPhotoDataLoaded, params);
									
			_customContextMenu = new ContextMenu();
			_customContextMenu.hideBuiltInItems();
			var customItem:ContextMenuItem = new ContextMenuItem('View On Facebook...');
			customItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onMenuItemSelect);
			_customContextMenu.customItems = [customItem];
			
			contextMenu = _customContextMenu;
		}

		private function _onRollOverOutStates(event:MouseEvent):void
		{
			switch(event.type)
			{			
				case MouseEvent.ROLL_OVER:
				{
					TweenLite.to(_background, 0.35, {tint:0xCCCCCC});
					break;
				}
					
				case MouseEvent.ROLL_OUT:
				{
					TweenLite.to(_background, 0.35, {tint:_backgroundColour});
					break;
				}
			}
		}

		private function _onMenuItemSelect(event:ContextMenuEvent):void
		{
			var url:String = VIEW_ON_FB_LINK + _id;
			Web.getURL( url, '_blank' );
		}
		
		private function _onPhotoDataLoaded (success:Object, fail:Object):void {
			if (success) 
			{
				_photoDetails = success;
				_from = success.from;
				_photoName = success.name;
				_source = success.source;
				_picture = success.picture;
				_images = success.images;
				
				// add the loader animation
				_photoLoader = new UICircularLoader();
				_photoLoader.startAnimating();
				_photoLoader.scaleX = _photoLoader.scaleY = 0.5;
				_photoLoader.x = width >> 1;
				_photoLoader.y = height >> 1;
				addChild(_photoLoader);
				
				// load the image 				
				_imageLoaderReq = new LoaderRequest();
				_imageLoaderReq.loadRequest(_source, _handleImageLoaded);
			}
		}
				
		private function _handleImageLoaded (target:LoaderRequest):void {
			
			if (_photoLoader) {
				_photoLoader.destroy();
				removeChild(_photoLoader);
				_photoLoader = null;
			}
			
			var image:Bitmap = target.content as Bitmap;
			
//			_photoImage = BitmapUtils.getCloneBitmap(image);

			_photoHolder = new Sprite();
			addChild(_photoHolder);
			
			_resizedPhotoImage = BitmapUtils.getCloneBitmap(image);
			_photoHolder.addChild(_resizedPhotoImage);
			
			var afa:AutoFitArea = new AutoFitArea(_photoHolder, 5, 5, _width-10, _height-10);
			afa.attach(_resizedPhotoImage, {scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, vAlign:'center', hAlign:'center', crop:true});
			
			image.bitmapData.dispose();
			image = null;
			
		}
		
		public function destroy():void
		{
			if (_imageLoaderReq) _imageLoaderReq.closeRequest(false);
			
			while (numChildren > 0) {
				var child:* = removeChildAt(0);
				if (child is IDestroyable) child.destroy();
				if (child is Bitmap) child.bitmapData.dispose();
				child = null;
			}
			
			_imageLoaderReq = null;
			_photoImage = null;
			_photoDetails = null;
			_from = null;
			_photoName = null;
			_source = null;
			_picture = null;
			_images = null;
		}
	}
}