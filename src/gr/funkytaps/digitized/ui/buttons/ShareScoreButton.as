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
	
	public class ShareScoreButton extends ButtonWithTitle
	{
		public function ShareScoreButton()
		{
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('share-score-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('share-score-hover')
			);
		}
	}
}