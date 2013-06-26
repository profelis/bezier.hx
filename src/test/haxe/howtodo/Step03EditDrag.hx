package howtodo;

import flash.events.Event;
import flash.events.MouseEvent;
import deep.math.Point;

class Step03EditDrag extends BezierUsage {

	static var DESCRIPTION : String = "<B>Edit drag</B><BR/><BR/>drag curve to change";
	var mouse : Point;
	var dragTime : Float;
	/**	

	 * @example

	 * Демонстрация редактирования кривой Безье второго порядка.<BR/>

	 * <table width="100%" border=1><td>

	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"

	 *			id="Step1Building" width="100%" height="500"

	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">

	 *			<param name="movie" value="../images/Step03EditDrag.swf" />

	 *			<param name="quality" value="high" />

	 *			<param name="bgcolor" value="#FFFFFF" />

	 *			<param name="allowScriptAccess" value="sameDomain" />

	 *			<embed src="../images/Step03EditDrag.swf" quality="high" bgcolor="#FFFFFF"

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

	 * <I>Изменяйте кривую Безье мышью</I><BR/>

	 **/
	public function new() {
		mouse = new Point();
		super();
	}

	override function init() : Void {
		super.init();
		initDescription(DESCRIPTION);
		buttonMode = true;
		useHandCursor = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		redraw();
	}

	function onMouseDownHandler(?event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
		dragTime = bezier.getClosest(mouse);
		if(dragTime < .1 || dragTime > .9)  {
			return;
		}
		var closest : Point = bezier.getPoint(dragTime);
		var distance : Float = Point.distance(closest, mouse);
		if(distance < 5)  {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
	}

	function onMouseUpHandler(?event : MouseEvent) : Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
	}

	function onMouseMoveHandler(?event : MouseEvent) : Void {
		mouse.x = event.stageX;
		mouse.y = event.stageY;
		bezier.setPoint(dragTime, mouse.x, mouse.y);
		control.position = bezier.control;
		redraw();
	}

	function redraw() : Void {
		graphics.clear();
		graphics.lineStyle(5, 0x0000FF, 0);
		drawBezier(bezier);
		graphics.lineStyle(0, 0x0000FF, 1);
		drawBezier(bezier);
	}

	override function onPointMoved(?event : Event) : Void {
		redraw();
	}

}

