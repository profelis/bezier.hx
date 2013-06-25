package howtodo;

import bezier.Intersection;
import flash.events.Event;
import bezier.Bezier;
import bezier.Line;
import deep.math.Point;
import deep.math.Rect;
import howtodo.view.DragPoint;

class Step08Bounce extends BezierUsage {

	static var DESCRIPTION : String = "<B>Bounce: detect intersection (not finished methods)</B><BR/><BR/>drag control points";
	var ball : DragPoint;
	var stageRectangle : Rect;
	var stepLine : Line;
	var speedX : Float;
	var speedY : Float;
	/**

	 * Нахождение пересечения и отскока.<BR/>

	 * @example

	 * <table width="100%" border=1><td>

	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"

	 *			id="Step1Building" width="100%" height="500"

	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">

	 *			<param name="movie" value="../images/Step08Bounce.swf" />

	 *			<param name="quality" value="high" />

	 *			<param name="bgcolor" value="#FFFFFF" />

	 *			<param name="allowScriptAccess" value="sameDomain" />

	 *			<embed src="../images/Step08Bounce.swf" quality="high" bgcolor="#FFFFFF"

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

	 * </td></table>

	 * <BR/>

	 **/
	public function new() {
		ball = new DragPoint();
		stageRectangle = new Rect();
		stepLine = new Line();
		speedX = 0;
		speedY = 0;
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		addChild(ball);
		ball.x = -1;
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		addEventListener(Event.RESIZE, onResize);
		start.x = 100;
		start.y = 100;
		control.x = 500;
		control.y = 300;
		end.x = 700;
		end.y = 700;
		bezier.isSegment = true;
		stepLine.isSegment = true;
		onResize();
		redraw();
	}

	function onResize(event : Event = null) : Void {
		stageRectangle.width = stage.stageWidth;
		stageRectangle.height = stage.stageHeight;
	}

	function enterFrameHandler(event : Event) : Void {
		if(stageRectangle.containsPoint(ball.point))  {
			moveBall();
		}

		else  {
			initBallMotion();
		}

	}

	function initBallMotion() : Void {
		ball.x = 1;
		ball.y = stageRectangle.height - 1;
		speedX = 3;
		// Math.random()+10;
		speedY = -3;
		//Math.random()-11;
	}

	function moveBall() : Void {
		stepLine.start = ball.position;
		ball.x += speedX;
		ball.y += speedY;
		stepLine.end = ball.position;
		var intersection : Intersection = bezier.intersectionLine(stepLine);
		if((intersection != null) && (intersection.currentTimes.length > 0))  {
			// trace(intersection.currentTimes, intersection.oppositeTimes);
			var time : Float = intersection.currentTimes[0];
			var fulcrum : Point = bezier.getPoint(time);
			var tangentAngle : Float = bezier.getTangentAngle(time);
			var angleDist : Float = (tangentAngle - stepLine.angle) % Math.PI;
			graphics.lineStyle(0, 0x0000FF, 1);
			drawLine(stepLine);
			stepLine.angleOffset(angleDist * 2, fulcrum);
			graphics.lineStyle(0, 0x00FF00, 1);
			drawLine(stepLine);
			speedX = stepLine.end.x - stepLine.start.x;
			speedY = stepLine.end.y - stepLine.start.y;
			ball.x = stepLine.end.x;
			ball.y = stepLine.end.y;
		}
	}

	override function onPointMoved(event : Event = null) : Void {
		redraw();
	}

	function redraw() : Void {
		graphics.clear();
		graphics.lineStyle(0, 0xFF0000, 1);
		drawBezier(bezier);
		graphics.lineStyle(0, 0xFF0000, .3);
		drawRectangle(bezier.bounds);
		drawRectangle(stepLine.bounds);
	}

}

