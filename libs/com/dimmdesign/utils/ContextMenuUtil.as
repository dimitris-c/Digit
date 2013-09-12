package com.dimmdesign.utils
{
	import flash.ui.ContextMenu;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class ContextMenuUtil
	{
		public function ContextMenuUtil()
		{
		}
		
		public static function getContextMenu(hideBuildInItems:Boolean = true):ContextMenu {
			var c:ContextMenu = new ContextMenu();
			c.hideBuiltInItems();
			return c;
		}
	}
}