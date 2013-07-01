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
	import com.dimmdesign.managers.display.ImageLoaderManager;
	import com.dimmdesign.ui.UICircularLoader;
	import com.dimmdesign.utils.DisplayUtils;
	import com.dimmdesign.utils.TextUtils;
	import com.dimmdesign.utils.Web;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	public class FBFriend extends Sprite implements IDestroyable
	{
	
		private static const 
						NAME_TEXTFIELD_CSS:String = "p {font-size: 10; font-family: HelveticaBold; letter-spacing:-0.3; color: #000000;}",
		
						BACKGROUND_COLOUR:Number = 0xD0D0D0,
		 				THUMB_BACKGROUND_COLOUR:Number = 0xC8C8C8,
						
						WIDTH:Number = 145;
		
		private var 
				_width:Number,
				_height:Number,
				
				_uid:String,
				_friendName:String,
				
				_selected:Boolean,
				
				_bgShape:Shape,
				_imageLoader:Loader,
				_loaderAnimation:UICircularLoader,
				
				_thumbPicture:Bitmap,
				_thumbPictureBackground:Shape,
				_nameTextfield:TextField,
				
				_customContext:ContextMenu;
				
		
		public function FBFriend(uid:String, friendName:String, width:Number = 145, height:Number = 65)
		{
			super();

			_width = width;
			_height = height;
			// temp draw a background
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			_uid = uid;
			_friendName = friendName;
			
			mouseChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}


		/**
		 * True if the current object is selected. 
		 */		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void { _selected = value; _toggleSelection(_selected); }

		public function get friendName():String { return _friendName; } 
		
		public function get uid():String { return _uid; }

		
		private function _onAddedToStage(event:Event):void
		{
			if (!_uid) return;

			graphics.clear();
			
			// create the background
			_createBackground();
			
			// create the profile picture's background.
			_createProfilePictureBackground();
			
			// load image 
			_loadProfilePicture();
						
			// add the friend's name
			_nameTextfield = TextUtils.createTextField(NAME_TEXTFIELD_CSS, true, "none", "advanced", true, true);
			_nameTextfield.x = 63;
			_nameTextfield.y = 5;
			
			_nameTextfield.width = 80;
			_nameTextfield.height = 56;
			
			_nameTextfield.htmlText = "<p>" + _friendName + "</p>";
			
			addChild(_nameTextfield);
			
			// add mouse event listeners
			addEventListener(MouseEvent.ROLL_OVER, _onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			addEventListener(MouseEvent.CLICK, _onClick);
			
			// add custom context menu for each friend.
			_customContext = new ContextMenu();
			_customContext.hideBuiltInItems();
			var viewProfileItem:ContextMenuItem = new ContextMenuItem("View Profile...", false, true, true);
			viewProfileItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onMenuItemSelect);
			_customContext.customItems = [viewProfileItem];
			
			contextMenu = _customContext;
			
		}

		private function _onMenuItemSelect(event:ContextMenuEvent):void
		{
			if (event.target.caption == "View Profile...") {
				Web.getURL("http://www.facebook.com/" + _uid);
			}
		}

		private function _toggleSelection(value:Boolean):void {
			_selected = value;

			if (_selected) {
				TweenMax.to(_bgShape, 0.55, {tint:0xCCCCCC, alpha:1, ease:Expo.easeOut});
				
				removeEventListener(MouseEvent.ROLL_OVER, _onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			} else {
				TweenMax.to(_bgShape, 0.55, {tint:BACKGROUND_COLOUR, alpha:1, ease:Expo.easeOut});
				
				addEventListener(MouseEvent.ROLL_OVER, _onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			}
		}
		
		private function _onClick(event:MouseEvent):void
		{
			
			_toggleSelection( !_selected );
						
		}


		private function _onRollOut(event:MouseEvent):void
		{
			if (_selected) return; // if is selected skip the rest
			
			TweenMax.to(_bgShape, 0.55, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(_thumbPictureBackground, 0.55, {tint:0xC8C8C8, ease:Expo.easeOut});
		}

		private function _onRollOver(event:MouseEvent):void
		{
			if (_selected) return; // if is selected skip the rest
			
			TweenMax.to(_bgShape, 0.55, {alpha:1, ease:Expo.easeOut});
			TweenMax.to(_thumbPictureBackground, 0.55, {tint:0x000000, ease:Expo.easeOut});
		}
		
		/**
		 * Loads the profile picture from Facebook.
		 * Using the convenient method form Facebook api, getImageUrl().
		 */		
		private function _loadProfilePicture():void {
			
			var url:String = "https://graph.facebook.com/" + _uid + "/picture"; // Facebook.getImageUrl(_uid);
			
			ImageLoaderManager.loadImage(url, _onImageLoaderComplete);
			_createLoaderAnimation();
			
			return;
			
			var urlRequest:URLRequest = new URLRequest (url); 
			
			var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImageLoaderComplete);
			_imageLoader.contentLoaderInfo.addEventListener(Event.OPEN, _onImageLoaderOpen);
			
			_imageLoader.load(urlRequest, loaderContext);
			
			
			
		}

		private function _onImageLoaderOpen(event:Event):void
		{
			
			_imageLoader.contentLoaderInfo.removeEventListener(Event.OPEN, _onImageLoaderOpen);
						
		}


		private function _onImageLoaderComplete(content:Bitmap):void
		{
			var content:Bitmap = content;
			
			_thumbPicture = new Bitmap(content.bitmapData.clone(), "always", false);
			_thumbPicture.x = _thumbPicture.y = 8;
			_thumbPicture.alpha = 0;
			addChild(_thumbPicture);
			
			TweenLite.to(_thumbPicture, 0.55, {alpha:1, ease:Expo.easeOut});
			
			if (_loaderAnimation) {
				_loaderAnimation.destroy();
				removeChild(_loaderAnimation);
				_loaderAnimation = null;
			}
			
			content.bitmapData.dispose();
			content = null;
			_imageLoader = null;
		}

		private function _createBackground():void {
			if (_bgShape) return;
			
			_bgShape = new Shape();
			_bgShape.alpha = 0;
			_bgShape.graphics.beginFill(BACKGROUND_COLOUR, 1);
			_bgShape.graphics.drawRect(0, 0, _width, _height);
			_bgShape.graphics.endFill();
			
			addChild(_bgShape);
		}
		
		private function _createProfilePictureBackground ():void {
			
			if (_thumbPictureBackground) return;
			
			_thumbPictureBackground = new Shape();
			_thumbPictureBackground.x = _thumbPictureBackground.y = 5;
			_thumbPictureBackground.graphics.beginFill(THUMB_BACKGROUND_COLOUR, 1);
			_thumbPictureBackground.graphics.drawRect(0, 0, 56, 56);
			_thumbPictureBackground.graphics.endFill();
			
			addChild(_thumbPictureBackground);
			
		}
		
		private function _createLoaderAnimation():void
		{
			if (!_loaderAnimation) {
				_loaderAnimation = new UICircularLoader();
				addChild(_loaderAnimation);
		
				_loaderAnimation.alpha = 0;
				_loaderAnimation.scaleX = _loaderAnimation.scaleY = 0.6;
				_loaderAnimation.x = 32
				_loaderAnimation.y = _height >> 1;
		
				TweenLite.to(_loaderAnimation, 0.55, {alpha:1});
				
				_loaderAnimation.startAnimating();
			}
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, _onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			removeEventListener(MouseEvent.CLICK, _onClick);
			
			while(numChildren > 0) {
				var child:* = removeChildAt(0);
				while(child.numChildren > 0) {
					child.removeChildAt(0);
				}
				child = null;
			}
			
			_loaderAnimation = null;
			_thumbPicture = null;
			_thumbPictureBackground = null;
			_bgShape = null;
			_nameTextfield = null;
		}
	}
}