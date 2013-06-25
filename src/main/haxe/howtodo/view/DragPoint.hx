package howtodo.view;

import deep.math.Point;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

@:meta(Event(name="change",type="flash.events.Event"))
class DragPoint extends Sprite {
	
	public var position(get, set) : Point;
	public var dragable(get, set) : Bool;
	public var textColor(get, set) : UInt;
	public var pointName(get, set) : String;
	public var textPosition(never, set) : UInt;
	public var radius(get, set) : Float;
	public var borderColor(get, set) : Int;
	public var bodyColor(get, set) : Int;

	static public var grid : UInt = 100;
	static var __last_selected : DragPoint;
	public var point : Point;
	var change : Event;
	var __radius : Float;
	var __borderColor : Int;
	var __bodyColor : Int;
	var __dragable : Bool;
	var nameTxt : TextField;
	
	public function new() {
		super();
		point = new Point();
		change = new Event(Event.CHANGE);
		__radius = 4;
		__borderColor = 0x000000;
		__bodyColor = 0xFFFFFF;
		__dragable = false;
		nameTxt = new TextField();
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		dragable = false;
		initNameTxt();
		redraw();
	}

	public function initNameTxt() : Void {
		nameTxt.autoSize = TextFieldAutoSize.LEFT;
		var space : UInt = 2;
		nameTxt.x = __radius + space;
		nameTxt.y = __radius + space - 20;
		nameTxt.selectable = false;
		nameTxt.mouseEnabled = false;
	}

	public function onMouseDownHandler(event : MouseEvent) : Void {
		if(__dragable)  {
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			if(__last_selected != null)  {
				__last_selected.onDeselect();
			}
			__last_selected = this;
			__last_selected.onSelect();
		}
	}

	public function onMouseUpHandler(event : MouseEvent) : Void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
	}

	public function onMouseMoveHandler(event : MouseEvent) : Void {
		var tmpX : Float = point.x;
		var tmpY : Float = point.y;
		var newX : Float = Math.round(event.stageX / grid) * grid;
		var newY : Float = Math.round(event.stageY / grid) * grid;
		if(tmpX != newX || tmpY != newY)  {
			point.x = newX;
			super.x = newX;
			point.y = newY;
			super.y = newY;
			dispatchEvent(change);
		}
	}

	public function get_position() : Point {
		return point.clone();
	}

	public function set_position(value : Point) : Point {
		point.x = value.x;
		super.x = value.x;
		point.y = value.y;
		super.y = value.y;
		return value;
	}

	@:setter(x) public function setX(value : Float) {
		point.x = value;
		super.x = value;
	}

	@:setter(y) public function setY(value : Float) {
		point.y = value;
		super.y = value;
	}

	public function get_dragable() : Bool {
		return __dragable;
	}

	public function set_dragable(value : Bool) : Bool {
		buttonMode = useHandCursor = mouseEnabled = __dragable = value;
		return value;
	}

	public function get_textColor() : UInt {
		return nameTxt.textColor;
	}

	public function set_textColor(value : UInt) : UInt {
		nameTxt.textColor = value;
		return value;
	}

	public function get_pointName() : String {
		return nameTxt.text;
	}

	public function set_pointName(value : String) : String {
		nameTxt.htmlText = value;
		if(value.length != 0)  {
			addChild(nameTxt);
		}

		else if(nameTxt.parent != null)  {
			removeChild(nameTxt);
		}
		return value;
	}

	public function set_textPosition(value : UInt) : UInt {
		var space : UInt = 2;
		switch(value) {
		case 1:
			nameTxt.x = __radius + space;
			nameTxt.y = __radius - space;
		case 2:
			nameTxt.x = -(__radius + space + nameTxt.width);
			nameTxt.y = __radius - space;
		case 3:
			nameTxt.x = -(__radius + space + nameTxt.width);
			nameTxt.y = __radius + space - 20;
		default:
			nameTxt.x = __radius + space;
			nameTxt.y = __radius + space - 20;
		}
		return value;
	}

	public function get_radius() : Float {
		return __radius;
	}

	public function set_radius(value : Float) : Float {
		__radius = value;
		redraw();
		return value;
	}

	public function get_borderColor() : Int {
		return __borderColor;
	}

	public function set_borderColor(value : Int) : Int {
		__borderColor = value;
		redraw();
		return value;
	}

	public function get_bodyColor() : Int {
		return __bodyColor;
	}

	public function set_bodyColor(value : Int) : Int {
		__bodyColor = value;
		redraw();
		return value;
	}

	function onSelect() : Void {
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	function onDeselect() : Void {
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	function onKeyDown(event : KeyboardEvent) : Void {
		if(event.keyCode > 36 && event.keyCode < 41)  {
			var step : UInt = 1;
			if(event.ctrlKey)  {
				step = 10;
			}
			var _sw0_ = (event.keyCode);
			switch(_sw0_) {
			case 37:
				x -= step;
			case 38:
				y -= step;
			case 39:
				x += step;
			case 40:
				y += step;
			}
			x = Std.int(x / step) * step;
			y = Std.int(y / step) * step;
			dispatchEvent(change);
		}
	}

	function redraw() : Void {
		graphics.clear();
		graphics.lineStyle(0, __borderColor, 1);
		graphics.beginFill(__bodyColor, .5);
		graphics.drawCircle(0, 0, __radius);
	}

	override public function toString() : String {
		return "(x=" + Math.round(x * 100) / 100 + ",y=" + Math.round(y * 100) / 100 + ")";
	}

}

