package howtodo {
	import flash.events.Event;
	
	import howtodo.view.DragPoint;	

	public class Step06PointOnBezier extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Distance by curve</B><BR/><BR/>uniform motion";
		
		private const point:DragPoint = new DragPoint();
		private var distance:Number = 0;
		
		/**	
		 * Получение точки по дистанции по кривой<BR/>
		 * @example
		 * <table width="100%" border=1><td>
		 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 *			id="Step1Building" width="100%" height="500"
		 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		 *			<param name="movie" value="../images/Step06PointOnBezier.swf" />
		 *			<param name="quality" value="high" />
		 *			<param name="bgcolor" value="#FFFFFF" />
		 *			<param name="allowScriptAccess" value="sameDomain" />
		 *			<embed src="../images/Step06PointOnBezier.swf" quality="high" bgcolor="#FFFFFF"
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

		
		public function Step06PointOnBezier () {
			super();
		}
		
		override protected function init():void {
			super.init();
			
			initDescription(DESCRIPTION);
			
			start.x = 100;
			start.y = 300;
			control.x = 300;
			control.y = 300;
			end.x = 700;
			end.y = 500;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addChild(point);
			redraw();
		}
		
		protected function enterFrameHandler(event:Event=undefined):void {
			distance+=1;
			updatePosition();
		}
		
		protected function updatePosition():void {
			var time:Number = bezier.getTimeByDistance(distance%bezier.length);
			point.position = bezier.getPoint(time);
		}
		
		override protected function onPointMoved(event:Event=undefined):void {
			redraw();
			updatePosition();
		}
		
		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000, 1);
			drawBezier(bezier);
		}
		
		
	}
}