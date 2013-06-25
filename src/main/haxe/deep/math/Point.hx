package deep.math;
import bezier.math.Equations;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class Point {
	
	public var x:Float;
	public var y:Float;
	
	public function new(x:Float = 0.0, y:Float = 0.0) {
		
		set(x, y);
	}
	
	public var length(get, never):Float;
	
	inline function get_length() {
		return len(x, y);
	}
	
	public var angle(get, never):Float;
	
	inline function get_angle() {
		return Equations.mathAtan2(x, y);
	}
	
	inline static function len(x:Float, y:Float):Float {
		if (x == 0 || y == 0) return x + y;
		else {
			var t = y / x;
			return Math.abs(x) * Math.sqrt(1 + t * t);
		}
	}
	
	inline public function sub(b:Point) {
		return new Point(x - b.x, y - b.y);
	}
	
	inline public function subEq(b:Point):Void {
		x -= b.x;
		y -= b.y;
	}
	
	inline public function add(b:Point) {
		return new Point(x + b.x, y + b.y);
	}
	
	inline public function addEq(b:Point):Void {
		x += b.x;
		y += b.y;
	}
	
	inline public function offset(dx:Float, dy:Float):Void {
		x += dx;
		y += dy;
	}
	
	inline public function set(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
	}
	
	inline public function normalize():Void {
		var l = length;
		if (l > Const.PRECISION) {
			x /= l;
			y /= l;
		}
	}
	
	public function equals(b:Point) {
		return x == b.x && y == b.y;
	}
	
	inline public function clone():Point {
		return new Point(x, y);
	}
	
	inline static public function distance(a:Point, b:Point) {
		return len(a.x - b.x, a.y - b.y);
	}
	
	inline static public function interpolate(a:Point, b:Point, f:Float) {
		return new Point(a.x + (b.x - a.x) * f, a.y + (b.y - a.y) * f);
	}
	
	inline static public function polar(len:Float, angle:Float):Point {
		return new Point(len * Math.cos(angle), len * Math.sin(angle));
	}
	
	public function toString() {
		return '{$x; $y}';
	}
	
	#if flash || nme || openfl
	inline public function toGeomPoint(out:flash.geom.Point):flash.geom.Point {
		if (out == null) 
			return new flash.geom.Point(x, y);
		else {
			out.x = x;
			out.y = y;
			return out;
		}
	}
	
	inline public function fromGeomPoint(p:flash.geom.Point):Point {
		x = p.x;
		y = p.y;
	}
	#end
}