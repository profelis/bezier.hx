package howtodo.view;

import flash.text.TextFieldAutoSize;
import flash.text.TextField;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.events.Event;

class SwitchButton extends Sprite {
	public var text(getText, setText) : String;

	static var SWITCH_BUTTON_SELECT : String = "switchButtonSelect";
	static var SWITCH_BUTTON_EVENT : Event = new Event(SWITCH_BUTTON_SELECT);
	static var CHANGED_EVENT : Event = new Event(Event.CHANGE);
	var TEXT : TextField;
	public function new() {
		TEXT = new TextField();
		initInstance();
	}

	public function getText() : String {
		return TEXT.htmlText;
	}

	public function setText(value : String) : String {
		TEXT.htmlText = value;
		TEXT.x = (20 - TEXT.width) / 2;
		return value;
	}

	function initInstance() : Void {
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		redraw();
		initText();
	}

	function initText() : Void {
		addChild(TEXT);
		TEXT.mouseEnabled = false;
		TEXT.selectable = false;
		TEXT.multiline = false;
		TEXT.wordWrap = false;
		TEXT.autoSize = TextFieldAutoSize.LEFT;
	}

	function onAddedToStage(event : Event) : Void {
		parent.addEventListener(SWITCH_BUTTON_SELECT, onSwitchButtonSelect);
		addEventListener(MouseEvent.CLICK, onMouseClick);
		var num : UInt = parent.getChildIndex(this) + 1;
		text = num.toString();
	}

	function onRemovedFromStage(event : Event) : Void {
		parent.removeEventListener(SWITCH_BUTTON_SELECT, onSwitchButtonSelect);
	}

	function onSwitchButtonSelect(event : Event) : Void {
		if(!mouseEnabled)  {
			mouseEnabled = true;
			redraw();
		}
	}

	public function onMouseClick(event : MouseEvent) : Void {
		parent.dispatchEvent(SWITCH_BUTTON_EVENT);
		mouseEnabled = false;
		redraw();
		dispatchEvent(CHANGED_EVENT);
	}

	function redraw() : Void {
		var color : UInt = (mouseEnabled) ? 0xFFFFFF : 0xCCCCCC;
		graphics.clear();
		graphics.lineStyle(0, 0x999999, 1);
		graphics.beginFill(color, 1);
		graphics.drawRect(0, 0, 20, 20);
	}

}

