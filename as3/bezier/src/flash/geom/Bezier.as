// UTF-8
/**
 *              I. INTRODUCTION
 *
 * There are two methods, that are used in ActionScript drawing: lineTo() and curveTo()
 * and realize sengment and Bezier second-order curve drawing correspondingly.
 * There are tools in Flash IDE to draw curves with Bezier third-order curves,
 * but during the compilation process they are approximated with second-order curves.
 * As the result, all shapes in compiled SWF-file become segments or Bezier second-order curves.
 * That's why we encounter a group of tasks, that need mathematical engine
 * to work with segments and Bezier second-order curves.
 *
 *
 *              II. BASE TASKS
 *
 * 1. Controlling:
 *   - using control points;
 *   - placing the particular point in particular coondinates;
 *   - rotating around any point;
 *   - offseting.
 * 2. Geometric properties:
 *   - finding actual point on curve or line by time-iterator;
 *   - parents (line for the segment and parabola for the Bezier curve)
 *   - length of the given segment
 *   - bounding rectangle
 *   - square (for the Bezier curve)
 *   - tangants
 * 3. Getting points on curve:
 *   - by distance from the beginning;
 *   - nearest to the given point;
 *   - inretsections with other segments and curves.
 *
 * Most of other practical tasks can be solved based on these solutions.
 *
 * Actually, these tasks are realizaed in this class package.
 * Samples for other practical tasks are located in <code>howtodo</code> package.
 *
 *
 *              III. CONCEPTIONS
 *
 * 1. <code>Bezier</code> and <code>Line</code> classes are realized in a similar way and most of
 * their methods have similar or the same syntax, defined by <code>IParametric</code> interface.
 * Of course, there are differencies: for example, <code>Line</code> doesn't have
 * <code>area</code> and <code>control</code> properties. <code>Bezier</code>
 * in it's turn doesn't have <code>angle</code>, that is presented in <code>Line.
 *
 * 2. Geometric figures (lines), defined in <code>Line</code> and <code>Bezier</code> classes,
 * are controlled in parametric form, every point of the figure is defined by it's time-iterator.
 * In the beginning it can seem inconvenient that computation of the point on curve returns
 * a time-iterator that is <code>Number</code> instead of <point>Point</point> class instance.
 * However, this realization helps us to avoid redundant convertations in future calculations.
 * To convert point on figure to the <class>Point</class>, use the <code>getPoint()</code> method.
 * To find time-iterator for the two-dimensional point, use the <code>getClosest()</code> method.
 *
 * 3. <class>Bezier</code> and <code>Line</code> instances can be infinite or limited with <code>start</code>
 * and <code>end</code> points. Limited nature can be set using <code>isSegment</code> property (default value
 * is <code>true</code>).
 * If you use <code>isSegment</code> <code>false</code>, then class methods results will include points that lie
 * outside of start-end segment. In other case, methods results will contain only points, that belong to
 * the segment, defined by <code>start</code> and <code>end</code> properties.
 *
 * @lang eng
 * @translator Maxim Kachurovskiy http://www.riapriority.com
 *
 **/
/* *
 * 		I. ВСТУПЛЕНИЕ
 * 
 * Для программного рисования во Flash используется два метода: lineTo() и curveTo(),
 * реализующие соответственно отрисовку отрезка и кривой Безье второго порядка.
 * В редакторе Flash имеется возможность отрисовывать кривые с помощью кривых Безье
 * третьего порядка, однако, на этапе компиляции, они аппроксимируются кривыми
 * Безье второго порядка.
 * В итоге, все векторные фигуры в скомпилированном swf файле реализованы с помощью
 * отрезков или кривых Безье второго порядка.
 * В результате возникает целый спектр задач, для решения которых требуется математический
 * аппарат работы с отрезками и кривыми Безье второго порядка.
 * 
 * 
 * 		II. БАЗОВЫЕ ЗАДАЧИ
 * 
 * 1. управление:
 *   - с помощью контрольных точек;
 *   - установка заданной точки в произвольно заданые координаты;
 *   - поворот относительно произвольно заданной точки;
 *   - смещение на заданное расстояние.
 * 2. геометрические свойства:
 *   - получение точки на линии по известному time-итератору;
 *   - родители (прямая для отрезка и парабола для кривой Безье)
 *   - длина заданного сегмента
 *   - габаритный прямоугольник
 *   - площадь (для кривой Безье)
 *   - касательные
 * 3. получение точек на кривой:
 *   - по дистанции от начала;
 *   - ближайшей до произвольно заданной;
 *   - пересечения с другими кривыми и линиями.
 * 
 * Подавляющее большинство остальных практических задач могут быть решены
 * на основе решений этих базовых задач. 
 * 
 * Собственно, перечисленные базовые задачи и реализованы в этом пакете классов. 
 * Примеры решения других практических задач вынесены в пакет howtodo.
 * 
 * 
 * 		III. КОНЦЕПЦИИ
 * 
 * 1. Классы Bezier и Line реализованы схожим образом и подавляющее большинство
 * их методов имеют либо схожий, либо аналогичный синтаксис, определенный интерфейсом IParametric.
 * Разумеется, есть и отличия: к примеру, у Line не может быть свойства area,
 * и отсутствует управляющая точка control; у Bezier, в свою очередь нет свойства
 * angle, присутствующего в Line.
 *
 * 2. Геометрические фигуры(линии), реализованные в классах Line и Bezier, задаются в
 * параметрической форме, и каждая точка фигуры характеризуется time-итератором.
 * Возможно, что поначалу покажется неудобным, что при вычислении точки на кривой
 * возвращается не привычный всем объект класса Point, а time-итератор,
 * являющийся Number. Однако такая реализация позволяет избежать избыточных 
 * конвертаций при последующих расчетах.
 * При необходимости перевести точку фигуры в объект Point, используйте метод getPoint().
 * При необходимости найти time-итератор двумерной точки, используйте метод getClosest().
 * 
 * 3. Объекты Bezier и Line могут быть бесконечны, либо ограничены конечными точками start и end.
 * Ограниченность может быть установлена свойством isSegment (по умолчанию true).
 * Если задать isSegment=false, то возвращаемые методами значения будут содержать точки, в том числе, 
 * лежащие за пределами сегмента start-end. В противном случае, возвращаемые методами значения 
 * будут содержать только точки, принадлежащие сегменту лежащему между start и end.
 * 
 * 4. Классы Bezier и Line содержат только математические вычисления и не содержат код, 
 * занимающийся обслуживанием методов рисования и других. Пользователям пакета рекомендуется 
 * создать собственные расширения классов Bezier и Line или использовать композицию. 
 * 
 **/
