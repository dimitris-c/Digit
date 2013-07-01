package com.dimmdesign.utils
{
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class ObjectUtils
	{
		
		/**
		 * Checks to see if the specified elements exists in the object. 
		 * @param obj The object to be tested
		 * @param element The element to be checked
		 * @return True if the element is found, otherwise false.
		 * 
		 */		
		public static function contains (obj:Object, element:String):Boolean {
			if ( !ObjectUtils.isEmpty(obj) ) {
				for (var prop:String in obj)
					if (obj[prop] == element)
						return true;
			}
			return false;
		}

		/**
		 * Checks to see if the object is empty. 
		 * @param obj The object to be tested
		 * @return True is the object is empty, otherwise false.
		 * 
		 */		
		public static function isEmpty (obj:Object):Boolean {
			
			if (obj === null || obj == {}) return true;
					
			return false;
			
		}
		
		/**
		 * Clones an object.
		 * @param obj An object to be cloned
		 * @return The newly cloned object.
		 * 
		 */		
		public static function clones (obj:Object):Object {
			var bytearray:ByteArray = new ByteArray();
			bytearray.writeObject(obj);
			bytearray.position = 0;
			
			return bytearray.readObject();
		}
		
		/**
		 * Clones an object.
		 * @param obj An object to be cloned
		 * @return The newly cloned object.
		 * 
		 */		
		public static function cloneDictionary(dictionary:Dictionary):Dictionary {
			var clone:Dictionary = new Dictionary();
			for (var keyValue:* in dictionary) {
				var value:* = dictionary[keyValue];
				var key:* = keyValue;
				clone[key] = value;
			}
			return clone;
		}
		
		
		/**
		 * Deletes an element at the specified object 
		 * @param $obj An object to be used
		 * @param $element The elemenent to be deleted
		 * @return True of the element deleted, otherwise false.
		 * 
		 */		
		public static function deleteSingleElement (obj:Object, element:String):Boolean {
			var _success:Boolean = false;
			
			if ( !ObjectUtils.isEmpty(obj) ) {
				if ( ObjectUtils.contains(obj, element) ) {
					obj[element] = null;
					delete obj[element];
					_success = true;
				}
			}
			
			return _success;
		}
		
		/**
		 * 
		 * @param $obj The object you want to delete elements from
		 * @param parameters A comma delimeter parameters to be passed on the object for deletion, if a parameter is not found the object it will be skipped
		 * @return The new object with the deleted element
		 * 
		 */		
		public static function deleteElements (obj:Object, ...parameters):Object {
			
			if ( !ObjectUtils.isEmpty(obj) ) {
				for (var s:String in parameters) {
					if ( ObjectUtils.contains(obj, parameters[s]) ) {
						obj[parameters[s]] = null;
						delete obj[parameters[s]];
					} else {
						trace ("parameter,", parameters[s], "was skipped as it couldn't be found on the object");
					}
				}
			}
			
			return obj;
		}
		
		/**
		 * Returns the length of an associative array or object similar function to Array.length 
		 * 
		 * @param $obj An object to be used.
		 * @return uint If the object doesn't include any elements it will return -1.
		 * 
		 */
		public static function getLength(obj:Object):int {
			var length:int = 0;
			if ( !ObjectUtils.isEmpty(obj) ) {
				for (var s:String in obj) {
					length++;
				}
			}
			return length;
		}
	}
}