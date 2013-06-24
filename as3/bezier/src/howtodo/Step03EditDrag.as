package howtodo {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	public class Step03EditDrag extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Edit drag</B><BR/><BR/>drag curve to change";
		
		private const mouse:Point = new Point();
		private var dragTime:Number;
		
		/**	
		 * @example
		 * Демонстрация редактирования кривой Безье второго порядка.<BR/>
		 * <table width="100%" border=1><td>
		 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 *			id="Step1Building" width="100%" height="500"
		 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		 *			<param name="movie" value="../images/Step03EditDrag.swf" />
		 *			<param name="quality" value="high" />
		 *			<param name="bgcolor" value="#FFFFFF" />
		 *			<param name="allowScriptAccess" value="sameDomain" />
		 *			<embed src="../images/Step03EditDrag.swf" quality="high" bgcolor="#FFFFFF"
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
		 * <BR/>
		 * <I>Изменяйте кривую Безье мышью</I><BR/>
		 **/

		
		public function Step03EditDrag () {
			super();
		}
		
		override protected function init():void {
			super.init();
			
			initDescription(DESCRIPTION);
			
			buttonMode = true;
			useHandCursor = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			redraw();
		}
		
		private function onMouseDownHandler(event:MouseEvent=undefined):void {
			mouse.x = event.stageX;
			mouse.y = event.stageY;
			dragTime = bezier.getClosest(mouse);
			
			if (dragTime < .1 || dragTime > .9) {
				return;
			}
			
			var closest:Point = bezier.getPoint(dragTime);
			var distance:Number = Point.distance(closest, mouse);
			if (distance < 5) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			}
			
		}
		private function onMouseUpHandler(event:MouseEvent=undefined):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		private function onMouseMoveHandler(event:MouseEvent=undefined):void {
			mouse.x = event.stageX;
			mouse.y = event.stageY;
			bezier.setPoint(dragTime, mouse.x, mouse.y);
			control.position = bezier.control;
			redraw();
		}
		
		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(5, 0x0000FF, 0);
			drawBezier(bezier);
			graphics.lineStyle(0, 0x0000FF, 1);
			drawBezier(bezier);
			
		}
		override protected function onPointMoved(event:Event=undefined):void {
			redraw();
		}
		
	}
	
}