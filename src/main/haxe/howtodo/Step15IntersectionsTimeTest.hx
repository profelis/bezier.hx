package howtodo;

import howtodo.view.DragPoint;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Bezier;
import flash.geom.Intersection;
import flash.geom.Line;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;
import flash.utils.GetTimer;

class Step15IntersectionsTimeTest extends BezierUsage {

	static var DESCRIPTION : String = "<B>Bezier-Bezier intersection time test</B><BR/> every frame does 1000 intersections";
	static var GRAY : UInt = 0x333333;
	static var BLUE : UInt = 0x0000FF;
	var bezierBlue : Bezier;
	var startGray : DragPoint;
	var controlGray : DragPoint;
	var endGray : DragPoint;
	var bezierGray : Bezier;
	var intersections : Array<Dynamic>;
	var fpsTextField : TextField;
	public function new() {
		startGray = new DragPoint();
		controlGray = new DragPoint();
		endGray = new DragPoint();
		bezierGray = new Bezier(startGray.point, controlGray.point, endGray.point);
		intersections = [];
		fpsTextField = new TextField();
		super();
	}

	override function init() : Void {
		addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		initDescription(DESCRIPTION);
		bezierBlue = bezier;
		bezier = null;
		initControl(start, BLUE, "S");
		initControl(control, BLUE, "C");
		initControl(end, BLUE, "E");
		initControl(startGray, GRAY, "S");
		initControl(controlGray, GRAY, "C");
		initControl(endGray, GRAY, "E");
		bezierBlue.isSegment = false;
		bezierGray.isSegment = false;
		setTestPosition(100, 400, 800, 500, 100, 600, 200, 700, 300, 100, 400, 700);
		addTextField(fpsTextField, 100, 50);
		onPointMoved();
	}

	function addTextField(textField : TextField, x : Float, y : Float) : Void {
		textField.selectable = false;
		textField.wordWrap = false;
		textField.multiline = true;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		textField.x = x;
		textField.y = y;
		addChild(textField);
	}

	function updateOutText(time : Float) : Void {
		fpsTextField.text = "1000 iterations duration - " + time + "milliseconds
" + round(time / 1000, 4) + " milliseconds spent on single method call";
	}

	function onKeyUpHandler(event : KeyboardEvent) : Void {
		if(event.keyCode == Keyboard.SPACE)  {
			// trace(getTestPosition());
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

	/*
	private function getTestPosition() : String {
	return "" + [start.x,
	start.y,
	control.x,
	control.y,
	end.x,
	end.y,

	startGray.x,
	startGray.y,
	controlGray.x,
	controlGray.y,
	endGray.x,
	endGray.y];
	}
	 */
	override function onPointMoved(event : Event = undefined) : Void {
		graphics.clear();
		graphics.lineStyle(0, BLUE, 1);
		drawBezier(bezierBlue);
		graphics.lineStyle(0, GRAY, 1);
		drawBezier(bezierGray);
		removeIntersections();
		showBezierBezierIntersection(bezierBlue, bezierGray);
	}

	function showBezierBezierIntersection(curve1 : Bezier, curve2 : Bezier) : Void {
		var time : Float;
		var isect : Intersection;
		var calculationTime : Float = getTimer();
		var j : Int = 0;
		while(j < 1000) {
			isect = curve1.intersectionBezier(curve2);
			j++;
		}
		calculationTime = getTimer() - calculationTime;
		updateOutText(calculationTime);
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
		trace("time: " + time);
		if(Std.is(point, Point))  {
			var intersection : DragPoint = new DragPoint();
			intersection.position = point;
			addChild(intersection);
			intersections.push(intersection);
			if(small)  {
				intersection.radius -= 2;
			}

			else  {
				intersection.pointName = "     t:" + round(time, 4);
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

