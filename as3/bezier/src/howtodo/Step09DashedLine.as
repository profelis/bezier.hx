package howtodo {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Bezier;
	
	public class Step09DashedLine extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Dashed line</B><BR/><BR/>mouse wheel - change line length<BR/>shift+mouse wheel - change gap length<BR/>alt+mouse wheel - change speed";
		
		private static var MIN_LINE_LENGTH:uint = 1;
		private static var MIN_GAP_LENGTH:uint = 1;
		
		private var lineLength:Number = 50;
		private var gapLength:Number = 20;
		
		private var speed:Number = 0.25;
		private var shift:Number = 0;
		
		public function Step09DashedLine () {
			super();
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		override protected function init():void {
			super.init();
			initDescription(DESCRIPTION);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
		} 

		protected function onEnterFrameHandler(event:Event):void {
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000, 1);
			
			var step:Number = lineLength+gapLength;

			shift+=speed;
			shift=shift%step;
			var starts:Array = bezier.getTimesSequence(step, shift-step);
			var ends:Array = bezier.getTimesSequence(step, shift-step+lineLength);
			
			if (starts[0] > ends[0]) {
				starts.unshift(0);
			}

			for(var i:uint=0; i<starts.length; i++) {
				var startSegmentTime:Number = starts[i];
				var endSegmentTime:Number = ends[i];
				if (isNaN(endSegmentTime)) {
					endSegmentTime = 1;
				}
				var segment:Bezier = bezier.getSegment(startSegmentTime, endSegmentTime);
				drawBezier(segment);
			}
		}
		
		protected function onStageMouseWheel(event:MouseEvent):void {
			if (event.shiftKey) {
				gapLength+=event.delta;
				gapLength = Math.max(MIN_GAP_LENGTH, gapLength); 
			} else if (event.altKey) {
				speed+=event.delta/10;
			} else {
				lineLength+=event.delta;
				lineLength = Math.max(MIN_LINE_LENGTH, lineLength);
			}
		}

		
		
	}
}