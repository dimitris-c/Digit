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
	import com.dimmdesign.utils.StringUtils;
	import com.dimmdesign.utils.TextUtils;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
		
	public class UIDropDownMenu extends Sprite implements IDestroyable
	{
		protected static const TEXT_WHITE_SHADOW:DropShadowFilter = new DropShadowFilter(1, 45, 0xFFFFFF, 1, 1, 1, 3, 1);
		protected static const DROP_DOWN_SHADOW:DropShadowFilter = new DropShadowFilter(1, 90, 0x999999, 0.7, 1,1,3,3);
			
		protected static const SELECTED_COLOUR:uint = 0x999999;
		protected static const GRADIENT_COLOURS:Array =  [0xE9E9E9, 0xFFFFFF];
		protected static const GRADIENT_MATRIX:Matrix = new Matrix();
		
		protected static const DEG_2_RAD:Number = Math.PI / 2;
		
		protected static var STYLESHEET:String = 	'.selected-item {font-size: 12; font-family: HelveticaBold; color: #383838;}' +
												 	'.single-item { font-size: 12; font-family: Helvetica; color: #333333; }';
		
						

		protected var 	_width:Number,
						_height:Number,
					
						_menuItems:Array,
						_dropDownMenuItemsArray:Array,
					
						_dropDownItemsBackground:Shape,
						_dropDownItemsHolder:Sprite,
						_dropDownMenuItem:UIDropDownMenuItem,
						
						_dropDownItemsMask:Sprite,
						
						_openedHeight:Number,
						_maskHeight:Number,
						
						_visibleItems:Number = 10,
					
						_dropDownArrow:Shape,
						_dropDownFaceBackground:Sprite,
						
						_activeItemName:String,
						_activeItemTextField:TextField,
						_activeItem:UIDropDownMenuItem,
						
						_scroller:UIScroller,
						_scrollerHolder:Sprite,
						_scrollHandle:Sprite,
						_scrollTrack:Sprite,
					
						_onSelectedCallback:Function = null,
					
						_isSelected:Boolean = false;
		/**
		 * Creates drop down menu with the specified items.
		 * 
		 * @param menuItems: An array containing the items for the menu. Each item on the array must be an object and contain a Name and an ID.
		 * @param defaultItemName: A string defining the default title.
		 * @param onSelectItemCallback: A function that will be called when an item is selected. The handler must has two parameters callback(name:String, id:String);
		 * @param width: A number defining the width of the menu.
		 * @param height: A number defining the height of the menu.
		 *
		 * @example The following create a drop drown menu with three items.
		 * <listing version="3.0">  
		 *		var items:Array = [ {name:'Greece', id:'gr'}, {name:'United Kingdom', id:'uk'},	{name:'United States of America', id:'usa'} ]
		 *  	var dropDown:UIDropDownMenu = new UIDropDownMenu (items, 'Select a country', _handleItemSelection, 160, 25);
		 *		addChild(dropDown);
		 *		function _handleItemSelection(name:String, id:String):void {
		 *			trace ('Selected item is:', name, 'with id:', id);
		 *		}
		 *	</listing>
		 *  
		 */			
		public function UIDropDownMenu(menuItems:Array, defaultItemName:String, onSelectItemCallback:Function, width:Number, height:Number)
		{
			super();
			
			_menuItems = menuItems;
			_activeItemName = defaultItemName;
			_onSelectedCallback = onSelectItemCallback;
			_width = width;
			_height = height;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		public function get visibleItems():Number { return _visibleItems; }
		
		public function set visibleItems(value:Number):void { _visibleItems = value; }
		
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			GRADIENT_MATRIX.createGradientBox(_width, _height, - DEG_2_RAD, 0, 0);
			
			_isSelected = false;
			
			_drawDropDownMenuFace();
			
			_createArrow();
			
			_populateItems();
			
			_activeItemTextField = TextUtils.createTextField(STYLESHEET, true, 'left', 'advanced');
			_activeItemTextField.htmlText = "<span class='selected-item'>" + _activeItemName + "</span>";
			_activeItemTextField.x = 5;
			_activeItemTextField.y = ((_height * 0.5) - (_activeItemTextField.height * 0.5) + 1 ) | 0.5;
			addChild(_activeItemTextField);
			
			_dropDownFaceBackground.addEventListener(MouseEvent.CLICK, _onDropDownBackgroundClick);
			
		}

		private function _onDropDownBackgroundClick(event:MouseEvent):void
		{
			_toggleDropDownSelected ();
		}
		
		private function _toggleDropDownSelected ():void {
			
			_isSelected = !_isSelected;
						
			_toggleVisibilityMenuItems();
			
			_drawDropDownMenuFace();
			
		}
		
		private function _drawDropDownMenuFace ():void {
			if (!_dropDownFaceBackground) {
				_dropDownFaceBackground = new Sprite();
				addChild(_dropDownFaceBackground);
			}
			
			var graphics:Graphics = _dropDownFaceBackground.graphics;
			graphics.clear();
			
			if (_isSelected) {
				graphics.lineStyle(1, 0x999999);
				DrawUtils.drawRectangleShape(graphics, 0, 0, _width, _height, 0xEAEAEA, 1);
				return;
			}
			
			graphics.lineStyle(1, 0x999999, 1, true);
			graphics.beginGradientFill(GradientType.LINEAR, GRADIENT_COLOURS, [1, 1], [0,255], GRADIENT_MATRIX);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		private function _toggleVisibilityMenuItems():void {		
			var i:uint = 0;
			var l:uint = _menuItems.length;
			
			_dropDownItemsHolder.visible = _isSelected;
			
			_dropDownItemsBackground.visible = _isSelected;

			if (_scrollerHolder) _scrollerHolder.visible = _isSelected;
			
			for (i = 0; i < _menuItems.length; i++){
				_dropDownMenuItemsArray[i].visible = _isSelected;
				if (_isSelected) 
					_dropDownMenuItemsArray[i].alpha = 0;
					TweenLite.to(_dropDownMenuItemsArray[i], 0.55, {alpha:1, delay:i * 0.015, ease:Expo.easeOut});
			}
		}
		
		private function _populateItems ():void {
			
			var prevY:Number = 5;
			var padding:Number = 2;
			var i:uint = 0;
			var l:int = _menuItems.length;
			_openedHeight = _height;
			_maskHeight = 0;
			
			_dropDownMenuItemsArray = [];
			
			_dropDownItemsBackground = new Shape();
			_dropDownItemsBackground.visible = false;
			_dropDownItemsBackground.y = _height;
			addChild(_dropDownItemsBackground);
			
			
			_dropDownItemsHolder = new Sprite();
			_dropDownItemsHolder.visible = false;
			_dropDownItemsHolder.y = _height;
			addChild(_dropDownItemsHolder);
			
			_dropDownItemsMask = new Sprite();
			_dropDownItemsMask.y = _height;
			addChild(_dropDownItemsMask);
			
			_dropDownItemsHolder.mask = _dropDownItemsMask;
			
			for (i = 0; i < _menuItems.length; i++) {
				
				var name:String = _menuItems[i].name;
				var id:String = _menuItems[i].id;

				_dropDownMenuItem = new UIDropDownMenuItem(name, id, STYLESHEET, _width, 20);
				_dropDownMenuItem.visible = true;
				_dropDownMenuItem.alpha = 0;
				_dropDownMenuItem.addEventListener(MouseEvent.CLICK, _onMenuItemClick);
				
				_dropDownItemsHolder.addChild(_dropDownMenuItem);
				
				_dropDownMenuItem.x = 1;
				_dropDownMenuItem.y = prevY | 0.5;
				prevY = prevY + (_dropDownMenuItem.height + padding);
				
				if (i == _visibleItems) _maskHeight = _dropDownItemsHolder.height;
				
				_dropDownMenuItemsArray.push( _dropDownMenuItem );
			}
			
			_openedHeight = _dropDownItemsHolder.height + 8 + padding;
			
			
			if (_menuItems.length > _visibleItems) {
				DrawUtils.drawRectangleShape(_dropDownItemsMask.graphics, 0, 0, _width, _maskHeight, 0xFFFFFF, 1);
				
				_dropDownItemsBackground.graphics.lineStyle(1, 0x999999, 1, true);
				DrawUtils.drawRectangleShape(_dropDownItemsBackground.graphics, 0, 0, _width, _maskHeight, 0xFFFFFF, 1);
				_dropDownItemsBackground.graphics.endFill();
				
				_createScroller();
//				scrollRect = new Rectangle(0, 0, _width, _maskHeight+2);
				return;
			}
			else {
				DrawUtils.drawRectangleShape(_dropDownItemsMask.graphics, 0, 0, _width, _openedHeight, 0xFFFFFF, 1);
			}
			
			_dropDownItemsBackground.graphics.lineStyle(1, 0x999999, 1, true);
			DrawUtils.drawRectangleShape(_dropDownItemsBackground.graphics, 0, 0, _width, _openedHeight, 0xFFFFFF, 1);
			_dropDownItemsBackground.graphics.endFill();
			
			// update the scrollRect
//			scrollRect = new Rectangle(0, 0, _width, _openedHeight+2);
		}

		private function _onMenuItemClick(event:MouseEvent):void
		{
			_toggleDropDownSelected();
			
			var item:UIDropDownMenuItem = event.target as UIDropDownMenuItem;
			var name:String = item.itemName;
			var id:String = item.itemID;
			
			if (_activeItemTextField) {
				_activeItemTextField.htmlText = "<span class='selected-item'>" + StringUtils.truncateString(name, 21, '...') + "</span>";
			}
		
			if (_onSelectedCallback != null) {
				_onSelectedCallback(name, id);
			}
		}
		
		private function _createArrow ():void {
			if (_dropDownArrow) return;
			_dropDownArrow = new Shape();
			
			_dropDownArrow.graphics.beginFill(0x999999);
			DrawUtils.drawShape(_dropDownArrow.graphics, [new Point(0, 0), new Point(12, 0), new Point(0, 12), new Point(6, 6)]);
			_dropDownArrow.graphics.endFill();
			
			addChild(_dropDownArrow);

			_dropDownArrow.x = _width - 20;
			_dropDownArrow.y = ((_height * 0.5) - (_dropDownArrow.height * 0.5)+5) | 0.5;
			
		}
		
		private function _createScroller():void {
			
			var mainContentHeight:Number = _openedHeight;
			
			if (_scrollerHolder) return;
			
			_scrollerHolder = new Sprite();
			_scrollerHolder.visible = false;
			_scrollerHolder.x = _width - 15;
			_scrollerHolder.y = 5;
			addChild(_scrollerHolder);
			
			_scrollTrack = new Sprite();
			_scrollTrack.graphics.beginFill(0xCCCCCC, 1);
			_scrollTrack.graphics.drawRect(0, 0, 8, _maskHeight-10);
			_scrollTrack.graphics.endFill();
			_scrollTrack.y = _height;
			
			_scrollHandle = new Sprite();
			_scrollHandle.graphics.beginFill(0x999999, 1);
			_scrollHandle.graphics.drawRect(0, 0, 8, 40);
			_scrollHandle.graphics.endFill();
			
			_scrollHandle.y = _scrollTrack.y;
			
			_scrollerHolder.addChild(_scrollTrack);
			_scrollerHolder.addChild(_scrollHandle);
			
			_scroller = new UIScroller(_dropDownItemsHolder, _dropDownItemsMask, _scrollHandle, _scrollTrack, stage);
			_scroller.initScroller();
			
		}

		public function destroy():void
		{
			while(this.numChildren){
				var child:* = removeChildAt(0);
				if (child is IDestroyable) child.destroy();
				child = null;
			}
			
			_menuItems = null;
			_onSelectedCallback = null
			_dropDownMenuItemsArray = null;
			
			_dropDownItemsHolder = null;
			_dropDownMenuItem = null;
			
			_dropDownArrow = null;
			_dropDownFaceBackground = null;
			
			_activeItemName = null;
			_activeItemTextField = null;
		}
		
	}
	
}

