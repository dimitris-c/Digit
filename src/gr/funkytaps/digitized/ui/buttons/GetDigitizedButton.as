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
	
	public class GetDigitizedButton extends ButtonWithTitle
	{
		public function GetDigitizedButton()
		{
			super(
				Assets.manager.getTexture('blue-button-normal'),
				Assets.manager.getTexture('getdigitized-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('getdigitized-hover')
			);
		}
	}
}