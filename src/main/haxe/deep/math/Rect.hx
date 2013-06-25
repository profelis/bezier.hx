package deep.math;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Rect {
	
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		
		set(x, y, width, height);
	}
	
	public var left(get, set):Float;
	public var right(get, set):Float;
	public var top(get, set):Float;
	public var bottom(get, set):Float;
	
	public var topLeft(get, never):Point;
	public var bottomRight(get, never):Point;
	
	inline function get_left():Float return x;
	inline function set_left(v:Float):Float {
		width -= v - x;
		return x = v;
	}
	inline function get_right():Float return x + width;
	inline function set_right(v:Float):Float {
		width = v - x;
		return v;
	}
	inline function get_top():Float return y;
	inline function set_top(v:Float):Float {
		height -= v - y;
		return y = v;
	}
	inline function get_bottom():Float return y + height;
	inline function set_bottom(v:Float):Float {
		height = v - y;
		return v;
	}
	
	inline function get_bottomRight() return new Point(x + width, y + height);
	inline function get_topLeft() return new Point(x, y);
	
	inline public function clone():Rect {
		return new Rect(x, y, width, height);
	}
	
	inline public function set(x:Float, y:Float, width:Float, height:Float):Void {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	public function intersects(b:Rect):Bool {
		
		var x0 = x < b.x ? b.x : x;
		var x1 = right > b.right ? b.right : right;
		
		if (x1 <= x0) return false;
		
		var y0 = y < b.y ? b.y : y;
		var y1 = bottom > b.bottom ? b.bottom : bottom;
		
		return y1 > y0;
	}
	
	public function toString() {
		return '{Rect x:$x, y:$y, w:$width, h:$height}';
	}
	
	#if flash || nme || openfl
	inline public function toGeomRect(out:flash.geom.Rectangle):flash.geom.Rectangle {
		if (out == null) 
			return new flash.geom.Rectangle(x, y, width, height);
		else {
			out.x = x;
			out.y = y;
			out.width = width;
			out.height = height;
			return out;
		}
	}
	
	inline public function fromGeomPoint(p:flash.geom.Rectangle):Point {
		x = p.x;
		y = p.y;
		width = p.width;
		height = p.height;
	}
	#end
	
}