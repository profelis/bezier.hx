package howtodo {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Bezier;
	import flash.geom.Intersection;
	import flash.geom.Line;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import howtodo.view.DragPoint;		

	public class IntersectionsTest extends BezierUsage {

		private static const DESCRIPTION:String = "intersections";

		private static const GRAY:uint = 0x333333; 
		private static const BLUE:uint = 0x0000FF; 

//		private static const RED:uint = 0xFF0000; 
//		private static const GREEN:uint = 0x006600; 
//		private const startRed:PointView=new PointView();
//		private const endRed:PointView=new PointView();
//		private const lineRed:Line = new Line(startRed.point, endRed.point);
//
//		private const startGreen:PointView=new PointView();
//		private const endGreen:PointView=new PointView();
//		private const lineGreen:Line = new Line(startGreen.point, endGreen.point);

		protected const startGray:DragPoint = new DragPoint();
		protected const controlGray:DragPoint = new DragPoint();
		protected const endGray:DragPoint = new DragPoint();
		protected const bezierGray:Bezier = new Bezier(startGray.point, controlGray.point, endGray.point);

		protected var bezierBlue:Bezier;

		protected const intersections:Array = [];

		public function IntersectionsTest() {
			super();
		}

		override protected function init():void {
			
			addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			
			initDescription(DESCRIPTION);
			
			bezierBlue = bezier;
			bezier = undefined;
			
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
			setTestPosition(200,300,400,500,500,600,600,100,400,300,200,500);
			// setTestPosition(400,500,500,200,500,600,500,600,500,100,400,100);
							
			onPointMoved();
		}
		
		private function onKeyUpHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SPACE) {
				trace(getTestPosition());
			}
		}

		private function setTestPosition (s0x:Number, s0y:Number, c0x:Number, c0y:Number, e0x:Number, e0y:Number,
				s1x:Number, s1y:Number, c1x:Number, c1y:Number, e1x:Number, e1y:Number):void {

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
		private function getTestPosition ():String {
			return ""+[
			start.x,
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
			endGray.y
			];
		}

		
		override protected function onPointMoved(event:Event = undefined):void {
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

		protected function showBezierBezierIntersection(curve1:Bezier, curve2:Bezier):void {
			var time:Number;
			var isect:Intersection = curve1.intersectionBezier(curve2);
			if (isect) {
				for (var i:uint = 0;i < isect.currentTimes.length; i++) {
					time = isect.currentTimes[i];
					showIntersection(curve1.getPoint(time), false, time);
					time = isect.targetTimes[i];
					showIntersection(curve2.getPoint(time), true, time);
				}
			}
		}

		protected function showLineBezierIntersection(curve:Bezier, line:Line):void {
			var isect:Intersection = curve.intersectionLine(line);
			if (isect) {
				if (isect.currentTimes.length) {
					var time:Number = isect.currentTimes[0];
					showIntersection(curve.getPoint(time), false, time);
					time = isect.targetTimes[0];
					showIntersection(line.getPoint(time), true, time);
					
					if (isect.currentTimes.length > 1) {
						time = isect.currentTimes[1];
						showIntersection(curve.getPoint(time), false, time);
						time = isect.targetTimes[1];
						showIntersection(line.getPoint(time), true, time);
					}
				}
			}
		}

		protected function showLineLineIntersection(line1:Line, line2:Line):void {
			var isect:Intersection = line1.intersectionLine(line2);
			if (isect) {
				if (isect.currentTimes.length) {
					var time:Number = isect.currentTimes[0];
					showIntersection(line1.getPoint(time), false, time);
					time = isect.targetTimes[0];
					showIntersection(line2.getPoint(time), true, time);
				}
				/*
				var line:Line = Line(isect.coincidenceLine);
				if (line) {
					graphics.lineStyle(3, 0x0000FF, 1);
					drawLine(line); 
				}
				 */
			}
		}

		protected function showIntersection(point:Point, small:Boolean, time:Number):DragPoint {
			if (point is Point) {
				var intersection:DragPoint = new DragPoint();
				intersection.position = point;
				addChild(intersection);
				intersections.push(intersection);
				if (small) {
					intersection.radius -= 2;
				} else {
					intersection.pointName = "     t:" + time;
				}
				return intersection;
			}
			return null;
		}

		protected function removeIntersections():void {
			while(intersections.length) {
				var intersectionPoint:DragPoint = intersections.pop();
				removeChild(intersectionPoint);
			}
		}
	}
}