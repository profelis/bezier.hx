package howtodo;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Bezier;
import flash.geom.Line;
import flash.geom.Point;
import howtodo.view.DragPoint;

class Step04EmulationCubic extends BezierUsage {

	static var DESCRIPTION : String = "<B>Smooth connection</B><BR/><BR/>Press Space button for enable/disable Cubic Bezier";
	var controlS : DragPoint;
	var controlE : DragPoint;
	var q_start : DragPoint;
	var q_mid : DragPoint;
	var q_end : DragPoint;
	var cubicEnabled : Bool;
	/**
	 * @example
	 * Псевдо трехмерная кривая Безье.<BR/>
	 * <table width="100%" border=1><td>
	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../images/Step04EmulationCubic.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../images/Step04EmulationCubic.swf" quality="high" bgcolor="#FFFFFF"
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
	 * <I>
	 * Нажмите клавишу "пробел", чтобы включить/выключить отображение кривой Безье третьего порядка.
	 * </I>
	 **/
	public function new() {
		controlS = new DragPoint();
		controlE = new DragPoint();
		q_start = new DragPoint();
		q_mid = new DragPoint();
		q_end = new DragPoint();
		cubicEnabled = true;
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		cubicEnabled = false;
		initControl(controlS, 0xCCCCCC);
		initControl(controlE, 0xCCCCCC);
		removeChild(control);
		onPointMoved();
	}

	function onKeyUpHandler(event : KeyboardEvent) : Void {
		if(event.keyCode == 32)  {
			cubicEnabled = !cubicEnabled;
			onPointMoved();
		}
	}

	override function onPointMoved(event : Event = undefined) : Void {
		graphics.clear();
		if(cubicEnabled)  {
			graphics.lineStyle(0, 0xFF0000, 1);
			drawCubic();
		}
		graphics.lineStyle(0, 0xFF0000, .3);
		var ss : Line = new Line(start.point, controlS.point);
		var ee : Line = new Line(end.point, controlE.point);
		drawLine(ss);
		drawLine(ee);
		recalcQuadratic();
	}

	function recalcQuadratic() : Void {
		graphics.lineStyle(0, 0x00FFFF, 0.5);
		var sc : Point = Point.interpolate(controlS.point, start.point, 3 / 4);
		var ec : Point = Point.interpolate(controlE.point, end.point, 3 / 4);
		//			graphics.moveTo(sc.x, sc.y);
		//			graphics.lineTo(ec.x, ec.y);
		q_start.position = sc;
		q_end.position = ec;
		q_mid.x = (sc.x + ec.x) / 2;
		q_mid.y = (sc.y + ec.y) / 2;
		//			sc = Point.interpolate(q_mid.point, sc, 1/4);
		//			ec = Point.interpolate(q_mid.point, ec, 1/4);
		var first_bezier : Bezier = new Bezier(start.point, sc, q_mid.point);
		var second_bezier : Bezier = new Bezier(q_mid.point, ec, end.point);
		graphics.lineStyle(0, 0x0000FF, 1);
		drawBezier(first_bezier);
		graphics.lineStyle(0, 0xFF0000, 1);
		drawBezier(second_bezier);
	}

	function drawCubic() : Void {
		graphics.moveTo(start.x, start.y);
		graphics.lineStyle(0, 0xFF00FF, 1);
		var t : UInt = 0;
		var s : Point = start.point;
		var cs : Point = controlS.point;
		var ce : Point = controlE.point;
		var e : Point = end.point;
		while(t++ < 100) {
			var point : Point = getCubicPoint(t / 100, s, cs, ce, e);
			graphics.lineTo(point.x, point.y);
		}

		// getCubicTangent(.5, s, cs, ce, e);
	}

	function getCubicTangent(time : Float, startPoint : Point, controlSPoint : Point, controlEPoint : Point, endPoint : Point) : Line {
		var s : Line = new Line(startPoint, controlSPoint);
		var e : Line = new Line(controlEPoint, endPoint);
		var m : Line = new Line(controlSPoint, controlEPoint);
		var sm : Line = new Line(s.getPoint(time), m.getPoint(time));
		var me : Line = new Line(m.getPoint(time), e.getPoint(time));
		var tangent : Line = new Line(sm.getPoint(time), me.getPoint(time), false);
		graphics.lineStyle(0, 0, .2);
		drawLine(tangent.getSegment(-1, 2));
		return tangent;
	}

	function getCubicPoint(time : Float, startPoint : Point, controlSPoint : Point, controlEPoint : Point, endPoint : Point) : Point {
		var cx : Float = 3 * (controlSPoint.x - startPoint.x);
		var bx : Float = 3 * (controlEPoint.x - controlSPoint.x) - cx;
		var ax : Float = endPoint.x - startPoint.x - cx - bx;
		var cy : Float = 3 * (controlSPoint.y - startPoint.y);
		var by : Float = 3 * (controlEPoint.y - controlSPoint.y) - cy;
		var ay : Float = endPoint.y - startPoint.y - cy - by;
		var tSquared : Float = time * time;
		var tCubed : Float = tSquared * time;
		var point : Point = new Point();
		point.x = (ax * tCubed) + (bx * tSquared) + (cx * time) + startPoint.x;
		point.y = (ay * tCubed) + (by * tSquared) + (cy * time) + startPoint.y;
		return point;
	}

}

