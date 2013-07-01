package com.dimmdesign.pool
{
	
	public interface IObjectPool
	{
	
		function initialize(size:int):void;

		function getItem():*;
		
		function setItem(item:*):void;
		
		function drain():void;
		
	}
}