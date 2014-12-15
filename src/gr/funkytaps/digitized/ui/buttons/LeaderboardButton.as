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
	
	public class LeaderboardButton extends ButtonWithTitle
	{
		public function LeaderboardButton()
		{
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('leaderboard-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('leaderboard-hover')
			);
		}
	}
}