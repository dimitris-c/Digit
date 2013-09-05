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
	
	public class RegisterButton extends ButtonWithTitle
	{
		public function RegisterButton()
		{
			//TODO replace this with textures for regisater button
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('submit-score-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('submit-score-hover')
			);
		}
	}
}

