package howtodo;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import deep.math.Point;
import howtodo.view.DragPoint;

class Step05SmoothCurve extends BezierUsage {

	static var DESCRIPTION : String = "<B>Multiple Bezier smooth connection</B><BR/><BR/>Drag points";
	var mouse : Point;
	var roupe : SmoothCurve;
	var controls : Array<Dynamic>;
	/**	

	 * Гладкая состыковка кривых Безье.<BR/>

	 * @example

	 * <table width="100%" border=1><td>

	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"

	 *			id="Step1Building" width="100%" height="500"

	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">

	 *			<param name="movie" value="../images/Step05SmoothCurve.swf" />

	 *			<param name="quality" value="high" />

	 *			<param name="bgcolor" value="#FFFFFF" />

	 *			<param name="allowScriptAccess" value="sameDomain" />

	 *			<embed src="../images/Step05SmoothCurve.swf" quality="high" bgcolor="#FFFFFF"

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
		super();
		mouse = new Point();
		controls = new Array<Dynamic>();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	override function onAddedToStage(event : Event) : Void {
		init();
	}

	override function init() : Void {
		if(stage == null) return;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		initDescription(DESCRIPTION);
		roupe = new SmoothCurve(start.point, end.point);
		initControl(start);
		initControl(end);
		start.pointName = "S";
		end.pointName = "E";
		initRoupeControls(10);
	}

	function mouseMoveHandler(event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
	}

	function enterFrameHandler(event : Event) : Void {
		var i : UInt = 0;
		var len : UInt = controls.length;
		while(i < len) {
			var point : RoupePoint = controls[i];
			point.updatePosition(mouse);
			i++;
		}
		graphics.clear();
		graphics.lineStyle(0, 0, 1);
		roupe.draw(graphics);
	}

	function initRoupeControls(num : UInt) : Void {
		var s : Point = start.point;
		var e : Point = end.point;
		var position : Point = Point.interpolate(s, e, 1 / (num + 2));
		var roupePoint : RoupePoint = new RoupePoint(position.x, position.y, s);
		var previousPoint : RoupePoint = roupePoint;
		roupe.pushControl(roupePoint);
		controls[controls.length] = roupePoint;
		var i : UInt = 1;
		while(i < num - 1) {
			position = Point.interpolate(s, e, (i + 1) / (num + 2));
			roupePoint = new RoupePoint(position.x, position.y, previousPoint);
			previousPoint.nextPoint = roupePoint;
			roupe.pushControl(roupePoint);
			controls[controls.length] = roupePoint;
			previousPoint = roupePoint;
			i++;
		}
		roupePoint.nextPoint = end.point;
	}

	override function initControl(pt : DragPoint, color : UInt = 0, pointName : String = "") : Void {
		color;
		pointName;
		randomizePosition(pt);
		pt.dragable = true;
		addChild(pt);
	}

}

class RoupePoint extends Point {

	public var prevPoint : Point;
	public var nextPoint : Point;
	public var gravityX : Float;
	public var gravityY : Float;
	public var elasticity : Float;
	public var friction : Float;
	var stepX : Float;
	var stepY : Float;
	public function new(ptX : Float = 0, ptY : Float = 0, prevPt : Point = null) {
		gravityX = 0;
		gravityY = 1;
		elasticity = .3;
		friction = .86;
		stepX = 0;
		stepY = 0;
		super(ptX, ptY);
		prevPoint = prevPt;
	}

	public function updatePosition(mouse : Point) : Void {
		mouse;
		var targetX : Float = (prevPoint.x + nextPoint.x) / 2;
		stepX += (targetX - x) * elasticity;
		stepX += gravityX;
		stepX *= friction;
		x += stepX;
		var targetY : Float = (prevPoint.y + nextPoint.y) / 2;
		stepY += (targetY - y) * elasticity;
		stepY += gravityY;
		stepY *= friction;
		y += stepY;
	}

}

