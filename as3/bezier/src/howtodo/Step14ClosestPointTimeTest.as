package howtodo {
	import howtodo.view.DragPoint;

	import flash.events.MouseEvent;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;	

	public class Step14ClosestPointTimeTest extends BezierUsage {

		private static const DESCRIPTION : String = "<B>Closest point time test</B><BR/> every frame does 1000 closest point searches";

		private const closestPoint : DragPoint = new DragPoint();
		private const mouse : Point = new Point();
		private var fpsTextField : TextField = new TextField();

		public function Step14ClosestPointTimeTest() {
			super();
		}

		override protected function init() : void {
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

		private function updateOutText(time : Number) : void {
			fpsTextField.text = "50000 iterations duration - " + time + "milliseconds\n" + (time / 1000) + " milliseconds spent on single method call";
		}

		private function addTextField(textField : TextField, x : Number, y : Number) : void {
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

		private function onMouseMoveHandler(event : MouseEvent = undefined) : void {
			mouse.x = event.stageX;
			mouse.y = event.stageY;
			redraw();
		}

		private function redraw() : void {	
			var closestTime : Number;

			var calculationTime : Number = getTimer();
			for(var i : int = 0;i < 50000; i++) {
				closestTime = bezier.getClosest(mouse);		
			}
			calculationTime = getTimer() - calculationTime;
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
}