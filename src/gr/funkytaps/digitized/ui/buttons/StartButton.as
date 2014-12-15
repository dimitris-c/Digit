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
	
	public class StartButton extends ButtonWithTitle
	{
		public function StartButton()
		{
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('start-title-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('start-title-hover')
				);
		}
	}
}