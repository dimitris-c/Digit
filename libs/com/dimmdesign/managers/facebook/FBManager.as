package com.dimmdesign.managers.facebook
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import com.dimmdesign.managers.facebook.vo.FacebookPostObject;
	import com.dimmdesign.utils.DrawUtils;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.controls.Distractor;
	import com.facebook.graph.core.FacebookLimits;
	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.BatchItem;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.net.FacebookBatchRequest;
	
	import flash.events.EventDispatcher;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	/**
	 * A manager/wrapper for common methods for Facebook API — Depends on Facebook API. 
	 * 
	 */	
	public class FBManager extends EventDispatcher
	{
		private static var _instance:FBManager;
		private static var _allowInstantiation:Boolean;
		
		/**
		 * The application's id; 
		 */		
		private static var _appID:String;
		
		/**
		 * A boolean indicating whether Facebook has been initialzed or not. 
		 */		
		public static var fbInitialized:Boolean = false;
		
		/**
		 * A boolean indicating whether the user has logged-in to the application or not.
		 */		
		public static var fbLoggedIn:Boolean = false;
		
		/**
		 * An object containing the users' details. Need to call getUserDetails() method first.
		 */		
		public static var userDetails:Object;
				
		/**
		 * An object containing the users's friends. Need to call getFriends() method first. 
		 */		
		public static var userFriends:Array;
		
		/**
		 * An Array with the permissions that the user has approved for the application.
		 */		
		public static var userPermissions:Array = [];
		
		/**
		 * If you define an active accessToken, it will be passed to every call, extremely useful if you're working locally.
		 * You can get an accessToken from <b>Facebook Graph API Explorer, https://developers.facebook.com/tools/explorer</b> 
		 */		
		public static var accessToken:String; 
		
		/** 
		 * Callbacks 
		 **/
		
		private var _callbackDictionary:Dictionary;
		
		private var _onInitCallback:Function = null;
		private var _onLoginCallback:Function = null;
		private var _onUserDetailsCallback:Function = null;
		private var _onGetPhotosCallback:Function = null;
		private var _onGetAlbumsCallback:Function = null;
		private var _onGetAlbumPhotosCallback:Function = null;
		private var _onGetPhotoDetailsCallback:Function = null;
		private var _onGetFriendsCallback:Function = null;
		private var _onPostToFacebookCallback:Function = null;
		private var _onPostToFriendWallCallback:Function = null;
		private var _onOpenDialogCallback:Function = null;
		private var _onGetLikesCallback:Function = null;
		private var _checkPermissionsCallback:Function = null;
		
		// etc not implemented
		private var _hasPostOnQueue:Boolean = false;
		public var _postParams:FacebookPostObject = null;
		
		
		public function FBManager() {
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use FBManager.getInstance() instead of new.");
			}
		}
		/**
		 * Returns the current appID used by the application. 
		 */		
		public static function get appID():String { return _appID; }

		public static function getInstance():FBManager {
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new FBManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/** 
		 * Initializes the application with Facebook.
		 * 
		 * @param appID - The application id.
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 * @param cookie - Optional - Boolean true to enable cookie support. Default, false.
		 * @param logging - Optional - Boolean false to disable logging. Default, true.
		 * @param status - Optional - Boolean true to fetch fresh status. Default, true.
		 * @param channelUrl - Optional - String, Specifies the URL of a custom URL channel file. This file must contain a single script element pointing to the JavaScript SDK URL. Default, null.
		 * 
		 */
		public static function initFacebook (appID:String, callback:Function, cookie:Boolean = false, logging:Boolean = true, status:Boolean = true, channelUrl:String = null):void {
			getInstance()._initFacebook(appID, callback, cookie, logging, status, channelUrl);
			
		}
		/**
		 * Login to facebook. 
		 * 
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 * @param perms - An object with the preferred permissions.
		 * 
		 */
		public static function loginFacebook (callback:Function, perms:Object = null):void {
			getInstance()._loginFacebook(callback, perms);
		}
		
		/**
		 * Post a status update to the user's feed.
		 * 
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 * @param params - The parameters for the desired post.
		 * 
		 */
		public static function postToFacebook (callback:Function, params:Object):void {
			getInstance()._postToFacebook(callback, params);
		}
		
		/**
		 * 
		 * @param callback
		 * @param params
		 * 
		 */		
		public static function postImageToFacebook (callback:Function, params:Object, id:String = null):void {
			getInstance()._postImageToFacebook(callback, params, id);
		}
		
		/**
		 * Post a status update to the desired friend's feed.
		 * 
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 * @param friendID - A string containing the friend id
		 * @param params - An object with the post paramaters.
		 * 
		 */	
		public static function postToFriendWall (callback:Function, friendID:String, params:FacebookPostObject):void {
			getInstance()._postToFriendWall(callback, friendID, params);
		}
		
		/**
		 * Loads the user's details. 
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 */		
		public static function getUserDetails(callback:Function = null):void {
			getInstance()._getUserDetails('/me', callback);
		}
		
		public static function getLikes(callback:Function):void {
			getInstance()._getLikes(callback);
		}
		
		public static function getDetailsFromUID(uid:String, callback:Function):void {
			getInstance()._getUserDetails(uid, callback);
		}
		
		/**
		 * Loads the user's friends. 
		 * @param callback - A function that will be called, it must have the signature of callback(success:Object, fail:Object); 
		 */
		public static function getFriends(callback:Function):void {
			getInstance()._getFriends(callback);			
		}
		
		/**
		 * Gets the users' photos 
		 * @param callback
		 */		
		public static function getPhotos(uid:String, limit:String, callback:Function):void {
			getInstance()._getPhotos(uid, limit, callback);
		}
		
		public static function getPhotoDetails(id:String, callback:Function):void {
			getInstance()._getPhotoDetails(id, callback);
		}
		
		/**
		 * Gets the users' photos albums 
		 * @param callback
		 */	
		public static function getAlbums(uid:String, callback:Function):void {
			getInstance()._getAlbums(uid, callback);
		}
		
		public static function getAlbumPhotos(albumId:String, callback:Function):void {
			getInstance()._getAlbumPhotos(albumId, callback);
		}
		
		/**
		 * Opens a desired dialog.
		 * @param type - The Dialog type. eg. FacebookDialogs.FEED.
		 * @param data - The data object for the dialog.
		 * @param display - (Optional) The display type of the dialog (iframe or popup);
		 * 
		 */		
		public static function openDialog (type:String, callback:Function, data:Object, display:String = null):void {
			getInstance()._openDialog(type, callback, data, display);
		}
		
		/**
		 * Creates a distractor. Does not add it the stage. 
		 * 
		 * <p>Example usage:<br />
		 * <code>
		 * 		var distractor:Distractor = FBManager.createDistractor();
		 * 		addChild(distractor);
		 * </code>
		 * </p>
		 * @param scaleRatio - The scale ratio.
		 * @param $text - An optional text.
		 * @return A distractor object.
		 * 
		 */
		public static function createDistractor (scaleRatio:Number = 1, text:String = ""):Distractor {
			return getInstance()._createDistractor(scaleRatio, text);
		}
		
		/**
		 * @private 
		 */		
			
		private function _initFacebook (appID:String, callback:Function, cookie:Boolean = false, logging:Boolean = true, status:Boolean = true, channelUrl:String = null):void {
			_appID = appID;
			
			_onInitCallback = callback;
			
//			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			Security.loadPolicyFile("https://fbcdn-sphotos-a-a.akamaihd.net/crossdomain.xml");
			
			_callbackDictionary = new Dictionary();
			
			if (!fbInitialized) {
				var options:Object = {};
				options.cookie = cookie;
				options.logging = logging;
				options.status = status;
				options.channelUrl = channelUrl;
				
				Facebook.init(appID, _handleFacebookInit, options);
			}
		}
		
				
		private function _loginFacebook (callback:Function, perms:Object = null):void {
			if (!fbInitialized) {
				_onLoginCallback = callback;
				Facebook.login(_handleFacebookLogin, perms);
			} else {
				// already logged in
				trace("already logged in");
			}
		}
				
				
		private function _postToFacebook (callback:Function, params:Object):void {
						
			_onPostToFacebookCallback = callback;
			
			if (accessToken != null) params.access_token = accessToken;
			
			Facebook.api("/me/feed", _onPostToFacebook, params, 'POST');
			
		}
		
		private function _postImageToFacebook (callback:Function, params:Object, id:String = null):void {
			
			_onPostToFacebookCallback = callback;
//			if (accessToken != null) params.access_token = accessToken;
			if (id != null) {
				Facebook.api( '/' + id + "/photos", _onPostToFacebook, params, 'POST');
			} else {
				Facebook.api( "/me/photos", _onPostToFacebook, params, 'POST');
			}
		}
		
		
		private function _postToFriendWall (callback:Function, friendID:String, params:FacebookPostObject):void {
			
			_onPostToFacebookCallback = callback;
			_postParams = params;
			
			if (accessToken != null) params.access_token = accessToken;

			Facebook.api(friendID + "/feed", _onPostToFacebook, params, 'POST');
			
		}
		
		public function _postToManyFriendsWall (callback:Function, uids:Array, params:FacebookPostObject):void {
			
			if (uids.length > FacebookLimits.BATCH_REQUESTS) return;
			
			_onPostToFacebookCallback = callback;
			
			var batch:Batch = new Batch();
			
			for (var i:uint = 0; i < uids.length; i++){
				batch.add( uids[i] + '/feed', _onPostToFacebook, params, 'POST');
			}
			
			Facebook.batchRequest(batch, _onPostToFacebook);
			
		}
		
		public static function checkPermissions(callback:Function):void {
			getInstance()._checkPermissions(callback);
		}
			
		private function _getUserDetails(uid:String = '/me', callback:Function = null):void {
			
			_onUserDetailsCallback = callback;
			
			var params:Object;
			if (accessToken != null) {
				params = {};
				params.access_token = accessToken;
			}
			
			Facebook.api(uid, _onUserDetails, params);
		}
		
		private function _getPhotos(uid:String, limit:String, callback:Function):void {
			_onGetPhotosCallback = callback;
			
			var params:Object = {};
			params.limit = limit;
			
			if (accessToken != null) {
				params.access_token = accessToken;
			}
			
			Facebook.api("/" + uid + "/photos", _onPhotosCallback, params);
			
		}
		
		private function _getLikes(callback:Function):void {
			_onGetLikesCallback = callback;
			
			if (accessToken != null) {
				var params:Object = {};
				params.access_token = accessToken;
			}
			
			Facebook.api('/me/likes', _onGetLikesCallback, params);	
			
		}
		
		private function _getPhotoDetails(id:String, callback:Function):void {
			_onGetPhotoDetailsCallback = callback;
			
			if (accessToken != null) {
				var params:Object = {};
				params.access_token = accessToken;
			}
			
			Facebook.api(id, _onPhotosDetailsCallback, params);
		}
		
		private function _getAlbums(uid:String, callback:Function):void {
			_onGetAlbumsCallback = callback;
			
			if (accessToken != null) {
				var params:Object = {};
				params.access_token = accessToken;
			}
			
			Facebook.api("/" + uid + "/albums", _onPhotoAlbumsCallback, params);
		}
		
		private function _getAlbumPhotos(albumId:String, callback:Function):void {
			_onGetAlbumPhotosCallback = callback;
			
			if (accessToken != null) {
				var params:Object = {};
				params.access_token = accessToken;
			}
			
			Facebook.api("/" + albumId + "/photos", _onAlbumPhotosComplete, params);
		}
	
		private function _getFriends(callback:Function):void {
			
			_onGetFriendsCallback = callback;
			
			if (accessToken != null) {
				var params:Object = {};
				params.access_token = accessToken;
			}
			
			Facebook.api("/me/friends", _handleFriendsRequestRespose, params);
			
		}
		
				
		private function _openDialog (type:String, callback:Function, data:Object, display:String = null):void {
			
			_onOpenDialogCallback = callback;
			
			Facebook.ui(type, data, _onDialogCallback, display);
			
		}
		
		private function _createDistractor (scaleRatio:Number = 1, text:String = ""):Distractor {
			
			var distractor:Distractor = new Distractor();
			distractor.text = text;
			distractor.mouseEnabled = false;
			distractor.mouseChildren = false;
			distractor.scaleX = distractor.scaleY = scaleRatio;
			
			return distractor;
		}
		
		/**
		 * Event handling 
		 */		
		private function _handleFacebookInit (success:Object, fail:Object):void {
			if (success) {	
				fbInitialized = true;
			} else {
				fbInitialized = false;
			}
			if (_onInitCallback != null) {
				_onInitCallback(success, fail);
				_onInitCallback = null;
			}
			
		}
		
		
		private function _handleFacebookLogin (success:Object, fail:Object):void {
			if (success) {
				fbLoggedIn = true;
			} else {
				fbLoggedIn = false;
			}
			
			if (_onLoginCallback != null) {
				_onLoginCallback(success, fail);
				_onLoginCallback = null;
			}
			
		}
				
		private function _onPostToFacebook (success:Object, fail:Object):void {
			
			if (success) {
				trace ("posted to facebook");
				if (_onPostToFacebookCallback != null) {
					_onPostToFacebookCallback(success, fail);
					_onPostToFacebookCallback = null;
				}
			} else {
				
			}
			
		}
		
		
		private function _onDialogCallback (success:Object):void 
		{
			if (_onOpenDialogCallback != null) {
				_onOpenDialogCallback(success);
				_onOpenDialogCallback = null;
			}
		}
		
		
		private function _checkPermissions(callback:Function):void {
			_checkPermissionsCallback = callback;
			Facebook.api("/me/permissions", _onCheckPermissionsCallBack);
			
		}
		
		
		private function _onCheckPermissionsCallBack (success:Object, fail:Object):void {
						
			if (success) {
				FBManager.userPermissions = success.data;
				if (_checkPermissionsCallback != null) {
					_checkPermissionsCallback(FBManager.userPermissions);
				}
			} else {
				
			}
			
		}
		
		private function _onPhotosDetailsCallback(success:Object, fail:Object):void {
			
			if (_onGetPhotoDetailsCallback != null)  {
				_onGetPhotoDetailsCallback(success, fail);
				_onGetPhotoDetailsCallback = null;
			}
			
		}
		
		private function _onPhotosCallback(success:Object, fail:Object):void {
			
			if (_onGetPhotosCallback != null)  {
				_onGetPhotosCallback(success, fail);
				_onGetPhotosCallback = null;
			}
			
		}
		
		private function _onAlbumPhotosComplete (success:Object, fail:Object):void {
			
			if (_onGetAlbumPhotosCallback != null) {
				_onGetAlbumPhotosCallback(success, fail);
				_onGetAlbumPhotosCallback = null;
			}
		}
		
		private function _onPhotoAlbumsCallback(success:Object, fail:Object):void {
			
			if (_onGetAlbumsCallback != null)  {
				_onGetAlbumsCallback(success, fail);
				_onGetAlbumsCallback = null;
			}
			
		}
		
		private function  _onUserDetails(success:Object, fail:Object):void {
			var response:Object = success;
			userDetails = response;
			
			if (_onUserDetailsCallback != null) {
				_onUserDetailsCallback(success, fail);
//				_onUserDetailsCallback = null;
			}
			
		}
		
		private function _handleFriendsRequestRespose(success:Object, fail:Object):void {
			
			if (success) {
				userFriends = success as Array;
			}
			
			if (_onGetFriendsCallback != null) {
				_onGetFriendsCallback(success, fail);
				_onGetFriendsCallback = null;
			}
			
		}
				
	}
}