package flash.geom {

	/* *
	 * Если пересечение существует, то результатом вычисления может быть либо массив точек,
	 * либо полное или частичное совпадение фигур.<BR/>
	 * <BR/>
	 * Если значение <code>isCoincidence=false</code>, значит фигуры пересеклись и не совпали.
	 * В этом случае массив <code>currentTimes</code> будет содержать итераторы точек пересечения
	 * на текущем объекте, а массив <code>targetTimes</code> будет содержать итераторы точек
	 * пересечения на целевом объекте.<BR/>
	 * <BR/>
	 * Если значение <code>isCoincidence=true</code>, значит найдено совпадение.<BR/>
	 * Совпадение описывается парами итераторов, определяющих начало и конец фигуры совпадения.<BR/>
	 * Используйте метод <code>getSegment</code> для получения совпадающих фигур.<BR/>
	 * <BR/>
	 * К примеру, получая пересечение двух кривых Безье, требуется проверить, 
	 * существует ли пересечение и далее обрабатывать в зависимости от его типа:
	 * <BR/>
	 * <listing version="3.0">
	 * var intersection:Intersection = currentBezier.intersectionBezier(targetBezier);
	 * if (intersection) {
	 * 	if (intersection.isCoincidence) {
	 * 		// обработка совпадения
	 * 	} else {
	 * 		// обработка пересечения
	 * 	}
	 * }
	 * </listing>
	 * <BR/>
	 * <BR/>
	 * Совпадением двух отрезков может являться только отрезок.
	 * Он будет описан как пара значений в массиве currentTimes
	 * и соответствующая пара значений в массиве targetTimes.<BR/>
	 * Отрезок можно получить:<BR/>
	 * <listing version="3.0">
	 * currentLine.getSegment(intersection.currentTimes[0], intersection.currentTimes[1]);
	 * </listing>
	 * либо <BR/>
	 * <listing version="3.0">
	 * targetLine.getSegment(intersection.targetTimes[0], intersection.targetTimes[1]);
	 * </listing>
	 * результатом этих двух вычислений будет два эквивалентных отрезка.<BR/>
	 * 
	 * <BR/>
	 * <BR/>
	 * 
	 * Совпадение отрезка и кривой Безье может быть только, если кривая Безье вырождена 
	 * (управляющие точки лежат на одной линии).<BR/>
	 * В вырожденном случае возможна ситуация, при котором совпадение даст два отрезка (4 итератора).  
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang rus
	 */
	/**
	 * If the intersection exists, then the result of calculation can be either an array of pixels, 
	 * or full or partial coincidence of the figures.<BR/>
	 * <BR/>
	 * If the value <code>isCoincidence=false</code>, then the figures have intersection and do not coincide.
	 * In this case, the array <code>currentTimes </code> will contain the intersection points of 
	 * the iterators of the current object, and an array <code>targetTimes</code> will contain the 
	 * intersection points of the iterators of the target object.<BR/>
	 * If the value <code>isCoincidence=true</code>, then a coincidence is found.<BR/>
	 * The coincidence is described by the pair of iterators defining the beginning and 
	 * the end of the coincidence figure.<BR/>
	 * Use the method <code>getSegment</code> for coincidence figures.<BR/>
	 * For example, obtaining the intersection of two Bezier curves, you want to check were there the 
	 * intersection, and further process it depending on its type:<BR/>
	 * <BR/>
	 * <listing version="3.0">
	 * var intersection:Intersection = currentBezier.intersectionBezier(targetBezier);
	 * if (intersection) {
	 * 	if (intersection.isCoincidence) {
	 * 		// Coincidence processing
	 * 	} else {
	 * 		// Intersection processing
	 * 	}
	 * }
	 * </listing>
	 * <BR/>
	 * <BR/>
	 * The coincidence of the two segments can only be a segment.
	 * It will be described as a pair of values in the array currentTimes and the corresponding 
	 * pair of values in the array targetTimes.<BR/>
	 * The segment can be obtained in following ways:<BR/>
	 * <listing version="3.0">
	 * currentLine.getSegment(intersection.currentTimes[0], intersection.currentTimes[1]);
	 * </listing>
	 * or <BR/>
	 * <listing version="3.0">
	 * targetLine.getSegment(intersection.targetTimes[0], intersection.targetTimes[1]);
	 * </listing>
	 * The results of these two calculations will be two equivalent segments.
	 * <BR/>
	 * <BR/>
	 * Coincidence of the segment and the Bezier curve can be only if the Bezier curve 
	 * is degenerate (control points lie on one line).<BR/>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 */	 
	public class Intersection extends Object {

		
		public static function isIntersectionPossible(current : Rectangle, target : Rectangle) : Boolean {
			current = current.clone();
			target = target.clone();
			
			// fix negative
			if (current.width < 0) {
				current.x += current.width;
				current.width = -current.width;
			}
			if (current.height < 0) {
				current.y += current.height;
				current.height = -current.height;
			}
			
			if (target.width < 0) {
				target.x += target.width;
				target.width = -target.width;
			}
			if (target.height < 0) {
				target.y += target.height;
				target.height = -target.height;
			}
			// fix zero
			current.width += 1e-10;
			current.height += 1e-10;
			target.width += 1e-10;
			target.height += 1e-10;
			
			trace(current, target, current.intersects(target));
			return current.intersects(target);
		}

		/* *
		 * Свойство, указывающее на тип пересечения. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		 
		/**
		 * The property that specifies the type of intersection. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 */

		public var isCoincidence : Boolean = false;

		public var coincidenceLine : Line;

		public var coincidenceBezier : Bezier;		

		/* *
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, метод которого был вызван.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Array, having time-interators of points of crossing.
		 * time-interators given for object, method whose was call.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 **/
		public const currentTimes : Array = new Array();

		/* *
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, который был передан 
		 * в качестве аргумента при вызове метода получения пересечений.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Array containing time-iterators of points of intersection.
		 * time-iterators are defined for an object that was passed as an argument 
		 * when calling the method for obtaining intersection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		 
		public const targetTimes : Array = new Array();

		
		/* *
		 * Меняет местами time-итераторы текущей и таргет фигур.
		 * Метод часто используется там, где делается перевызов на другой метод пересечения, например, 
		 * с вырожденной фигурой. Не стоит забывать в таких случаях, что у разных фигур могут быть 
		 * разные итераторы для одной и той же точки. 
		 * Если есть такая опасность, то следует дополнительно скорректировать time-итераторы через 
		 * методы getPoint и getPointOnCurve.
		 *    
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/* *
		 * Swaps time-iterators of current and target figures.
		 * The method is often used where another method of intersection is recalled, for example, with 
		 * a degenerate figure. In such cases remember, that different figures can have different iterators 
		 * for the same point.
		 * If there is such a possibility, time-iterators should be further adjusted through the methods 
		 * getPoint and getPointOnCurve.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function switchCurrentAndTarget() : void {
			var time : Number;
			for(var i : int = 0;i < currentTimes.length; i++) {
				time = currentTimes[i];
				currentTimes[i] = targetTimes[i];
				targetTimes[i] = time;
			}			
		}

		public function translateCurrentIterators(originFigure:IParametric, finalFigure:IParametric):void
		{			
			var correctedCurrentTimes:Array = new Array();
			var correctedTargetTimes:Array = new Array();
				
			for (var i:int = 0; i < currentTimes.length; i++) 
			{
				var point : Point = originFigure.getPoint(currentTimes[i]);
				var iterators:Array = finalFigure.getExistedPointIterators(point);
					
				for (var j:int=0; j<iterators.length; j++)
				{
					correctedCurrentTimes.push(iterators[j]);
					correctedTargetTimes.push(targetTimes[i]);
				}					
			}
				
			currentTimes.length = 0;
			targetTimes.length = 0;
			for (i = 0;i <correctedCurrentTimes.length; i++) 
			{
				currentTimes.push(correctedCurrentTimes[i]);
				targetTimes.push(correctedTargetTimes[i]);					
			}		
		}

		public function translateTargetIterators(originFigure:IParametric, finalFigure:IParametric):void
		{			
			var correctedCurrentTimes:Array = new Array();
			var correctedTargetTimes:Array = new Array();
				
			for (var i:int = 0; i < targetTimes.length; i++) 
			{
				var point : Point = originFigure.getPoint(targetTimes[i]);
				var iterators:Array = finalFigure.getExistedPointIterators(point);
					
				for (var j:int=0; j<iterators.length; j++)
				{
					correctedCurrentTimes.push(currentTimes[i]);
					correctedTargetTimes.push(iterators[j]);
				}					
			}
				
			currentTimes.length = 0;
			targetTimes.length = 0;
			for (i = 0;i <correctedCurrentTimes.length; i++) 
			{
				currentTimes.push(correctedCurrentTimes[i]);
				targetTimes.push(correctedTargetTimes[i]);					
			}		
		}

		/* *
		 * Добавляет новую точку в пересечение, с учетом флагов ограниченности пересекающихся фигур.
		 * 
		 * @param solutionForCurrent:Number time-итератор для текущей фигуры
		 * @param solutionForTarget:Number time-итератор для пересекающей фигуры
		 * @param currentIsSegment:Boolean флаг ограниченности для текущей фигуры
		 * @param targetIsSegment:Boolean флаг ограниченности для пересекающей фигуры
		 *  
		 * @return Intersection текущий объект с пересечением
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * @lang rus
		 **/
		 
		/* *
		 * Adds a new point of intersection, with the respect to the flags of limitation of intersecting figures.
		 * 
		 * @param solutionForCurrent:Number time-iterator for the current figure
		 * @param solutionForTarget:Number time-iterator for the intersecting figure
		 * @param currentIsSegment:Boolean flag of limitation for the current figure
		 * @param targetIsSegment:Boolean flag of limitation for the intersecting figure
		 * 
		 * @return Intersection current object with intersection
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		public function addIntersection(solutionForCurrent : Number, solutionForTarget : Number, currentIsSegment : Boolean, targetIsSegment : Boolean) : Intersection {						
			const segmentRestrictionForCurve : Boolean = (!currentIsSegment) || ((solutionForCurrent >= 0) && (solutionForCurrent <= 1));
			const segmentRestrictionForLine : Boolean = (!targetIsSegment) || ((solutionForTarget >= 0) && (solutionForTarget <= 1));
							
			if (segmentRestrictionForCurve && segmentRestrictionForLine) {								
				targetTimes.push(solutionForTarget);
				currentTimes.push(solutionForCurrent);
			}
			
			return this;
		}
	}
}