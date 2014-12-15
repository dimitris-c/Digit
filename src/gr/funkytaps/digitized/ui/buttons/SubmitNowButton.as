package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Giorgos Ampavis
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.core.Assets;
	
	public class SubmitNowButton extends ButtonWithTitle
	{
		public function SubmitNowButton()
		{
			//TODO replace this with textures for regisater button
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('submit-now-button-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('submit-now-button-hover')
			);
		}
	}
}

