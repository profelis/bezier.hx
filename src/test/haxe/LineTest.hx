package ;

import bezier.Line;
import deep.math.Const;
import deep.math.Point;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class LineTest extends TestCase
{

	public function new() 
	{
		super();
	}
	
	function testBase() {
		var l = new Line();
		l.end = new Point(10, 0);
		
		assertEquals(l.length, 10);
		
		assertEquals(l.angle, 0);
		l.angle = Math.PI;
		assertEquals(l.end.x, -10);
		assertTrue(Math.abs(l.end.y) < Const.PRECISION);
	}
	
}