package howtodo;

import flash.geom.Point;
import howtodo.view.DragPoint;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Bezier;
import flash.geom.IParametric;
import flash.geom.Line;

class Step12Drawing extends Sprite {

	var lines : Array<Dynamic>;
	var speed : Float;
	var drawLength : Float;
	public function new() {
		lines = [];
		speed = 5;
		drawLength = 0;
		super();
		initInstance();
	}

	function initInstance() : Void {
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onAddedToStage(event : Event) : Void {
		initRandomShape();
	}

	function onRemovedFromStage(event : Event) : Void {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onEnterFrame(event : Event) : Void {
		drawLength += speed;
		var linesLength : Float = 0;
		var shapeNum : Int = 0;
		graphics.clear();
		graphics.lineStyle(0, 0, .2);
		var line : IParametric;
		while(true) {
			line = lines[shapeNum++];
			if(!line)  {
				break;
			}
			drawLine(line);
		}

		graphics.lineStyle(3, 0xFF0000, 1);
		shapeNum = 0;
		while(true) {
			line = lines[shapeNum++];
			if(!line)  {
				drawLength = 0;
				return;
			}
			if(drawLength > linesLength + line.length)  {
				drawLine(line);
			}

			else  {
				var endPointTime : Float = line.getTimeByDistance(drawLength - linesLength);
				var endBezier : Bezier = try cast(line, Bezier) catch(e) null;
				var endLine : Line = try cast(line, Line) catch(e) null;
				if(endBezier)  {
					drawLine(endBezier.getSegment(0, endPointTime));
				}

				else if(endLine)  {
					drawLine(endLine.getSegment(0, endPointTime));
				}
				return;
			}

			linesLength += line.length;
		}

	}

	function initRandomShape() : Void {
		var line : IParametric;
		var start : DragPoint;
		var control : DragPoint;
		var end : DragPoint = createRandomPoint();
		var totalLines : Int = 10 + Math.random() * 5;
		while(totalLines--) {
			start = end;
			end = createRandomPoint();
			if(Math.random() > .5)  {
				control = createRandomPoint(true);
				line = new Bezier(start.point, control.point, end.point);
			}

			else  {
				line = new Line(start.point, end.point);
			}

			lines.push(line);
		}

		//
		var startPoint : Point = end.point;
		var endPoint : Point = lines[0].start;
		lines.push(new Line(startPoint, endPoint));
	}

	function createRandomPoint(isControl : Bool = false) : DragPoint {
		var randomDragPoint : DragPoint = new DragPoint();
		if(isControl)  {
			randomDragPoint.bodyColor = 0xCCCCCC;
		}
		randomDragPoint.dragable = true;
		randomDragPoint.x = Math.round(Math.random() * stage.stageWidth);
		randomDragPoint.y = Math.round(Math.random() * (stage.stageHeight - 100)) + 100;
		addChild(randomDragPoint);
		return randomDragPoint;
	}

	function drawLine(line : IParametric) : Void {
		if(!line)  {
			return;
		}
		graphics.moveTo(line.start.x, line.start.y);
		var bezier : Bezier = try cast(line, Bezier) catch(e) null;
		if(bezier)  {
			graphics.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
		}

		else  {
			graphics.lineTo(line.end.x, line.end.y);
		}

	}

}

