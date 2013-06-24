package howtodo {
	
	
	public class Step00HowToDo extends BezierUsage {
		
		private static const DESCRIPTION:String = "Use 1-9 keys to view examples<BR/>Change grid step if needed";
		
		public function Step00HowToDo () {
			super();
		}
		
		override protected function init():void {
			initDescription(DESCRIPTION);
		}	
	}
}