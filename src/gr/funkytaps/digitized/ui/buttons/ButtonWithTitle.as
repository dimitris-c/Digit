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
	
		public function ButtonWithTitle(normalState:Texture, titleNormalState:Texture, downState:Texture=null, titleDownState:Texture=null)
		{
			super(normalState, downState);
			
			_titleNormalState = titleNormalState;
			_titleDownState = titleDownState ? titleDownState : titleNormalState;
			
		}
		
		override protected function _onAddedToStage(event:Event):void {
			super._onAddedToStage(event);
			
			_title = new Image(_titleNormalState);
			_holder.addChild(_title);
			
			_title.x = ((_backgroundWidth >> 1) - (_title.width >> 1)) | 0;
			_title.y = ((_backgroundHeight  >> 1) - (_title.height >> 1) - 5) | 0;
			
		}
		
		override protected function _setNormalState():void {
			super._setNormalState();
			
			_title.texture = _titleNormalState;
		}
		
		override protected function _setDownState():void {
			super._setDownState();
			
			_title.texture = _titleDownState;
		}
		
		override public function destroy():void {
			super.destroy();
			
			_holder.removeFromParent(true);
			_title = null;
		}
	}
}