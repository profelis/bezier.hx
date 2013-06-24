package ;

import bezier.math.Equations;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class EquationsTest extends TestCase
{

	public function new() 
	{
		super();
	}
	
	function testConst() {
		assertEquals(Equations.PRECISION, 1e-10);
	}

	@:access(bezier.math.Equations)
	function testMathPower() {
		
		assertEquals(Equations.mathPower(0, 2), 0);
		assertEquals(Equations.mathPower(2, 2), 4);
		assertEquals(Equations.mathPower(-2, 2), -4);
		assertEquals(Equations.mathPower(2, 0), 1);
		assertEquals(Equations.mathPower(-2, 0), 1);
		assertEquals(Equations.mathPower(0, 0), 1);
	}
	
	@:access(bezier.math.Equations)
	function testMathAtan2() {
		
		assertEquals(Equations.mathAtan2(0, 0), 0);
		assertEquals(Equations.mathAtan2(1, 0), 0);
		assertEquals(Equations.mathAtan2(1, 1), Math.PI * 0.25);
		assertEquals(Equations.mathAtan2(0, 1), Math.PI * 0.5);
		assertEquals(Equations.mathAtan2(-1, 1), Math.PI * 3 / 4);
		assertEquals(Equations.mathAtan2(-1, 0), Math.PI);
		assertEquals(Equations.mathAtan2(-1, -1), -Math.PI * 3 / 4);
		assertEquals(Equations.mathAtan2(0, -1), -Math.PI * 0.5);
		assertEquals(Equations.mathAtan2(1, -1), -Math.PI * 0.25);
	}
	
	function test2() {
		assertEquals(Equations.solveEquation(0, 0), null);
		assertEquals(Equations.solveEquation(0, 3).join(","), "");
		assertEquals(Equations.solveEquation(3, 3).join(","), "-1");
		assertEquals(Equations.solveEquation(3, -3).join(","), "1");
		assertEquals(Equations.solveEquation(-3, 3).join(","), "1");
	}
	
	function test3() {
		assertEquals(Equations.solveEquation(0, 0, 0), null);
		assertEquals(Equations.solveEquation(0, 0, 3).join(","), "");
		assertEquals(Equations.solveEquation(0, 3, 3).join(","), "-1");
		assertEquals(Equations.solveEquation(3, 3, 3).join(","), "");
		assertEquals(Equations.solveEquation(1, -4, 0).join(","), "0,4");
		assertEquals(Equations.solveEquation(1, 2, 1).join(","), "-1");
	}
	
	function test4() {
		assertEquals(Equations.solveEquation(0, 0, 0, 0), null);
		assertEquals(Equations.solveEquation(0, 0, 0, 3).join(","), "");
		assertEquals(Equations.solveEquation(0, 0, 3, 3).join(","), "-1");
		assertEquals(Equations.solveEquation(0, 1, 2, 1).join(","), "-1");
		assertEquals(Equations.solveEquation(0, 4, 4, 4).join(","), "");
		assertEquals(Equations.solveEquation(1, 3, -6, -8).join(","), "-4,-1,2");
		assertEquals(Equations.solveEquation(8, 7, -4, 1).join(","), "-1.32396468861425");
	}
	
	function test5() {
		assertEquals(Equations.solveEquation(0, 0, 0, 0, 0), null);
		assertEquals(Equations.solveEquation(0, 0, 0, 0, 3).join(","), "");
		assertEquals(Equations.solveEquation(0, 0, 0, 3, 3).join(","), "-1");
		assertEquals(Equations.solveEquation(0, 0, 1, 2, 1).join(","), "-1");
	}
}