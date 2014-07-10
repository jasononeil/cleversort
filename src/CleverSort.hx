#if macro
	import haxe.macro.Context;
	import haxe.macro.Expr;
	using tink.MacroApi;
#end

/** Syntax sugar for creating arrays that sorts on multiple properties

```
// Imagine we have this data:

class Person {
	var firstName:String;
	var surname:String;
	var age:Int;
	var postcode:PostCode;
}
class PostCode {
	var state:StateEnum;
	var number:Int;
}
var array:Array<Person> = ...;

// We call "using CleverSort" so that we can use the `cleverSort()` function on any array

using CleverSort;

//
// Example 1:
// Sort by surname, firstName, age
//

array.cleverSort(
	_.firstName.toLowerCase()
	_.surname.toLowerCase(),
	_.age
);

// Which is the equivalent of writing

array.sort( function(i1,i2) {
	var cmp:Int;
	cmp = Reflect.compare(i1.firstName.toLowerCase(),i2.firstName.toLowerCase());
		if ( cmp!=0 ) return cmp;
	cmp = Reflect.compare(i1.surname.toLowerCase(),i2.surname.toLowerCase());
		if ( cmp!=0 ) return cmp;
	cmp = Reflect.compare(i1.age,i2.age);
		if ( cmp!=0 ) return cmp;
	return 0;
});

//
// Example 2:
// Sort by state, postcode, surname, firstname
//

array.cleverSort(
	Type.enumConstructor( _.postcode.state ),
	_.postcode.number,
	_.surname,
	_.firstName
);

// Which is the equivalent of writing

array.sort( function(i1,i2) {
	var cmp:Int;
	cmp = Reflect.compare(Type.enumConstructor(i1.postcode.state),Type.enumConstructor(i2.postcode.state));
		if ( cmp!=0 ) return cmp;
	cmp = Reflect.compare(i1.postcode.number,i2.postcode.number);
		if ( cmp!=0 ) return cmp;
	cmp = Reflect.compare(i1.surname,i2.surname);
		if ( cmp!=0 ) return cmp;
	cmp = Reflect.compare(i1.firstName,i2.firstName);
		if ( cmp!=0 ) return cmp;
	return 0;
});
```

As you can see, the syntax is much more readable.  Winning!
*/
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
		return macro try $arr.sort($sortFn) catch( e:Dynamic ) { trace('Cleversort failed: $e'); };
	}
}
