package howtodo;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Bezier;
import flash.geom.Line;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import howtodo.view.DragPoint;

class BezierUsage extends Sprite {

	var descriptionTxt : TextField;
	var start : DragPoint;
	var control : DragPoint;
	var end : DragPoint;
	var bezier : Bezier;
	public function new() {
		start = new DragPoint();
		control = new DragPoint();
		end = new DragPoint();
		bezier = new Bezier(start.point, control.point, end.point);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	function onAddedToStage(event : Event) : Void {
		init();
	}

	function init() : Void {
		initControl(start, 0, "S");
		initControl(control, 0, "C");
		initControl(end, 0, "E");
	}

	function initDescription(description : String) : Void {
		if(!descriptionTxt)  {
			var txt : TextField = new TextField();
			txt.selectable = false;
			txt.wordWrap = false;
			txt.multiline = true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			txt.mouseWheelEnabled = false;
			txt.x = 120;
			addChild(txt);
			descriptionTxt = txt;
		}
		descriptionTxt.htmlText = description;
	}

	function onPointMoved(event : Event = undefined) : Void {
	}

	function randomizePosition(obj : DisplayObject) : Void {
		obj.x = Math.round(Math.random() * stage.stageWidth);
		obj.y = Math.round(Math.random() * (stage.stageHeight - 100)) + 100;
	}

	function initControl(pt : DragPoint, color : UInt = 0, pointName : String = "") : Void {
		randomizePosition(pt);
		pt.dragable = true;
		if(color)  {
			pt.bodyColor = color;
		}
		if(name)  {
			pt.pointName = pointName;
			pt.textColor = color;
		}
		pt.addEventListener(Event.CHANGE, onPointMoved);
		addChild(pt);
	}

	function drawBezier(bezierCurve : Bezier, target : Graphics = null, continueDraw : Bool = false) : Void {
		target = target || graphics;
		if(!continueDraw)  {
			target.moveTo(bezierCurve.start.x, bezierCurve.start.y);
		}
		target.curveTo(bezierCurve.control.x, bezierCurve.control.y, bezierCurve.end.x, bezierCurve.end.y);
	}

	function drawLine(line : Line, target : Graphics = null, continueDraw : Bool = false) : Void {
		target = target || graphics;
		if(!continueDraw)  {
			target.moveTo(line.start.x, line.start.y);
		}
		target.lineTo(line.end.x, line.end.y);
	}

	function drawRectangle(rect : Rectangle, target : Graphics = null) : Void {
		target = target || graphics;
		target.drawRect(rect.x, rect.y, rect.width, rect.height);
	}

	function drawPoint(point : Point) : Void {
		graphics.moveTo(point.x, point.y);
		graphics.lineTo(point.x, point.y + .5);
	}

	function round(num : Float, order : UInt = 2) : Float {
		var n : UInt = Math.pow(10, order);
		return Math.round(num * n) / n;
	}

	function removeObject(obj : DisplayObject) : Void {
		if(obj.parent)  {
			obj.parent.removeChild(obj);
		}
	}

}

