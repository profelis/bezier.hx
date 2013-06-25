package ;
import haxe.unit.TestRunner;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Tests
{

	static function main() 
	{
		var r = new TestRunner();
		r.add(new EquationsTest());
		r.add(new PointTest());
		r.add(new RectTest());
		r.add(new LineTest());
		r.run();
	}
	
}