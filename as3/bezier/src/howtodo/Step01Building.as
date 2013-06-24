package howtodo {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	
	import howtodo.view.DragPoint;	

	/**
	 * @example
	 * Демонстрация интерполяционного построения линии и кривой Безье второго порядка.<BR/>
	 * <table width="100%" border=1><td>
	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../images/Step01Building.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *				width="100%" height="400" name="Step01Building"
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
	 * <I>Используйте клавиши "влево" "вправо" для управления итератором.<BR/>
	 * Перемещайте контрольные точки безье мышью.</I><BR/>
	 * 
	 **/
	
	public class Step01Building extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Bezier curve building</B><BR/><BR/>Use Rigt and Left arrow keys";
		private static const MIN:uint=0;
		private static const MAX:uint=20;
		private var showNum:Number = 0;
		
		private const timePoint:DragPoint = new DragPoint();
		private const time1Point:DragPoint = new DragPoint();
		private const time2Point:DragPoint = new DragPoint();

		private var startLine:Line;
		private var endLine:Line;
		private var baseLine:Line;
		
		
		/**
		 * Демонстрация 
		 * 
		 * @see BezierUsage
		 **/
		
		public function Step01Building () {
			super();
		}
		
		override protected function init():void {
			super.init();
			
			initDescription(DESCRIPTION);
			
			startLine = new Line(start.point, control.point);
			endLine = new Line(control.point, end.point);
			baseLine = new Line(start.point, end.point);


			start.x = stage.stageWidth*.1;
			start.y = stage.stageHeight*.9;
			control.x = stage.stageWidth*.4;
			control.y = stage.stageHeight*.1;
			end.x = stage.stageWidth*.8;
			end.y = stage.stageHeight*.8;
			
			addChild(timePoint);
			addChild(time1Point);
			addChild(time2Point);
			time1Point.pointName = "T1";
			time2Point.pointName = "T2";
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			redraw();
		}
		
		override protected function onPointMoved(event:Event=undefined):void {
			redraw();
		}
		
		/**
		 * текст
		 * @param event:KeyboardEvent
		 * 
		 */
		
		public function onKeyUpHandler (event:KeyboardEvent):void {
			switch (event.keyCode) {
				case 37:
					if (showNum>MIN) {
						showNum--;
						redraw();
					}
				break;
				case 39:
					if (showNum<MAX) {
						showNum++;
						redraw();
					}
				break;
			}
		}

		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, 0xCCCCCC, 1);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(control.x, control.y);
			graphics.lineTo(end.x, end.y);
			
			time1Point.visible =
			time2Point.visible =
			timePoint.visible = showNum != MIN && showNum != MAX; 
			
			for (var i:uint=MIN; i<=showNum; i++) {
				var time:Number = i/MAX;
				graphics.lineStyle(5, 0xFF0000, 1);
				var bezierPoint:Point = bezier.getPoint(time);
				var basePoint:Point = baseLine.getPoint(time);
				var startPoint:Point = startLine.getPoint(time);
				var endPoint:Point = endLine.getPoint(time);
				drawPoint(bezierPoint);
				drawPoint(startPoint);
				drawPoint(endPoint);
				drawPoint(basePoint);
				var line:Line = new Line(basePoint, bezierPoint);
				graphics.lineStyle(0, 0x0000FF, .3);
				drawLine(line.getSegment(0, 2));
				// drawLine(line);
			}
			var maxTime:Number = showNum/MAX;
			var segment:Bezier = bezier.getSegment(0, maxTime); 
			
			timePoint.pointName = "P("+maxTime+")";
			timePoint.position = bezierPoint;
			
			var t1:Point = Point.interpolate(control.point, start.point, maxTime);
			var t2:Point = Point.interpolate(end.point, control.point, maxTime);
			
			time1Point.position = t1;
			time2Point.position = t2;
			
			var tangent:Line = new Line(t1, t2);
			
			graphics.lineStyle(0, 0xFF0000, .5);
			drawBezier(segment);
			graphics.lineStyle(0, 0xFF00FF, .5);
			drawLine(tangent);

			
		}
		
		
		
	}
	
}









