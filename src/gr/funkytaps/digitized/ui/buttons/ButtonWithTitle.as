package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ButtonWithTitle extends BaseButton
	{
		protected var _title:Image;
		protected var _titleNormalState:Texture;
		protected var _titleDownState:Texture;
		
		protected var _titleNormalStateTextureWidth:Number;
		protected var _titleNormalStateTextureHeight:Number;
		
		protected var _titleDownStateTextureWidth:Number;
		protected var _titleDownStateTextureHeight:Number;
		
		public function ButtonWithTitle(normalState:Texture, titleNormalState:Texture, downState:Texture=null, titleDownState:Texture=null)
		{
			super(normalState, downState);
			
			_titleNormalState = titleNormalState;
			_titleDownState = titleDownState ? titleDownState : titleNormalState;
			
			_titleNormalStateTextureWidth = _titleNormalState.width;
			_titleNormalStateTextureHeight = _titleNormalState.height;
			
			_titleDownStateTextureWidth = _titleNormalState.width;
			_titleDownStateTextureHeight = _titleNormalState.height;
		}
		
		override protected function _onAddedToStage(event:Event):void {
			super._onAddedToStage(event);
			
			_title = new Image(_titleNormalState);
			_holder.addChild(_title);
			
			_title.x = ((_backgroundWidth >> 1) - (_title.width >> 1)) | 0;
			_title.y = ((_backgroundHeight  >> 1) - (_title.height >> 1) - 3) | 0;
			
		}
		
		override public function setNormalState():void {
			super.setNormalState();
			
			_title.texture = _titleNormalState;
			_title.readjustSize();
			
			_updateTitlePosition();
		}
		
		override public function setDownState():void {
			super.setDownState();
			
			_title.texture = _titleDownState;
			_title.readjustSize();
			
			_updateTitlePosition();
		}
		
		protected function _updateTitlePosition():void {
			
			_title.x = ((_backgroundWidth >> 1) - (_title.width >> 1));
			_title.y = ((_backgroundHeight >> 1) - (_title.height >> 1)) - 3;

		}
		
		override public function destroy():void {
			super.destroy();
			
			_title = null;
		}
	}
}