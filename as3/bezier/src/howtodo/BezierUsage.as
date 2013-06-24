package howtodo {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import howtodo.view.DragPoint;	

	public class BezierUsage extends Sprite {

		private var descriptionTxt:TextField;
		
		protected var start:DragPoint = new DragPoint();
		protected var control:DragPoint = new DragPoint();
		protected var end:DragPoint = new DragPoint();
		protected var bezier:Bezier = new Bezier(start.point, control.point, end.point);

		public function BezierUsage() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		};

		private function onAddedToStage(event:Event):void {
			init();
		}

		protected function init():void {
			initControl(start, 0, "S");
			initControl(control, 0, "C");
			initControl(end, 0, "E");
		}

		protected function initDescription(description:String):void {
			if (!descriptionTxt) {
				var txt:TextField = new TextField();
				txt.selectable = false;
				txt.wordWrap = false;
				txt.multiline = true;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.mouseEnabled = false;
				txt.mouseWheelEnabled = false;
				txt.x = 120;
				addChild(txt);
				descriptionTxt = txt;
			}
			descriptionTxt.htmlText = description;
		}

		protected function onPointMoved(event:Event = undefined):void {
			
		}

		protected function randomizePosition(obj:DisplayObject):void {
			obj.x = Math.round(Math.random()*stage.stageWidth);
			obj.y = Math.round(Math.random()*(stage.stageHeight-100))+100;
		}

		protected function initControl(pt:DragPoint, color:uint = 0, pointName:String = ""):void {
			randomizePosition(pt);
			pt.dragable = true;
			if (color) {
				pt.bodyColor = color;
			}
			if (name) {
				pt.pointName = pointName; 
				pt.textColor = color;
			}
			pt.addEventListener(Event.CHANGE, onPointMoved);
			addChild(pt);
		}

		protected function drawBezier(bezierCurve:Bezier, target:Graphics = null, continueDraw:Boolean = false):void {
			target = target || graphics;
			if (!continueDraw) {
				target.moveTo(bezierCurve.start.x, bezierCurve.start.y);
			}
			target.curveTo(bezierCurve.control.x, bezierCurve.control.y, bezierCurve.end.x, bezierCurve.end.y);
		}

		protected function drawLine(line:Line, target:Graphics = null, continueDraw:Boolean = false):void {
			target = target || graphics;
			if (!continueDraw) {
				target.moveTo(line.start.x, line.start.y);
			}
			target.lineTo(line.end.x, line.end.y);
		}

		protected function drawRectangle(rect:Rectangle, target:Graphics = null):void {
			target = target || graphics;
			target.drawRect(rect.x, rect.y, rect.width, rect.height);
		}

		protected function drawPoint(point:Point):void {
			graphics.moveTo(point.x, point.y);
			graphics.lineTo(point.x, point.y + .5);
		}

		protected function round(num:Number, order:uint = 2):Number {
			var n:uint = Math.pow(10, order);
			return Math.round(num*n)/n;
		}

		protected function removeObject(obj:DisplayObject):void {
			if (obj.parent) {
				obj.parent.removeChild(obj);
			}
		}
	}
}