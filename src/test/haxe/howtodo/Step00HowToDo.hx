package howtodo;

class Step00HowToDo extends BezierUsage {

	static var DESCRIPTION : String = "Use 1-9 keys to view examples<BR/>Change grid step if needed";
	public function new() {
		super();
	}

	override function init() : Void {
		initDescription(DESCRIPTION);
	}

}

