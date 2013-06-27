import haxe.macro.Context;
import haxe.macro.Expr;
using tink.macro.tools.MacroTools;

/** Syntax sugar for creating arrays that sorts on multiple properties */
class CleverSort
{
	macro public static function cleverSort(arr:ExprOf<Array<Dynamic>>, filters:Array<Expr>)
	{
		// Set up the sort function, with an empty comparison function body to start

		var pos = arr.pos;
		var statements:Array<Expr> = [];
		var sortFnBody = { expr: EBlock(statements), pos: pos };
		var sortFn = macro function (i1, i2) $sortFnBody;

		// Set up the comaprison function body, adding one statement at a time

		statements.push( macro var cmp:Int );
		for ( f in filters ) {

			// Replace an _ in the filter with "i1" or "i2"

			var first = f.substitute({ "_": macro i1 });
			var second = f.substitute({ "_": macro i2 });

			// Add the comparison using Reflect.compare(), and then return if they were not equal

			statements.push( macro cmp = Reflect.compare($first, $second) );
			statements.push( macro if (cmp != 0) return cmp );
		}
		statements.push( macro return 0 );

		// Return it as an expression: arr.sort(sortFn);
		return macro $arr.sort($sortFn);
	}
}