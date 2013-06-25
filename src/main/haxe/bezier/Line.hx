package bezier;

// translator: Flastar http://flastar.110mb.com

import bezier.math.Equations;
import deep.math.Point;
import deep.math.Rect;

/* *
 * Класс Line представляет линию в параметрическом представлении, 
 * задаваемую точками на плоскости <code>start</code> и <code>end</code>
 * и реализован в поддержку встроенного метода <code>lineTo()</code>.<BR/>
 * 
 * В классе реализованы свойства и методы, предоставляющие доступ к основным 
 * геометрическим свойствам линии.<BR/>
 * Точки, принадлежащие линии определяются их time-итератором. 
 * Итератор <code>t</code> точки на линии <code>P<sub>t</sub></code> равен отношению 
 * расстояния от точки <code>P<sub>t</sub></code> до стартоврой точки <code>S</code> 
 * к расстоянию от конечной точки <code>E</code> до стартовой точки <code>S</code>.  
 * <BR/>
 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
 * <BR/>
 * Класс Line, как и класс Bezier, имплементирует интерфейс IParametric.
 * 
 * @langversion 3.0
 * @playerversion Flash 9.0
 * 
 * @see Bezier
 * @see Intersection
 * 
 * @lang rus
 */
 
/**
 * The Line class introduces a line in parametric representation, given by <code>start</code> and <code>end</code> 
 * points in a plane, and is implemented to support internal method <code>lineTo()</code>.<BR/>
 * In this class implemented are the properties and methods, that provide an access 
 * to the basic geometrical properties of line.<BR/>
 * <BR/>
 * Points of the line are determined by their time-iterator.<BR/>  
 * 
 * Iterator <code>t</code> of the <code>P<sub>t</sub></code>point on a line is the ratio of the distance 
 * from the point <code>P<sub>t</sub></code> to the start point <code>S</code> to the distance from 
 * the end point <code>E</code> to the start point <code>S</code>.<BR/>
 * <BR/>
 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
 * <BR/>
 * Line class implements IParametric interface, same as Bezier class. 
 * 
 * @langversion 3.0
 * @playerversion Flash 9.0
 * 
 * @see Bezier
 * @see Intersection
 */

