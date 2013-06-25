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

@:meta(SWF(backgroundColor="0xFFFFFF"))
class Test extends Sprite {

	var stepContainer : Sprite;
	var constructors : Array<Dynamic>;
	var switchButtonsTarget : Sprite;
	var SPACE : UInt;
	public function new() {
		constructors = [Step01Building, Step02ClosestPoint, Step03EditDrag, Step04EmulationCubic, Step05SmoothCurve, Step06PointOnBezier, Step07PointOnCurve, Step08Bounce, Step09DashedLine, Step10Centroids, Step11Intersections, Step12GeometryProperties, Step13MovingRotating, Step14ClosestPointTimeTest, Step15IntersectionsTimeTest];
		switchButtonsTarget = new Sprite();
		SPACE = 5;
		initInstance();
	}

	function initInstance() : Void {
		initStage();
		initSwitchButtons();
		DragPoint.grid = 50;
		initGrid();
		showByFlashvars();
	}

	function showByFlashvars() : Void {
		var demoNum : Float = Std.parseFloat(stage.loaderInfo.parameters["demo"]) /* WARNING check type */;
		if(!Math.isNaN(demoNum))  {
			try {
				var switchButton : SwitchButton = try cast(switchButtonsTarget.getChildAt(demoNum - 1), SwitchButton) catch(e) null;
				switchButton.onMouseClick(null);
			}
			catch(err : Error){ };
		}
	}

	function initSwitchButtons() : Void {
		addChild(switchButtonsTarget);
		switchButtonsTarget.x = 405;
		switchButtonsTarget.y = 5;
		var switchButton : SwitchButton = new SwitchButton();
		switchButtonsTarget.addChild(switchButton);
		switchButton.addEventListener(Event.CHANGE, onSwitchButtonChange);
		var prevButton : SwitchButton = switchButton;
		var i : UInt = 1;
		while(i < constructors.length) {
			switchButton = new SwitchButton();
			switchButtonsTarget.addChild(switchButton);
			switchButton.x = prevButton.x + prevButton.width + SPACE;
			prevButton = switchButton;
			switchButton.addEventListener(Event.CHANGE, onSwitchButtonChange);
			i++;
		}
	}

	function onSwitchButtonChange(event : Event) : Void {
		var switchButton : SwitchButton = try cast(event.target, SwitchButton) catch(e) null;
		if(switchButton != null)  {
			var num : UInt = switchButton.parent.getChildIndex(switchButton);
			showStep(num);
		}
	}

	function initStage() : Void {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.frameRate = 100;
		stage.addEventListener(Event.RESIZE, redrawGrid);
	}

	function showStep(k : UInt) : Void {
		var StepConstructor : Class<Dynamic> = constructors[k];
		if(StepConstructor == null)  {
			return;
		}
		if(!Math.isNaN(k))  {
			if(stepContainer)  {
				removeChild(stepContainer);
				stepContainer = null;
			}
			stepContainer = new StepConstructor();
			addChildAt(stepContainer, 0);
		}
	}

	function initGrid() : Void {
		var gridTxt : GridInput = new GridInput();
		addChild(gridTxt);
		gridTxt.x = 5;
		gridTxt.y = 5;
		gridTxt.text = "grid step: " + DragPoint.grid;
		gridTxt.addEventListener(Event.CHANGE, onGridChange);
		redrawGrid();
	}

	function onGridChange(event : Event) : Void {
		redrawGrid();
	}

	function redrawGrid(event : Event = null) : Void {
		var gridStep : UInt = DragPoint.grid;
		var gridWidth : UInt = stage.stageWidth;
		var gridHeight : UInt = stage.stageHeight;
		graphics.clear();
		graphics.lineStyle(0, 0xCCCCCC, 1);
		var pX : UInt = 0;
		while(pX < gridWidth) {
			graphics.moveTo(pX, 0);
			graphics.lineTo(pX, gridHeight);
			pX += gridStep;
		}
		var pY : UInt = 0;
		while(pY < gridHeight) {
			graphics.moveTo(0, pY);
			graphics.lineTo(gridWidth, pY);
			pY += gridStep;
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

