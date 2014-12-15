package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.core.Assets;
	
	public class BackButton extends BaseButton
	{
		
		public function BackButton()
		{
			super(
				Assets.manager.getTexture('back-button-normal'),
				Assets.manager.getTexture('back-button-hover')
			)
			
			_padding = 15;
			
		}
				
	}
}

