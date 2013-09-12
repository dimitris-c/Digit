package gr.funkytaps.digitized.utils
{
	import com.dimmdesign.core.IDestroyable;
	
	import flash.display.Loader;
	
	import starling.display.DisplayObjectContainer;

	public class DisplayUtils
	{
		public function DisplayUtils()
		{
			
		}
		
		/**
		 * Removes all the children of the passed display object container.
		 * @param target The display object container to remove its children.
		 * @param recursive If true it will remove all children and grandchildren going.
		 * 
		 */		
		public static function removeAllChildren(target:*, recursive:Boolean = false, destroy:Boolean = false, dispose:Boolean = false):void {
			
			if ((target is Loader) || !(target is DisplayObjectContainer))
				return;
			
			const targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;
			
			while(targetContainer.numChildren) {
				DisplayUtils.destroyChild(targetContainer.removeChildAt(0, dispose), recursive, destroy);
				
			}
			
		}
		
		public static function destroyChild(target:*, recursive:Boolean = false, destroy:Boolean = false):void {
			
			if (destroy && (target is IDestroyable)) {
				const child:IDestroyable = target as IDestroyable;
				child.destroy();
			}
			
			if (recursive)
				DisplayUtils.removeAllChildren(target, recursive, destroy);
		}
	}
}