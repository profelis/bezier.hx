package ;

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
}