@:final class Line implements IParametric<Line>
{

	static var POINT0 = new Point();
	static var POINT1 = new Point();

	static inline var PRECISION = Equations.PRECISION;

	/* *
	 * Начальная опорная точка прямой. Итератор <code>time</code> равен нулю.
	 * 
	 * @return Point начальная точка прямой
	 * 
	 * @default Point(0, 0)
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 * 
	 **/
	 
	/**
	 * Initial control point of a line. Iterator <code>time</code> is equal to zero.
	 * 
	 * @return Point initial point of a line
	 * 
	 * @default Point(0, 0)
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 **/
	public var start:Point;
	
	/* *
	 * Конечная опорная точка прямой. Итератор <code>time</code> равен единице.
	 *  
	 * @return Point конечная точка прямой
	 *  
	 * @default Point(0, 0)
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * End control point of a line. Iterator <code>time</code> is equal to 1.
	 * 
	 * @return Point end point of a line
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 **/
	public var end:Point;
	
	/* *
	 * Определяет является ли прямая бесконечной в обе стороны,
	 * или ограничена в пределах итераторов от 0 до 1.<BR/>
	 * <BR/>
	 * <BR/>
	 * Текущее значение isSegment влияет на результаты методов:<BR/>
	 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
	 * <a href="#intersectionLine">intersectionLine</a><BR/>
	 * <a href="#getClosest">getClosest</a><BR/>
	 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
	 * 
	 * @see #intersectionBezier
	 * @see #intersectionLine
	 * @see #getClosest
	 * 
	 * @default true
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * Determines whether a line infinite in both directions, or restricted within the iterators from 0 to 1.
	 * <BR/>
	 * <BR/>
	 * Current value of isSegment affects the results of methods:<BR/>
	 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
	 * <a href="#intersectionLine">intersectionLine</a><BR/>
	 * <a href="#getClosest">getClosest</a><BR/>
	 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
	 * 
	 * @see #intersectionBezier
	 * @see #intersectionLine
	 * @see #getClosest
	 * 
	 * @default true
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 **/
	public var isSegment:Bool;
	
	/* *
	 * Определяет является ли прямая лучом, то есть бесконечной только в направлении от start к end.
	 * <BR/>
	 * Текущее значение isRay влияет на результаты методов:<BR/>
	 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
	 * <a href="#intersectionLine">intersectionLine</a><BR/>
	 * <a href="#getClosest">getClosest</a><BR/>
	 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
	 * 
	 * @see #intersectionBezier
	 * @see #intersectionLine
	 * @see #getClosest
	 * 
	 * @default true
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * Determines whether a line is a ray, i.e. it is infinite only in the direction from start to end.
	 * <BR/>
	 * Current value of isRay affects the results of methods:
	 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
	 * <a href="#intersectionLine">intersectionLine</a><BR/>
	 * <a href="#getClosest">getClosest</a><BR/>
	 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
	 * 
	 * @see #intersectionBezier
	 * @see #intersectionLine
	 * @see #getClosest
	 * 
	 * @default true
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 **/
	public var isRay:Bool;

	//**************************************************
	//				CONSTRUCTOR 
	//**************************************************
	
	/* *
	 * 
	 * Создает новый объект Line. 
	 * Если параметры не переданы, то все опорные точки создаются в координатах 0,0  
	 * 
	 * @param start:Point начальная точка прямой или отрезка
	 * @param end:Point конечная точка прямой или отрезка
	 * @param isSegment:Boolean флаг ограниченности
	 * @param isRay:Boolean флаг того, что прямая является лучом
	 * 
	 * @example В этом примере создается прямая в случайных координатах.  
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 * function randomPoint():Point {
	 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 * }
	 * function randomLine():Line {
	 * 	return new Line(randomPoint(), randomPoint());
	 * }
	 *
	 * var line:Line = randomLine();
	 * trace("random line: "+line);
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
			
	/**
	 * 
	 * Creates new object Line. 
	 * If the parameters were not given, all control points are created in the coordinates 0,0  
	 * 
	 * @param start:Point initial point of a line or a segment.
	 * @param end:Point end point of a line or a segment
	 * @param isSegment:Boolean limitation flag
	 * @param isRay:Boolean flag of the ray type of line
	 * 
	 * @example This example creates a line in random coordinates. 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 * function randomPoint():Point {
	 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 * }
	 * function randomLine():Line {
	 * 	return new Line(randomPoint(), randomPoint());
	 * }
	 *
	 * var line:Line = randomLine();
	 * trace("random line: "+line);
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/		

	public function new(?start:Point, ?end:Point, isSegment = true, isRay = false) {
		
		this.start = start != null ? start : new Point();
		this.end = end != null ? end : new Point();
		this.isSegment = isSegment;
		this.isRay = isRay;
	}

	
	/* *
	 * Создает и возвращает копию текущего объекта Line. 
	 * Обратите внимание, что в копии опорные точки так же копируются, и являются новыми объектами.
	 * 
	 * @return Line копия прямой
	 * 
	 * @example В этом примере создается случайная прямая и ее копия. 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 * function randomPoint():Point {
	 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 * }
	 * function randomLine():Line {
	 * 	return new Line(randomPoint(), randomPoint());
	 * }
	 *	
	 * var line:Line = randomLine();
	 * var clone:Line = line.clone();
	 * trace("random line: "+line);
	 * trace("clone line: "+clone);
	 * trace(line == clone); //false
	 * 	 
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
		
	/**
	 * Creates and returns a copy of the current object Line.<BR/>
	 * Please note that copies of the control points are copied as well, and they are new objects.
	 * 
	 * @return Line a copy of the line
	 * 
	 * @example This example creates a random line and its copy.
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 * function randomPoint():Point {
	 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 * }
	 * function randomLine():Line {
	 * 	return new Line(randomPoint(), randomPoint());
	 * }
	 *	
	 * var line:Line = randomLine();
	 * var clone:Line = line.clone();
	 * trace("random line: " + line);
	 * trace("clone line: " + clone);
	 * trace(line == clone); //false
	 * 
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 **/

	inline public function clone():Line {
		return new Line(start.clone(), end.clone(), isSegment, isRay);
	}

	/* *
	 * Проверка вырожденности прямой в точку.
	 * Если прямая вырождена в точку, то возвращается объект класса Point с координатой точки, в которую вырождена прямая.
	 * В других случаях, если прямая протяженная, возвращается null.
	 * 
	 * @return Point точка, в которую вырождена прямая
	 * 
	 * @example В этом примере создается прямая, и проверяется ее вырожденность в точку.
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *		
	 * var line:Line = new Line(new Point(100, 300), new Point(100, 200));
	 * var point:Point = line.lineAsPoint();
	 * trace("Is it point? "+ (point != null)); //Is it point? false
	 * line.end.y = 300;
	 * point = line.lineAsPoint();
	 * trace("Is it point? "+ (point != null)); //Is it point?  true
	 * 
	 * </listing>
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	 
	/**
	 * Check for line degeneration into the point.
	 * If the line is degenerated to the point, so returned is the object of the Point class with the coordinates of degenerate point.
	 * In other cases, if the line is extended, returns null.
	 * 
	 * @private The logic of the method - tolerance check that the control points of the line match.
	 * 
	 * @return Point the point to which the line is degenerated
	 * 
	 * @example This example creates a line and checks its degeneration to a point.
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *		
	 * var line:Line = new Line(new Point(100, 300), new Point(100, 200));
	 * var point:Point = line.lineAsPoint();
	 * trace("Is it point? "+ (point != null)); //Is it point? false
	 * line.end.y = 300;
	 * point = line.lineAsPoint();
	 * trace("Is it point? "+ (point != null)); //Is it point?  true
	 * 
	 * </listing>
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */
	 
	// Логика работы метода - проверка, что опорные точки прямой совпадают, с учетом допуска.
	public function asPoint():Point {
		
		var startToEndVector = POINT0;
		startToEndVector.x = end.x - start.x;
		startToEndVector.y = end.y - start.y;
		
		return if (startToEndVector.length < PRECISION)
				start.clone();				
			else null;
	}

	/* *
	 * Угол наклона прямой.
	 * Измеряется в радианах, от положительного направления оси X к положительному направлению оси Y (стандартная схема).
	 * Возвращаемое значение находится в пределах от отрицательного PI до положительного PI.
	 * 
	 * @return Float угол наклона прямой
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * Inclination of line.
	 * It is measured in radians, from the positive direction of the X-axis to the positive direction of axis Y (the standard scheme).
	 * The return value is in the range from negative PI to positive PI.
	 * 
	 * @return Float inclination of line
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 **/

	public var angle(get, set):Float;
	
	inline function get_angle():Float {
		return Math.atan2(end.y - start.y, end.x - start.x);
	}

	function set_angle(rad:Float):Float {
		
		var distance = Point.distance(start, end);
		var polar = Point.polar(distance, rad);
		end.x = start.x + polar.x;
		end.y = start.y + polar.y;
		return rad;
	}

	/* *
	 * Поворачивает линию относительно точки <code>fulcrum</code> на заданный угол.
	 * Если точка <code>fulcrum</code> не задана, используется (0,0);
	 * 
	 * @param value:Float угол поворота в радианах
	 * @param fulcrum:Point центр вращения. 
	 * 		
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	 
	/**
	 * Rotates the line with respect to a point <code>fulcrum</code> to a selected angle.
	 * If the point <code>fulcrum</code> was not given, the coordinates (0,0) are used;
	 * 
	 * @param value:Float angle of rotation in radians
	 * @param fulcrum:Point center of rotation.
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */

	public function angleOffset(value:Float, fulcrum:Point = null):Void {
		
		if (fulcrum == null) {
			POINT0.x = 0;
			POINT0.y = 0;
			fulcrum = POINT0;
		}
		var startLine = new Line(fulcrum, start);
		startLine.angle += value;
		var endLine = new Line(fulcrum, end);
		endLine.angle += value;
	}

	/* *
	 * Смещает прямую на заданное расстояние по осям X и Y.  
	 * 
	 * @param dx:Float величина смещения по оси X
	 * @param dy:Float величина смещения по оси Y
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 *  
	 * @lang rus
	 */
	 
	/**
	 * Moves the object to the specified distance by X and Y axes.
	 * 
	 * @param dx:Float X axial displacement
	 * @param dy:Float Y axial displacement
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 *  
	 */

	inline public function offset(dx:Float = 0, dy:Float = 0):Void {
		start.offset(dx, dy);
		end.offset(dx, dy);
	}

	/* *
	 * Длина отрезка <code>start</code>-<code>end</code>.
	 * Возвращаемое число - всегда положительное значение.
	 * При задании свойства length возможно использовать и отрицательные значения, но не нулевые.
	 * Изменение длины не меняет угла наклона прямой, а только перемещает точку end вдоль прямой.
	 * 
	 * @return Float длина отрезка
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 *  
	 * @lang rus
	 **/
	 
	/**
	 * Length of line segment <code>start</code>-<code>end</code>.
	 * Return value is always positive.
	 * When specifying the properties of length, negative values may be used too, but not zero.
	 * The change of length does not change the inclination of line, but only moves the end point along the line.
	 * 
	 * @return Float length of line segment
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 **/

	public var length(get, set):Float;
	
	inline function get_length():Float {
		return Point.distance(start, end); 
	}

	public function set_length(value:Float):Float {
		
		var lastLength = this.length;
		if (lastLength > PRECISION) 
		{
			var newEndX = start.x + value * (end.x - start.x) / lastLength;
			var newEndY = start.y + value * (end.y - start.y) / lastLength;			
			end.x = newEndX;
			end.y = newEndY;
		} else {
			end.x = start.x + value; // angle == 0 for zero length
		}
		return value;
	}

	/* *
	 * Вычисляет и возвращает объект Point, представляющий точку на прямой, заданную параметром <code>time</code>.
	 * 
	 * @param time:Float итератор точки прямой
	 * @param point:Point=null необязательный параметр, объект Point. 
	 * При передаче объекта Point в качестве аргумента, ему будут присвоены координаты точки и он же будет возвращен функцией.
	 * В противном случае будет создан и возвращен новый объект Point с координатами точки.
	 * 
	 * @return Point точка на прямой
	 * <I>
	 * Если передан параметр time равный 0 или 1, то будут возвращены объекты Point
	 * эквивалентные <code>start</code> и <code>end</code>, но не сами объекты <code>start</code> и <code>end</code> 
	 * </I> 
	 * 
	 * @example <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 *	var time:Float = Math.random();
	 *	var point:Point = line.getPoint(Math.random());
	 *	trace(point);
	 *	
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
		
	/**
	 * Calculates and returns an object Point, representing a point of line, given by parameter <code>time</code>.
	 * 
	 * @param time:Float iterator of a point of line
	 * @param point:Point=null optional parameter, object Point
	 * 
	 * @return Point point of line
	 * 
	 * <I>
	 * If the given parameter time equals 0 or 1, so the objects Point equal to <code>start</code> and 
	 * <code>end</code> will be returned, but not the objects <code>start</code> and <code>end</code> itself.
	 * </I>
	 * 
	 * @example <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 *	var time:Float = Math.random();
	 *	var point:Point = line.getPoint(Math.random());
	 *	trace(point);
	 *	
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */	

	public function getPoint(time:Float, point:Point = null):Point 
	{
		if (Math.isNaN(time)) return null;
		point = point != null ? point : new Point();
		point.x = start.x + (end.x - start.x) * time;
		point.y = start.y + (end.y - start.y) * time;
		return point;
	}

	/* *
	 * Вычисляет time-итератор точки, находящейся на заданной дистанции 
	 * по прямой от точки <code>start</code><BR/>
	 *  
	 * @param distance:Float дистанция по прямой до искомой точки.
	 * 
	 * @return Float time-итератор искомой точки
	 *  
	 * @example <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 * 
	 *	trace(line.getTimeByDistance(-10); // negative value
	 *	trace(line.getTimeByDistance(line.length/2); // value between 0 and 1
	 * </listing>
	 * 
	 * @see #getPoint 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	  
	/**
	 * Calculates time-iterator of the point, located at a given distance along the straight line from point <code>start</code>
	 * 
	 * @param distance:Float distance along the straight line to the desired point.
	 * @return Float time-iterator of the desired point
	 * 
	 * @example <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 * 
	 *	trace(line.getTimeByDistance(-10); // negative value
	 *	trace(line.getTimeByDistance(line.length/2); // value between 0 and 1
	 * </listing>
	 * 
	 * @see #getPoint 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */ 

	public function getTimeByDistance(distance:Float):Float {
		if (Math.isNaN(distance)) return Math.NaN;
		var lineLength = this.length;
		
		return if (lineLength > PRECISION) 
				distance / lineLength;
			else Math.NaN;
	}

	/* *
	 * Изменяет позицию точки <code>end</code> таким образром, 
	 * что точка <code>P<sub>time</sub></code> станет в координаты,
	 * заданные параметрами <code>x</code> и <code>y</code>.
	 * Если параметр <code>x</code> или <code>y</code> не определен,
	 * значение соответствующей координаты точки <code>P<sub>time</sub></code>
	 * не изменится. 
	 * 
	 * @param time:Float time-итератор точки кривой.
	 * @param x:Float новое значение позиции точки по оси X.
	 * @param y:Float новое значение позиции точки по оси Y.
	 * 
	 * @example 
	 * <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 *	trace(line);
	 *	 
	 *	line.setPoint(0, 0, 0);
	 *	trace(line);
	 *	 
	 *	line.setPoint(1, 200, 0);
	 *	trace(line);
	 *	 
	 *	line.setPoint(0.5, 100, 100);
	 *	trace(line);
	 *	
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus
	 */
	 
	/**
	 * Changes the location of the point <code>end</code> so that the point <code>P<sub>time</sub></code> 
	 * moves to the coordinates, given by parameters <code>x</code> and <code>y</code>.
	 * If the parameter <code>x</code> and <code>y</code> is not determined, the value of the corresponding 
	 * coordinates of the point <code>P<sub>time</sub></code> will not change.
	 * 
	 * @param time:Float time-iterator of the point of a curve.
	 * @param x:Float new value of the position of a point on the axis X.
	 * @param y:Float new value of the position of a point on the axis Y.
	 * 
	 * @example 
	 * <listing version="3.0">
	 * 
	 *	import bezier.Line;
	 *	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();	
	 *	trace(line);
	 *	 
	 *	line.setPoint(0, 0, 0);
	 *	trace(line);
	 *	 
	 *	line.setPoint(1, 200, 0);
	 *	trace(line);
	 *	 
	 *	line.setPoint(0.5, 100, 100);
	 *	trace(line);
	 *	
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus
	 */

	public function setPoint(time:Float, ?x:Float, ?y:Float):Void 
	{
		if ((x == null || Math.isNaN(x)) && (y == null || Math.isNaN(y))) return;
		var point = getPoint(time);
		if (x != null && !Math.isNaN(x)) point.x = x;
		if (y != null && !Math.isNaN(y)) point.y = y;
		end.x = point.x + (point.x - start.x) * ((1 - time) / time);
		end.y = point.y + (point.y - start.y) * ((1 - time) / time);
	}

	/* *
	 * Вычисляет и возвращает описывающий прямоугольник сегмента прямой между начальной и конечной точками.<BR/> 
	 * Если свойство isSegment=false, это игнорируется, не влияет на результаты рассчета.</I> 
	 * 
	 * @return Rectangle габаритный прямоугольник.
	 * 
	 * @example В этом примере создается случайна кривая Безье, и выводится центр тяжести описывающего ее треугольника.
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 * var boundBox:Rectangle = line.bounds;
	 * trace(boundBox.x+" "+boundBox.y+" "+boundBox.width+" "+boundBox.height); 
	 *  
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	 
	/**
	 * Calculates and returns the bounding box of the line segment between the start and end points.
	 * If the property isSegment=false, it is ignored, does not affect the results of the calculation.
	 * 
	 * @return Rectangle bounding box
	 * 
	 * @example This example creates random Bezier curve, and obtains the gravity center of the bounding triangle. 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 * var boundBox:Rectangle = line.bounds;
	 * trace(boundBox.x+" "+boundBox.y+" "+boundBox.width+" "+boundBox.height); 
	 *  
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 */

	public var bounds(get, never):Rect;
	
	function get_bounds():Rect {
	
		if (start.x > end.x) {
			return if (start.y > end.y) 
					new Rect(end.x, end.y, start.x - end.x, start.y - end.y);
				else
					new Rect(end.x, start.y, start.x - end.x, end.y - start.y);
		}
		if (start.y > end.y) 
			return new Rect(start.x, end.y, end.x - start.x, start.y - end.y);
		
		return new Rect(start.x, start.y, end.x - start.x, end.y - start.y);
	}

	/* *
	 * Возвращает отрезок - сегмент линии, заданный начальным и конечным итераторами.
	 * 
	 * @param fromTime:Float time-итератор начальной точки сегмента
	 * @param toTime:Float time-итератор конечной точки сегмента кривой
	 * 
	 * @return Line;
	 * 
	 * @example 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 * var segment1:Line = line.getSegment(1/3, 2/3);
	 * var segment2:Line = line.getSegment(-1, 2);
	 * 
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus
	 */
	 
	/**
	 * Returns the line segment, given by the initial and finite iterators.
	 * 
	 * @param fromTime:Float time-iterator of the initial point of the curve segment
	 * @param toTime:Float time-iterator of the end point of the curve segment
	 * 
	 * @return Line;
	 * 
	 * @example 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 * var segment1:Line = line.getSegment(1/3, 2/3);
	 * var segment2:Line = line.getSegment(-1, 2);
	 * 
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus
	 */

	inline public function getSegment(fromTime:Float = 0, toTime:Float = 1):Line {
		return new Line(getPoint(fromTime), getPoint(toTime));
	}

	
	/* *
	 * Возвращает длину сегмента прямой от точки <code>start</code> 
	 * до точки на линии, заданной time-итератором.
	 * 
	 * @param time:Float параметр time конечной точки сегмента.
	 * 
	 * @return Float длина сегмента прямой
	 * 
	 * 
	 * @example В этом примере создается случайная прямая, 
	 * вычисляется time-итератор точки середины прямой, а затем
	 * выводятся значения половины длины прямой и длина сегмента
	 * прямой до средней точки - они должны быть равны.
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 *	
	 *	var middleDistance:Float = line.length/2;
	 *	var middleTime:Float = line.getTimeByDistance(middleDistance);
	 *	var segmentLength:Float = line.getSegmentLength(middleTime);
	 *	
	 *	trace(middleDistance);
	 *	trace(segmentLength);
	 *	
	 *</listing> 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see #length
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * Returns the length of the line segment from the point <code>start</code> to 
	 * a point on the line, given by time-iterator.
	 * 
	 * @param time:Float time parameter of the segments end point.
	 * 
	 * @return Float length of a line segment
	 * 
	 * @example This example creates random line, calculates time-iterator of 
	 * the middle point of a line, and then obtains the values of half of length 
	 * of a line and length of a line segment to the middle point - they must be equal. 
	 * 
	 * <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();	
	 *	
	 *	var middleDistance:Float = line.length/2;
	 *	var middleTime:Float = line.getTimeByDistance(middleDistance);
	 *	var segmentLength:Float = line.getSegmentLength(middleTime);
	 *	
	 *	trace(middleDistance);
	 *	trace(segmentLength);
	 *	
	 *</listing> 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see #length
	 * 
	 **/

	inline public function getSegmentLength(time:Float):Float {
		return Point.distance(start, getPoint(time));
	}

	/* *  
	 * Вычисляет и возвращает массив точек на линии удаленных друг от друга на 
	 * расстояние, заданное параметром <code>step</code>.<BR/>
	 * Первая точка массива будет смещена от стартовой точки на расстояние, 
	 * заданное параметром <code>startShift</code>. 
	 * При этом, если значение <code>startShift</code> превышает значение
	 * <code>step</code>, будет использован остаток от деления на <code>step</code>.<BR/>
	 * <BR/>
	 * Типичное применение данного метода - вычисление последовательности точек 
	 * для рисования пунктирных линий. 
	 *  
	 * @param step:Float шаг, дистанция по прямой между точками.
	 * @param startShift:Float дистанция по прямой, задающая смещение первой 
	 * точки последовательности относительно точки <code>start</code>
	 *  
	 * @return Array массив итераторов
	 *  
	 * @example <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();
	 * var points:Array = line.getTimesSequence(10, 0);
	 *
	 *  for(var i:uint=0; i<points.length; i+=2)
	 *  {
	 *  	var startSegmentTime:Float = points[i];
	 *		var endSegmentTime:Float = points[i+1];
	 *		var segment:Line = line.getSegment(startSegmentTime, endSegmentTime);
	 *		drawLine(segment);
	 *  }
	 *
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	 
	/**  
	 * Calculates and returns an array of points on a line, distant from each other by a distance specified by <code>step</code> parameter.
	 * The first point of the array will be shifted from the initial point for a distance, specified by the <code>startShift</code> parameter.
	 * In this case, if the value <code>startShift</code> exceeds the value <code>step</code>, the remainder of division by <code>step</code>will be used.
	 * The typical application of this method is calculating a sequence of points for drawing dotted lines.
	 * 
	 * @param step:Float step, the distance along the straight line between the points.
	 * @param startShift:Float the distance along the straight line, determining the shift of the first sequence point with respect to a point <code>start</code>
	 * 
	 * @return Array iterators array
	 *  
	 * @example <listing version="3.0">
	 * import bezier.Line;
	 * import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 * var line:Line = randomLine();
	 * var points:Array = line.getTimesSequence(10, 0);
	 *
	 *  for(var i:uint=0; i<points.length; i+=2)
	 *  {
	 *  	var startSegmentTime:Float = points[i];
	 *		var endSegmentTime:Float = points[i+1];
	 *		var segment:Line = line.getSegment(startSegmentTime, endSegmentTime);
	 *		drawLine(segment);
	 *  }
	 *
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */

	public function getTimesSequence(step:Float, startShift:Float = 0):Array<Float> {
		if (step < 0) step = -step;
		var distance = (startShift % step + step) % step;
		
		var times = [];
		var lineLength = Point.distance(start, end);
		if (distance > lineLength) return times;
		
		var timeStep = step / lineLength;
		var time = getTimeByDistance(distance);
		
		while (time <= 1) 
		{
			times.push(time);
			time += timeStep;
		}
		return times;
	}

	/* *
	 * Метод находит пересечения прямой с точкой<BR/>
	 * Добавлен для гармонии с методами пересечения двух прямых и кривой Безье с прямой.
	 * К этому методу сводятся остальные методы поиска пересечений в случае вырожденности фигур.
	 * 
	 * @param target:Point точка, с которой ищется пересечение
	 * @return Intersection объект с описанием пересечения
	 *  
	 * @example <listing version="3.0">
	 *	import bezier.Line;
	 * 	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var intersection:Intersection = line.intersectionPoint(new Point(100, 100));
	 *	trace(intersection);
	 *	
	 * </listing>
	 *  
	 * @see Intersection
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus
	 */
	 
	/**
	 * The method searches the intersection of the line with a point.
	 * It is added for the harmony with the methods of intersection of two lines and intersection of Bezier curve with the line.
	 * By this method reduce the remaining methods of search of intersections in the case of degeneracy of the figures.
	 *
	 * @param target:Point the point at which the intersection is sought
	 * 
	 * @return Intersection the object with the description of intersection
	 *  
	 * @example <listing version="3.0">
	 *	import bezier.Line;
	 * 	import bezier.Point;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var intersection:Intersection = line.intersectionPoint(new Point(100, 100));
	 *	trace(intersection);
	 *	
	 * </listing>
	 *  
	 * @see Intersection
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */

	public function intersectionPoint(target:Point):Intersection {
		
		var intersection = new Intersection();
		
		var closestTime = this.getClosest(target);
		var closestPoint = this.getPoint(closestTime);
					
		if (Point.distance(target, closestPoint) < PRECISION)
			intersection.addIntersection(closestTime, 0, this.isSegment, false);

		return intersection;
	}

	/* *
	 * Метод находит пересечения двух прямых<BR/>
	 * Результат вычисления пересечения двух прямых может дать следующие результаты:  <BR/>
	 * - если пересечение отсутствует, возвращается объект Intersection с пустыми массивами <code>currentTimes<code> и <code>targetTimes;</code><BR/>
	 * - если пересечение произошло в одной или двух точках, будет возвращен объект Intersection,
	 *   и time-итераторы точек пересечения данной прямой будут находиться в массиве currentTimes.
	 *   time-итераторы точек пересечения прямой <code>target</code> будут находиться в массиве targetTimes;<BR/>
	 * - если прямая вырождена, то может произойти совпадение. 
	 * В этом случае результатом будет являться отрезок - объект Line (<code>isSegment=true</code>), 
	 * который будет доступен как свойство <code>coincidenceLine</code> в возвращаемом объекте Intersection;<BR/>
	 * <BR/>  
	 * На результаты вычисления пересечений оказывает влияние свойство <code>isSegment<code> как текущего объекта,
	 * так и значение <code>isSegment</code> объекта target.
	 * 
	 * @param target:Line прямая линия, с которой ищется пересечение
	 * @return Intersection объект с описанием пересечения
	 *  
	 * @example <listing version="3.0">
	 *	import flash.geom.Bezier;
	 * 	import bezier.Point;
	 *	import bezier.Line;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var target:Line = new Line(new Point(100, 100), new Point(200, 200));
	 *	var intersection:Intersection = line.intersectionLine(target);
	 *	trace(intersection);
	 *	
	 * </listing>
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Intersection
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @lang rus 
	 */
	 
	/**
	 * The method searches the intersection of two lines<BR/>
	 * Calculation of the intersection of two lines can give the following results:<BR/>
	 * - if there is no intersection, an object Intersection with empty arrays 
	 *   <code>currentTimes</code> and <code>targetTimes</code> returns;<BR/>
	 * - if there were intersections in one or two points, the object Intersection returns, 
	 *   and time-iterators of intersection points of this line will be located in an array 
	 *   <code>currentTimes</code>, time-iterators of intersection points of line <code>target</code> will 
	 *   be located in an array targetTimes;<BR/>
	 * - if the line is degenerate, the coincidence can happen. In this case, the result is 
	 *   a segment - object Line (<code>isSegment=true</code>), which will be available as 
	 *   a property <code>coincidenceLine</code> in the returned object Intersection;<BR/>
	 * <BR/>
	 * The property <code>isSegment<code> of current object, as well as value <code>isSegment</code> 
	 * of target object, affects the result of calculation.
	 * 
	 * @param target:Line line at which the intersection is sought
	 * 
	 * @return Intersection the object with the description of intersection
	 *  
	 * @example <listing version="3.0">
	 *	import flash.geom.Bezier;
	 * 	import bezier.Point;
	 *	import bezier.Line;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var target:Line = new Line(new Point(100, 100), new Point(200, 200));
	 *	var intersection:Intersection = line.intersectionLine(target);
	 *	trace(intersection);
	 *	
	 * </listing>
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Intersection
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 */

	public function intersectionLine(targetLine:Line):Intersection 
	{
		var intersection = new Intersection();
		
		if (isSegment && targetLine.isSegment) {
			var currentBoundBox = this.bounds;
			var targetBoundBox = targetLine.bounds;
					
			if (currentBoundBox.right < targetBoundBox.left
				|| targetBoundBox.right < currentBoundBox.left
				|| targetBoundBox.bottom < currentBoundBox.top
				|| currentBoundBox.bottom < targetBoundBox.top
				) return intersection;  
		}
		
		var startToEndVector = POINT0;
		startToEndVector.x = end.x - start.x;
		startToEndVector.y = end.y - start.y;
		
		var targetStartToEndVector = POINT1;
		targetStartToEndVector.x = targetLine.end.x - targetLine.start.x;
		targetStartToEndVector.y = targetLine.end.y - targetLine.start.y;
		
		var currentDeterminant = startToEndVector.x * start.y - startToEndVector.y * start.x;
		var targetDeterminant = targetStartToEndVector.x * targetLine.start.y - targetStartToEndVector.y * targetLine.start.x;
		var crossDeterminant = startToEndVector.x * targetStartToEndVector.y - startToEndVector.y * targetStartToEndVector.x;
		var crossDeterminant2 = start.x * targetStartToEndVector.y - start.y * targetStartToEndVector.x;
		
		if(Math.abs(crossDeterminant) < PRECISION) {
			if(Math.abs(crossDeterminant2 + targetDeterminant) < PRECISION) {
				intersection.isCoincidence = true;
									
				var coincidenceStartTime:Float = 0;
				var coincidenceEndTime:Float = 0;
				
				var currentEndTime:Float;
				var currentStartTime:Float;
				
				var linesStartTime:Float = 0;
				var linesEndTime:Float = 1;					
				
				if (Math.abs(startToEndVector.x) > PRECISION) {
					currentStartTime = - (start.x - targetLine.start.x) / startToEndVector.x;
					currentEndTime = - (start.x - targetLine.end.x) / startToEndVector.x;
				} else { 
					if (Math.abs(startToEndVector.y) > PRECISION) {
						currentStartTime = (targetLine.start.y - start.y) / startToEndVector.y;
						currentEndTime = (targetLine.end.y - start.y) / startToEndVector.y;
					} else {
						currentStartTime = 0;
						currentEndTime = 0;
					}
				}
				
				if ((linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 && (linesEndTime - currentStartTime) * (linesEndTime - currentEndTime) <= 0) {
					coincidenceEndTime = linesEndTime;
					coincidenceStartTime = linesStartTime; 
				} else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) <= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) <= 0) {
					coincidenceEndTime = currentEndTime;
					coincidenceStartTime = currentStartTime; 
				} else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) <= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) >= 0) {
					coincidenceStartTime = currentStartTime;
					coincidenceEndTime = (linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 ? linesStartTime : linesEndTime;
				} else if ((currentStartTime - linesStartTime) * (currentStartTime - linesEndTime) >= 0 && (currentEndTime - linesStartTime) * (currentEndTime - linesEndTime) <= 0) {
					coincidenceStartTime = currentEndTime;
					coincidenceEndTime = (linesStartTime - currentStartTime) * (linesStartTime - currentEndTime) <= 0 ? linesStartTime : linesEndTime;
				}
				var startPt = new Point(coincidenceStartTime * startToEndVector.x + start.x, coincidenceStartTime * startToEndVector.y + start.y);
				var endPt = new Point(coincidenceEndTime * startToEndVector.x + start.x, coincidenceEndTime * startToEndVector.y + start.y);
				
				intersection.coincidenceLine = new Line(startPt, endPt);
			}
			
		} else {
			var solve = new Point();			
			solve.x = (currentDeterminant * targetStartToEndVector.x - targetDeterminant * startToEndVector.x) / crossDeterminant;
			solve.y = (currentDeterminant * targetStartToEndVector.y - targetDeterminant * startToEndVector.y) / crossDeterminant;
		
			var time:Float;
			if (Math.abs(startToEndVector.x) > PRECISION) {
				time = (solve.x - start.x) / startToEndVector.x;
			} else {
				if (Math.abs(startToEndVector.y) > PRECISION) 
					time = (solve.y - start.y) / startToEndVector.y;
				else time = Math.NaN;
			}
			
			var targetTime:Float;
			if (Math.abs(targetStartToEndVector.x) > PRECISION) 
				targetTime = (solve.x - targetLine.start.x) / targetStartToEndVector.x;
			else {
				if (Math.abs(targetStartToEndVector.y) > PRECISION) 
					targetTime = (solve.y - targetLine.start.y) / targetStartToEndVector.y;
				else targetTime = Math.NaN;
			}
			if ((! isSegment || (time >= 0 && time <= 1)) && (! targetLine.isSegment || (targetTime >= 0 && targetTime <= 1))) {								
				intersection.currentTimes.push(time);
				intersection.targetTimes.push(targetTime);
			}
		}
		return intersection;
	}

	/**
	 * Метод находит пересечения прямой линии с кривой Безье<BR/>
	 * Полностью сводится к методу intersectionLine класса Bezier, подробное описание его работы смотрите там.
	 * 
	 * @param target:Bezier кривая Безье, с которой ищется пересечение
	 * @return Intersection объект с описанием пересечения
	 *   
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus 
	 */
					
	/**
	 * The method searches the intersection of the line with a Bezier curve<BR/>
	 * Absolutely reduces the intersectionLine method of the Bezier class, refer its description for details.
	 * 
	 * @param target:Bezier Bezier curve at which the intersection is sought
	 * @return Intersection the object with the description of intersection
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 */		   		
	public function intersectionBezier(target:Bezier):Intersection 
	{
		var intersection = target.intersectionLine(this);
		intersection.switchCurrentAndTarget();
		return intersection;
	}

	
	/**
	 * <P>Вычисляет и возвращает time-итератор точки на прямой, 
	 * ближайшей к точке <code>fromPoint</code>.<BR/>
	 * В зависимости от значения свойства <a href="#isSegment">isSegment</a>
	 * возвращает либо значение в пределах от 0 до 1, либо от минус 
	 * бесконечности до плюс бесконечности.</P>
	 * 
	 * @param fromPoint:Point произвольная точка на плоскости
	 * 
	 * @return Float time-итератор ближайшей точки на прямой
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	import bezier.Point;
	 *	import bezier.Line;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var fromPoint:Point = randomPoint();
	 *	var closest:Float = line.getClosest(fromPoint);
	 * 
	 *  trace(line);
	 *  trace(fromPoint);
	 *  trace(line.getPoint(closest));
	 *  
	 * </listing>
	 * 
	 * @see #isSegment
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	 
	/**
	 * Calculates and returns the time-iterator of the point on the line, nearest to the point <code>fromPoint</code>.
	 * Depending on the value of property <a href="#isSegment">isSegment</a>, returns a value ranging from 0 to 1, or 
	 * from minus infinity to plus infinity.
	 * 
	 * @param fromPoint:Point arbitrary point on the plane
	 * @return Float time-iterator of the nearest point on the line
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	import bezier.Point;
	 *	import bezier.Line;
	 *	
	 *	function randomPoint():Point {
	 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
	 *	}
	 *	function randomLine():Line {
	 *		return new Line(randomPoint(), randomPoint());
	 *	}
	 *	
	 *	var line:Line = randomLine();
	 *	var fromPoint:Point = randomPoint();
	 *	var closest:Float = line.getClosest(fromPoint);
	 * 
	 *  trace(line);
	 *  trace(fromPoint);
	 *  trace(line.getPoint(closest));
	 *  
	 * </listing>
	 * 
	 * @see #isSegment
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 **/

	public function getClosest(fromPoint:Point):Float 
	{
		var startToEndVector = POINT0;
		startToEndVector.x = end.x - start.x;
		startToEndVector.y = end.y - start.y;
		
		var startToEndLength = startToEndVector.length;
			
		if(startToEndLength < PRECISION) return 0;
		
		var selfProjection = - startToEndVector.y * start.x + startToEndVector.x * start.y;
		var projection = (startToEndVector.y * fromPoint.x + startToEndVector.x * fromPoint.y + selfProjection) / (startToEndLength * startToEndLength);
		var point = new Point(fromPoint.x - startToEndVector.y * projection, fromPoint.y - startToEndVector.x * projection);
		var time = startToEndVector.x != 0 ? (start.x - point.x) / startToEndVector.x : (point.y - start.y) / startToEndVector.y;
				
		if (!isSegment) return time;
		if(time < 0) return 0;
		if (time > 1) return 1;
		return time;
	}

	
	
	public function getExistedPointIterators(point:Point):Array<Float>
	{
		var startToEndVector = POINT0;
		startToEndVector.x = end.x - start.x;
		startToEndVector.y = end.y - start.y;
			
		var solution = Math.NaN;
		
		if (Math.abs(startToEndVector.x) > PRECISION)
			solution = (point.x - start.x) / startToEndVector.x;
		else if (Math.abs(startToEndVector.y) > PRECISION)
			solution = (point.y - start.y) / startToEndVector.y;
					
		var iteratorsArray = [];		
		
		if (! Math.isNaN(solution)) 
			if ((! isSegment) || ((solution >= 0) && (solution <= 1)))
			{
				var foundPoint = getPoint(solution);
				if (Point.distance(foundPoint, point) < PRECISION) 
					iteratorsArray.push(solution);				
			}
		
		return iteratorsArray;
	}

	
	//**************************************************
	//				UTILS 
	//**************************************************
	/**
	 * Возвращает описание объекта Line, понятное человекам. 
	 * 
	 * @return String описание объекта
	 * 
	 * @lang rus
	 */
	 
	/**
	 * Returns the description of the Line object.
	 * 
	 * @return String object description
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 */
	public function toString():String 
	{
		return 	"(start:" + start + ", end:" + end + ")";
	}
}
