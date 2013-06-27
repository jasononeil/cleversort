CleverSort
==========

A very simple Haxe macro for helping to sort arrays based on multiple properties with a very simple syntax.

### Usage

Imagine we have this data:

```haxe
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
```

Include this at the top of your file, so that we can use the `cleverSort()` function on any array:

```haxe
using CleverSort;
```
**Example 1:**

Sort by surname, firstName, age:

```haxe
array.cleverSort(
	_.firstName.toLowerCase(),
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
```

**Example 2:**

Sort by state, postcode, surname, firstname:

```haxe
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

As you can see, the CleverSort syntax is much cleaner and more readable.  Enjoy!

Code released into the Public Domain.