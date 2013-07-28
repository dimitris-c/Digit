package gr.funkytaps.digitized.interfaces
{
	public interface IUpdateable
	{
		/**
		 * Use this in objects that need to be updated by the EnterFrameEvent.
		 * 
		 * @param passedTime The time that has passed since the last frame (in seconds).
		 * 
		 */		
		function update(passedTime:Number = 0):void;
	}
}