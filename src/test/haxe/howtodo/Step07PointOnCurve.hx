package howtodo;

import flash.events.Event;
import howtodo.view.DragPoint;

class Step07PointOnCurve extends Step05SmoothCurve {

	static var DESCRIPTION : String = "<B>Distance by curve</B><BR/><BR/>uniform motion by curve";
	var point : DragPoint;
	var distance : Float;
	/**	
	 * Получение точки по дистанции по кривой<BR/>
	 * @example
	 * <table width="100%" border=1><td>
	 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../images/Step07PointOnCurve.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../images/Step07PointOnCurve.swf" quality="high" bgcolor="#FFFFFF"
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
		addChild(point);
		initDescription(DESCRIPTION);
	}

	override function enterFrameHandler(event : Event) : Void {
		super.enterFrameHandler(event);
		distance += 1;
		distance = distance % roupe.length;
		point.position = roupe.getPointByDistance(distance);
	}

}

