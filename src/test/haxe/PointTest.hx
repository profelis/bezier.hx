package ;

import deep.math.Const;
import deep.math.Point;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class PointTest extends TestCase
{

	public function new() 
	{
		super();
	}

	public function testBase() {
		var p = new Point();
		assertEquals(p.x, 0);
		assertEquals(p.y, 0);
		
		p.set(-3, 4);
		assertEquals(p.x, -3);
		assertEquals(p.y, 4);
		assertEquals(p.length, 5);
		
		p.normalize();
		assertEquals(p.length, 1);
		
		var p2 = p.clone();
		assertFalse(p == p2);
		assertTrue(p.equals(p2));
		assertTrue(p2.equals(p));
		
	}
	
	public function testMath() {
		var a = new Point(2, -5);
		var b = new Point( -3, 2);
		
		var c = a.add(b);
		assertEquals(c.x, -1);
		assertEquals(c.y, -3);
		assertEquals(a.x, 2);
		assertEquals(a.y, -5);
		
		c = a.sub(b);
		assertEquals(c.x, 5);
		assertEquals(c.y, -7);
	}
	
	public function testStatics() {
		var a = new Point();
		var b = new Point();
		
		assertEquals(Point.distance(a, b), 0);
		
		a.x = 10;
		assertEquals(Point.distance(a, b), 10);
		
		b.x = 5;
		assertEquals(Point.distance(a, b), 5);
		
		a.y = 5;
		b.y = -3;
		var c = a.sub(b);
		assertEquals(Point.distance(a, b), c.length);
		
		a.set(1, 1);
		b.set(10, 10);
		assertEquals(Point.interpolate(a, b, 0.5).x, 5.5);
		assertEquals(Point.interpolate(a, b, 0.5).y, 5.5);
		
		var p = Point.polar(10, Math.PI * 0.5);
		assertTrue(Math.abs(p.x) < Const.PRECISION);
		assertEquals(p.y, 10);
	}
}