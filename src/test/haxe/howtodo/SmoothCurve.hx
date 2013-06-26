package howtodo;

import bezier.IParametric.IParametric;
import flash.display.Graphics;
import bezier.Bezier;
import deep.math.Point;
import flash.errors.Error;

class SmoothCurve {
	public var length(get, never) : Float;

	var beziers : Array<Bezier>;
	public var start : Point;
	public var end : Point;
	var __length : Float;
	var __length_dirty : Bool;
	public function new(startPoint : Point = null, endPoint : Point = null) {
		beziers = new Array<Bezier>();
		__length_dirty = true;
		this.start = startPoint != null ? startPoint : new Point();
		this.end = endPoint != null ? endPoint : new Point();
	}

	public function pushControl(control : Point) : Void {
		if(control != null)  {
			var newBezier : Bezier;
			if(beziers.length > 0)  {
				var lastBezier : Bezier = beziers[beziers.length - 1];
				lastBezier.end = new Point();
				newBezier = new Bezier(lastBezier.end, control, end);
			}

			else  {
				newBezier = new Bezier(start, control, end);
			}

			beziers[beziers.length] = newBezier;
		}
	}

	public function get_length() : Float {
		if(!__length_dirty)  {
			return __length;
		}
		var len : UInt = beziers.length;
		if(len != 0)  {
			var curveLength : Float = 0;
			var i : UInt = 0;
			while(i < len) {
				var bezier : Bezier = beziers[i];
				curveLength += bezier.length;
				i++;
			}
			__length = curveLength;
		}

		else  {
			__length = Point.distance(start, end);
		}

		__length_dirty = false;
		return __length;
	}

	public function getPointByDistance(distance : Float) : Point {
		if(distance <= 0)  {
			return start.clone();
		}
		var curveLength : Float = length;
		if(distance >= curveLength)  {
			return end.clone();
		}
		var distanceFromStart : Float = 0;
		var len : UInt = beziers.length;
		var i : UInt = 0;
		while(i < len) {
			var bezier : Bezier = beziers[i];
			var bezierLength : Float = bezier.length;
			if((distanceFromStart + bezierLength) > distance)  {
				var difference : Float = distance - distanceFromStart;
				var time : Float = bezier.getTimeByDistance(difference);
				var position : Point = bezier.getPoint(time);
				return position;
			}
			distanceFromStart += bezierLength;
			i++;
		}
		throw new Error("**ERROR** usage.SmoothCurve.getPointByDistance(" + distance + ")");
		return null;
	}

	public function update() : Void {
		__length_dirty = true;
		var len : UInt = beziers.length;
		if(len == 0)  {
			return;
		}
		var prevBezier : Bezier = beziers[0];
		var currentBezier : Bezier;
		var i : UInt = 1;
		while(i < len) {
			currentBezier = beziers[i];
			var mid : Point = Point.interpolate(prevBezier.control, currentBezier.control, 0.5);
			currentBezier.start.x = mid.x;
			currentBezier.start.y = mid.y;
			prevBezier = currentBezier;
			i++;
		}
	}

	public function draw(target : Graphics) : Void {
		if(target == null)  {
			return;
		}
		update();
		target.moveTo(start.x, start.y);
		var len : UInt = beziers.length;
		if(len == 0)  {
			target.lineTo(end.x, end.y);
			return;
		}
		var bezier : Bezier = beziers[0];
		drawBezier(target, bezier, true);
		var i : UInt = 1;
		while(i < len) {
			bezier = beziers[i];
			drawBezier(target, bezier);
			i++;
		}
	}

	function drawBezier(target : Graphics, bezier : Bezier, move : Bool = false) : Void {
		if(move)  {
			target.moveTo(bezier.start.x, bezier.start.y);
		}
		target.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
	}

}

