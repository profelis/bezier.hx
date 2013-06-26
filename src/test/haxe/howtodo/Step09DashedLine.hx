package howtodo;

import flash.events.Event;
import flash.events.MouseEvent;
import bezier.Bezier;

class Step09DashedLine extends BezierUsage {

	static var DESCRIPTION : String = "<B>Dashed line</B><BR/><BR/>mouse wheel - change line length<BR/>shift+mouse wheel - change gap length<BR/>alt+mouse wheel - change speed";
	static var MIN_LINE_LENGTH : UInt = 1;
	static var MIN_GAP_LENGTH : UInt = 1;
	var lineLength : Float;
	var gapLength : Float;
	var speed : Float;
	var shift : Float;
	public function new() {
		lineLength = 50;
		gapLength = 20;
		speed = 0.25;
		shift = 0;
		super();
		addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
	}

	function onEnterFrameHandler(event : Event) : Void {
		graphics.clear();
		graphics.lineStyle(0, 0xFF0000, 1);
		var step : Float = lineLength + gapLength;
		shift += speed;
		shift = shift % step;
		var starts : Array<Dynamic> = bezier.getTimesSequence(step, shift - step);
		var ends : Array<Dynamic> = bezier.getTimesSequence(step, shift - step + lineLength);
		if(starts[0] > ends[0])  {
			starts.unshift(0);
		}
		var i = 0;
		while(i < starts.length) {
			var startSegmentTime : Float = starts[i];
			var endSegmentTime : Float = ends[i];
			if(Math.isNaN(endSegmentTime))  {
				endSegmentTime = 1;
			}
			var segment : Bezier = bezier.getSegment(startSegmentTime, endSegmentTime);
			drawBezier(segment);
			i++;
		}
	}

	function onStageMouseWheel(event : MouseEvent) : Void {
		if(event.shiftKey)  {
			gapLength += event.delta;
			gapLength = Math.max(MIN_GAP_LENGTH, gapLength);
		}

		else if(event.altKey)  {
			speed += event.delta / 10;
		}

		else  {
			lineLength += event.delta;
			lineLength = Math.max(MIN_LINE_LENGTH, lineLength);
		}

	}

}