package flash.geom {
	import flash.math.Equations;

	/* * 
	 * <P>
	 * Класс Bezier представляет кривую Безье второго порядка в параметрическом представлении, 
	 * задаваемую точками на плоскости <code>start</code>, <code>control</code> и <code>end</code>
	 * и реализован в поддержку встроенного метода curveTo(). 
	 * В классе реализованы свойства и методы, предоставляющие доступ к основным геометрическим свойствам этой кривой.
	 * </P>
	 * <BR/>
	 * <h2>Краткие сведения о кривой Безье второго порядка.</h2>
	 * Любая точка P<sub>t</sub> на кривой Безье второго порядка вычисляется по формуле:<BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;S&#42;(1-t)<sup>2</sup>&nbsp;+&nbsp;2&#42;C&#42;(1-t)&#42;t&nbsp;+&nbsp;E&#42;t<sup>2</sup></code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * где: <BR/>
	 * <code><B>t</B></code> (<code><b>t</b>ime</code>) — time-итератор точки<BR/>
	 * <code><B>S</B></code> (<code><b>s</b>tart</code>) — начальная опорная (узловая) точка (<code>t=0</code>) (anchor point)<BR/>
	 * <code><B>С</B></code> (<code><b>c</b>ontrol</code>) — управляющая точка (direction point)<BR/> 
	 * <code><B>E</B></code> (<code><b>e</b>nd</code>) — конечная опорная (узловая) точка (<code>t=1</code>) (anchor point)<BR/>
	 * <BR/>
	 * Построение производится итерационным вычислением множества точек кривой, c изменением значения итератора t в пределах от нуля до единицы.<BR/>
	 * Точка кривой Безье характеризуется time-итератором.
	 * Две точки кривой, имеющие одинаковый time-итератор совпадут.
	 * В общем случае две точки кривой Безье второго порядка с различным time-итератором не совпадут.<BR/>
	 * <a name="bezier_building_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../../images/Step01Building.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *				width="100%" height="400" name="Step01Building"
	 * 				align="middle"
	 *				play="true"
	 *				loop="false"
	 *				quality="high"
	 *				allowScriptAccess="sameDomain"
	 *				type="application/x-shockwave-flash"
	 *				pluginspage="http://www.adobe.com/go/getflashplayer">
	 *			</embed>
	 *	</object>
	 * </td></table>
	 * <BR/>
	 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR/>
	 * <I>Используйте клавиши "влево" "вправо" для управления итератором.<BR/>
	 * Мышью перемещайте контрольные точки кривой.</I></P><BR/>
	 * <BR/>
	 * <h3>Свойства кривой Безье второго порядка</h3>
	 * <ul>
	 * 		<li>кривая непрерывна</li>
	 * 		<li>кривая аффинно-инвариантна</li>
	 * 		<li>все точки кривой Безье лежат в пределах треугольника ∆SCE</li>
	 * 		<li>точки <code>S</code> и <code>E</code> всегда принадлежат кривой Безье и ограничивают ее.</li>
	 * 		<li>точки с равномерно изменяющимся итератором распределены плотнее на участках с бóльшим изгибом</li>
	 * 		<li>вершина кривой Безье — точка с итератором <code>t=0.5</code> лежит на середине отрезка, соединяюшем <code>С</code> и середину отрезка <code>SE</code>.</li>
	 * 		<li>точка <code>C</code> в общем случае не принадлежит кривой и лежит на пересечении касательных к кривой в точках <code>S</code> и <code>E</code></li>
	 * 		<li>если точка <code>С</code> лежит на прямой <code>SE</code>, то такая кривая является вырожденной</li>
	 * 		<li>площадь фигуры, образуемой кривой Безье и отрезком <code>SE</code> равняется 2/3 </li>
	 * </ul>
	 * <h3>Кривая Безье и парабола</h3>
	 * Кривая Безье второго порядка является сегментом параболы.
	 * Кривая, построенная по <a href="#formula1">формуле <B>1</B></a>, и итератором <code><B>t</B></code> изменяющимся в бесконечных пределах является параболой. 
	 * Если кривая Безье лежит на параболе, то такая парабола по отношению к ней является родительской.
	 * <UL>
	 * 		<I>
	 * 		Это свойство также относится и к кривым Безье других степеней. Так, к примеру, отрезок можно 
	 * 		рассматривать как Безье первого порядка, а его родителем будет линия, которой принадлежит этот отрезок.
	 * 		Класс <a href="Line.html">Line</a> именно так интерпретирует отрезок для упрощения использования совместно с классом Bezier.<BR/>
	 * 		Кривая Безье третьего порядка на плоскости - сегмент проекции на плоскость кубической параболы, построеной в трехмерном пространстве.
	 * 		И общай случай: Кривая Безье порядка N на плоскости - сегмент проекции на плоскость N-мерной кривой, построеной в N-мерном пространстве.
	 * 		</I>
	 * </UL>
	 * 
	 * @see Line
	 * @see Intersection
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 **/
	/**
	 * <p>
	 * Class <code>Bezier</code> represents a Bezier second-order curve in parametric view,
	 * and is given by <code>start</code>, <code>control</code> and <code>end</code> points on the plane.
	 * It exists to support the <code>curveTo()</code> method. Methods and properties of this class
	 * give access to the geometric properties of the curve.
	 * </p>
	 * <br/>
	 * <h2>Brief information about the Bezier second-order curve.</h2>
	 * Any point <code>P<sub>t</sub></code> on the Bezier second-order curve is computed using formula:<br/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;S&#42;(1-t)<sup>2</sup>
	 * &nbsp;+&nbsp;2&#42;C&#42;(1-t)&#42;t&nbsp;+&nbsp;E&#42;t<sup>2</sup></code>&nbsp;
	 * &nbsp;&nbsp;&nbsp;(1)</h2><br/>
	 * where: <br/>
	 * <code><strong>t</strong></code>(<code><strong>t</strong>ime</code>) — time-iterator of the point<br/>
	 * <code><strong>S</strong></code>(<code><strong>s</strong>tart</code>) — initial control (anchor) point (<code>t=0</code>)<br/>
	 * <code><strong>С</strong></code>(<code><strong>c</strong>ontrol</code>) — direction point<br/>
	 * <code><strong>E</strong></code>(<code><strong>e</strong>nd</code>) — final control (anchor) point (<code>t=1</code>)<br/>
	 * <br/>
	 * The curve is built by iterative computing of the curve points
	 * with time-iterator modification from 0 to 1<br/>
	 * Bezier curve point is characterized by it's time-iterator.
	 * Two curve points with the same time-iterator coincide.
	 * Generally, two curve points with different time-iterator do not coincide.<br/>
	 * <a name="bezier_building_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *				      id="Step1Building" width="100%" height="500"
	 *				      codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *				      <param name="movie" value="../../images/Step01Building.swf" />
	 *				      <param name="quality" value="high" />
	 *				      <param name="bgcolor" value="#FFFFFF" />
	 *				      <param name="allowScriptAccess" value="sameDomain" />
	 *				      <embed src="../../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *						      width="100%" height="400" name="Step01Building"
	 *						      align="middle"
	 *						      play="true"
	 *						      loop="false"
	 *						      quality="high"
	 *						      allowScriptAccess="sameDomain"
	 *						      type="application/x-shockwave-flash"
	 *						      pluginspage="http://www.adobe.com/go/getflashplayer">
	 *				      </embed>
	 *      </object>
	 * </td></table>
	 * <br/>
	 * <p align="center"><strong>Interactive demo</strong><br/>
	 * <em>You can use "Left" and "Right" keys to control the iterator.<br/>
	 * Curve control points are dragable.</em></p><br/>
	 * <br/>
	 * <h3>Bezier second-order curve properties</h3>
	 * <ul>
	 *      <li>curve is continuous</li>
	 *      <li>curve is affine-invariant</li>
	 *      <li>all curve points lie inside the ∆SCE triangle</li>
	 *      <li>points <code>S</code> and <code>E</code> always
	 *      lie on the Bezier curve and limit it</li>
	 *      <li>points with uniformly changing iterator are closely
	 *      distributed on the segments with the bigger winding</li>
	 *      <li>Bezier curve summit - point with iterator <code>t = 0.5</code> -
	 *      lies in the middle of the segment, that connects <code>С</code> and the
	 *      middle of the <code>SE</code> segment</li>
	 *      <li>point <code>C</code> generally does not belongs to the curve
	 *      and lies on the intersection of the tangents to the curve from points
	 *      <code>S</code> and <code>E</code></li>
	 *      <li>if point <code>С</code> belongs to <code>SE</code> then the curve is singular</li>
	 *      <li>Square of the figure, composed of Bezier curve and segment
	 *      <code>SE</code> equals 2/3 of the ∆SCE triangle square</li>
	 * </ul>
	 * <h3>Bezier curve and parabola</h3>
	 * Bezier second-order curve is a parabola segment.
	 * Curve built from <a href="#formula1">formula <strong>1</strong></a> with iterator
	 * <code><strong>t</strong></code> changing in infinite limits is a parabola.
	 * If Bezier curve lies on parabola then this parabola is considered to be the parent for it.<br/>
	 * <em>
	 * This property also applies to the Bezier curves with other orders.
	 * For example, segment can be considered as Bezier first-order curve
	 * and it's parent will be the line that contains it.
	 * Class <code>Line</code> interprets segment this way to simplify
	 * it's usage together with <code>Bezier</code> class.<br/>
	 * Bezier third-order curve on the plane is a segment of projection of
	 * cubic parabola in a three-dimensional space on the plane.
	 * General case: Bezier N-order curve is a segment of projection
	 * of the N-order curve built in N-dimensional space.
	 * </em>
	 *
	 * @see Line
	 * @see Intersection
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @translator Maxim Kachurovskiy http://www.riapriority.com
	 **/
	public class Bezier extends Object implements IParametric {
		protected static const PRECISION : Number = Equations.PRECISION;
		private static const POINT0 : Point = new Point();
		private static const POINT1 : Point = new Point();
		private static const POINT2 : Point = new Point();
		private static const POINT3 : Point = new Point();
		protected var startPoint : Point;
		protected var controlPoint : Point;
		protected var endPoint : Point;
		protected var __isSegment : Boolean = true;

		// **************************************************
		// CONSTRUCTOR
		// **************************************************
		/* *
		 * 
		 * Создает новый объект Bezier. 
		 * Если параметры не переданы, то все опорные точки создаются в координатах 0,0  
		 * 
		 * @param start:Point начальная точка кривой Безье 
		 * 
		 * @param control:Point контрольная точка кривой Безье
		 *  
		 * @param end:Point конечная точка кривой Безье
		 * 
		 * @param isSegment:Boolean флаг ограниченности кривой Безье.
		 * 
		 * @example В этом примере создается кривая Безье в случайных координатах.  
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/** 
		 * Create new Bezier object.
		 * If parameters are not passed, all control points are created in coordinates 0,0
		 *
		 * @param start:Point initial point of Bezier curve
		 *
		 * @param control:Point control point of Bezier curve
		 *
		 * @param end:Point end point of Bezier curve
		 *
		 * @param isSegment:Boolean limitation flag
		 *
		 * @example In this example created Bezier curve with random coordinates.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function Bezier(start : Point = undefined, control : Point = undefined, end : Point = undefined, isSegment : Boolean = true) {
			initInstance(start, control, end, isSegment);
		}

		/* *
		 * Приватный инициализатор для объекта, который можно переопределить. Параметры совпадают с параметрами конструктора.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/**
		 * Private initializer for an object that can be redefined. Parameters coincide with the parameters of the constructor.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		protected function initInstance(start : Point = undefined, control : Point = undefined, end : Point = undefined, isSegment : Boolean = true) : void {
			startPoint = (start as Point) || new Point();
			controlPoint = (control as Point) || new Point();
			endPoint = (end as Point) || new Point();
			__isSegment = Boolean(isSegment);
		}

		// Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах,
		// start, control, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		/* *
		 * Начальная опорная точка кривой Безье. Итератор <code>time</code> равен нулю.
		 * 
		 * @return Point начальная точка кривой Безье
		 * 
		 * @default Point(0, 0)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 * 
		 **/
		// As public variables cannot be redefined in affiliated classes, start, control, end and isSegment
		// are realized as get-set methods, instead of as public variables.
		/**
		 * Initial anchor point of Bezier curve. Iterator <code>time</code> is equal to zero.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/
		public function get start() : Point {
			return startPoint;
		}

		public function set start(value : Point) : void {
			startPoint = value;
		}

		/* *
		 * Контрольная точка кривой Безье. 
		 * 
		 * @return Point контрольная точка кривой Безье
		 * 
		 * @default Point(0, 0)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/**
		 * Control point of Bezier curve.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function get control() : Point {
			return controlPoint;
		}

		public function set control(value : Point) : void {
			controlPoint = value;
		}

		/* *
		 * Конечная опорная точка кривой Безье. Итератор <code>time</code> равен единице.
		 *  
		 * @return Point конечная точка кривой Безье
		 *  
		 * @default Point(0, 0)
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		/**
		 * End anchor point of Bezier curve. Iterator <code>time</code> is equal to one
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function get end() : Point {
			return endPoint;
		}

		public function set end(value : Point) : void {
			endPoint = value;
		}

		/* *
		 * Определяет является ли кривая Безье бесконечной в обе стороны
		 * или ограничена в пределах значения итераторов от 0 до 1.<BR/>
		 * <BR/>
		 * Безье строится с использованием итератора в пределах от 0 до 1, однако, 
		 * может быть построена в произвольных пределах.<BR/> 
		 * Кривая Безье, построеная от минус бесконечности до плюс 
		 * бесконечности является параболой, которая так же называется "родительской кривой" для Безье.<BR/>
		 * <BR/>
		 * Текущее значение isSegment влияет на результаты методов:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Line.html#intersectionBezier">Line.intersectionBezier</a><BR/>
		 * 
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 * 
		 * @return Boolean флаг ограниченности кривой Безье
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/**
		 * Defines is the Bezier curve is infinite in both directions or is limited within
		 * the bounds of value of iterators from 0 up to 1.<BR/>
		 * <BR/>
		 * The Bezier curve is constructed with using iterator within the bounds from 0 up to 1,
		 * however, it can be constructed in any bounds.<BR/>
		 * The Bezier curve constructed from a minus of infinity up to plus of infinity is a parabola.<BR/>
		 * <BR/>
		 * Current value isSegment influence on the results of methods:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Line.html#intersectionBezier">Line.intersectionBezier</a><BR/>
		 *
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 *
		 * @return Boolean
		 * 
		 * @default true
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function get isSegment() : Boolean {
			return __isSegment;
		}

		public function set isSegment(value : Boolean) : void {
			__isSegment = value;
		}

		/* *
		 * Создает и возвращает копию текущего объекта Bezier. 
		 * Обратите внимание, что в копии опорные точки так же копируются, и являются новыми объектами.
		 * 
		 * @return Bezier копия кривой Безье
		 * 
		 * @example В этом примере создается случайная кривая Безье и ее копия. 
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const bezier:Bezier = randomBezier();
		 * const clone:Bezier = bezier.clone();
		 * trace("bezier: "+bezier);
		 * trace("clone: "+clone);
		 * trace(bezier == clone); // false
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/**
		 * Creates and returns a copy of the current Bezier object.
		 * Please note that copies of the control points are copied as well, and they are new objects.
		 * 
		 * @return Bezier copy of the Bezier curve
		 * 
		 * @example This example creates a random Bezier curve and its copy:
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 * const clone:Bezier = bezier.clone();
		 * trace("bezier: "+bezier);
		 * trace("clone: "+clone);
		 * trace(bezier == clone);
		 *
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function clone() : Bezier {
			return new Bezier(startPoint.clone(), controlPoint.clone(), endPoint.clone(), __isSegment);
		}

		// **************************************************
		// GEOMETRIC PROPERTIES
		// **************************************************
		/* *
		 * Проверка вырожденности кривой в прямую линию.<BR/>
		 * Если кривая Безье вырождена в бесконечную в оба направления прямую линию, 
		 * возвращается объект класса Line со свойством isRay = false, геометрически 
		 * совпадающий с кривой Безье.<BR/>
		 * Если кривая Безье вырождена в луч, то есть прямую линию, бесконечную 
		 * только в одном направлении, возвращается объект класса Line со свойством isRay = true.<BR/>
		 * В других случаях, если кривая Безье выпуклая, или вырождена в точку, возвращается null.<BR/>
		 * Если при этом control между start и end, то isRay=true. Начало луча в этом случае 
		 * вычисляется просто - это точка с итератором time=0.5.<BR/>
		 * Остается проблема, что в новосозданном объекте Line итератор действует иначе, чем в кривой. 
		 * В случае использования объекта Line там, где надо вычислить инератор по кривой Безье, нужно 
		 * не забывать об этом, получать Point и пользоваться методом getPointOnCurve.<BR/>
		 *  
		 * @return Line прямая, в которую вырождена кривая Безье
		 * 
		 * @example В этом примере создается кривая Безье, и проверяется ее вырожденность в прямую линию.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *		
		 * const bezier:Bezier = Bezier( new Point(100, 100), new Point(200, 200), new Point(300, 301));
		 * var line:Line = bezier.curveAsLine();
		 * trace("Is it line? "+ (line != null)); // Is it line? false
		 * bezier.end.y = 300;
		 * line = bezier.curveAsLine();
		 * trace("Is it line? "+ (line != null)); // Is it line?  true
		 * 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Checking the degeneracy of the curve in a straight line.<BR/>
		 * If the Bezier curve is degenerate in an infinite in both directions straight line, 
		 * an object of class Line with the property isRay = false, geometrically coinciding 
		 * with the Bezier curve, returns.<BR/>
		 * If the Bezier curve is degenerate in a ray, i.e. a straight line, infinite in one 
		 * direction only, an object of class Line with the property isRay = true returns.<BR/>
		 * In other cases, if the Bezier curve is convex, or degenerate to the point, returns null.<BR/>
		 * If the control is between the start and end, then isRay=true. In this case the start of 
		 * a ray is calculated simply - it is a point with an iterator time=0.5.<BR/>
		 * There remains the problem that in the newly created object Line iterator operates 
		 * differently than in the curve. In the case of using an object Line, where we have 
		 * to calculate the iterator on a Bezier curve, we must not forget about obtaining 
		 * a Point and using the method getPointOnCurve.<BR/>
		 * 
		 * @return Line the line, which is degenerate Bezier curve
		 * 
		 * @example In this example a Bezier curve is created, and its degeneration into a straight line is checked.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Line;
		 * import flash.geom.Point;
		 *		
		 * const bezier:Bezier = Bezier( new Point(100, 100), new Point(200, 200), new Point(300, 301));
		 * var line:Line = bezier.curveAsLine();
		 * trace("Is it line? "+ (line != null)); // Is it line? false
		 * bezier.end.y = 300;
		 * line = bezier.curveAsLine();
		 * trace("Is it line? "+ (line != null)); // Is it line?  true
		 * 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		// Логика работы метода - проверка, что существует такое t, при котором control = start+t*(end-start).
		// The logic of method - check, that there exists a t, where control = start+t*(end-start).
		public function asLine() : Line {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const startToEndVector : Point = POINT1;
			startToEndVector.x = end.x - start.x;
			startToEndVector.y = end.y - start.y;

			if (startToEndVector.length > PRECISION) {
				var timeOfControl : Number = startToControlVector.length / startToEndVector.length;
				var isLine : Boolean = (Math.abs(startToControlVector.x - timeOfControl * startToEndVector.x) < PRECISION) && (Math.abs(startToControlVector.y - timeOfControl * startToEndVector.y) < PRECISION);

				if (isLine) {
					if (timeOfControl < 0) {
						return new Line(this.getPoint(this.parabolaVertex), end.clone(), this.isSegment, true);
					} else {
						if (timeOfControl > 1) {
							return new Line(this.getPoint(this.parabolaVertex), start.clone(), this.isSegment, true);
						} else {
							return new Line(start.clone(), end.clone(), this.isSegment, ((timeOfControl - 0.5) > PRECISION));
						}
					}
				}
			} else {
				if (startToControlVector.length > PRECISION) {
					return new Line(this.getPoint(this.parabolaVertex), start.clone(), this.isSegment, true);
				}
			}

			return null;
		}

		/* *
		 * Проверка вырожденности кривой в точку.
		 * Если кривая Безье вырождена в точку, то возвращается объект класса Point с координатой точки, в которую вырождена кривая.
		 * В других случаях, если кривая Безье выпуклая, или вырождена в прямую, возвращается null.
		 * 
		 * @return Point точка, в которую вырождена кривая Безье
		 * 
		 * @example В этом примере создается кривая Безье, и проверяется ее вырожденность в точку.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * const bezier:Bezier = Bezier( new Point(100, 100), new Point(100, 100), new Point(100, 101));
		 * var point:Point = bezier.curveAsPoint();
		 * trace("Is it point? "+ (point != null)); // Is it point? false
		 * bezier.end.y = 100;
		 * point = bezier.curveAsPoint();
		 * trace("Is it point? "+ (point != null)); // Is it point?  true
		 * 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Checking the degeneracy of the curve in a point.
		 * If the Bezier curve is degenerate in a point, an object of class Point with the coordinates of the point at which the curve degenerates returns.
		 * In other cases, if the Bezier curve is convex, or degenerate to a line, returns null.
		 * 
		 * @return Point the point, which is the degenerate Bezier curve
		 * 
		 * @example In this example a Bezier curve is created, and its degeneration into a point is checked.
		 * 
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * const bezier:Bezier = Bezier( new Point(100, 100), new Point(100, 100), new Point(100, 101));
		 * var point:Point = bezier.curveAsPoint();
		 * trace("Is it point? "+ (point != null)); // Is it point? false
		 * bezier.end.y = 100;
		 * point = bezier.curveAsPoint();
		 * trace("Is it point? "+ (point != null)); // Is it point?  true
		 * 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		// Логика работы метода - проверка, что все три опорные точки кривой совпадают, с учетом допуска.
		// The logic of method - tolerance check all three anchor points of the curve coincide
		public function asPoint() : Point {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const startToEndVector : Point = POINT1;
			startToEndVector.x = end.x - start.x;
			startToEndVector.y = end.y - start.y;

			if ((startToEndVector.length < PRECISION) && (startToControlVector.length < PRECISION)) {
				return start.clone();
			} else {
				return null;
			}
		}

		/* *
		 * Вычисляет длину кривой Безье от начальной точки до конечной.
		 * 
		 * @return Number длина кривой Безье
		 * 
		 * @example В этом примере создается случайная кривая Безье и выводится ее длина.  
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	trace("bezier length: "+bezier.length);
		 * 
		 * </listing> 
		 * 
		 * 
		 * @see #getSegmentLength
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 * 
		 **/
		/**
		 * Calculates a length of a Bezier curve from the initial point to the end point.
		 * 
		 * @return Number a length of a Bezier curve
		 * 
		 * @example In this example a Bezier curve is created, and its length is derived.
		 * <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * trace("bezier length: "+bezier.length);
		 * </listing>
		 *
		 *
		 * @see #getSegmentLength
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 **/
		public function get length() : Number {
			return getSegmentLength(1.0);
		}

		/* *
		 * Вычисляет длину сегмента кривой Безье от стартовой точки до
		 * точки на кривой, заданной параметром time. 
		 * 
		 * @param time:Number параметр time конечной точки сегмента.
		 * 
		 * @return Number длина сегмента кривой Безье
		 * 
		 * @private Логика работы метода - один раз был подсчитан интеграл длины кривой, и запрограммировано его вычисление для интервала 0..time
		 * 
		 * @example В этом примере создается случайная кривая Безье, 
		 * вычисляется time-итератор точки середины кривой, а затем
		 * выводятся значения половины длины кривой и длина сегмента
		 * кривой до средней точки - они должны быть равны.
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	const middleDistance:Number = bezier.length/2;
		 *	const middleTime:Number = bezier.getTimeByDistance(middleDistance);
		 *	const segmentLength:Number = bezier.getSegmentLength(middleTime);
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
		 * Calculates length of a segment of Bezier curve from a starting point
		 * up to a point on a curve which passed in parameter time.
		 *
		 * @param time:Number parameter time of the end point of a segment.
		 * @return Number length of arc.
		 *
		 * @example In this example creates random Bezier curve, calculates time-iterator
		 * of the middle of a curve, and then traces values of half of length of a curve
		 * and length of a segment of a curve up to an middle point - they should be equal.
		 * <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * const middleDistance:Number = bezier.length/2;
		 * const middleTime:Number = bezier.getTimeByDistance(middleDistance);
		 * const segmentLength:Number = bezier.getSegmentLength(middleTime);
		 *
		 * trace(middleDistance);
		 * trace(segmentLength);
		 *
		 *</listing>
		 *
		 *
		 * @see #length
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/
		public function getSegmentLength(time : Number) : Number {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const startToControlLenght : Number = startToControlVector.length;
			const startToControlLenghtPower2 : Number = startToControlLenght * startToControlLenght;
			const controlToStartMultiplyMainDiagonal : Number = 2 * (startToControlVector.x * diagonalVector.x + startToControlVector.y * diagonalVector.y);
			const diagonalLenght : Number = diagonalVector.length;
			const diagonalLenghtPower2 : Number = diagonalLenght * diagonalLenght;

			var integralValueInTime : Number;
			var integralValueInZero : Number;

			if (diagonalLenght == 0) {
				integralValueInTime = 2 * diagonalLenght * time;
				integralValueInZero = 0;
			} else {
				const integralFrequentPart1 : Number = Math.sqrt(diagonalLenghtPower2 * time * time + controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2);
				const integralFrequentPart2 : Number = (controlToStartMultiplyMainDiagonal + 2 * diagonalLenghtPower2 * time) / diagonalLenght + 2 * integralFrequentPart1;
				const integralFrequentPart3 : Number = controlToStartMultiplyMainDiagonal / diagonalLenght + 2 * startToControlLenght;
				const integralFrequentPart4 : Number = (startToControlLenghtPower2 - 0.25 * controlToStartMultiplyMainDiagonal * controlToStartMultiplyMainDiagonal / diagonalLenghtPower2);

				integralValueInTime = 0.5 * (2 * diagonalLenghtPower2 * time + controlToStartMultiplyMainDiagonal) * integralFrequentPart1 / diagonalLenghtPower2;
				if (Math.abs(integralFrequentPart2) >= PRECISION) {
					integralValueInTime += Math.log(integralFrequentPart2) / diagonalLenght * integralFrequentPart4;
				}

				integralValueInZero = 0.5 * (controlToStartMultiplyMainDiagonal) * startToControlLenght / diagonalLenghtPower2;
				if (Math.abs(integralFrequentPart3) >= PRECISION) {
					integralValueInZero += Math.log(integralFrequentPart3) / diagonalLenght * integralFrequentPart4;
				}
			}

			return integralValueInTime - integralValueInZero;
		}

		/* * 
		 * Вычисляет и возвращает площадь фигуры, ограниченой кривой Безье
		 * и отрезком, соединяющим начальную и конечную точку.
		 * Площадь этой фигуры составляет 2/3 площади треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.
		 * 
		 * @return Number площадь кривой Безье
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const randomBezier:Bezier = randomBezier();
		 *	
		 *  trace("bezier area: "+randomBezier.area);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #triangleArea
		 * 
		 * @lang rus	
		 **/
		/**
		 * Calculates and returns an area of the figure, limited by Bezier curve and a segment, connecting the initial point and the end point.
		 * The area of this figure makes 2/3 areas of a triangle ∆SCE, which is formed of control points <code>start, control, end</code>.
		 * 
		 * @return Number an area of the Bezier curve
		 *
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * trace("bezier area: "+randomBezier.area);
		 *
		 * </listing>
		 *
		 * @see #triangleArea
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 *
		 **/
		public function get area() : Number {
			return this.triangleArea * (2.0 / 3.0);
		}

		/* *
		 * Вычисляет и возвращает площадь треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.  
		 * 
		 * @return Number площадь треугольника, ограничиваюшего кривую Безье
		 * 
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * trace("triangle area: "+randomBezier.triangleArea);
		 *
		 * </listing>
		 * 
		 * 
		 * @see #area
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		/**
		 * Calculates and returns an area of the triangle ∆SCE, which is formed of control points <code>start, control, end</code>.
		 * @return Number an area of the triangle, limiting a Bezier curve
		 * 
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * trace("triangle area: "+randomBezier.triangleArea);
		 * </listing>
		 * 
		 * @see #area
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 **/
		// Логика работы метода - вычисление площади треугольника по формуле Герона.
		// The logic of method - calculate an area of a triangle using the Heron's formula.
		public function get triangleArea() : Number {
			const distanceStartControl : Number = Point.distance(startPoint, controlPoint);
			const distanceEndControl : Number = Point.distance(endPoint, controlPoint);
			const distanceStartEnd : Number = Point.distance(startPoint, endPoint);
			const halfPerimeter : Number = (distanceStartControl + distanceEndControl + distanceStartEnd) / 2;
			const area : Number = Math.sqrt(halfPerimeter * (halfPerimeter - distanceStartControl) * (halfPerimeter - distanceEndControl) * (halfPerimeter - distanceStartEnd));
			return area;
		}

		/* *
		 * Получение центра тяжести кривой Безье.
		 * 
		 * @return Point центр тяжести кривой Безье
		 * 
		 * @example В этом примере создается случайна кривая Безье, и выводится ее центр тяжести.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.internalCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #externalCentroid
		 * @see #triangleCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Obtaining a center of gravity of a Bezier curve.
		 * 
		 * @param targetPoint:Point 
		 * 
		 * @return Point a center of gravity of a Bezier curve
		 * 
		 * @example In this example a random Bezier curve is created, and its center of gravity is derived.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.internalCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #externalCentroid
		 * @see #triangleCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */
		public function get internalCentroid() : Point {
			const x : Number = (startPoint.x + endPoint.x) * 0.4 + controlPoint.x * 0.2;
			const y : Number = (startPoint.y + endPoint.y) * 0.4 + controlPoint.y * 0.2;
			return new Point(x, y);
		}

		/**
		 * Получение центра тяжести внешней фигуры - фигуры, полученной кривой Безье и боковыми сторонами (SC,CE) описывающего ее треугольника.
		 * 
		 * @return Point центр тяжести врешней фигуры.
		 * 
		 * @example В этом примере создается случайна кривая Безье, и выводится центр тяжести внешней фигуры.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.externalCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #internalCentroid
		 * @see #triangleCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Obtaining a center of gravity of the outside figure - this figure is obtained by the Bezier curve and sides (SC,CE) of the bounding triangle.
		 * 
		 * @return Point a center of gravity of the outside figure
		 * 
		 * @example In this example a random Bezier curve is created and a center of gravity of the outside figure is derived.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.externalCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #internalCentroid
		 * @see #triangleCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		public function get externalCentroid() : Point {
			const x : Number = (startPoint.x + endPoint.x) * 0.2 + controlPoint.x * 0.6 ;
			const y : Number = (startPoint.y + endPoint.y) * 0.2 + controlPoint.y * 0.6;
			return new Point(x, y);
		}

		/* *
		 * Получение центра тяжести треугольника, описывающего кривую Безье.
		 * 
		 * @return Point центра тяжести треугольника, описывающего кривую Безье
		 * 
		 * @example В этом примере создается случайна кривая Безье, и выводится центр тяжести описывающего ее треугольника.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.triangleCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #internalCentroid
		 * @see #externalCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Obtaining a center of gravity of the triangle, bounding the Bezier curve.
		 * 
		 * @return Point a center of gravity of the triangle, bounding the Bezier curve
		 * 
		 * @example In this example a random Bezier curve is created and a center of gravity of its bounding triangle is derived.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var point:Point = randomBezier.triangleCentroid;
		 * trace(point.x+" "+point.y); 
		 *  
		 * </listing>
		 *
		 * @see #internalCentroid
		 * @see #externalCentroid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function get triangleCentroid() : Point {
			const x : Number = (startPoint.x + endPoint.x + controlPoint.x) / 3 ;
			const y : Number = (startPoint.y + endPoint.y + controlPoint.y) / 3;
			return new Point(x, y);
		}

		/* *
		 * Вычисляет и возвращает описывающий прямоугольник сегмента кривой Безье между начальной и конечной точками.<BR/> 
		 * Если свойство isSegment=false, это игнорируется, не влияет на результаты рассчета.</I> 
		 * 
		 * @return Rectangle габаритный прямоугольник.
		 * 
		 * @example В этом примере создается случайна кривая Безье, и выводится центр тяжести описывающего ее треугольника.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 * import flash.geom.Rectangle;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var boundBox:Rectangle = randomBezier.bounds;
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
		 * Calculates and returns a bounding rectangle of the Bezier curve segment between initial point and end point.
		 * If the property isSegment=false, it is ignored, does not affect the results of the calculation.
		 * 
		 * @return Rectangle bounding rectangle
		 * 
		 * @example In this example a random Bezier curve is created and a center of gravity of its bounding triangle is derived.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 * import flash.geom.Rectangle;
		 *		
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 * var boundBox:Rectangle = randomBezier.bounds;
		 * trace(boundBox.x+" "+boundBox.y+" "+boundBox.width+" "+boundBox.height); 
		 *  
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		// Логика работы метода - вычисляются минимальные и максимальные значения координат из начальной и конечной точек, и возможно, точек экстремума по каждой из координат.
		// Logic of the method - calculate minimum and maximum values of the coordinates of the initial and end points, and perhaps the extreme points in each of the coordinates.
		public function get bounds() : Rectangle {
			var xMin : Number = Math.min(startPoint.x, endPoint.x);
			var xMax : Number = Math.max(startPoint.x, endPoint.x);
			var yMin : Number = Math.min(startPoint.y, endPoint.y);
			var yMax : Number = Math.max(startPoint.y, endPoint.y);

			const controlToStartVector : Point = POINT0;
			controlToStartVector.x = start.x - control.x;
			controlToStartVector.y = start.y - control.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const extremumTimeX : Number = controlToStartVector.x / diagonalVector.x;
			const extremumTimeY : Number = controlToStartVector.y / diagonalVector.y;

			if ((!isNaN(extremumTimeX)) && (extremumTimeX > 0) && (extremumTimeX < 1)) {
				const extremumPointX : Point = getPoint(extremumTimeX);
				xMin = Math.min(extremumPointX.x, xMin);
				xMax = Math.max(extremumPointX.x, xMax);
			}

			if ((!isNaN(extremumTimeY)) && (extremumTimeY > 0) && (extremumTimeY < 1)) {
				const extemumPointY : Point = getPoint(extremumTimeY);
				yMin = Math.min(extemumPointY.y, yMin);
				yMax = Math.max(extemumPointY.y, yMax);
			}

			const width : Number = xMax - xMin;
			const height : Number = yMax - yMin;
			return new Rectangle(xMin, yMin, width, height);
		}

		// **************************************************
		// PARENT PARABOLA
		// **************************************************
		/* *
		 * Вычисляет и возвращает time-итератор вершины родительской параболы.
		 * Точку можно получить из итератора методом getPoint у кривой Безье, так как вершина параболы принадлежит ей. 
		 * 
		 * @return Number time-итератор вершины родительской параболы
		 * 
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 *	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const randomBezier:Bezier = randomBezier();
		 *	
		 * trace("parabola vertex time: "+randomBezier.parabolaVertex);
		 *	
		 * </listing>
		 * 
		 * @see #parabolaFocus
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Calculates and returns the time-iterator of vertex of the parent parabola.
		 * The point can be obtained from the iterator using the method getPoint from Bezier curve, as the vertex of the parabola belongs to it.
		 * 
		 * @return Number time-iterator of vertex of the parent parabola
		 *
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 *
		 * trace("parabola vertex time: "+randomBezier.parabolaVertex);
		 *
		 * </listing>
		 *
		 * @see #parabolaFocus
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 *
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function get parabolaVertex() : Number {
			const controlToStartVector : Point = POINT0;
			controlToStartVector.x = start.x - control.x;
			controlToStartVector.y = start.y - control.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const diagonalLengh : Number = diagonalVector.length;
			const diagonalLenghtPower2 : Number = diagonalLengh * diagonalLengh;

			var vertexTime : Number = 0.5;
			if (diagonalLengh > PRECISION) {
				vertexTime = (diagonalVector.x * controlToStartVector.x + diagonalVector.y * controlToStartVector.y) / diagonalLenghtPower2;
			}
			return vertexTime;
		}

		/**
		 * Вычисляет и возвращает фокус родительской параболы кривой Безье.
		 * 
		 * @return Point фокус родительской параболы
		 * 
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 *	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const randomBezier:Bezier = randomBezier();
		 * const point:Point = randomBezier.parabolaFocusPoint();
		 * trace("parabola focus: "+point.x+" "+point.y);
		 *	
		 * </listing>
		 * 
		 * @see #parabolaVertex
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Calculates and returns the focus of parent parabola of the Bezier curve.
		 * 
		 * @return Point a focus of parent parabola
		 * 
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 *	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const randomBezier:Bezier = randomBezier();
		 * const point:Point = randomBezier.parabolaFocusPoint();
		 * trace("parabola focus: "+point.x+" "+point.y);
		 *	
		 * </listing>
		 * 
		 * @see #parabolaVertex
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */
		public function get parabolaFocus() : Point {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const diagonalLenght : Number = diagonalVector.length;
			const diagonalLenghtPower2 : Number = diagonalLenght * diagonalLenght;

			if (diagonalLenght < PRECISION) {
				return controlPoint.clone();
			}

			const vertexTime : Number = -(diagonalVector.x * startToControlVector.x + diagonalVector.y * startToControlVector.y) / diagonalLenghtPower2;
			const parabolaVertex : Point = getPoint(vertexTime);
			const parabolaAxisX : Number = 2 * startToControlVector.x + 2 * vertexTime * diagonalVector.x;
			const parabolaAxisY : Number = 2 * startToControlVector.y + 2 * vertexTime * diagonalVector.y;
			const parabolaAxisLengthPower2 : Number = parabolaAxisX * parabolaAxisX + parabolaAxisY * parabolaAxisY;
			const parabolaAxisLength : Number = Math.sqrt(parabolaAxisLengthPower2);
			const focusLength : Number = parabolaAxisLengthPower2 / diagonalLenght / 4;

			var focusX : Number = parabolaVertex.x - focusLength * parabolaAxisY / parabolaAxisLength;
			var focusY : Number = parabolaVertex.y + focusLength * parabolaAxisX / parabolaAxisLength;

			const parabolaConvexity : Number = (parabolaAxisY * (start.x - parabolaVertex.x) - parabolaAxisX * (start.y - parabolaVertex.y)) * (parabolaAxisY * (focusX - parabolaVertex.x) - parabolaAxisX * (focusY - parabolaVertex.y));

			if (parabolaConvexity < 0) {
				focusX = parabolaVertex.x + focusLength * parabolaAxisY / parabolaAxisLength;
				focusY = parabolaVertex.y - focusLength * parabolaAxisX / parabolaAxisLength;
			}

			return new Point(focusX, focusY);
		}

		// **************************************************
		// CURVE POINTS
		// **************************************************
		/* *
		 * Вычисляет и возвращает объект Point, представляющий точку на кривой Безье, заданную параметром <code>time</code>.
		 * Реализация <a href="#formula1">формулы 1</a><BR/>
		 * 
		 * <I>
		 * Если передан параметр time равный 0 или 1, то будут возвращены объекты Point
		 * эквивалентные <code>start</code> и <code>end</code>, но не сами объекты <code>start</code> и <code>end</code> 
		 * </I> 
		 * 
		 * @param time:Number итератор точки кривой
		 * @param point:Point=null необязательный параметр, объект Point, в который будут записаны координаты. 
		 * Если этот параметр не передан, то будет создан и возвращен новый объект Point с вычисленными координатами.
		 * 
		 * @return Point точка на кривой Безье
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	const time:Number = Math.random();
		 *	const point:Point = bezier.getPoint(Math.random());
		 *	
		 *	trace(point);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Calculates and returns the object Point, introducing the point on the Bezier curve, given by the parameter <code>time</code>.
		 * Implementation of the <a href="#formula1">formula 1</a>
		 * 
		 * <I>
		 * If the given parameter time equals 0 or 1, so the objects Point equal to <code>start</code> and <code>end</code> will be returned, 
		 * but not the objects <code>start</code> and <code>end</code> itself.
		 * </I>
		 * 
		 * @param time:Number iterator of the point of the curve
		 * @param point:Point=null optional parameter, object Point
		 * 
		 * @return Point point on the Bezier curve
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * 		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * const time:Number = Math.random();
		 * const point:Point = bezier.getPoint(time);
		 *
		 * trace(point);
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function getPoint(time : Number, point : Point = null) : Point {
			if (isNaN(time)) {
				return null;
			}
			point = point || new Point();
			const invertedTime : Number = 1 - time;
			const timePower2 : Number = time * time;
			const invertedTimePower2 : Number = invertedTime * invertedTime;

			point.x = invertedTimePower2 * startPoint.x + 2 * time * invertedTime * controlPoint.x + timePower2 * endPoint.x;
			point.y = invertedTimePower2 * startPoint.y + 2 * time * invertedTime * controlPoint.y + timePower2 * endPoint.y;
			return point;
		}

		/* Логика работы метода - считается интеграл длины L(t) сегмента кривой Безье от 0 до t, и ищется решение L(t)=distance.
		 * Решение производится методом Ньютона, т.к. функция L(t) монотонна и везде имеет производную. 
		 * Смысл делать метод для вычисления нескольких значений есть, потому как много общих величин вычисляется предварительно.
		 */
		/* Logic of the method - calculates length integral L(t) of the Bezier curve segment from 0 to t, and seek a solution of L(t)=distance.
		 * The decision is made by Newton's method, because function L(t) is monotone and has a derivative everywhere.
		 * Making the method for calculating multiple values is worthwhile, because a lot of common values are calculated previously.
		 */
		protected function getTimesByDistances(distances : Array) : Array {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const curveLength : Number = length;
			const startToControlLenght : Number = startToControlVector.length;
			const startToControlLenghtPower2 : Number = startToControlLenght * startToControlLenght;
			const controlToStartMultiplyMainDiagonal : Number = 2 * (startToControlVector.x * diagonalVector.x + startToControlVector.y * diagonalVector.y);
			const diagonalLenght : Number = diagonalVector.length;
			const diagonalLenghtPower2 : Number = diagonalLenght * diagonalLenght;

			const integralFrequentPart1 : Number = 4 * startToControlLenghtPower2 - controlToStartMultiplyMainDiagonal * controlToStartMultiplyMainDiagonal / diagonalLenghtPower2;
			const integralFrequentPart2 : Number = 0.5 * controlToStartMultiplyMainDiagonal * Math.sqrt(startToControlLenghtPower2) / diagonalLenghtPower2;
			const integralFrequentPart3 : Number = controlToStartMultiplyMainDiagonal / Math.sqrt(diagonalLenghtPower2) + 2 * Math.sqrt(startToControlLenghtPower2);
			var integralFrequentPart4 : Number;
			var integralFrequentPart5 : Number;
			var integralValueInTime : Number;
			var integralValueInZero : Number;
			var arcLength : Number;
			var derivativeArcLength : Number;

			var times : Array = new Array();

			for (var i : int = 0;i < distances.length; i++) {
				var distance : Number = distances[i];

				var maxIterations : Number = 20;
				var time : Number = distance / curveLength;

				if (diagonalLenght < PRECISION) {
					if (controlToStartMultiplyMainDiagonal < PRECISION) {
						do {
							arcLength = 2 * startToControlLenght * time;
							derivativeArcLength = 2 * Math.sqrt(diagonalLenghtPower2 * time * time + controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2) || PRECISION;
							time = time - (arcLength - distance) / derivativeArcLength;
						} while ((Math.abs(arcLength - distance) > PRECISION) && (maxIterations--));
					} else {
						do {
							arcLength = (4 / 3) * (controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2) * Math.sqrt(controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2) / controlToStartMultiplyMainDiagonal - (4 / 3) * startToControlLenghtPower2 * startToControlLenght / controlToStartMultiplyMainDiagonal;
							derivativeArcLength = 2 * Math.sqrt(diagonalLenghtPower2 * time * time + controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2) || PRECISION;
							time = time - (arcLength - distance) / derivativeArcLength;
						} while ((Math.abs(arcLength - distance) > PRECISION) && (maxIterations--));
					}
				} else {
					do {
						integralFrequentPart4 = 2 * Math.sqrt(diagonalLenghtPower2 * time * time + controlToStartMultiplyMainDiagonal * time + startToControlLenghtPower2);
						integralFrequentPart5 = (controlToStartMultiplyMainDiagonal + 2 * diagonalLenghtPower2 * time) / diagonalLenght + integralFrequentPart4;

						integralValueInTime = 0.25 * (2 * diagonalLenghtPower2 * time + controlToStartMultiplyMainDiagonal) * integralFrequentPart4 / diagonalLenghtPower2;
						integralValueInZero = integralFrequentPart2;

						if (integralFrequentPart5 >= PRECISION) {
							integralValueInTime += 0.25 * Math.log(integralFrequentPart5) / diagonalLenght * integralFrequentPart1;
						}
						if (integralFrequentPart3 >= PRECISION) {
							integralValueInZero += 0.25 * Math.log(controlToStartMultiplyMainDiagonal / diagonalLenght + 2 * startToControlLenght) / diagonalLenght * integralFrequentPart1;
						}

						arcLength = integralValueInTime - integralValueInZero;
						derivativeArcLength = integralFrequentPart4 || PRECISION;
						time = time - (arcLength - distance) / derivativeArcLength;
					} while ((Math.abs(arcLength - distance) > PRECISION) && (maxIterations--));
				}

				times[times.length] = time;
			}

			return times;
		}

		/**
		 * Вычисляет time-итератор точки, находящейся на заданной дистанции 
		 * по кривой от точки <code>start</code><BR/>
		 * <I>Для вычисления равноудаленных последовательностей точек,
		 * например, для рисования пунктиром, используйте метод getTimesSequence</I>
		 * 
		 * @param distance:Number дистанция по кривой до искомой точки.
		 * 
		 * @return Number time-итератор искомой точки
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * 
		 *	trace(bezier.getTimeByDistance(-10); // negative value
		 *	trace(bezier.getTimeByDistance(bezier.length/2); // value between 0 and 1
		 * </listing>
		 * 
		 * @see #getPoint
		 * @see #getTimesSequence
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Calculates time-iterator of the point, located at a given distance along the curve from the point <code>start</code>
		 * To calculate the equidistant sequence of points, for example, drawing a dotted line, use the method getTimesSequence.
		 * 
		 * @param distance:Number a distance from the curve to the desired point
		 * @return Number time-iterator of the desired point
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * 
		 *	trace(bezier.getTimeByDistance(-10); // negative value
		 *	trace(bezier.getTimeByDistance(bezier.length/2); // value between 0 and 1
		 * </listing>
		 * 
		 * @see #getPoint
		 * @see #getTimesSequence
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		// Логика работы метода - сводится к общему методу вычисления массива итераторов по массиву дистанций
		// Logic of the method - reduces the common method of calculating the iterators array over distances array
		public function getTimeByDistance(distance : Number) : Number {
			if (isNaN(distance)) {
				return Number.NaN;
			}

			const curveLength : Number = this.length;

			if (__isSegment) {
				if (distance <= 0) {
					return 0;
				}
				if (distance >= curveLength) {
					return 1;
				}
			}

			var distances : Array = new Array();
			distances.push(distance);
			var times : Array = getTimesByDistances(distances);

			return times[0];
		}

		/**  
		 * Вычисляет и возвращает массив time-итераторов точек, 
		 * находящихся друг от друга на дистанции по кривой,
		 * заданной параметром <code>step</code>.<BR/>
		 * Если задан параметр <code>startShift</code>, то расчет производится
		 * не от точки <code>start</code>, а от точки на кривой, находящейся на 
		 * заданнй этим параметром дистанции.<BR/>
		 * Значение startShift конвертируется в остаток от деления на step.<BR/> 
		 *  
		 * @param step:Number шаг, дистанция по кривой между точками.
		 * @param startShift:Number дистанция по кривой, задающая смещение первой 
		 * точки последовательности относительно точки <code>start</code>
		 *  
		 * @return Array массив итераторов
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var points:Array = bezier.getTimesSequence(10, 0);
		 *
		 *  for(var i:uint=0; i<points.length; i+=2)
		 *  {
		 *  	var startSegmentTime:Number = points[i];
		 *		var endSegmentTime:Number = points[i+1];
		 *		var segment:Bezier = bezier.getSegment(startSegmentTime, endSegmentTime);
		 *		drawBezier(segment);
		 *  }
		 *
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**  
		 * Calculates the array of time-iterators of points, are separated by a distance on the curve given by the parameter <code>step</code>.
		 * If the parameter <code>startShift</code> is given, the calculation is made not from the point <code>start</code>, 
		 * but from the point on the curve, located on a range given by this parameter.
		 * The value startShift is converted to remainder of division by step.
		 * 
		 * @param step:Number a step, distance along the curve between points.
		 * @param startShift:Number a distance along the curve between points, giving the shift of the first point 
		 * of the sequence relatively to the point <code>start</code>
		 * 
		 * @return Array array of the iterators
		 * 
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var points:Array = bezier.getTimesSequence(10, 0);
		 *
		 *  for(var i:uint=0; i<points.length; i+=2)
		 *  {
		 *  	var startSegmentTime:Number = points[i];
		 *		var endSegmentTime:Number = points[i+1];
		 *		var segment:Bezier = bezier.getSegment(startSegmentTime, endSegmentTime);
		 *		drawBezier(segment);
		 *  }
		 *
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		// Логика работы метода - сводится к общему методу вычисления массива итераторов по массиву дистанций
		// Logic of the method - reduces the common method of calculating the iterators array over distances array
		public function getTimesSequence(step : Number, startShift : Number = 0) : Array {
			step = Math.abs(step);

			var times : Array = new Array();
			const curveLength : Number = length;

			if (startShift < 0) {
				startShift = startShift % step + step;
			} else {
				startShift = startShift % step;
			}

			if (startShift > curveLength) {
				return times;
			}

			var distance : Number = startShift;
			var distances : Array = new Array();

			while (distance <= curveLength) {
				distances[distances.length] = distance;
				distance += step;
			}

			times = this.getTimesByDistances(distances);

			return times;
		}

		// **************************************************
		// CHANGE OF BEZIER CURVE
		// **************************************************
		/**
		 * Изменяет кривую таким образом, что заданная параметром time точка кривой <code>P<sub>t</sub></code>, 
		 * будет находиться в заданных параметрами <code>x</code> и <code>y</code> координатах.<BR/>
		 * Если один из параметров <code>x</code> или <code>y</code> не задан, 
		 * то точка <code>P<sub>t</sub></code> не изменит значение соответствующей координаты.<BR/>
		 * <BR/>
		 * <I>Типичное применение данного метода - организация интерактивного изменения кривой пользователем с помощью мыши.</I>
		 * 
		 * @param time:Number time-итератор точки кривой.
		 * @param x:Number новое значение позиции точки по оси X.
		 * @param y:Number новое значение позиции точки по оси Y.
		 * 
		 * @example 
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	trace(bezier);
		 *	
		 *	bezier.setPoint(0, 0, 0);
		 *	bezier.setPoint(0.5, 100, 100);
		 *	bezier.setPoint(1, 200, 0);
		 *	
		 *	trace(bezier); // (start:(x=0, y=0), control:(x=100, y=200), end:(x=200, y=0))
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Changes the curve in such a way that the point of the curve <code>P<sub>t</sub></ code> 
		 * given by the parameter time, will be located in the coordinates, given by the specified 
		 * parameters <code>x</code> and <code>y</code>.<BR/>
		 * If one of the parameters <code>x</code> or <code>y</code> is not given, so the point 
		 * <code>P<sub>t</sub></code> will not change the corresponding coordinates.<BR/>
		 * <BR/>
		 * 
		 * <I>A typical application of this method is the organization of interactive change of the curve by the user using the mouse.</I>
		 * 
		 * @param time:Number a time-iterator of a point of a curve.
		 * @param x:Number new value of the position of a point on the X axis.
		 * @param y:Number new value of the position of a point on the Y axis.
		 * 
		 * @example 
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	trace(bezier);
		 *	
		 *	bezier.setPoint(0, 0, 0);
		 *	bezier.setPoint(0.5, 100, 100);
		 *	bezier.setPoint(1, 200, 0);
		 *	
		 *	trace(bezier); // (start:(x=0, y=0), control:(x=100, y=200), end:(x=200, y=0))
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function setPoint(time : Number, newX : Number = undefined, newY : Number = undefined) : void {
			if ((isNaN(newX) && isNaN(newY))) {
				return;
			}

			const invertedTime : Number = 1 - time;
			const timePower2 : Number = time * time;
			const invertedTimePower2 : Number = invertedTime * invertedTime;
			const timeMultiplyInvertedTime : Number = 2 * time * invertedTime;

			var point : Point = this.getPoint(time);

			if (isNaN(newX)) {
				newX = point.x;
			}
			if (isNaN(newY)) {
				newY = point.y;
			}

			switch (time) {
				case 0:
					startPoint.x = newX;
					startPoint.y = newY;
					break;
				case 1:
					endPoint.x = newX;
					endPoint.y = newY;
					break;
				default:
					controlPoint.x = (newX - timePower2 * endPoint.x - invertedTimePower2 * startPoint.x) / timeMultiplyInvertedTime;
					controlPoint.y = (newY - timePower2 * endPoint.y - invertedTimePower2 * startPoint.y ) / timeMultiplyInvertedTime;
			}
		}

		/* *
		 * Поворачивает кривую относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0)
		 * 
		 * @param value:Number угол поворота 
		 * @param fulcrum:Point центр вращения
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Rotate the curve relative to the point <code>fulcrum</code> at a given angle.
		 * If the point <code>fulcrum</code> is not given, (0,0) is used
		 * 
		 * @param value:Number angle of rotation
		 * @param fulcrum:Point rotation center
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function angleOffset(value : Number, fulcrum : Point = null) : void {
			fulcrum = fulcrum || POINT0;
			POINT0.x = 0;
			POINT0.y = 0;

			const startLine : Line = new Line(fulcrum, startPoint);
			startLine.angle += value;
			const controlLine : Line = new Line(fulcrum, controlPoint);
			controlLine.angle += value;
			const endLine : Line = new Line(fulcrum, endPoint);
			endLine.angle += value;
		}

		/* *
		 * Смещает кривую на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0 
		 * @lang rus
		 */
		/**
		 * Moves a curve on the prescribed distance on axes X and Y.
		 *
		 * @param dx:Number offset by X
		 * @param dy:Number offset by Y
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 *
		 */
		public function offset(dX : Number = 0, dY : Number = 0) : void {
			startPoint.offset(dX, dY);
			controlPoint.offset(dX, dY);
			endPoint.offset(dX, dY);
		}

		/* *
		 * Вычисляет и возвращает time-итератор точки, заведомо принадлежащей кривой Безье.
		 * Используется только при уверенности, что точка лежит на кривой, например - для определения time-итератора от точки пересечения.
		 * Этот метод работает значительно быстрее универсального getClosest.
		 * В случае, если точек находится несколько (что возможно при вырожденности кривой в луч), будет возвращен time-итератор с минимальным значением, потому что там оба итератора дают одну и ту же точку.
		 * 
		 * @param point:Point точка на кривой
		 * 
		 * @see #getClosest
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Calculates and returns a time-iterator of a point, obviously belonging to a Bezier curve.
		 * Used only when convinced that the point lies on the curve, for example - to determine 
		 * the time-iterator from the point of intersection.<BR/>
		 * This method works much faster than universal getClosest.<BR/>
		 * If there are several points (which is possible if the curve is degenerate in the ray), 
		 * time-iterator with a minimum value will be returned, because there are two iterator giving the same point.
		 * 
		 * @param point:Point a point on the curve
		 * 
		 * @see #getClosest
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function getExistedPointIterators(point : Point) : Array {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			var squareCoefficient : Number = diagonalVector.x;
			var linearCoefficient : Number = 2 * startToControlVector.x;
			var freeCoefficient : Number = start.x - point.x;
			var solutions : Array = Equations.solveQuadraticEquation(squareCoefficient, linearCoefficient, freeCoefficient);

			if (!solutions) {
				squareCoefficient = diagonalVector.y;
				linearCoefficient = 2 * startToControlVector.y;
				freeCoefficient = start.y - point.y;
				solutions = Equations.solveQuadraticEquation(squareCoefficient, linearCoefficient, freeCoefficient);
			}

			var iteratorsArray : Array = new Array();

			if (solutions) {
				for (var i : uint = 0;i < solutions.length; i++) {
					if ((!isSegment) || ((solutions[i] >= 0) && (solutions[i] <= 1))) {
						var foundPoint : Point = getPoint(solutions[i]);
						if (Point.distance(foundPoint, point) < PRECISION) {
							iteratorsArray.push(solutions[i]);
						}
					}
				}
			}

			return iteratorsArray;
		}

		// **************************************************
		// BEZIER AND EXTERNAL POINTS
		// **************************************************
		/**
		 * <P>Вычисляет и возвращает time-итератор точки на кривой, 
		 * ближайшей к точке <code>fromPoint</code>.<BR/>
		 * В зависимости от значения свойства <a href="#isSegment">isSegment</a>
		 * возвращает либо значение в пределах от 0 до 1, либо от минус 
		 * бесконечности до плюс бесконечности.</P>
		 * 
		 * @param fromPoint:Point произвольная точка на плоскости
		 * 
		 * @return Number time-итератор ближайшей точки на кривой.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var fromPoint:Point = randomPoint();
		 *	var closest:Number = bezier.getClosest(fromPoint);
		 * 
		 *  trace(bezier);
		 *  trace(fromPoint);
		 *  trace(bezier.getPoint(closest));
		 *  
		 * </listing>
		 * 
		 * @see #isSegment
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 **/
		/**
		 * Calculates and returns a time-iterator of a point on a curve, nearest to the point <code>fromPoint</code>.
		 * Depending on the value of a property <a href="#isSegment">isSegment</a> returns a value ranging from 0 to 1, 
		 * or from minus infinity to plus infinity.
		 * 
		 * @param fromPoint:Point arbitrary point on the plane
		 * 
		 * @return Number time-iterator of the nearest point on a curve.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var fromPoint:Point = randomPoint();
		 *	var closest:Number = bezier.getClosest(fromPoint);
		 * 
		 *  trace(bezier);
		 *  trace(fromPoint);
		 *  trace(bezier.getPoint(closest));
		 *  
		 * </listing>
		 * 
		 * @see #isSegment
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function getClosest(fromPoint : Point) : Number {
			if (!fromPoint) {
				return NaN;
			}

			var curveAsPoint : Point = this.asPoint();
			if (curveAsPoint) {
				return 0;
			}

			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const fromPointToStartVector : Point = POINT2;
			fromPointToStartVector.x = startPoint.x - fromPoint.x;
			fromPointToStartVector.y = startPoint.y - fromPoint.y;

			const startToControlLenght : Number = startToControlVector.length;
			const startToControlLenghtPower2 : Number = startToControlLenght * startToControlLenght;
			const controlToStartMultiplyMainDiagonal : Number = startToControlVector.x * diagonalVector.x + startToControlVector.y * diagonalVector.y;
			const diagonalLenght : Number = diagonalVector.length;
			const diagonalLenghtPower2 : Number = diagonalLenght * diagonalLenght;
			const fromPointToStartMultiplyMainDiagonal : Number = fromPointToStartVector.x * diagonalVector.x + fromPointToStartVector.y * diagonalVector.y;
			const fromPointToStartMultiplyStartToControl : Number = startToControlVector.x * fromPointToStartVector.x + startToControlVector.y * fromPointToStartVector.y;

			var extremumTimes : Array;
			var cubicCoefficient : Number, squareCoefficient : Number, linearCoefficient : Number, freeCoefficient : Number;

			if (diagonalLenght > PRECISION) {
				cubicCoefficient = 1;
				squareCoefficient = 3 * controlToStartMultiplyMainDiagonal / diagonalLenghtPower2;
				linearCoefficient = (2 * startToControlLenghtPower2 + fromPointToStartMultiplyMainDiagonal) / diagonalLenghtPower2;
				freeCoefficient = fromPointToStartMultiplyStartToControl / diagonalLenghtPower2;

				extremumTimes = Equations.solveCubicEquation(cubicCoefficient, squareCoefficient, linearCoefficient, freeCoefficient);
			} else {
				linearCoefficient = 2 * startToControlLenghtPower2 + fromPointToStartMultiplyMainDiagonal;
				freeCoefficient = fromPointToStartMultiplyStartToControl;

				extremumTimes = Equations.solveLinearEquation(linearCoefficient, freeCoefficient);
			}

			if (__isSegment) {
				extremumTimes.push(0);
				extremumTimes.push(1);
			}

			var extremumTime : Number;
			var extremumPoint : Point;
			var extremumDistance : Number;

			var closestPointTime : Number;
			var closestDistance : Number;

			var isInside : Boolean;

			for (var i : uint = 0;i < extremumTimes.length; i++) {
				extremumTime = extremumTimes[i];
				extremumPoint = getPoint(extremumTime);

				extremumDistance = Point.distance(fromPoint, extremumPoint);

				isInside = (extremumTime >= 0) && (extremumTime <= 1);

				if (isNaN(closestPointTime)) {
					if (!__isSegment || isInside) {
						closestPointTime = extremumTime;
						closestDistance = extremumDistance;
					}
					continue;
				}

				if (extremumDistance < closestDistance) {
					if (!__isSegment || isInside) {
						closestPointTime = extremumTime;
						closestDistance = extremumDistance;
					}
				}
			}

			return closestPointTime;
		}

		// **************************************************
		// WORKING WITH SEGMENTS
		// **************************************************
		/* *
		 * Вычисляет и возвращает сегмент кривой Безье, заданный начальным и конечным итераторами.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Bezier;
		 * 
		 * @example 
		 * В данном примере на основе случайной кривой Безье создаются еще две.
		 * Первая из них - <code>segment1</code> 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 * const bezier:Bezier = randomBezier();
		 * const segment1:Bezier = bezier.getSegment(1/3, 2/3);
		 * const segment2:Bezier = bezier.getSegment(-1, 2);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		/**
		 * Calculates and returns a segment of a Bezier curve, defined by initial and end iterators.
		 * 
		 * @param fromTime:Number a time-iterator of an initial point of a segment of curve
		 * @param toTime:Number time--iterator of an end point of a segment of curve
		 * 
		 * @return Bezier;
		 * 
		 * @example In this example two Bezier curves are created on basis of random Bezier curve.<BR/>
		 * Frist of it is <code>segment1</code>
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 * const bezier:Bezier = randomBezier();
		 * const segment1:Bezier = bezier.getSegment(1/3, 2/3);
		 * const segment2:Bezier = bezier.getSegment(-1, 2);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Bezier {
			const segmentStart : Point = getPoint(fromTime);
			const segmentEnd : Point = getPoint(toTime);
			const segmentVertex : Point = getPoint((fromTime + toTime) / 2);
			const baseMiddle : Point = Point.interpolate(segmentStart, segmentEnd, 0.5);
			const segmentControl : Point = Point.interpolate(segmentVertex, baseMiddle, 2);
			return new Bezier(segmentStart, segmentControl, segmentEnd, true);
		}

		// **************************************************
		// TANGENT OF BEZIER POINT
		// **************************************************
		/**
		 * Касательная - это прямая, проходящая через заданную точку кривой Безье, совпадающая с ней по направлению в этой точке, и не пересекающая ее.
		 * Метод вычисляет и возвращает угол наклона точке кривой Безье, заданной time-итератором.
		 * Возвращаемое значение находится в пределах от отрицательного PI до положительного PI.
		 * 
		 * @param t:Number time-итератор точки на кривой
		 * @return Number угол наклона касательной
		 * 
		 * @example 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Tangent - a line passing through a given point of a Bezier curve, which coincides with its direction 
		 * at this point, and does not intersect it.
		 * The method calculates and returns the inclination to a point of a Bezier curve, defined by time-iterator.
		 * The return value is in the range from negative PI to positive PI.
		 * 
		 * @param t:Number time-iterator of a point on a curve
		 * @return Number tangent inclination
		 * 
		 * @example 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */
		public function getTangentAngle(time : Number = 0) : Number {
			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const tangentX : Number = startToControlVector.x + diagonalVector.x * time;
			const tangentY : Number = startToControlVector.y + diagonalVector.y * time;
			return Math.atan2(tangentY, tangentX);
		}

		// **************************************************
		// INTERSECTIONS
		// **************************************************
		/**
		 * Метод находит пересечения кривой Безье с точкой<BR/>
		 * Добавлен для гармонии с методами пересечения двух кривых Безье и кривой Безье с прямой.
		 * К этому методу сводятся остальные методы поиска пересечений в случае вырожденности фигур.
		 * 
		 * @param target:Point точка, с которой ищется пересечение
		 * @return Intersection объект с описанием пересечения
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var intersection:Intersection = bezier.intersectionPoint(new Point(100, 100));
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
		 * The method searches the intersection of the Bezier curve with a point.
		 * It is added for the harmony with the methods of intersection of two Bezier curves and intersection of Bezier curve with the line.
		 * By this method reduce the remaining methods of search of intersections in the case of degeneracy of the figures.
		 * 
		 * @param target:Point the point at which the intersection is sought
		 * 
		 * @return Intersection the object with the description of intersection
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var intersection:Intersection = bezier.intersectionPoint(new Point(100, 100));
		 *	trace(intersection);
		 *	
		 * </listing>
		 *  
		 * @see Intersection
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function intersectionPoint(target : Point) : Intersection {
			var intersection : Intersection = new Intersection();

			var closestTime : Number = this.getClosest(target);
			var closestPoint : Point = this.getPoint(closestTime);

			if (Point.distance(target, closestPoint) < PRECISION) {
				intersection.addIntersection(closestTime, 0, this.isSegment, false);
			}

			return intersection;
		}

		/**
		 * Метод находит пересечения кривой Безье с прямой линией<BR/>
		 * Результат вычисления пересечения кривой Безье с прямой может дать следующие результаты:  <BR/>
		 * - если пересечение отсутствует, возвращается объект Intersection с пустыми массивами currentTimes и targetTimes;<BR/>
		 * - если пересечение произошло в одной или двух точках, будет возвращен объект Intersection,
		 *   и time-итераторы точек пересечения на кривой Безье будут находиться в массиве currentTimes.
		 *   time-итераторы точек пересечения <code>target</code> будут находиться в массиве targetTimes;<BR/>
		 * - если кривая Безье вырождена, то может произойти совпадение. 
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
		 * 	import flash.geom.Point;
		 *	import flash.geom.Line;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var target:Line = new Line(new Point(100, 100), new Point(200, 200));
		 *	var intersection:Intersection = bezier.intersectionLine(target);
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
		 * The method searches the intersection of a Bezier curve with the line.<BR/>
		 * Calculation of the intersection of a Bezier curve with the line can give the following results:<BR/>
		 * - if there is no intersection, an object Intersection with empty arrays currentTimes and targetTimes returns;<BR/>
		 * - if there were intersections in one or two points, the object Intersection returns, 
		 * - and time-iterators of intersection points of a Bezier curve will be located in an array currentTimes. 
		 *   time-iterators of intersection points of Bezier curve <code>target</code> will be located in an array targetTimes;<BR/>
		 * - if the Bezier curve is degenerate, the coincidence can happen.<BR/>
		 *   In this case, the result is a segment - object Line (<code>isSegment=true</code>), 
		 *   which will be available as a property <code>coincidenceLine</code> in the returned object Intersection;<BR/>
		 * <BR/>
		 * The property <code>isSegment</code> of current object, as well as value <code>isSegment</code> of target object, affects the result of calculation.
		 * 
		 * @param target:Line line at which the intersection is sought
		 * 
		 * @return Intersection the object with the description of intersection
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	import flash.geom.Line;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var target:Line = new Line(new Point(100, 100), new Point(200, 200));
		 *	var intersection:Intersection = bezier.intersectionLine(target);
		 *	trace(intersection);
		 *	
		 * </listing>
		 * 
		 * @see Intersection
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */
		public function intersectionLine(target : Line) : Intersection {
			var intersection : Intersection = new Intersection();
			var i : int;

			var curveAsPoint : Point = this.asPoint();
			if (curveAsPoint) {
				intersection = target.intersectionPoint(curveAsPoint);
				intersection.switchCurrentAndTarget();
				return intersection;
			}

			var curveAsLine : Line = this.asLine();
			if (curveAsLine) {
				intersection = target.intersectionLine(curveAsLine);
				intersection.switchCurrentAndTarget();
				intersection.translateCurrentIterators(curveAsLine, this);

				return intersection;
			}

			var targetAsPoint : Point = target.asPoint();
			if (targetAsPoint) {
				intersection = this.intersectionPoint(targetAsPoint);
				return intersection;
			}

			// если ни одна из проверок не прошла, значит у нас настоящая кривая и настоящая прямая.
			// решаем чистый случай!
			// if none of the checks passed, then we have a real curve and a real line.
			// solving a pure chance!

			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const lineVector : Point = POINT2;
			lineVector.x = target.start.x - target.end.x;
			lineVector.y = target.start.y - target.end.y;

			const deltaStarts : Point = POINT3;
			deltaStarts.x = start.x - target.start.x;
			deltaStarts.y = start.y - target.start.y;

			var coefficientInPower2 : Number, coefficientInPower1 : Number, coefficientInPower0 : Number;
			var solutionsForCurve : Array;
			var solutionForLine : Number, solutionForCurve : Number;

			/*
			 * Дальше решается векторное уравнение (по 2 координатам - система 2 уравнений):
			 * 
			 * diagonal*t2^2 + 2*startToControl*t2 + lineVector*t + deltaStarts = 0
			 * 
			 * где t1 - итератор прямой, а t2 - итератор кривой Безье
			 * Пары решений (t1,t2) соответствуют одной и той же точке.
			 */
			/*
			 * Solving the vector equation (by 2 coordinates - 2 combined equations):
			 * diagonal*t2^2 + 2*startToControl*t2 + lineVector*t + deltaStarts = 0
			 * 
			 * where t1 is an iterator of a line, а t2 - is an iterator of a Bezier curve
			 * The pares of solutions (t1,t2) correspond to the same point.
			 */

			if (Math.abs(lineVector.x) < PRECISION) {
				// Прямая вертикальна. Уравнение по X имеет только переменную t2. Решаем относительно нее, подставляем во второе уравнение.
				// The line is vertical. The equation for X has only variable t2. Solve relatively to it, substitute to the second equation.

				coefficientInPower2 = diagonalVector.x;
				coefficientInPower1 = 2 * startToControlVector.x;
				coefficientInPower0 = deltaStarts.x;

				solutionsForCurve = Equations.solveQuadraticEquation(coefficientInPower2, coefficientInPower1, coefficientInPower0);

				if (!solutionsForCurve) {
					// вообще, такого быть не может - если кривая совпала с прямой, то она сама прямая, и это обработалось в начале метода
					return null;
				}

				if (Math.abs(lineVector.y) < PRECISION) {
					// вообще, такого быть не может - если прямая вырождена в точку, то это обработалось в начале метода
					// но все же, решение найти можно
					// in general, this can not happen - if the curve degenerates to a point, it is processed in the beginning of the method
					// but still, the solution could be found
					for (i = 0;i < solutionsForCurve.length; i++) {
						solutionForCurve = solutionsForCurve[i];
						solutionForLine = 0;

						intersection.addIntersection(solutionForCurve, solutionForLine, this.isSegment, target.isSegment);
					}
				} else {
					for (i = 0;i < solutionsForCurve.length; i++) {
						solutionForCurve = solutionsForCurve[i];
						solutionForLine = -(diagonalVector.y * Math.pow(solutionForCurve, 2) + 2 * startToControlVector.y * solutionForCurve + deltaStarts.y) / lineVector.y;

						intersection.addIntersection(solutionForCurve, solutionForLine, this.isSegment, target.isSegment);
					}
				}
			} else {
				if (Math.abs(lineVector.y) < PRECISION) {
					// прямая горизонтальна. Уравнение по Y имеет только переменную t2. Решаем относительно нее, подставляем в первое уравнение.
					// The line is horisontal. The equation for Y has only variable t2. Solve relatively to it, substitute to the first equation.

					coefficientInPower2 = diagonalVector.y;
					coefficientInPower1 = 2 * startToControlVector.y;
					coefficientInPower0 = deltaStarts.y;
				} else {
					// прямая имеет обе ненулевых координаты, нормируем одну по другой, и собираем одно квадратное уравнение относительно t2.
					// line has two nonzero coordinates, we normalize one to another, and collect a quadratic equation relatively to t2.
					const normalizationCoefficient : Number = lineVector.y / lineVector.x;

					coefficientInPower2 = diagonalVector.x * normalizationCoefficient - diagonalVector.y;
					coefficientInPower1 = 2 * (startToControlVector.x * normalizationCoefficient - startToControlVector.y);
					coefficientInPower0 = deltaStarts.x * normalizationCoefficient - deltaStarts.y;
				}

				solutionsForCurve = Equations.solveQuadraticEquation(coefficientInPower2, coefficientInPower1, coefficientInPower0);

				if (!solutionsForCurve) {
					// вообще, такого быть не может - если кривая совпала с прямой, то она сама прямая, и это обработалось в начале метода
					// in general, this can not happen - if the curve coincided with the line, then it is a straight line, and it is processed in the beginning of the method
					return null;
				}

				for (i = 0;i < solutionsForCurve.length; i++) {
					solutionForCurve = solutionsForCurve[i];
					solutionForLine = -(diagonalVector.x * Math.pow(solutionForCurve, 2) + 2 * startToControlVector.x * solutionForCurve + deltaStarts.x) / lineVector.x;

					intersection.addIntersection(solutionForCurve, solutionForLine, this.isSegment, target.isSegment);
				}
			}

			return intersection;
		}

		/* *
		 * Результат вычисления пересечения кривой Безье с другой кривой Безье может дать следующие результаты:<BR/>
		 * - если пересечение отсутствует, возвращается объект Intersection с пустыми массивами currentTimes и targetTimes;<BR/>
		 * - если пересечение произошло в точках (от одной до четырех точек), будет возвращен объект Intersection,
		 *   и time-итераторы точек пересечения на данной кривой Безье будут находиться в массиве currentTimes.
		 *   time-итераторы точек пересечения <code>target</code> будут находиться в массиве <code>targetTimes</code>;<BR/>
		 * - также может произойти совпадение кривых. В этом случае результатом будет являться кривая - объект Bezier (<code>isSegment=true</code>), 
		 * которая будет доступна как свойство <code>coincidenceBezier</code> в возвращаемом объекте Intersection;<BR/>
		 * <BR/>
		 * На результаты вычисления пересечений оказывает влияние свойство <code>isSegment<code> как текущего объекта,
		 * так и значение <code>isSegment</code> объекта <code>target</code>.
		 * 
		 * @param target:Bezier
		 * @return Intersection
		 * 
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var target:Bezier = new Bezier(new Point(100, 100), new Point(200, 200), new Point(300, 400));
		 *	var intersection:Intersection = bezier.intersectionBezier(target);
		 *	trace(intersection);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		/**
		 * Calculation of the intersection of a Bezier curve with a Bezier curve can give the following results:<BR/>
		 * - if there is no intersection, an object Intersection with empty arrays currentTimes and targetTimes returns;<BR/>
		 * - if there were intersections in one to four points, the object Intersection returns, and time-iterators of 
		 *   intersection points of a Bezier curve will be located in an array currentTimes. 
		 *   time-iterators of intersection points of Bezier curve <code>target</code> will be located in an array targetTimes;<BR/>
		 * - the coincidence of curves can also occur. In this case the result is a curve - an object Bezier (<code>isSegment=true</code>), 
		 *   which will be available as a property <code>coincidenceBezier</code> in the returned object Intersection;<BR/>
		 *   <BR/>
		 * The property <code>isSegment<code> of current object, as well as value <code>isSegment</code> of target object, affects the result of calculation.
		 *   
		 * @param target:Bezier
		 * @return Intersection
		 * 
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	var target:Bezier = new Bezier(new Point(100, 100), new Point(200, 200), new Point(300, 400));
		 *	var intersection:Intersection = bezier.intersectionBezier(target);
		 *	trace(intersection);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 */
		public function intersectionBezier(target : Bezier) : Intersection {
			var intersection : Intersection = null;
			var i : int;

			const curveAsPoint : Point = this.asPoint();
			if (curveAsPoint) {
				intersection = target.intersectionPoint(curveAsPoint);
				intersection.switchCurrentAndTarget();
				return intersection;
			}

			const curveAsLine : Line = this.asLine();
			if (curveAsLine) {
				intersection = target.intersectionLine(curveAsLine);
				intersection.switchCurrentAndTarget();
				intersection.translateCurrentIterators(curveAsLine, this);

				return intersection;
			}

			const targetAsPoint : Point = target.asPoint();
			if (targetAsPoint) {
				intersection = this.intersectionPoint(targetAsPoint);
				return intersection;
			}

			var targetAsLine : Line = target.asLine();
			if (targetAsLine) {
				intersection = this.intersectionLine(targetAsLine);
				intersection.translateTargetIterators(targetAsLine, target);

				return intersection;
			}

			// если ни одна из проверок не прошла, значит у нас две настоящих невырожденных кривых
			// решаем чистый случай!

			const startToControlVector : Point = POINT0;
			startToControlVector.x = control.x - start.x;
			startToControlVector.y = control.y - start.y;

			const diagonalVector : Point = POINT1;
			diagonalVector.x = start.x - 2 * control.x + end.x;
			diagonalVector.y = start.y - 2 * control.y + end.y;

			const targetStartToControlVector : Point = POINT2;
			targetStartToControlVector.x = target.control.x - target.start.x;
			targetStartToControlVector.y = target.control.y - target.start.y;

			const targetDiagonalVector : Point = POINT3;
			targetDiagonalVector.x = target.start.x - 2 * target.control.x + target.end.x;
			targetDiagonalVector.y = target.start.y - 2 * target.control.y + target.end.y;

			const ax1 : Number = diagonalVector.x,
			ay1 : Number = diagonalVector.y,
                  
			bx1 : Number = 2 * startToControlVector.x,
			by1 : Number = 2 * startToControlVector.y,
                  
			cx1 : Number = startPoint.x,
			cy1 : Number = startPoint.y,
                  
			ax2 : Number = targetDiagonalVector.x,
			ay2 : Number = targetDiagonalVector.y,
                  
			bx2 : Number = 2 * targetStartToControlVector.x,
			by2 : Number = 2 * targetStartToControlVector.y,
                  
			cx2 : Number = target.startPoint.x,
			cy2 : Number = target.startPoint.y,
                     
			cx : Number = cx1 - cx2,              
			cy : Number = cy1 - cy2;

			// решение «в лоб»
			const	part1 : Number = (ax2 * ay1 - ax1 * ay2),
			part2 : Number = (-ay2 * bx1 + ax2 * by1),
			part3 : Number = (bx1 * bx1 + 2 * ax1 * cx),
			part4 : Number = (ay1 * bx2 - ax1 * by2),
			part5 : Number = (by1 * by1 + 2 * ay1 * cy),
			part6 : Number = (bx2 * bx2 + 2 * ax2 * cx),
			part7 : Number = (bx1 * by1 + ax1 * cy),
			part8 : Number = (bx2 * by1 - bx1 * by2),
			part9 : Number = (by1 * cx + bx1 * cy),
			part10 : Number = (-bx2 * by1 + bx1 * by2),
			part11 : Number = (-by2 * cx + bx2 * cy),
			part12 : Number = (-by2 * cx + bx2 * cy);

			const   A : Number = -part1 * part1,
			B : Number = -2 * part1 * part2,
			C : Number = -ay2 * ay2 * part3 - ax2 * (by2 * part4 + ax2 * part5) + ay2 * (-ax1 * bx2 * by2 + ay1 * part6 + 2 * ax2 * part7),
			D : Number = -2 * ay2 * ay2 * bx1 * cx + ay2 * (bx2 * part8 + 2 * ax2 * part9) + ax2 * (part10 * by2 - 2 * ax2 * by1 * cy),
			E : Number = -ay2 * ay2 * cx * cx + ay2 * (bx2 * part11 + 2 * ax2 * cx * cy) - ax2 * (part12 * by2 + ax2 * cy * cy);

			const solutionsForCurve : Array = Equations.solveEquation(A, B, C, D, E);

			intersection = new Intersection();

			// поворачиваем кривую в вертикальное положение. Решение будет одно и только одно.
			// turn a curve in a vertical position. There will be only one solution.
			var	tga : Number, sina : Number, cosa : Number;

			if (Math.abs(ay2) > PRECISION) {
				tga = -ax2 / ay2;
				sina = tga / Math.sqrt(1 + tga * tga);
				cosa = 1 / Math.sqrt(1 + tga * tga);
			} else {
				tga = 0;
				sina = (-ax2 > PRECISION) ? 1 : (-ax2) < -PRECISION ? -1 : 0;
				cosa = 0;
			}

			const	bxn : Number = bx2 * cosa + by2 * sina,
			cxn : Number = cx2 * cosa + cy2 * sina;

			var	pointSolve : Point;

			// бесконечное множество решений. То есть есть совпадение кривых
			// infinite set of solutions. That is a coincidence of the curves
			if ((Math.abs(A) < PRECISION) && (Math.abs(B) < PRECISION) && (Math.abs(C) < PRECISION) && (Math.abs(D) < PRECISION) && (Math.abs(E) < PRECISION)) {
				var	time1 : Number,
				time2 : Number,
					
				rt1 : Number,
				rt2 : Number;

				pointSolve = getPoint(0);
				time1 = (pointSolve.x * cosa + pointSolve.y * sina - cxn) / bxn;
				pointSolve = getPoint(1);
				time2 = (pointSolve.x * cosa + pointSolve.y * sina - cxn) / bxn;

				if (time1 * (time1 - 1) <= 0 && time2 * (time2 - 1) <= 0) {
					rt2 = time2;
					rt1 = time1;
				} else if ( time1 * time2 <= 0 && (1 - time1) * (1 - time2) <= 0) {
					rt2 = 1;
					rt1 = 0;
				} else if ( time1 * time2 <= 0 && (1 - time1) * (1 - time2) >= 0) {
					rt1 = 0;
					rt2 = time1 * (time1 - 1) <= 0 ? time1 : time2;
				} else if (time1 * time2 >= 0 && (1 - time1) * (1 - time2) <= 0) {
					rt1 = 1;
					rt2 = time1 * (time1 - 1) <= 0 ? time1 : time2;
				} else {
					// нет пересечений
					// no intersections
					return intersection;
				}

				intersection.isCoincidence = true;
				intersection.coincidenceBezier = target.getSegment(rt1, rt2);
				return intersection;
			}

			for (i = 0 ;i < solutionsForCurve.length; i++) {
				var solutionForCurve : Number = solutionsForCurve[i];
				var solutionForTarget : Number;

				pointSolve = getPoint(solutionForCurve);
				var ox : Number = pointSolve.x * cosa + pointSolve.y * sina;
				solutionForTarget = bxn ? (ox - cxn) / bxn : 0.5;

				intersection.addIntersection(solutionForCurve, solutionForTarget, this.isSegment, target.isSegment);
			}

			return intersection;
		}

		// **************************************************
		// UTILS
		// **************************************************
		/**
		 * Возвращает описание объекта Bezier, понятное человекам. 
		 * 
		 * @return String описание объекта
		 * 
		 */
		/**
		 * Returns the string presentation of the Bezier object.
		 * 
		 * @return String object description
		 * 
		 */
		public function toString() : String {
			return 	"(start:" + startPoint + ", control:" + controlPoint + ", end:" + endPoint + ")";
		}
	}
}


