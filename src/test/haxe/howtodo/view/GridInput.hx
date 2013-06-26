package howtodo.view;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

class GridInput extends TextField {

	var GRID_CHANGED : Event;
	
	public function new() {
		super();
		GRID_CHANGED = new Event(Event.CHANGE);
		initInstance();
	}

	function initInstance() : Void {
		type = TextFieldType.INPUT;
		border = true;
		borderColor = 0xCCCCCC;
		addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		restrict = "0-9";
		maxChars = 3;
		width = 80;
		height = 20;
	}

	function onFocusIn(event : FocusEvent) : Void {
		var currentGrid = DragPoint.grid != 0 ? DragPoint.grid : 10;
		text = Std.string(currentGrid);
		setSelection(0, 10);
		stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
	}

	function onStageMouseUp(event : MouseEvent) : Void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		setSelection(0, length);
	}

	function onFocusOut(event : FocusEvent) : Void {
		DragPoint.grid = Std.parseInt(text);
		if (DragPoint.grid == 0) DragPoint.grid = 10;
		if(DragPoint.grid > 100)  {
			DragPoint.grid = 100;
		}

		else if(DragPoint.grid < 10)  {
			DragPoint.grid = 10;
		}
		text = "grid step: " + DragPoint.grid;
		dispatchEvent(GRID_CHANGED);
	}

}

