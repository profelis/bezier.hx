package howtodo {
	import flash.geom.Line;	
	import flash.events.Event;
	import flash.geom.Point;
	
	import howtodo.view.DragPoint;	

	/**
	 * @author ivan.dembicki@gmail.com
	 */
	public class Step10Centroids extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Centroids</B>";
		
		protected const internalCentroid:DragPoint = new DragPoint();
		protected const externalCentroid:DragPoint = new DragPoint();
		protected const triangleCentroid:DragPoint = new DragPoint();
		
		protected const bezierAxis : Line = new Line();
		
		protected const midPoint:DragPoint = new DragPoint();
		
		public function Step10Centroids() {
			super();
		}
		
		override protected function init() : void {
			super.init();
			initDescription(DESCRIPTION);
			
			initCentroid(internalCentroid, "Gi");
			initCentroid(externalCentroid, "Ge");
			initCentroid(triangleCentroid, "Gt");
			initCentroid(midPoint, "M");
			
			onPointMoved();
		}
		
		private function initCentroid(centroid:DragPoint, pointName:String) : void {
			centroid.pointName = pointName;
			addChild(centroid);
		}

		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, 0x0000FF, 1);
			drawBezier(bezier);
			
			graphics.lineStyle(0, 0x0000FF, .3);
			drawLine(bezierAxis);
		}
		
		override protected function onPointMoved(event:Event=undefined):void {
			midPoint.position = Point.interpolate(bezier.start, bezier.end, 1/2);
			
			internalCentroid.position = bezier.internalCentroid;
			externalCentroid.position = bezier.externalCentroid;
			
			triangleCentroid.position = Point.interpolate(internalCentroid.position, externalCentroid.position, 2/3);
			
			bezierAxis.start = bezier.control;
			bezierAxis.end = midPoint.position;
			
			
			
			redraw();
		}

		
		
	}
}
