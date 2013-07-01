package com.dimmdesign.pool
{
	

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class ObjectPool implements IObjectPool
	{

		private var _type:Class;
		
		private var _pool:Array;
		
		private var _currentSize:int;
		
		private var _count:int = 0;
		
		/**
		 * Simple object pool.
		 */		
		public function ObjectPool(type:Class)
		{
			_type = type;
		}
		
		public function initialize(size:int):void {
			
			_pool = [];
			_currentSize = _count = size;
			
			var i:int = _currentSize; 
			for (i = 0; i < _currentSize; i++)
				_pool[i] = new _type();
			
		}
		
		public function getItem():*
		{
			if (_count > 0)
				return _pool[--_count];
			
		}

		public function setItem(item:*):void
		{
			_pool[++_count] = item;
		}

		public function drain():void
		{
			_pool = null;
		}
	}

}

