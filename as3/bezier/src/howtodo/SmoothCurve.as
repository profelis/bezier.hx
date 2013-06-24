package howtodo {
	import flash.display.Graphics;
	import flash.geom.Bezier;
	import flash.geom.Point;	

	public class SmoothCurve {
		
		private const beziers:Array = new Array();
		
		public var start:Point;
		public var end:Point;
		
		private var __length:Number;
		private var __length_dirty:Boolean = true;
		
		public function SmoothCurve (startPoint:Point=null, endPoint:Point=null) {
			this.start		= (startPoint	as Point) || new Point();
			this.end		= (endPoint		as Point) || new Point();
		}
		
		public function pushControl(control:Point):void {
			if (control as Point) {
				var newBezier:Bezier;
				if (beziers.length) {
					var lastBezier:Bezier = beziers[beziers.length-1];
					lastBezier.end = new Point();
					newBezier = new Bezier(lastBezier.end, control, end);
				} else {
					newBezier = new Bezier(start, control, end);
				}
				beziers[beziers.length] = newBezier;
			}
		}
		
		public function get length():Number {
			if (!__length_dirty) {
				return __length;
			}
			var len:uint = beziers.length;
			if (len) {
				var curveLength:Number = 0;
				
				for (var i:uint=0; i<len; i++) {
					var bezier:Bezier = beziers[i];
					curveLength+=bezier.length;
				}
				__length = curveLength;
			} else {
				__length = Point.distance(start, end);
			}
			__length_dirty = false;
			return __length;
		}
		
		public function getPointByDistance(distance:Number):Point {
			if (distance <= 0) {
				return start.clone();
			}
			var curveLength:Number = length;
			if (distance >= curveLength) {
				return end.clone();
			}
			
			var distanceFromStart:Number=0;
			var len:uint = beziers.length;
			
			for (var i:uint=0; i<len; i++) {
				var bezier:Bezier = beziers[i] as Bezier;
				var bezierLength:Number = bezier.length;
				
				if ((distanceFromStart+bezierLength)>distance) {
					var difference:Number = distance-distanceFromStart;
					var time:Number = bezier.getTimeByDistance(difference);
					var position:Point = bezier.getPoint(time); 
					return position;
				}
				distanceFromStart+=bezierLength;
			}
			throw new Error("**ERROR** usage.SmoothCurve.getPointByDistance("+distance+")");
			return null;
		}
		
		public function update():void {
			__length_dirty = true;
			var len:uint = beziers.length;
			if (!len) {
				return;
			}
			var prevBezier:Bezier = beziers[0] as Bezier;
			var currentBezier:Bezier;
			
			for (var i:uint=1; i<len; i++) {
				currentBezier = beziers[i];
				var mid:Point = Point.interpolate(prevBezier.control, currentBezier.control, 0.5);
				currentBezier.start.x = mid.x; 
				currentBezier.start.y = mid.y;
				prevBezier = currentBezier;
			}
		}
		
		public function draw(target:Graphics):void {
			if (!(target as Graphics)) {
				return;
			}
			update();
			target.moveTo(start.x, start.y);
			var len:uint = beziers.length;
			if (!len) {
				target.lineTo(end.x, end.y);
				return;
			}
			var bezier:Bezier = beziers[0] as Bezier;
			drawBezier(target, bezier, true);
			for (var i:uint=1; i<len; i++) {
				bezier = beziers[i] as Bezier;
				drawBezier(target, bezier);
			}
			
		}
		
		private function drawBezier(target:Graphics, bezier:Bezier, move:Boolean=false):void {
			if (move) {
				target.moveTo(bezier.start.x, bezier.start.y);
			}
			target.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
		}
		
	}
}




