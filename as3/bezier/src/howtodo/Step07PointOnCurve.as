package howtodo {
	import flash.events.Event;
	
	import howtodo.view.DragPoint;	

	public class Step07PointOnCurve extends Step05SmoothCurve {
		
		private static const DESCRIPTION:String = "<B>Distance by curve</B><BR/><BR/>uniform motion by curve";
		
		private const point:DragPoint = new DragPoint();
		private var distance:Number = 0;
		
		/**	
		 * Получение точки по дистанции по кривой<BR/>
		 * @example
		 * <table width="100%" border=1><td>
		 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 *			id="Step1Building" width="100%" height="500"
		 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		 *			<param name="movie" value="../images/Step07PointOnCurve.swf" />
		 *			<param name="quality" value="high" />
		 *			<param name="bgcolor" value="#FFFFFF" />
		 *			<param name="allowScriptAccess" value="sameDomain" />
		 *			<embed src="../images/Step07PointOnCurve.swf" quality="high" bgcolor="#FFFFFF"
		 *				width="100%" height="400" name="Step1Building"
		 * 				align="middle"
		 *				play="true"
		 *				loop="false"
		 *				quality="high"
		 *				allowScriptAccess="sameDomain"
		 *				type="application/x-shockwave-flash"
		 *				pluginspage="http://www.adobe.com/go/getflashplayer">
		 *			</embed>
		 *	</object>
		 * </td></table>
		 **/

		public function Step07PointOnCurve () {
			super();
		}
		
		override protected function init():void {
			super.init();
			addChild(point);
			initDescription(DESCRIPTION);
		}
		
		
		override protected function enterFrameHandler(event:Event):void {
			super.enterFrameHandler(event);
			distance+=1;
			distance=distance%roupe.length;
			point.position = roupe.getPointByDistance(distance);
		}


		
		
	}
}