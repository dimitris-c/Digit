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
	
	import com.adobe.serialization.json.JSON;
	import com.dimmdesign.core.IDestroyable;
	import com.dimmdesign.managers.data.DataLoaderManager;
	import com.dimmdesign.managers.facebook.FBManager;
	import com.dimmdesign.ui.UICircularLoader;
	import com.dimmdesign.ui.UIDropDownMenu;
	import com.dimmdesign.ui.UIScroller;
	import com.dimmdesign.utils.DrawUtils;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class FBPhotosDialog extends Sprite implements IDestroyable
	{
		
		private static var BACKGROUND_COLOUR:uint = 0xEEEEEE;
		private static var BACKGROUND_OUTLINE_STROKE:uint = 0xCCCCCC;
		
		private static var CACHED_IMAGES:Dictionary;
		
		private var _width:Number,
					_height:Number,
					_useCache:Boolean = false,
					
					_headerHolder:Sprite,
					_headerBackground:Shape,
					_headerDropdownMenu:Sprite,
					
					_loader:UICircularLoader,
					
					_dropDownMenu:UIDropDownMenu,
					
					_contentHolder:Sprite,
					_photosHolder:Sprite,				
					_photosHolderMask:Sprite,
					
					_scrollBarHolder:Sprite,
					_scrollBar:UIScroller,
					_scrollerHandle:Sprite,
					_scrollerTrack:Sprite,
					
					_currentAlbumID:String,
					_currentAlbumArray:Vector.<FBPhoto>,
					
					_imagesArray:Array,
					_albumsArray:Array;
					
		
		public function FBPhotosDialog(width:Number = 620, height:Number = 300, useCache:Boolean = false)
		{
			super();
			_width = width;
			_height = height;
			_useCache = useCache;
			
			DrawUtils.drawRectangleShape(graphics, 0, 0, _width, _height, BACKGROUND_COLOUR);
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			TweenPlugin.activate([TintPlugin]);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			if (_useCache) {
				CACHED_IMAGES = new Dictionary();
			}
			
			_contentHolder = new Sprite();
			_contentHolder.x = 10;
			_contentHolder.y = 45;
			addChild(_contentHolder);
			
			_headerHolder = new Sprite();
			addChild(_headerHolder);
			
			_currentAlbumID = 'allphotos';
			
			_togglePreloader();
			
			// get user photos and albums
			//FBManager.getAlbums( _handleGetAlbumsComplete );
			
			DataLoaderManager.loadData('albums.json', _handleAlbumsComplete);
			
			DataLoaderManager.loadData('photos.json', _handlePhotosComplete);
			
//			FBManager.getPhotos( '0', _handleGetPhotosComplete );
			
			
		}
		
		private function _updatePhotos (photosId:String):void {
			
			if (CACHED_IMAGES[photosId] == null) return;
			
			var chachedImagesVector:Vector.<FBPhoto> = CACHED_IMAGES[photosId] as Vector.<FBPhoto>;
			
			var fbFriendWidth:Number = 110;
			var maxColumns:Number = Math.floor(_width / fbFriendWidth);
			var col:Number = 0;
			var row:Number = 0;
			var xSpacing:Number = 0;
			var ySpacing:Number = 0;
			var xPadding:Number = 10;
			var yPadding:Number = 10;
			var len:uint = chachedImagesVector.length;
			
			var photosArray:Vector.<FBPhoto> = new Vector.<FBPhoto>;
			
			for (var i:int = 0; i < len; i++) 
			{
				var photo:FBPhoto = chachedImagesVector[i];
				_photosHolder.addChild(photo);
				
				row = (i % maxColumns);
				col = Math.floor(i / maxColumns);
				
				photo.x = Math.round ( row * ( xSpacing + xPadding ) );
				photo.y = Math.round ( col * ( ySpacing + yPadding ) );
				
				xSpacing = photo.width;
				ySpacing = photo.height;				
			}
			
			_scrollBar.resetScroller();
			
		}
		
		private function _clearPreviousPhotos ():void {
			if (!_photosHolder) return;
			
			if (_photosHolder.numChildren > 0) 
			{
				while (_photosHolder.numChildren > 0) 
				{
					var child:* = _photosHolder.removeChildAt(0);
					if (!_useCache) {
						if (child is IDestroyable) child.destroy();
					}
					child = null;
				}
			}
		}
		
		private function _createPhotos (photosId:String):void {
			
			if (_imagesArray.length == 0) return;
			
			_togglePreloader();
			
			if (!_photosHolder) {
				_photosHolder = new Sprite();
				_contentHolder.addChild(_photosHolder);
			}
			
			if (!_photosHolderMask) {
				_photosHolderMask = new Sprite();
				DrawUtils.drawRectangleShape(_photosHolderMask.graphics, 0, 0, _width, _height - 55);
				_contentHolder.addChild(_photosHolderMask);
				
				_photosHolder.mask = _photosHolderMask;
			}
			
			var fbFriendWidth:Number = 110;
			var maxColumns:Number = Math.floor(_width / fbFriendWidth);
			var col:Number = 0;
			var row:Number = 0;
			var xSpacing:Number = 0;
			var ySpacing:Number = 0;
			var xPadding:Number = 7;
			var yPadding:Number = 7;
			var len:Number = _imagesArray.length;
			
			var photosArray:Vector.<FBPhoto> = new Vector.<FBPhoto>;
			
			for (var i:int = 0; i < len; i++) 
			{
				var id:String = _imagesArray[i].id;
								
				var photo:FBPhoto = new FBPhoto( id, 110, 80 );
				_photosHolder.addChild(photo);
				
				row = (i % maxColumns);
				col = Math.floor(i / maxColumns);
				
				photo.x = Math.round ( row * ( xSpacing + xPadding ) );
				photo.y = Math.round ( col * ( ySpacing + yPadding ) );
				
				xSpacing = photo.width;
				ySpacing = photo.height;
				
				photosArray.push( photo );
			}
			
			if (_useCache) CACHED_IMAGES[photosId] = photosArray;
			
			if (_scrollBarHolder) {
				_scrollBar.resetScroller();
			} else {
				_buildScroller();
			}
						
		}
		
		private function _handlePhotosComplete(success:*):void {
			
			
			var json:Object = JSON.decode(success);
			_imagesArray = [];
			_imagesArray = json.data as Array;
			_createPhotos('allphotos');
			
		}
		
		private function _handleGetPhotosComplete (success:Object, fail:Object):void {
			if (success) {
				_imagesArray = [];
				_imagesArray = success as Array;
				_createPhotos('allphotos');
			}
		}
		
		private function _handleAlbumsComplete (success:*):void {
			
			var json:Object = JSON.decode(success);
			var albumsObj:Array = json.data as Array;
			_parseAlbumsObject( albumsObj );
		}
		
		private function _handleGetAlbumsComplete (success:Object, fail:Object):void {
			if (success) {
				_parseAlbumsObject( success );
			}
			else {
			}
		}
		
		private function _parseAlbumsObject(object:Object):void {
			var i:int = 0;
			var l:int = object.length;
			
			_albumsArray = [];
			_albumsArray.push({name:"Photos of you", id:"allphotos"});
			
			for (i = 0; i < l; i++) 
			{
				var childObj:Object = object[i];
				_albumsArray.push( childObj );
			}
			
			_createDropDownMenu();
			
		}

		private function _createDropDownMenu():void
		{
			// create the dropDownMenu 
			if (!_dropDownMenu) {
				_dropDownMenu = new UIDropDownMenu(_albumsArray, 'Διάλεξε Album', _handleDropDownItemSelection, 180, 25);
				_dropDownMenu.x = _width - 180;
				_dropDownMenu.y = 0;
				_headerHolder.addChild(_dropDownMenu);
			}
		}
		
		private function _handleDropDownItemSelection (name:String, id:String):void {
			
			if (_currentAlbumID == id) return; // don't load the same album
			
			_currentAlbumID = id;
			
			_togglePreloader();
			
			_clearPreviousPhotos();
			
			if (_useCache) {
				if (CACHED_IMAGES[ _currentAlbumID ] != null) {
					_updatePhotos( _currentAlbumID );
					return;
				}
			}
			
			if (_currentAlbumID == 'allphotos') {
				FBManager.getPhotos( '0', '0', _handleGetPhotosComplete );
				return;
			}
			
			// load album photos then create the photos...
			FBManager.getAlbumPhotos( _currentAlbumID, _handleGetAlbumPhotosComplete);
			
		}
		
		private function _handleGetAlbumPhotosComplete (success:Object, fail:Object):void {
			
			if (success) {
				_imagesArray = [];
				_imagesArray = success as Array;
				
				_createPhotos( _currentAlbumID );
			}
			
		}
		
		private function _buildScroller ():void {
			
			if (_scrollBarHolder) return; // add the scrollbar once.
			
			_scrollBarHolder = new Sprite();
			_scrollBarHolder.x = _width - 25;
			_contentHolder.addChild(_scrollBarHolder);
			
			_scrollerTrack = new Sprite();
			DrawUtils.drawRectangleShape(_scrollerTrack.graphics, 0, 0, 8, _height-55, 0x999999);
			_scrollBarHolder.addChild(_scrollerTrack);
			
			_scrollerHandle = new Sprite();
			DrawUtils.drawRectangleShape(_scrollerHandle.graphics, 0, 0, 8, 20, 0xCCCCCC);
			_scrollBarHolder.addChild(_scrollerHandle);
			
			_scrollerHandle.y = _scrollerTrack.y;
			
			_scrollBar = new UIScroller(_photosHolder, _photosHolderMask, _scrollerHandle, _scrollerTrack, stage);
			_scrollBar.initScroller();
			
		}
		
		private function _togglePreloader():void 
		{
			if (!_loader) {
				_loader = new UICircularLoader();
				_loader.x = _width >> 1;
				_loader.y = _height >> 1;
				_loader.startAnimating();
				_contentHolder.addChild(_loader);
			}
			else {
				_loader.visible = !_loader.visible;
				if (_loader.visible) {
					_loader.startAnimating();
				} else {
					_loader.stopAnimating();
				}
			}
		}
		
		public function destroy():void
		{
			
			while(numChildren > 0) {
				var child:* = removeChildAt(0);
				if (child is IDestroyable) child.destroy();
				if (child.numChildren>0){
					while (child.numChildren>0) {
						var grandchild:* = child.removeChildAt(0);
						if (grandchild is IDestroyable) grandchild.destroy();
						grandchild = null;
					}
				}
				child = null;
			}
			
			_headerHolder = null;
			_headerBackground = null;
			_headerDropdownMenu = null;
			_loader = null;
			_dropDownMenu = null;
			_contentHolder = null;
			_photosHolder = null;				
			_photosHolderMask = null;
			_scrollBarHolder = null;
			_scrollBar = null;
			_scrollerHandle = null;
			_scrollerTrack = null;
			_currentAlbumID = null;
			_currentAlbumArray = null;
			_imagesArray = null;
			_albumsArray = null;
			
		}
	}
}