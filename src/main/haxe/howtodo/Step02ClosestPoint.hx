/**

 * @example

 * Синим цветом обозначена кривая Безье, ограниченная точками start, end, а также линия до ближайшей точки на ней. Свойство <code>isSegment=true;</code> <BR/>

 * Красным цветом обозначена неограниченная кривая, а также линия до ближайшей точки на ней. Свойство <code>isSegment=false;</code>

 * <P><a name="closest_point_demo"></a>

 * <table width="100%" border=1><td>

 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"

 *			id="Step1Building" width="100%" height="500"

 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">

 *			<param name="movie" value="../images/Step02ClosestPoint.swf" />

 *			<param name="quality" value="high" />

 *			<param name="bgcolor" value="#FFFFFF" />

 *			<param name="allowScriptAccess" value="sameDomain" />

 *			<embed src="../images/Step02ClosestPoint.swf" quality="high" bgcolor="#FFFFFF"

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

 * 	</td></table>

 * </P>

 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR>

 * <I>Перемещайте мышью контрольные точки кривой.</I></P>

 * <BR/>

 * 

 **/
package howtodo;

import flash.events.MouseEvent;
import bezier.Bezier;
import bezier.Line;
import deep.math.Point;
import howtodo.view.DragPoint;

class Step02ClosestPoint extends BezierUsage {

	static var DESCRIPTION : String = "<B>Closest point</B><BR/><BR/>Red line - isSegment=false <BR/>Blue line - isSegment=true";
	var closestUnlimited : DragPoint;
	var closestLimited : DragPoint;
	var mouse : Point;
	var unlimited : Line;
	var limited : Line;
	public function new() {
		closestUnlimited = new DragPoint();
		closestLimited = new DragPoint();
		mouse = new Point();
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		unlimited = new Line(start.point, control.point);
		limited = new Line(control.point, end.point);
		start.x = 100;
		start.y = 300;
		control.x = 300;
		control.y = 300;
		end.x = 700;
		end.y = 500;
		/*

		//TODO: было изначально, вернуть!

		start.x = stage.stageWidth*.1;

		start.y = stage.stageHeight*.9;

		control.x = stage.stageWidth*.7;

		control.y = stage.stageHeight*.1;

		end.x = stage.stageWidth*.7;

		end.y = stage.stageHeight*.2;

		*/
		addChild(closestUnlimited);
		addChild(closestLimited);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		redraw();
	}

	function onMouseMoveHandler(?event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
		redraw();
	}

	function redraw() : Void {
		bezier.isSegment = false;
		var unlimitedTime : Float = bezier.getClosest(mouse);
		bezier.isSegment = true;
		var limitedTime : Float = bezier.getClosest(mouse);
		start.visible = unlimitedTime != 0 && limitedTime != 0;
		end.visible = unlimitedTime != 1 && limitedTime != 1;
		closestUnlimited.position = bezier.getPoint(unlimitedTime);
		closestLimited.position = bezier.getPoint(limitedTime);
		closestUnlimited.pointName = "P(" + round(unlimitedTime, 3) + ")";
		closestLimited.pointName = "P(" + round(limitedTime, 3) + ")";
		graphics.clear();
		graphics.lineStyle(0, 0xFF0000, .5);
		drawBezier(bezier.getSegment(-1, 2));
		graphics.lineStyle(0, 0x0000FF, 1);
		drawBezier(bezier);
		graphics.lineStyle(0, 0xFF0000, .5);
		drawLine(new Line(mouse, closestUnlimited.point));
		graphics.lineStyle(0, 0x0000FF, 1);
		drawLine(new Line(mouse, closestLimited.point));
	}

}

