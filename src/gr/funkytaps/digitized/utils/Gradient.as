package gr.funkytaps.digitized.utils
{
	import starling.display.Quad;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class Gradient
	{
		public function Gradient()
		{
		}
		
		public static function setGradient (quad:Quad, colors:Array, alphas:Array):void {
			quad.setVertexColor(0, 0x000000);
			quad.setVertexAlpha(1, 0.6);
			quad.setVertexColor(1, 0x000000);
			quad.setVertexAlpha(1, 0.4);
			quad.setVertexColor(2, 0x000000);
			quad.setVertexAlpha(2, 0);
			quad.setVertexColor(3, 0x000000);
			quad.setVertexAlpha(3, 0);
		}
	}
}