import com.dimmdesign.core.IDestroyable;
import com.dimmdesign.utils.DrawUtils;
import com.dimmdesign.utils.StringUtils;
import com.dimmdesign.utils.TextUtils;
import com.greensock.TweenLite;
import com.greensock.easing.Expo;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

/**
 * Internal Class for the UIDropDownMenuItem 
 */	
internal class UIDropDownMenuItem extends Sprite implements IDestroyable {
	
	private var _width:Number,
				_height:Number,
				_itemName:String,
				_itemID:String,
			
				_shapeBackground:Shape,
				_itemNameTextField:TextField,
			
				_itemData:Object,
				_stylesheet:String;
			
	
	public function UIDropDownMenuItem (itemName:String, itemID:String, stylesheet:String, width:Number, height:Number) {
		super();
		_itemName = itemName;
		_itemID = itemID;
		_width = width;
		_height = height;
		_stylesheet = stylesheet;
		addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
	}
	

	public function get itemName():String {	return _itemName; }

	public function get itemID():String	{ return _itemID; }

	private function _onAddedToStage(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		
		_shapeBackground = new Shape();
		_shapeBackground.alpha = 0;
		DrawUtils.drawRectangleShape(_shapeBackground.graphics, 0, 0, _width-1, _height, 0xEEEEEE, 1);
		addChild(_shapeBackground);
		
		_itemNameTextField = TextUtils.createTextField(_stylesheet, true, 'left', 'advanced');
		var _truncatedItemName:String = StringUtils.truncateString(_itemName, 21, '...');
		_itemNameTextField.htmlText = '<span class="single-item">' + _truncatedItemName + '</span>';
		_itemNameTextField.x = 5;
		_itemNameTextField.y = ((_height * 0.5) - (_itemNameTextField.height * 0.5)) | 0.5;
		addChild(_itemNameTextField);
		
		addEventListener(MouseEvent.ROLL_OVER, _onRollOverOut);
		addEventListener(MouseEvent.ROLL_OUT, _onRollOverOut);
		
	}	

	private function _onRollOverOut(event:MouseEvent):void
	{
		switch(event.type)
		{
			case MouseEvent.ROLL_OUT:
			{
				TweenLite.to(_shapeBackground, 0.45, {alpha:0, ease:Expo.easeOut});
				break;
			}
				
			case MouseEvent.ROLL_OVER:
			{
				TweenLite.to(_shapeBackground, 0.45, {alpha:1, ease:Expo.easeOut});
				break;
			}
		}
	}
	
	public function destroy():void
	{
		while(this.numChildren>0){
			var child:* = removeChildAt(0);
			child = null;
		}
		
		_shapeBackground = null;
		_itemNameTextField = null;
	}
}

