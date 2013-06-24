package bezier;

import deep.math.Point;
import deep.math.Rect;

interface IParametric {

	/* *
	 * Режим ограничения линии.
	 * @default true   
	 **/
	 
	/**
	 * Line constraint mode.
	 * @default true   
	 **/
	var isSegment:Bool;

	/**
	 * First control point of a figure. 
	 * @default (0,0)
	 **/
	var start:Point;

	/**
	 * Last control point of a figure.
	 * @default (0,0)
	 **/
	var end:Point;

	/**
	 * Length of figure
	 * @return Float
	 */
	var length(get, never):Float;

	/* *
	 * Вычисляет и возвращает точку по time-итератору.
	 * @return Point;
	 **/
	/**
	 * Calculates and returns Point by time-iterator.
	 * @return Point;
	 **/
	function getPoint(time:Float, point:Point=null):Point;
	
	/* *
	 * Проверка вырожденности в точку.
	 */
	 
	/**
	 * Check for degeneration into the point. 
	 */
	function asPoint():Point;

	/* *
	 * Вычисляет и возвращает time-итератор точки по дистанции от <code>start</code>.
	 * @return Float;
	 **/
	 
	/**
	 * Calculates and returns time-iterator of a Point by the distance from <code>start</code>.
	 * @return Float;
	 **/		 
	function getTimeByDistance(distance:Float):Float;

	/* *
	 * Вычисляет и возвращает массив time-итераторов точек с заданным шагом.
	 * @return Array;
	 **/
	 
	/**
	 * Calculates and returns the array of time-iterators of points with defined step.
	 * @return Array;
	 **/
	 
	function getTimesSequence(step:Float, startShift:Float = 0):Array<Float>;

	/**
	 * Calculates and returns bounds rectangle.
	 * @return Rectangle;
	 **/
	 
	var bounds(get, never):Rect;

	//  == management == 
	/* *
	 * Изменяет объект таким образом, что точка с заданным итератором
	 * примет координаты, определенные параметрами.
	 * @return void 
	 **/
	/**
	 * Changes the object so that the Point with a given iterator takes coordinates, defined by parameters.
	 * 
	 * @return void 
	 **/
	 
	function setPoint(time:Float, ?x:Float, ?y:Float):Void;

	/* *
	 * Смещает объект на заданную дистанцию по осям X и Y
	 * @return void 
	 **/
	 
	/**
	 * Moves the object to the specified distance by X and Y axes
	 * @return void 
	 **/
	 
	function offset(dx:Float = 0, dy:Float = 0):Void;

	/**
	 * Rotate a figure concerning to a point <code>fulcrum</code> on the <code>value</code> angle
	 * If point <code>fulcrum</code> is not set, used (0,0)
	 * @return void 
	 **/
	 
	function angleOffset(value:Float, fulcrum:Point = null):Void;

	/**
	 * Calculates and returns a time-iterator of Point nearer to given. 
	 * @return Float
	 **/
	function getClosest(fromPoint:Point):Float;
	
	function getExistedPointIterators(point:Point):Array<Float>;
	
	//		function getSegment (fromTime:Float=0, toTime:Float=1):IParametric;
	
	/**
	 * Calculates and returns the length of a segment from Point <code>start</code> to the Point, given by parameter <code>time</code>
	 * 
	 * @return Float
	 **/
	 
	function getSegmentLength(time:Float):Float;

	// == intersections ==
	/**
	 * Calculates and returns the intersection with Line
	 * @return Intersection
	 **/
	function intersectionLine(line:Line):Intersection;

	/**
	 * Calculates and returns the intersection with Bezier curve
	 * @return Intersection
	 **/
	function intersectionBezier(target:Bezier):Intersection;

	
	/**
	 * Calculates and returns the string presentation of object
	 * @return String
	 **/
	 
	function toString():String;
}