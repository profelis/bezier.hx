package bezier.math;

//=============================================================================================================
//
//                                 class Equations 
//                        from package ru.bezier.math
//
//                             by Alexander Sergeyev
//                                   BEZIER.RU
//                              a.sergeyev@gmail.com
//
//                           Russia  Samara  06.02.2007
//==============================================================================================================
// haxe port: Dima (deep) Granetchi <system.grand@gmail.com>
/**
 * В классе представлены методы для решения уравнений с 1 неизвестным.<BR/>
 * Если в уравнении n-ой степени ведущие коэффициенты нулевые, то все равно можно 
 * использовать метод для n-ой степени, нужный метод перевызовется автоматически.<BR/>
 * Погрешность решения составляет порядка 10^-5. <BR/>
 * Можно использовать универсальную функцию, при этом сдедует быть внимательным с параметрами.
 * @author Alexander Sergeyev
 * @since 2006
 * @version 0.2 alpha
 */

class Equations {
	
	public static inline var PRECISION:Float = 1e-10;

	/** Универсальная функция для решения уравнений c одним неизвестным. <BR/>
	 * Осуществляет перевызов на соответствующий метод, в зависимости от количества параметров. <BR/>
	 * Параметры означают коэффициенты при степенях переменной, начиная от старшей степени и заканчивая свободным членом.<BR/>
	 * 
	 * @param A:Float —  коэффициент при старшей степени.
	 * @param B:Float — коэффициент при следующей степени.
	 * @param C:Float — коэффициент при следующей степени.
	 * @param D:Float — коэффициент при следующей степени.
	 * @param E:Float — коэффициент при следующей степени.
	 *
	 * @return Array — Массив с корнями уравнения.
	 * Если действительных корней нет, либо их бесконечно много, возвращает пустой массив.
	 * 
	 * @example
	 * <pre>
	 *	import bezier.math.Equations;
	 *	
	 *	var solutions = Equations.solveEquation(1,0,3,4); // x^3+3*x+4=0
	 *	trace(solutions);
	 * </pre>
	 **/
	 
	public static function solveEquation(A:Float, B:Float, ?C:Float, ?D:Float, ?E:Float):Array<Float> {
		
		if (C == null)
			return solveLinearEquation(A, B);
		if (D == null)
			return solveQuadraticEquation(A, B, C);
		if (E == null)
			return solveCubicEquation(A, B, C, D);
		
		return solveQuarticEquation(A, B, C, D, E);
	}

	/** Функция для решения линейного уравнения, записанного в форме ax + b = 0
	 *
	 * @param A:Float — коэффициент при x
	 * @param B:Float — свободный член
	 * 
	 * @return Array — Массив с корнями уравнения.
	 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив.
	 *
	 * @example
	 * <pre>
	 *	import bezier.math.Equations;
	 *	var solutions = Equations.solveEquation(1,3); // x+3=0
	 *	trace(solutions);
	 * </pre>
	 * @see solveEquation
	 **/

	public static function solveLinearEquation(A:Float, B:Float):Array<Float> {
		
		if (Math.abs(A) < PRECISION) {
			if (Math.abs(B) < PRECISION) return null;
			else return [];
		}
		return [-B/A];
	}

	
	/** Функция для решения квадратичного уравнения, записанного в форме ax^2 + bx + c = 0 
	 *	
	 * @param A:Float — коэффициент при x^2
	 * @param B:Float — коэффициент при x
	 * @param C:Float — свободный член
	 *
	 * @return Array — Возвращает массив с корнями уравнения. 
	 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
	 *
	 * @example
	 * <pre>
	 *	import bezier.math.Equations;
	 *	var solutions = Equations.solveEquation(3,4,1); // 3*x^2+4*x+1=0
	 *	trace(solutions);
	 * </pre>
	 * @see solveEquation
	 **/
	 
	public static function solveQuadraticEquation(A:Float, B:Float, C:Float):Array<Float> {
		
		if (Math.abs(A) < PRECISION)
			return solveLinearEquation(B, C);
		
		var b = B/A;
		var c = C/A;
		
		if (Math.abs(b) < PRECISION) b = 0;
		if (Math.abs(c) < PRECISION) c = 0;

		var d = b*b - 4*c;
		
		if (Math.abs(d) < PRECISION) d = 0;
		
		if (d > 0) {
			d = Math.sqrt(d);
			return [(-b - d)/2, (-b + d)/2];
		} 
		if (d == 0) return [ -b / 2];
		
		return [];
	}

	/** Функция для решения кубического уравнения, записанного в форме ax^3 + bx^2 + cx + d = 0
	 * 
	 * @param A:Float — коэффициент при x^3
	 * @param B:Float — коэффициент при x^2
	 * @param C:Float — коэффициент при x
	 * @param D:Float — свободный член
	 *
	 * @return Array — массив с корнями уравнения. 
	 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
	 *
	 * @example
	 * <pre>
	 *	import bezier.math.Equations;
	 *	var solutions = Equations.solveEquation(1,0,3,4); // x^3+3*x+4=0
	 *	trace(solutions);
	 * </pre>
	 * @see solveEquation
	 **/
	 
