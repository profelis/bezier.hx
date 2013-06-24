package howtodo.view {
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextField;	
	import flash.events.MouseEvent;	
	import flash.display.Sprite;
	import flash.events.Event;	

	public class SwitchButton extends Sprite {
		
		private static const SWITCH_BUTTON_SELECT:String = "switchButtonSelect";
		private static const SWITCH_BUTTON_EVENT:Event = new Event(SWITCH_BUTTON_SELECT);
		private static const CHANGED_EVENT:Event = new Event(Event.CHANGE);
		
		private const TEXT : TextField = new TextField();
		
		public function SwitchButton() {
			initInstance();
		}
		
		public function get text() : String {
			return TEXT.htmlText;
		}
		public function set text(value : String):void {
			TEXT.htmlText = value;
			TEXT.x = (20 - TEXT.width)/2;
		}
		
		private function initInstance() : void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			redraw();
			initText();
		}
		
		private function initText() : void {
			addChild(TEXT);
			TEXT.mouseEnabled = false;
			TEXT.selectable = false;
			TEXT.multiline = false;
			TEXT.wordWrap = false;
			TEXT.autoSize = TextFieldAutoSize.LEFT;
		}

		private function onAddedToStage(event : Event) : void {
			parent.addEventListener(SWITCH_BUTTON_SELECT, onSwitchButtonSelect);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			var num:uint = parent.getChildIndex(this)+1;
			text = num.toString();
		}
		
		private function onRemovedFromStage(event : Event) : void {
			parent.removeEventListener(SWITCH_BUTTON_SELECT, onSwitchButtonSelect);
		}

		private function onSwitchButtonSelect(event : Event) : void {
			if (!mouseEnabled) {
				mouseEnabled = true;
				redraw();
			}
		}
		
		public function onMouseClick(event : MouseEvent) : void {
			parent.dispatchEvent(SWITCH_BUTTON_EVENT);
			mouseEnabled = false;
			redraw();
			dispatchEvent(CHANGED_EVENT);
		}
		
		private function redraw() : void {
			const color:uint = mouseEnabled ? 0xFFFFFF : 0xCCCCCC;
			graphics.clear();
			graphics.lineStyle(0, 0x999999, 1);
			graphics.beginFill(color, 1);
			graphics.drawRect(0, 0, 20, 20);
		}
	}
}
