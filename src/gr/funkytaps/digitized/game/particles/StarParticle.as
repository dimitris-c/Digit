package gr.funkytaps.digitized.game.particles
{
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.display.MovieClip;
	
	public class StarParticle extends MovieClip
	{
		public function StarParticle()
		{
			super(Assets.manager.getTextures('starexplosion0'), 31);
		}
		
	}
}