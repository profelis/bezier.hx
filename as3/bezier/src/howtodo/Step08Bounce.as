package howtodo {
	import flash.events.Event;
	import flash.geom.Bezier;
	import flash.geom.Intersection;
	import flash.geom.Line;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import howtodo.view.DragPoint;	

	public class Step08Bounce extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Bounce: detect intersection (not finished methods)</B><BR/><BR/>drag control points";
		
		private const ball:DragPoint = new DragPoint();
		private const stageRectangle:Rectangle = new Rectangle();
		private const stepLine:Line = new Line();
		
		private var speedX:Number=0;
		private var speedY:Number=0;
		
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
		
		public function Step08Bounce () {
			super();
		}
		
		
		override protected function init():void {
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
		
		protected function onResize(event:Event=null):void {
			stageRectangle.width = stage.stageWidth;
			stageRectangle.height = stage.stageHeight;
		}
		
		protected function enterFrameHandler(event:Event):void {
			if (stageRectangle.containsPoint(ball.point)) {
				moveBall();
			} else {
				initBallMotion();
			}
		}
		
		private function initBallMotion ():void {
			ball.x = 1;
			ball.y = stageRectangle.height-1;
			speedX = 3; // Math.random()+10;
			speedY =-3; //Math.random()-11;
		}
		
		private function moveBall():void {
			stepLine.start = ball.position;
			ball.x+=speedX;
			ball.y+=speedY;
			stepLine.end = ball.position;
			var intersection:Intersection = bezier.intersectionLine(stepLine);
			if ((intersection)&&(intersection.currentTimes.length > 0)) 
			{
				// trace(intersection.currentTimes, intersection.oppositeTimes);
				var time:Number = intersection.currentTimes[0];
				var fulcrum:Point = bezier.getPoint(time);
				var tangentAngle:Number = bezier.getTangentAngle(time);
				
				var angleDist:Number = (tangentAngle-stepLine.angle)%Math.PI;
				
				graphics.lineStyle(0, 0x0000FF, 1);
				drawLine(stepLine);
				stepLine.angleOffset(angleDist*2, fulcrum);
				graphics.lineStyle(0, 0x00FF00, 1) ; 
				drawLine(stepLine);
				
				speedX=stepLine.end.x - stepLine.start.x; 
				speedY=stepLine.end.y - stepLine.start.y;
				ball.x = stepLine.end.x;
				ball.y = stepLine.end.y;
			}
		}
		
		override protected function onPointMoved(event:Event=null):void {
			redraw();
			
		}
		
		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000, 1);
			drawBezier(bezier);
			graphics.lineStyle(0, 0xFF0000, .3);
			drawRectangle(bezier.bounds);
			
			drawRectangle(stepLine.bounds);
		}
		
		
		
		
		
	}
}