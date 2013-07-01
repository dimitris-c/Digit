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
	import com.dimmdesign.managers.facebook.FBManager;
	import com.dimmdesign.ui.UIScroller;
	import com.dimmdesign.utils.StringUtils;
	import com.dimmdesign.utils.TextUtils;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class FBFriendsDialog extends Sprite implements IDestroyable
	{
		
		private static const
						HEADER_COLOUR:Number = 0xDBDBDB,
						MAIN_CONTENT_COLOUR:Number = 0xF1F1F1,
						MAIN_CONTENT_BORDER_COLOUR:Number = 0xA9A9A9,
						FOOTER_COLOUR:Number = 0xDBDBDB,
						SCROLLER_TRACK_COLOUR:Number = 0xDBDBDB,
						SCROLLER_HANDLE_COLOUR:Number = 0x999999,
						
						SEARCH_TEXTFIELD_CSS:String = ".title {font-size: 11; font-family: VerdanaBold; letter-spacing:-0.2; color: #676767;}"+
													  ".input {font-size: 11; font-family: Verdana; letter-spacing:-0.1; color: #000000;}",
						SEARCH_TITLE:String = "Εύρεση Φίλων:",
						INPUT_DEFAULD_TITLE:String = "Όνομα Φίλου",
						
						SCROLLER_WIDTH:Number = 6,
						
						HEADER_HEIGHT:Number = 35,
						FOOTER_HEIGHT:Number = 35,
						RADIUS:Number = 5;
		
		private var 
					_width:Number,
					_height:Number,
					
					_headerBackground:Shape,
					_headerSearchHolder:Sprite,
					_searchTitle:TextField,
					_searchInputTextfield:TextField,
					
					_mainContentHolder:Sprite,
					_mainContentBackground:Shape,
					_mainContentBorder:Shape,
					
					_footerBackground:Shape,
					
					_friendsListMainHolder:Sprite,
					_friendsListContent:Sprite,
					_friendsListMask:Sprite,
					_friendsSearchableArray:Array,
					_friendsPointArray:Array,
					_friendsArray:Array,
					
					_scroller:UIScroller,
					_scrollerHolder:Sprite,
					_scrollHandle:Sprite,
					_scrollTrack:Sprite;
					
		
		/**
		 * Creates a popup dialog that displays the users' friends.
		 *  
		 * @param width
		 * @param height
		 * 
		 */		
		public function FBFriendsDialog (width:Number = 620, height:Number = 300)
		{
			super();
						
			_width = width;
			_height = height;
			
			if (!FBManager.userFriends) {
				// load the friends' user
				FBManager.getFriends(_onFbFriendsLoaded);
				
				// continue building the dialog.
				_friendsArray = FBManager.userFriends;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}


		private function _onAddedToStage(event:Event):void
		{
			
			_createHeader();
			
			_createMainContent();
			
			_createFooter();
			
		}
		
		private function _populateFriendsList ():void {
			
			if (!_friendsArray) return;
			
			var fbFriendWidth:Number = 145;
			var maxColumns:Number = (_width / fbFriendWidth) | 0.5;
			var col:Number = 0;
			var row:Number = 0;
			var xSpacing:Number = 0;
			var ySpacing:Number = 0;
			var xPadding:Number = 5;
			var yPadding:Number = 5;
			var len:Number = _friendsArray.length;
			
			_friendsSearchableArray = [];
			_friendsPointArray = [];
			
			_friendsListMainHolder = new Sprite();
			_friendsListMainHolder.scrollRect = new Rectangle(0, HEADER_HEIGHT, _width, _height - HEADER_HEIGHT - FOOTER_HEIGHT );
			_friendsListMainHolder.y = HEADER_HEIGHT;
			addChild(_friendsListMainHolder);
			
			_friendsListContent = new Sprite();
			_friendsListContent.x = 5;
			_friendsListContent.y = HEADER_HEIGHT + 5;
			
			_friendsListMask = new Sprite();
			_friendsListMask.y = HEADER_HEIGHT;
			_friendsListMask.graphics.beginFill(0, 1);
			_friendsListMask.graphics.drawRect(0, 0, _width, _height - HEADER_HEIGHT - FOOTER_HEIGHT);
			_friendsListMask.graphics.endFill();
			
			_friendsListContent.mask = _friendsListMask;
			
			for (var i:int = 0; i < len; i++) 
			{
				var friend:FBFriend = new FBFriend(_friendsArray[i].id, _friendsArray[i].name);
				_friendsListContent.addChild(friend);
				
				row = (i % maxColumns);
				col = Math.floor(i / maxColumns);
				
				friend.x = Math.round ( row * ( xSpacing + xPadding ) );
				friend.y = Math.round ( col * ( ySpacing + yPadding ) );
				
				xSpacing = friend.width;
				ySpacing = friend.height;
				
				_friendsSearchableArray[i] = {friendName:friend.friendName, sprite:friend};
				_friendsPointArray[i] = {x:friend.x, y:friend.y};
				
			}
			
			_friendsListMainHolder.addChild(_friendsListMask);
			_friendsListMainHolder.addChild(_friendsListContent);
			
			_createScroller();
			
		}
		
		private function _createHeader():void {
			
			_headerBackground = new Shape();
			_headerBackground.graphics.beginFill(HEADER_COLOUR, 1);
			_headerBackground.graphics.drawRoundRectComplex(0, 0, _width, HEADER_HEIGHT, RADIUS, RADIUS, 0, 0);
			_headerBackground.graphics.endFill();
			
			addChild(_headerBackground);
			
			_headerSearchHolder = new Sprite();
			
			_searchTitle = TextUtils.createTextField(SEARCH_TEXTFIELD_CSS, true, "left", "advanced");
			_searchTitle.y = 4;
			_searchTitle.htmlText = "<span class='title'>" + SEARCH_TITLE + "</span>";
			
			_headerSearchHolder.addChild(_searchTitle);
			
			var inputTextfieldBackground:Shape = TextUtils.createInputBackground(_searchTitle.x + _searchTitle.width + 5, 0, 225, 25, 0xFFFFFF);
			
			_headerSearchHolder.addChild(inputTextfieldBackground);
			
			_searchInputTextfield = TextUtils.createInputTextfield(SEARCH_TEXTFIELD_CSS, ".input", false);
			_searchInputTextfield.htmlText = INPUT_DEFAULD_TITLE;
			_searchInputTextfield.x = _searchTitle.x + _searchTitle.width + 10;
			_searchInputTextfield.y = 3;
			_searchInputTextfield.width = 220;
			_searchInputTextfield.height = 20;
			
			_searchInputTextfield.addEventListener(FocusEvent.FOCUS_IN, _onFocusInOut);
			_searchInputTextfield.addEventListener(FocusEvent.FOCUS_OUT, _onFocusInOut);
			
			_searchInputTextfield.addEventListener(Event.CHANGE, _onTextInputChange);
						
			_headerSearchHolder.addChild(_searchInputTextfield);
						
			_headerSearchHolder.x = _headerBackground.width - _headerSearchHolder.width - 5;
			_headerSearchHolder.y = 5;
			addChild(_headerSearchHolder);
			
		}
		
		private function _onTextInputChange(event:Event):void
		{
			var currentSearch:String = _searchInputTextfield.text;
			
			// fuzzy matching
			var input:String = currentSearch.split('').join('\\w*').replace(/\W/, "");
			
			_onAutoCompleteSearch( input );
			
		}
		
		private function _onAutoCompleteSearch (currentSearch:String):void {
			
			var regExp:RegExp = new RegExp(currentSearch, "gi");
			var counter:int = 0;
			
			if (_friendsSearchableArray) {
				var l:Number = _friendsSearchableArray.length;
				for (var i:int = 0; i < l; ++i) 
				{
					if (currentSearch != "") {
						// searches each friendName against the regular expression and returns an array of the matches.
						var arr:Array = String(_friendsSearchableArray[i].friendName).match(regExp);
							if (arr.length > 0) {
								_friendsSearchableArray[i].sprite.x = _friendsPointArray[counter].x;
								_friendsSearchableArray[i].sprite.y = _friendsPointArray[counter].y;
								_friendsSearchableArray[i].sprite.visible = true;
								counter++;
							}
							else {
								// moves any unmatched sprites to the top of the holder in order for the height to be changed.
								_friendsSearchableArray[i].sprite.x = 0;
								_friendsSearchableArray[i].sprite.y = 0;
								_friendsSearchableArray[i].sprite.visible = false;
							}
						
					} else {
						_friendsSearchableArray[i].sprite.x = _friendsPointArray[i].x;
						_friendsSearchableArray[i].sprite.y = _friendsPointArray[i].y;
						_friendsSearchableArray[i].sprite.visible = true;
					}
				}
				
				// update the scroller by resetting it.
				_scroller.resetScroller();
			}
			
		}
		
		private function _createMainContent():void {
			
			var mainContentHeight:Number = _height - HEADER_HEIGHT - FOOTER_HEIGHT;
			
			_mainContentHolder = new Sprite();
			
			_mainContentBorder = new Shape();
			_mainContentBorder.graphics.beginFill(MAIN_CONTENT_BORDER_COLOUR, 1);
			_mainContentBorder.graphics.drawRect(0, 0, _width, mainContentHeight);
			_mainContentBorder.graphics.endFill();
			
			_mainContentHolder.addChild(_mainContentBorder);
			
			_mainContentBackground = new Shape();
			_mainContentBackground.graphics.beginFill(MAIN_CONTENT_COLOUR, 1);
			_mainContentBackground.graphics.drawRect(0, 1, _width, mainContentHeight-2);
			_mainContentBackground.graphics.endFill();
			
			_mainContentHolder.addChild(_mainContentBackground);
			
			_mainContentHolder.y = HEADER_HEIGHT;
			
			addChild(_mainContentHolder);
			
		}
		
		private function _createFooter():void {
			
			_footerBackground = new Shape();
			_footerBackground.graphics.beginFill(FOOTER_COLOUR, 1);
			_footerBackground.graphics.drawRoundRectComplex(0, 0, _width, FOOTER_HEIGHT, 0, 0, RADIUS, RADIUS);
			_footerBackground.graphics.endFill();
			
			_footerBackground.y = _height - _footerBackground.height;
			
			addChild(_footerBackground);
			
			// TODO: create the buttons.
		}
		
		private function _createScroller():void {
			
			var mainContentHeight:Number = _height - HEADER_HEIGHT - FOOTER_HEIGHT;
			
			_scrollerHolder = new Sprite();
			_scrollerHolder.x = _width - 10;
			addChild(_scrollerHolder);
			
			_scrollTrack = new Sprite();
			_scrollTrack.graphics.beginFill(SCROLLER_TRACK_COLOUR, 1);
			_scrollTrack.graphics.drawRect(0, 0, SCROLLER_WIDTH, mainContentHeight-10);
			_scrollTrack.graphics.endFill();
			_scrollTrack.y = HEADER_HEIGHT + 5;
			
			_scrollHandle = new Sprite();
			_scrollHandle.graphics.beginFill(SCROLLER_HANDLE_COLOUR, 1);
			_scrollHandle.graphics.drawRect(0, 0, SCROLLER_WIDTH, 40);
			_scrollHandle.graphics.endFill();
			
			_scrollHandle.y = _scrollTrack.y;
			
			_scrollerHolder.addChild(_scrollTrack);
			_scrollerHolder.addChild(_scrollHandle);
			
			_scroller = new UIScroller(_friendsListContent, _friendsListMask, _scrollHandle, _scrollTrack, stage);
			_scroller.initScroller();
			
		}
		
		/**
		 * Events handling 
		 */		
		
		private function _onFocusInOut(event:FocusEvent):void
		{
			if (_searchInputTextfield.text == INPUT_DEFAULD_TITLE) {
				_searchInputTextfield.text = "";
			} else if (_searchInputTextfield.text == "") {
				_searchInputTextfield.text = INPUT_DEFAULD_TITLE;
			}
		}
		
		private function _onFbFriendsLoaded(success:Object, fail:Object):void
		{
			if (success) {
				_friendsArray = [];
				_friendsArray = success as Array;
				
				_populateFriendsList();
			}
		}
		
		
		// implemented method from IDestroyable...
		public function destroy():void
		{
			while(numChildren > 0) {
				var child:* = removeChildAt(0);
				if (child is Sprite || child is MovieClip) {
					while(child.numChildren > 0) {
						child.removeChildAt(0);
					}
				}
				child = null;
			}
		}
	}
}