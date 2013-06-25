/**
 * @author ivan.dembicki@gmail.com
 */
package howtodo;

import flash.geom.Line;
import flash.events.Event;
import flash.geom.Point;
import howtodo.view.DragPoint;

class Step10Centroids extends BezierUsage {

	static var DESCRIPTION : String = "<B>Centroids</B>";
	var internalCentroid : DragPoint;
	var externalCentroid : DragPoint;
	var triangleCentroid : DragPoint;
	var bezierAxis : Line;
	var midPoint : DragPoint;
	public function new() {
		internalCentroid = new DragPoint();
		externalCentroid = new DragPoint();
		triangleCentroid = new DragPoint();
		bezierAxis = new Line();
		midPoint = new DragPoint();
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		initCentroid(internalCentroid, "Gi");
		initCentroid(externalCentroid, "Ge");
		initCentroid(triangleCentroid, "Gt");
		initCentroid(midPoint, "M");
		onPointMoved();
	}

	function initCentroid(centroid : DragPoint, pointName : String) : Void {
		centroid.pointName = pointName;
		addChild(centroid);
	}

	function redraw() : Void {
		graphics.clear();
		graphics.lineStyle(0, 0x0000FF, 1);
		drawBezier(bezier);
		graphics.lineStyle(0, 0x0000FF, .3);
		drawLine(bezierAxis);
	}

	override function onPointMoved(event : Event = undefined) : Void {
		midPoint.position = Point.interpolate(bezier.start, bezier.end, 1 / 2);
		internalCentroid.position = bezier.internalCentroid;
		externalCentroid.position = bezier.externalCentroid;
		triangleCentroid.position = Point.interpolate(internalCentroid.position, externalCentroid.position, 2 / 3);
		bezierAxis.start = bezier.control;
		bezierAxis.end = midPoint.position;
		redraw();
	}

}

