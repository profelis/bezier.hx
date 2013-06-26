package ;

import deep.math.Point;
import deep.math.Rect;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class RectTest extends TestCase
{

	public function new() 
	{
		super();
	}

	function testBase() {
		var r = new Rect();
		assertEquals(r.x, 0);
		assertEquals(r.y, 0);
		assertEquals(r.width, 0);
		assertEquals(r.height, 0);
		assertEquals(r.right, 0);
		assertEquals(r.bottom, 0);
		
		r.right = 20;
		r.left = 10;
		assertEquals(r.right, 20);
		assertEquals(r.width, 10);
		
		r.top = 20;
		r.bottom = 20;
		assertEquals(r.height, 0);
		assertEquals(r.y, 20);
	}
	
	function testIntersects() {
		var a = new Rect(0, 0, 10, 20);
		var b = new Rect(5, 5, 20, 10);
		
		var u = a.union(b);
		assertEquals(u.x, 0);
		assertEquals(u.y, 0);
		assertEquals(u.width, 25);
		assertEquals(u.height, 20);
		
		assertEquals(a.intersects(b), true);
		
		var i = a.intersect(b);
		assertEquals(i.x, 5);
		assertEquals(i.y, 5);
		assertEquals(i.width, 5);
		assertEquals(i.height, 10);
		
		assertTrue(i.min().equals(new Point(5, 5)));
		
		var c = new Rect(0, 0, 10, 20);
		assertTrue(c.equals(a));
	}
}