	public static function solveCubicEquation(A:Float, B:Float, C:Float, D:Float):Array<Float> {
		if (Math.abs(A) < PRECISION)
			return solveQuadraticEquation(B, C, D);
		
		var b = B/A;
		var c = C/A;
		var d = D/A;
		
		if (Math.abs(b) < PRECISION) b = 0;
		if (Math.abs(c) < PRECISION) c = 0;
		if (Math.abs(d) < PRECISION) d = 0;
		
		var p = -b*b/3 + c;
		var q = 2*b*b*b/27 - b*c/3 + d;
		var r = q*q/4 + p*p*p/27;
		
		var x:Float;
		if (r >= 0) {
			var squrtR = Math.sqrt(r);
			x = mathPower(-q/2 + squrtR, 1/3) + mathPower(-q/2 - squrtR, 1/3) - b/3;
		} else
			x = 2*Math.sqrt(-p/3)*Math.cos(mathAtan2(-q/2, Math.sqrt(Math.abs(r)))/3) - b/3;
		
		var quadraticSolve = solveQuadraticEquation(1, x + b, x*x + b*x + c);
		if ((quadraticSolve[0] != x) && (quadraticSolve[1] != x))
			quadraticSolve.push(x);
		
		return quadraticSolve;
	}

	/** Функция для решения уравнения четвертой степени, записанного в форме ax^4 + bx^3 + cx^2 + dx + e = 0
	 * 
	 * @param A:Float — коэффициент при x^4
	 * @param B:Float — коэффициент при x^3
	 * @param C:Float — коэффициент при x^2
	 * @param D:Float — коэффициент при x
	 * @param E:Float — свободный член
	 *
	 * @return Array — массив с корнями уравнения. 
	 * Если действительных корней нет, либо бесконечно много, возвращает пустой массив. 
	 *
	 * @example
	 * <pre>
	 *	import bezier.math.Equations;
	 *	var solutions = Equations.solveEquation(1,0,3,4,2); // x^4+3*x^2+4*x+2=0
	 *	trace(solutions);
	 * </pre>
	 * @see solveEquation
	 **/
	 
	public static function solveQuarticEquation(A:Float, B:Float, C:Float, D:Float, E:Float):Array<Float> {
		
		if (Math.abs(A) < PRECISION)
			return solveCubicEquation(B, C, D, E);
		
		var b = B/A;
		var c = C/A;
		var d = D/A;
		var e = E/A;
		
		if (Math.abs(b) < PRECISION) b = 0;
		if (Math.abs(c) < PRECISION) c = 0;
		if (Math.abs(d) < PRECISION) d = 0;
		if (Math.abs(e) < PRECISION) e = 0;
		
		var c1:Float;
		var c2:Float;
		
		var cubicSolve = solveCubicEquation(1, -c, b*d - 4*e, -b*b*e + 4*c*e - d*d)[0];
		var cubicSolve2 = cubicSolve/2;
		
		
		var m = b*b/4 - c + cubicSolve;
		var n = b*cubicSolve2 - d;
		var k = cubicSolve2*cubicSolve2 - e;
		
		if (Math.abs(m) < PRECISION) m = 0;
		if (Math.abs(n) < PRECISION) n = 0;
		if (Math.abs(k) < PRECISION) k = 0;

		if ((m >= 0) && (k >= 0)) {
			var sqrtK = Math.sqrt(k);
			var sqrtM = Math.sqrt(m);
			
			c1 = b/2 - sqrtM;
			c2 = if (n > 0) cubicSolve2 - sqrtK;
				else cubicSolve2 + sqrtK;
			
			var quarticSolve = solveQuadraticEquation(1, c1, c2);
			c1 = b / 2 + sqrtM;
			
			c2 = if (n > 0) cubicSolve2 + sqrtK;
				else cubicSolve2 - sqrtK;
			
			return quarticSolve.concat(solveQuadraticEquation(1, c1, c2));
		}
		return [];
	}

	// Функция для возведения в степень. Работает лучше, чем Math.pow, но все равно не идеально.
	// Идеальная функция возведения в произвольную действительную степень будет иметь комплексный результат.
	private static function mathPower(x:Float, p:Float):Float {
		return if (p == 0) 1;
				else if (x > 0) Math.exp(Math.log(x)*p);
				else if (x < 0) -Math.exp(Math.log(-x)*p);
				else 0;
	}

	// Функция, аналогичная Math.atan2, только работает для произвольных параметров.
	public static function mathAtan2(dx:Float, dy:Float):Float {
		var a:Float = if (dx == 0) {
						if (dy == 0) 0 else Math.PI/2;
					} else if (dx > 0)
						Math.atan(Math.abs(dy/dx));
					else
						Math.PI - Math.atan(Math.abs(dy/dx));
		return if (dy >= 0) a; else -a;
	}
}
