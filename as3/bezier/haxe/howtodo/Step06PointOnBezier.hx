package howtodo;

import flash.events.Event;
import howtodo.view.DragPoint;

class Step06PointOnBezier extends BezierUsage {

	static var DESCRIPTION : String = "<B>Distance by curve</B><BR/><BR/>uniform motion";
	var point : DragPoint;
	var distance : Float;
	/**	
	 * Получение точки по дистанции по кривой<BR/>
	 * @example
	 * <table width="100%" border=1><td>
	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../images/Step06PointOnBezier.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../images/Step06PointOnBezier.swf" quality="high" bgcolor="#FFFFFF"
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
	 **/
	public function new() {
		point = new DragPoint();
		distance = 0;
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		start.x = 100;
		start.y = 300;
		control.x = 300;
		control.y = 300;
		end.x = 700;
		end.y = 500;
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		addChild(point);
		redraw();
	}

	function enterFrameHandler(event : Event = undefined) : Void {
		distance += 1;
		updatePosition();
	}

	function updatePosition() : Void {
		var time : Float = bezier.getTimeByDistance(distance % bezier.length);
		point.position = bezier.getPoint(time);
	}

	override function onPointMoved(event : Event = undefined) : Void {
		redraw();
		updatePosition();
	}

	function redraw() : Void {
		graphics.clear();
		graphics.lineStyle(0, 0xFF0000, 1);
		drawBezier(bezier);
	}

}

