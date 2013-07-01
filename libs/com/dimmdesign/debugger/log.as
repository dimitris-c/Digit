package com.dimmdesign.debugger
{

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	/**
	 * Logs a message to the console;
	 */	
	
	public function log(...values):void
	{
		if (logEnabled) 
			Trace.log(values);
	}
	
}