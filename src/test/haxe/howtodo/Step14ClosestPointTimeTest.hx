package howtodo;

import flash.Lib;
import howtodo.view.DragPoint;
import flash.events.MouseEvent;
import bezier.Bezier;
import bezier.Line;
import deep.math.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class Step14ClosestPointTimeTest extends BezierUsage {

	static var DESCRIPTION : String = "<B>Closest point time test</B><BR/> every frame does 1000 closest point searches";
	var closestPoint : DragPoint;
	var mouse : Point;
	var fpsTextField : TextField;
	public function new() {
		closestPoint = new DragPoint();
		mouse = new Point();
		fpsTextField = new TextField();
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		start.x = 100;
		start.y = 300;
		control.x = 300;
		control.y = 300;
		end.x = 700;
		end.y = 500;
		bezier.isSegment = false;
		addTextField(fpsTextField, 100, 50);
		addChild(closestPoint);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		redraw();
	}

	function updateOutText(time : Float) : Void {
		fpsTextField.text = "1000 iterations duration - " + time + " milliseconds\n" 
		+ (time / 10000) + " milliseconds spent on single method call";
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

	function onMouseMoveHandler(?event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
		redraw();
	}

	function redraw() : Void {
		var closestTime : Float = 0;
		var calculationTime : Float = Lib.getTimer();
		var i : Int = 0;
		while(i < 1000) {
			closestTime = bezier.getClosest(mouse);
			i++;
		}
		calculationTime = Lib.getTimer() - calculationTime;
		updateOutText(calculationTime);
		closestPoint.position = bezier.getPoint(closestTime);
		closestPoint.pointName = "P(" + round(closestTime, 3) + ")";
		graphics.clear();
		graphics.lineStyle(0, 0xFF0000, .5);
		drawBezier(bezier.getSegment(-1, 2));
		graphics.lineStyle(0, 0x0000FF, 1);
		drawBezier(bezier);
		graphics.lineStyle(0, 0xFF0000, .5);
		drawLine(new Line(mouse, closestPoint.point));
	}

}

