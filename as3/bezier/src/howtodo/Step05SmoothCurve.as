package howtodo {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import howtodo.view.DragPoint;	

	public class Step05SmoothCurve extends BezierUsage {

		private static const DESCRIPTION:String = "<B>Multiple Bezier smooth connection</B><BR/><BR/>Drag points";	
		private const mouse:Point = new Point();
		protected var roupe:SmoothCurve;
		
		private const controls:Array = new Array();
		
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

		
		public function Step05SmoothCurve () {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void {
			init();
		}
		
		override protected function init():void {
			if (!stage) return; 
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
		
		private function mouseMoveHandler(event:MouseEvent):void {
			mouse.x = event.stageX;
			mouse.y = event.stageY;
		}
		protected function enterFrameHandler(event:Event):void {
			
			for (var i:uint=0, len:uint=controls.length; i<len; i++) {
				var point:RoupePoint = controls[i];
				point.updatePosition(mouse);
			}
			graphics.clear();
			graphics.lineStyle(0,0,1);
			roupe.draw(graphics);
		}
		
		protected function initRoupeControls(num:uint):void {
			var s:Point = start.point;
			var e:Point = end.point;
			
			var position:Point =  Point.interpolate(s, e, 1/(num+2));
			
			var roupePoint:RoupePoint = new RoupePoint(position.x, position.y, s);
			var previousPoint:RoupePoint = roupePoint;
			roupe.pushControl(roupePoint);
			controls[controls.length] = roupePoint;
			
			for (var i:uint=1; i<num-1; i++) {
				position =  Point.interpolate(s, e, (i+1)/(num+2));
				roupePoint = new RoupePoint(position.x, position.y, previousPoint);
				previousPoint.nextPoint = roupePoint;
				
				roupe.pushControl(roupePoint);
				controls[controls.length] = roupePoint;
				previousPoint = roupePoint;
			}
			roupePoint.nextPoint = end.point;
		}
		
		override protected function initControl(pt:DragPoint, color:uint = 0, pointName:String = ""):void {
			color, pointName;
			randomizePosition(pt);
			pt.dragable = true;
			addChild(pt);
		}
		
	}
}

import flash.geom.Point;

internal class RoupePoint extends Point {
	
	public var prevPoint:Point;
	public var nextPoint:Point;
	
	public var gravityX:Number = 0;
	public var gravityY:Number = 1;
	public var elasticity:Number = .3;
	public var friction:Number = .86;
	
	private var stepX:Number = 0;
	private var stepY:Number = 0;
	
	public function RoupePoint (ptX:Number=0, ptY:Number=0, prevPt:Point=null) {
		super(ptX, ptY);
		prevPoint = prevPt;
	}
	
	public function updatePosition (mouse:Point):void {
		mouse;
		var targetX:Number = (prevPoint.x+nextPoint.x)/2;
		stepX+= (targetX-x)*elasticity;
		stepX+=gravityX;
		stepX*=friction;
		
		x+=stepX;
		
		var targetY:Number = (prevPoint.y+nextPoint.y)/2;
		stepY+= (targetY-y)*elasticity;
		stepY+=gravityY;
		stepY*=friction;
		y+=stepY;
		
		
	}






}










