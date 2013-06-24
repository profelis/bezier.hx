// UTF-8

package flash.geom {

	public interface IParametric {

		/* *
		 * Режим ограничения линии.
		 * @default true   
		 **/
		 
		/**
		 * Line constraint mode.
		 * @default true   
		 **/
		function get isSegment():Boolean;

		function set isSegment(value:Boolean):void;

		/**
		 * First control point of a figure. 
		 * @default (0,0)
		 **/
		function get start():Point;

		function set start(value:Point):void;

		/**
		 * Last control point of a figure.
		 * @default (0,0)
		 **/
		function get end():Point;

		function set end(value:Point):void;

		/**
		 * Length of figure
		 * @return Number
		 */
		function get length():Number;

		/* *
		 * Вычисляет и возвращает точку по time-итератору.
		 * @return Point;
		 **/
		/**
		 * Calculates and returns Point by time-iterator.
		 * @return Point;
		 **/
		function getPoint(time:Number, point:Point=null):Point;
		
		/* *
		 * Проверка вырожденности в точку.
		 */
		 
		/**
		 * Check for degeneration into the point. 
		 */
		function asPoint() : Point;

		/* *
		 * Вычисляет и возвращает time-итератор точки по дистанции от <code>start</code>.
		 * @return Number;
		 **/
		 
		/**
		 * Calculates and returns time-iterator of a Point by the distance from <code>start</code>.
		 * @return Number;
		 **/		 
		function getTimeByDistance(distance:Number):Number;

		/* *
		 * Вычисляет и возвращает массив time-итераторов точек с заданным шагом.
		 * @return Array;
		 **/
		 
		/**
		 * Calculates and returns the array of time-iterators of points with defined step.
		 * @return Array;
		 **/
		 
		function getTimesSequence(step:Number, startShift:Number = 0):Array;

		/**
		 * Calculates and returns bounds rectangle.
		 * @return Rectangle;
		 **/
		 
		function get bounds():Rectangle;

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
		 
		function setPoint(time:Number, x:Number = undefined, y:Number = undefined):void;

		/* *
		 * Смещает объект на заданную дистанцию по осям X и Y
		 * @return void 
		 **/
		 
		/**
		 * Moves the object to the specified distance by X and Y axes
		 * @return void 
		 **/
		 
		function offset(dX : Number = 0, dY : Number = 0):void;

		/**
		 * Rotate a figure concerning to a point <code>fulcrum</code> on the <code>value</code> angle
		 * If point <code>fulcrum</code> is not set, used (0,0)
		 * @return void 
		 **/
		 
		function angleOffset(value:Number, fulcrum:Point = null):void;

		/**
		 * Calculates and returns a time-iterator of Point nearer to given. 
		 * @return Number
		 **/
		function getClosest(fromPoint:Point):Number;
		
		function getExistedPointIterators(point : Point) : Array;
		
		//		function getSegment (fromTime:Number=0, toTime:Number=1):IParametric;
		
		/**
		 * Calculates and returns the length of a segment from Point <code>start</code> to the Point, given by parameter <code>time</code>
		 * 
		 * @return Number
		 **/
		 
		function getSegmentLength(time:Number):Number;

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
}