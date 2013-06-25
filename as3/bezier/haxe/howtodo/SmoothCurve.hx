package howtodo;

import flash.display.Graphics;
import flash.geom.Bezier;
import flash.geom.Point;

class SmoothCurve {
	public var length(getLength, never) : Float;

	var beziers : Array<Dynamic>;
	public var start : Point;
	public var end : Point;
	var __length : Float;
	var __length_dirty : Bool;
	public function new(startPoint : Point = null, endPoint : Point = null) {
		beziers = new Array<Dynamic>();
		__length_dirty = true;
		this.start = (try cast(startPoint, Point) catch(e) null) || new Point();
		this.end = (try cast(endPoint, Point) catch(e) null) || new Point();
	}

	public function pushControl(control : Point) : Void {
		if(try cast(control, Point) catch(e) null)  {
			var newBezier : Bezier;
			if(beziers.length)  {
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

	public function getLength() : Float {
		if(!__length_dirty)  {
			return __length;
		}
		var len : UInt = beziers.length;
		if(len)  {
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
			var bezier : Bezier = try cast(beziers[i], Bezier) catch(e) null;
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
		if(!len)  {
			return;
		}
		var prevBezier : Bezier = try cast(beziers[0], Bezier) catch(e) null;
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
		if(!(try cast(target, Graphics) catch(e) null))  {
			return;
		}
		update();
		target.moveTo(start.x, start.y);
		var len : UInt = beziers.length;
		if(!len)  {
			target.lineTo(end.x, end.y);
			return;
		}
		var bezier : Bezier = try cast(beziers[0], Bezier) catch(e) null;
		drawBezier(target, bezier, true);
		var i : UInt = 1;
		while(i < len) {
			bezier = try cast(beziers[i], Bezier) catch(e) null;
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

