package gr.funkytaps.digitized.ui.buttons
{
	import gr.funkytaps.digitized.core.Assets;
	
	public class ResumeButton extends ButtonWithTitle
	{
		public function ResumeButton()
		{
			super(
				Assets.manager.getTexture('green-button-normal'),
				Assets.manager.getTexture('resume-normal'), 
				Assets.manager.getTexture('green-button-hover'),
				Assets.manager.getTexture('resume-hover')
			);
		}
	}
}