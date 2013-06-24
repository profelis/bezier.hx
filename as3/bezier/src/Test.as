package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;

	import howtodo.*;
	import howtodo.view.DragPoint;
	import howtodo.view.GridInput;
	import howtodo.view.SwitchButton;	

	[SWF(backgroundColor="0xFFFFFF")]

	public class Test extends Sprite {

		
		private var stepContainer : Sprite;

		private const constructors : Array = [Step01Building,
			Step02ClosestPoint,
			Step03EditDrag,
			Step04EmulationCubic,
			Step05SmoothCurve,
			Step06PointOnBezier,
			Step07PointOnCurve,
			Step08Bounce,
			Step09DashedLine,
			Step10Centroids,
			Step11Intersections,
			Step12GeometryProperties,
			Step13MovingRotating,
			Step14ClosestPointTimeTest,
			Step15IntersectionsTimeTest]; 

		private const switchButtonsTarget : Sprite = new Sprite();
		private const SPACE : uint = 5;

		public function Test() {
			initInstance();
		}

		private function initInstance() : void {
			initStage();
			initSwitchButtons();
			DragPoint.grid = 50;
			initGrid();
			
			showByFlashvars();
		}

		private function showByFlashvars() : void {
			var demoNum : Number = Number(stage.loaderInfo.parameters["demo"]);
			if (!isNaN(demoNum)) {
				try {
					var switchButton : SwitchButton = switchButtonsTarget.getChildAt(demoNum - 1) as SwitchButton;
					switchButton.onMouseClick(null);
				} catch (err : Error) {
				}
			}
		}

		private function initSwitchButtons() : void {
			addChild(switchButtonsTarget);
			switchButtonsTarget.x = 405;
			switchButtonsTarget.y = 5;
			
			var switchButton : SwitchButton = new SwitchButton(); 
			switchButtonsTarget.addChild(switchButton);
			switchButton.addEventListener(Event.CHANGE, onSwitchButtonChange);
			
			var prevButton : SwitchButton = switchButton;
			
			for (var i : uint = 1;i < constructors.length; i++) {
				switchButton = new SwitchButton(); 
				switchButtonsTarget.addChild(switchButton);
				switchButton.x = prevButton.x + prevButton.width + SPACE;
				prevButton = switchButton;
				switchButton.addEventListener(Event.CHANGE, onSwitchButtonChange);
			}
		}

		private function onSwitchButtonChange(event : Event) : void {
			const switchButton : SwitchButton = event.target as SwitchButton;
			if (switchButton != null) {
				var num : uint = switchButton.parent.getChildIndex(switchButton);
				showStep(num);
			}
		}

		private function initStage() : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 100;
						
			stage.addEventListener(Event.RESIZE, redrawGrid);
		}

		private function showStep(k : uint) : void {
			var StepConstructor : Class = constructors[k];
			if (StepConstructor == null) {
				return;
			}
			if (!isNaN(k)) {
				if (stepContainer) {
					removeChild(stepContainer);
					stepContainer = null;
				}
				stepContainer = new StepConstructor();
				addChildAt(stepContainer, 0);
			}
		}

		private function initGrid() : void {
			var gridTxt : GridInput = new GridInput();
			addChild(gridTxt);
			gridTxt.x = 5;
			gridTxt.y = 5;
			gridTxt.text = "grid step: " + DragPoint.grid;
			gridTxt.addEventListener(Event.CHANGE, onGridChange);
			redrawGrid();
		}

		private function onGridChange(event : Event) : void {
			redrawGrid();
		}

		private function redrawGrid(event : Event = null) : void {
			const gridStep : uint = DragPoint.grid;
			const gridWidth : uint = stage.stageWidth;
			const gridHeight : uint = stage.stageHeight;
			
			graphics.clear();
			graphics.lineStyle(0, 0xCCCCCC, 1);
			
			for (var pX : uint = 0;pX < gridWidth; pX += gridStep) {
				graphics.moveTo(pX, 0);
				graphics.lineTo(pX, gridHeight);
			}
			
			for (var pY : uint = 0;pY < gridHeight; pY += gridStep) {
				graphics.moveTo(0, pY);
				graphics.lineTo(gridWidth, pY);
			}
		}
		
//		protected function testBoundsIntersection():void {
//			var current:Rectangle = new Rectangle(100, 100, -20, -10);
//			var target:Rectangle = new Rectangle(100, 100, -20, -10);
//			Intersection.isIntersectionPossible(current, target);
//			target.x+=20;
//			Intersection.isIntersectionPossible(current, target);
//			
//			current = new Rectangle(100, 100, 100, 100);
//			target = new Rectangle(110, 110, 80, 80);
//			Intersection.isIntersectionPossible(current, target);
//			Intersection.isIntersectionPossible(target, current);
//		}
	}
}













