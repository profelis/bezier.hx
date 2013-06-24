package howtodo 
{
	import howtodo.view.DragPoint;

	import flash.events.MouseEvent;
	import flash.geom.Bezier;
	import flash.geom.Point;		

	public class Step13MovingRotating extends BezierUsage 
	{

		private static const DESCRIPTION : String = "<B>Moving and rotating</B><BR>Drag fulcrum point for bezier offset<BR>rotate mouse wheel for bezier rotating";

		private const fulcrum : DragPoint = new DragPoint();	
		private var lastFulcrumPosition : Point = null;	

		public function Step13MovingRotating() 
		{
			super();
		}

		override protected function init() : void 
		{
			super.init();
			initDescription(DESCRIPTION);
			
			start.x = 250;
			start.y = 500;
			control.x = 200;
			control.y = 300;
			end.x = 550;
			end.y = 350;
			
			fulcrum.dragable = true;
			fulcrum.pointName = "fulcrum";
			fulcrum.position = bezier.internalCentroid;
			addChild(fulcrum);
			
			redraw();
			
			fulcrum.addEventListener(MouseEvent.MOUSE_DOWN, onFulcrumMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
		} 

		private function redraw() : void 
		{					
			graphics.clear();
			
			// рисуем кривую
			graphics.lineStyle(1, 0xFF0000, 0.5);
			drawBezier(bezier);					
		}

		public function onFulcrumMouseDownHandler(event : MouseEvent) : void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onFulcrumMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onFulcrumMouseMoveHandler);
				
			lastFulcrumPosition = fulcrum.position.clone();
		}

		public function onFulcrumMouseUpHandler(event : MouseEvent) : void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onFulcrumMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onFulcrumMouseMoveHandler);
		}

		public function onFulcrumMouseMoveHandler(event : MouseEvent) : void 
		{
			bezier.offset(fulcrum.position.x - lastFulcrumPosition.x, fulcrum.position.y - lastFulcrumPosition.y);
			start.position = bezier.start;
			control.position = bezier.control;
			end.position = bezier.end;	
			lastFulcrumPosition = fulcrum.position.clone();
			
			redraw();
		}

		private function onMouseMoveHandler(event : MouseEvent) : void 
		{						
			redraw();
		}

		protected function onStageMouseWheel(event : MouseEvent) : void 
		{
			
			bezier.angleOffset(event.delta / 100, fulcrum.position);
			start.position = bezier.start;
			control.position = bezier.control;
			end.position = bezier.end;			
			
			redraw();
		}
	}
}