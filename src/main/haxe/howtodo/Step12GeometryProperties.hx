/**

 * @example

 * Синим цветом обозначена кривая Безье, ограниченная точками start, end, а также линия до ближайшей точки на ней. Свойство <code>isSegment=true;</code> <BR/>

 * Красным цветом обозначена неограниченная кривая, а также линия до ближайшей точки на ней. Свойство <code>isSegment=false;</code>

 * <P><a name="closest_point_demo"></a>

 * <table width="100%" border=1><td>

 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"

 *			id="Step1Building" width="100%" height="500"

 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">

 *			<param name="movie" value="../images/Step02ClosestPoint.swf" />

 *			<param name="quality" value="high" />

 *			<param name="bgcolor" value="#FFFFFF" />

 *			<param name="allowScriptAccess" value="sameDomain" />

 *			<embed src="../images/Step02ClosestPoint.swf" quality="high" bgcolor="#FFFFFF"

 *				width="100%" height="400" name="Step1Building"

 * 				align="middle"

 *				play="true"

 *				loop="false"

 *				quality="high"

 *				allowScriptAccess="sameDomain"

 *				type="application/x-shockwave-flash"

 *				pluginspage="http://www.adobe.com/go/getflashplayer">

 *			</embed>

 *	</object>

 * 	</td></table>

 * </P>

 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR>

 * <I>Перемещайте мышью контрольные точки кривой.</I></P>

 * <BR/>

 * 

 **/
package howtodo;

import flash.text.TextFieldAutoSize;
import flash.text.TextField;
import flash.events.MouseEvent;
import bezier.Bezier;
import bezier.Line;
import deep.math.Point;
import howtodo.view.DragPoint;

class Step12GeometryProperties extends BezierUsage {

	static var DESCRIPTION : String = "<B>Geometry properties</B>";
	var closestPoint : DragPoint;
	var diagonalPoint : DragPoint;
	var parabolaVertexPoint : DragPoint;
	var parabolaFocusPoint : DragPoint;
	var mouse : Point;
	var curveLengthText : TextField;
	var curveFormText : TextField;
	var areaText : TextField;
	public function new() {
		closestPoint = new DragPoint();
		diagonalPoint = new DragPoint();
		parabolaVertexPoint = new DragPoint();
		parabolaFocusPoint = new DragPoint();
		mouse = new Point();
		curveLengthText = new TextField();
		curveFormText = new TextField();
		areaText = new TextField();
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		start.x = 250;
		start.y = 500;
		control.x = 200;
		control.y = 300;
		end.x = 550;
		end.y = 350;
		addTextField(curveLengthText, 100, 80);
		addTextField(curveFormText, 100, 105);
		addTextField(areaText, 100, 130);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		redraw();
		addChild(closestPoint);
		addChild(diagonalPoint);
		addChild(parabolaVertexPoint);
		addChild(parabolaFocusPoint);
	}

	function addTextField(textField : TextField, x : Float, y : Float) : Void {
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

	function onMouseMoveHandler(?event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
		redraw();
	}

	function redraw() : Void {
		bezier.isSegment = false;
		var closestPointTime : Float = bezier.getClosest(mouse);
		closestPoint.position = bezier.getPoint(closestPointTime);
		closestPoint.pointName = "closest";
		var oppositeControl : Point = new Point(bezier.start.x - bezier.control.x + bezier.end.x, bezier.start.y - bezier.control.y + bezier.end.y);
		diagonalPoint.position = oppositeControl;
		diagonalPoint.pointName = "diagonal";
		parabolaVertexPoint.position = bezier.getPoint(bezier.parabolaVertex);
		parabolaVertexPoint.pointName = "vertex";
		parabolaFocusPoint.position = bezier.parabolaFocus;
		parabolaFocusPoint.pointName = "focus";
		var curveText : String = "bezier is simple convex curve";
		var curveAsPoint : Point = bezier.asPoint();
		var curveAsLine : Line = bezier.asLine();
		if(curveAsPoint != null)  {
			curveText = "bezier is point";
		}
		if(curveAsLine != null)  {
			if(curveAsLine.isRay)  {
				curveText = "bezier is ray";
			}

			else  {
				curveText = "bezier is line";
			}

		}
		curveFormText.text = curveText;
		graphics.clear();
		// рисуем кривую
		graphics.lineStyle(1, 0xFF0000, 0.5);
		drawBezier(bezier.getSegment(-2, 3));
		// рисуем основные вектора
		graphics.lineStyle(0, 0x00FF00, 0.5);
		var startToControlVector : Point = new Point(bezier.control.x - bezier.start.x, bezier.control.y - bezier.start.y);
		var startToEndVector : Point = new Point(bezier.end.x - bezier.start.x, bezier.end.y - bezier.start.y);
		var diagonalVector : Point = new Point(bezier.start.x - 2 * bezier.control.x + bezier.end.x, bezier.start.y - 2 * bezier.control.y + bezier.end.y);
		var controlToEndVector : Point = new Point(bezier.end.x - bezier.control.x, bezier.end.y - bezier.control.y);
		drawLine(new Line(bezier.start, bezier.start.add(startToEndVector)));
		drawLine(new Line(bezier.start, bezier.start.add(startToControlVector)));
		drawLine(new Line(bezier.start, oppositeControl));
		drawLine(new Line(bezier.control, bezier.control.add(controlToEndVector)));
		drawLine(new Line(bezier.control, bezier.control.add(diagonalVector)));
		drawLine(new Line(bezier.end, oppositeControl));
		// рисуем площадь кривой и равновеликий ей прямоугольник
		graphics.lineStyle(0, 0x000000, 0);
		graphics.beginFill(0xFF0000, 0.2);
		drawBezier(bezier);
		graphics.lineTo(bezier.start.x, bezier.start.y);
		graphics.endFill();
		graphics.beginFill(0xFF0000, 0.2);
		graphics.drawRect(100, 150, bezier.area / 50, 50);
		graphics.endFill();
		areaText.text = "curve area " + bezier.area;
		// рисуем фрагмент кривой и равный ему по длине отрезок
		var curvePartLength : Float = bezier.getSegmentLength(closestPointTime);
		graphics.lineStyle(1, 0x0000FF, 1);
		drawBezier(bezier.getSegment(0, closestPointTime));
		var lineLikeCurveLength : Line = new Line(new Point(100, 100), new Point(200, 100));
		lineLikeCurveLength.length = curvePartLength;
		graphics.lineStyle(2, 0x0000FF, 1);
		drawLine(lineLikeCurveLength);
		curveLengthText.text = "curve length " + curvePartLength;
	}

}

