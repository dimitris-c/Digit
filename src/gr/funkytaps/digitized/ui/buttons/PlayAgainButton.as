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
				Assets.manager.getTexture('orange-button-normal'),
				Assets.manager.getTexture('play-again-hover'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('play-again-hover')
			);
		}
	}
}