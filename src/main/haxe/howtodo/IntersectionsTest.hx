package howtodo;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Bezier;
import flash.geom.Intersection;
import flash.geom.Line;
import flash.geom.Point;
import flash.ui.Keyboard;
import howtodo.view.DragPoint;

class IntersectionsTest extends BezierUsage {

	static var DESCRIPTION : String = "intersections";
	static var GRAY : UInt = 0x333333;
	static var BLUE : UInt = 0x0000FF;
	//		private static const RED:uint = 0xFF0000;
	//		private static const GREEN:uint = 0x006600;
	//		private const startRed:PointView=new PointView();
	//		private const endRed:PointView=new PointView();
	//		private const lineRed:Line = new Line(startRed.point, endRed.point);
	//
	//		private const startGreen:PointView=new PointView();
	//		private const endGreen:PointView=new PointView();
	//		private const lineGreen:Line = new Line(startGreen.point, endGreen.point);
	var startGray : DragPoint;
	var controlGray : DragPoint;
	var endGray : DragPoint;
	var bezierGray : Bezier;
	var bezierBlue : Bezier;
	var intersections : Array<Dynamic>;
	public function new() {
		startGray = new DragPoint();
		controlGray = new DragPoint();
		endGray = new DragPoint();
		bezierGray = new Bezier(startGray.point, controlGray.point, endGray.point);
		intersections = [];
		super();
	}

	override function init() : Void {
		addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		initDescription(DESCRIPTION);
		bezierBlue = bezier;
		bezier = null;
		//			initControl(startRed, RED, "S");
		//			initControl(endRed, RED, "E");
		//			initControl(startGreen, GREEN, "S");
		//			initControl(endGreen, GREEN, "E");
		initControl(startGray, GRAY, "S");
		initControl(controlGray, GRAY, "C");
		initControl(endGray, GRAY, "E");
		initControl(start, BLUE, "S");
		initControl(control, BLUE, "C");
		initControl(end, BLUE, "E");
		//			start.x = 200;
		//			start.y = 200;
		//			control.x = 300;
		//			control.y = 400;
		//			end.x = 400;
		//			end.y = 200;
		//
		//			startGray.x = 200;
		//			startGray.y = 300;
		//			controlGray.x = 300;
		//			controlGray.y = 100;
		//			endGray.x = 400;
		//			endGray.y = 300;
		//setTestPosition(200, 200, 300, 400, 400, 200,  200, 300, 300, 100, 400, 300);
		//setTestPosition(200,200,400,200,400,400,200,300,501,100,300,400);
		//setTestPosition(200,200,300,300,400,400,200,400,300,300,500,100);
		//setTestPosition(200,200,299,400,400,200,200,400,301,199,400,400);
		//setTestPosition(200,300,400,500,500,600,100,400,700,0,200,500);
		//setTestPosition(400,500,500,200,500,600,500,600,500,100,400,300);
		//setTestPosition(200,300,400,500,500,600,600,100,300,600,200,500);
		//setTestPosition(200,300,400,500,500,600,600,100,400,300,200,500);
		// setTestPosition(200,300,400,500,500,600,200,400,700,0,200,500);
		//setTestPosition(400,500,100,0,500,400,100,400,700,0,200,500);
		setTestPosition(200, 300, 400, 500, 500, 600, 600, 100, 400, 300, 200, 500);
		// setTestPosition(400,500,500,200,500,600,500,600,500,100,400,100);
		onPointMoved();
	}

	function onKeyUpHandler(event : KeyboardEvent) : Void {
		if(event.keyCode == Keyboard.SPACE)  {
			trace(getTestPosition());
		}
	}

	function setTestPosition(s0x : Float, s0y : Float, c0x : Float, c0y : Float, e0x : Float, e0y : Float, s1x : Float, s1y : Float, c1x : Float, c1y : Float, e1x : Float, e1y : Float) : Void {
		start.x = s0x;
		start.y = s0y;
		control.x = c0x;
		control.y = c0y;
		end.x = e0x;
		end.y = e0y;
		startGray.x = s1x;
		startGray.y = s1y;
		controlGray.x = c1x;
		controlGray.y = c1y;
		endGray.x = e1x;
		endGray.y = e1y;
	}

	function getTestPosition() : String {
		return "" + [start.x, start.y, control.x, control.y, end.x, end.y, startGray.x, startGray.y, controlGray.x, controlGray.y, endGray.x, endGray.y];
	}

	override function onPointMoved(event : Event = undefined) : Void {
		graphics.clear();
		//			graphics.lineStyle(0, RED, 1);
		//			drawLine(lineRed);
		//			graphics.lineStyle(0, GREEN, 1);
		//			drawLine(lineGreen);
		graphics.lineStyle(0, BLUE, 1);
		drawBezier(bezierBlue);
		graphics.lineStyle(0, GRAY, 1);
		drawBezier(bezierGray);
		removeIntersections();
		//			showLineLineIntersection(lineRed, lineGreen);
		//
		//			showLineBezierIntersection(bezierBlue, lineRed);
		//			showLineBezierIntersection(bezierBlue, lineGreen);
		//
		//			showLineBezierIntersection(bezierGray, lineRed);
		//			showLineBezierIntersection(bezierGray, lineGreen);
		showBezierBezierIntersection(bezierBlue, bezierGray);
	}

	function showBezierBezierIntersection(curve1 : Bezier, curve2 : Bezier) : Void {
		var time : Float;
		var isect : Intersection = curve1.intersectionBezier(curve2);
		if(isect)  {
			var i : UInt = 0;
			while(i < isect.currentTimes.length) {
				time = isect.currentTimes[i];
				showIntersection(curve1.getPoint(time), false, time);
				time = isect.targetTimes[i];
				showIntersection(curve2.getPoint(time), true, time);
				i++;
			}
		}
	}

	function showLineBezierIntersection(curve : Bezier, line : Line) : Void {
		var isect : Intersection = curve.intersectionLine(line);
		if(isect)  {
			if(isect.currentTimes.length)  {
				var time : Float = isect.currentTimes[0];
				showIntersection(curve.getPoint(time), false, time);
				time = isect.targetTimes[0];
				showIntersection(line.getPoint(time), true, time);
				if(isect.currentTimes.length > 1)  {
					time = isect.currentTimes[1];
					showIntersection(curve.getPoint(time), false, time);
					time = isect.targetTimes[1];
					showIntersection(line.getPoint(time), true, time);
				}
			}
		}
	}

	function showLineLineIntersection(line1 : Line, line2 : Line) : Void {
		var isect : Intersection = line1.intersectionLine(line2);
		if(isect)  {
			if(isect.currentTimes.length)  {
				var time : Float = isect.currentTimes[0];
				showIntersection(line1.getPoint(time), false, time);
				time = isect.targetTimes[0];
				showIntersection(line2.getPoint(time), true, time);
			}
		}
	}

	function showIntersection(point : Point, small : Bool, time : Float) : DragPoint {
		if(Std.is(point, Point))  {
			var intersection : DragPoint = new DragPoint();
			intersection.position = point;
			addChild(intersection);
			intersections.push(intersection);
			if(small)  {
				intersection.radius -= 2;
			}

			else  {
				intersection.pointName = "     t:" + time;
			}

			return intersection;
		}
		return null;
	}

	function removeIntersections() : Void {
		while(intersections.length) {
			var intersectionPoint : DragPoint = intersections.pop();
			removeChild(intersectionPoint);
		}

	}

}

