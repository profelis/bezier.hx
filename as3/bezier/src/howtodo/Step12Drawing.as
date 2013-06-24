package howtodo {
	import flash.geom.Point;	
	
	import howtodo.view.DragPoint;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Bezier;
	import flash.geom.IParametric;
	import flash.geom.Line;	

	public class Step12Drawing extends Sprite {

		private const lines : Array = [];
		private var speed : Number = 5;
		private var drawLength : Number = 0;

		public function Step12Drawing() {
			super();
			initInstance();
		}

		private function initInstance() : void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		

		private function onAddedToStage(event : Event) : void {
			initRandomShape();
		}
		
		private function onRemovedFromStage(event : Event) : void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event : Event) : void {
			drawLength += speed;
			
			var linesLength : Number = 0;
			var shapeNum : int = 0;
			
			graphics.clear();
			graphics.lineStyle(0, 0, .2);
			
			var line : IParametric;
			while (true) {
				line = lines[shapeNum++];
				if (!line) {
					break;
				}
				drawLine(line);
			}
			
			graphics.lineStyle(3, 0xFF0000, 1);
			
			shapeNum = 0;
			while (true) {
				line = lines[shapeNum++];
				if (!line) {
					drawLength = 0;
					return;
				}
				if (drawLength > linesLength + line.length) {
					drawLine(line);
				} else {
					var endPointTime:Number = line.getTimeByDistance(drawLength - linesLength);
					var endBezier:Bezier = line as Bezier;
					var endLine:Line = line as Line;
					if (endBezier) {
						drawLine(endBezier.getSegment(0, endPointTime));
					} else if (endLine) {
						drawLine(endLine.getSegment(0, endPointTime));
					}
					return;
				}
				linesLength += line.length;
			}
		}
		
		private function initRandomShape() : void {
			var line : IParametric;
			
			var start : DragPoint;
			var control : DragPoint;
			var end : DragPoint = createRandomPoint();
			
			const totalLines : int = 10 + Math.random() * 5;
			while (totalLines--) {
				start = end;
				end = createRandomPoint();
				
				if (Math.random() > .5) {
					control = createRandomPoint(true);
					line = new Bezier(start.point, control.point, end.point);
				} else {
					line = new Line(start.point, end.point);
				}
				lines.push(line);
			}
			// 
			var startPoint:Point = end.point;
			var endPoint:Point = lines[0].start;
			lines.push(new Line(startPoint, endPoint));
		}

		protected function createRandomPoint(isControl:Boolean = false) : DragPoint {
			const randomDragPoint : DragPoint = new DragPoint();
			if (isControl) {
				randomDragPoint.bodyColor = 0xCCCCCC;
			}
			randomDragPoint.dragable = true;
			randomDragPoint.x = Math.round(Math.random() * stage.stageWidth);
			randomDragPoint.y = Math.round(Math.random() * (stage.stageHeight - 100)) + 100;
			addChild(randomDragPoint);
			return randomDragPoint;
		}
		
		private function drawLine(line : IParametric) : void {
			if (!line) {
				return;
			}
			graphics.moveTo(line.start.x, line.start.y);
			var bezier : Bezier = line as Bezier;
			if (bezier) {
				graphics.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
			} else {
				graphics.lineTo(line.end.x, line.end.y);
			}
		}
		
		
	}
}
