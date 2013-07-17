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
	
	public class PlayAgainButton extends ButtonWithTitle
	{
		public function PlayAgainButton()
		{
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('play-again-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('play-again-hover')
			);
		}
	}
}