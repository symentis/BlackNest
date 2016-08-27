

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest logo">
</p>

# BlackNest - Swift Test Breeding - Spec Based - Data Driven

## Want to test input combinations for a SUT?

Let's write a test for a simple function.

```swift
/// Not that hard. 👍
func asTuple(_ int: Int) -> (Int, Int) {
  return (int, int * 2)
}
```

We add a general function, taking `Input` and `Expected`.
This function performs all assertions in a DSL.

```swift
/// This is the spec.
/// The error message contains the values.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act:
  let subject = asTuple(input)

  // Assert:
  try subject.0 == expect.0
    => "first entry should be the same"
  try subject.1 == expect.1
    => "second entry should be duplicate"

  return subject
}
```

Now perform different combinations.

```swift
// You like named arguments?
expect(004, in:doubleTuple, is:(04, 08))
expect(008, in:doubleTuple, is:(08, 16))
expect(012, in:doubleTuple, is:(12, 24))
expect(100, in:doubleTuple, is:(100, 200))

// You like named arguments and custom operators?
expect(004, in: doubleTuple => (04, 08))
expect(008, in: doubleTuple => (08, 16))
expect(012, in: doubleTuple => (12, 24))
expect(100, in: doubleTuple => (100, 200))

// You're totally into custom operators?
expect(004 | doubleTuple => (04, 08))
expect(008 | doubleTuple => (08, 16))
expect(012 | doubleTuple => (12, 24))
expect(100 | doubleTuple => (100, 200))
```

What? It failed?
Relax - you will understand why:

   <img  src="https://github.com/elm4ward/BlackNest/blob/master/resources/error.png?raw=true" alt="error output by BlackNest">

## Want to test combinations of your tests?

Let's add another simple function.

```swift
/// Cool. 👍
func asSum(_ tuple: Int, Int) -> Int {
  return tuple.0 + tuple.1
}
```

And another generic test function.

```swift
func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
  // Act:
  let subject = asSum(input)

  // Assert:
  try subject == expect
    => "sum calculation"

  return subject
}
```

And now you can easily combine the tests.

```swift
/// Again, you prefer multiline named arguments: Cool!
expect(04, in:doubleTuple, is:(04, 08)).then(tupleSum, is:12)
expect(08, in:doubleTuple, is:(08, 16)).then(tupleSum, is:24)
expect(12, in:doubleTuple, is:(12, 24)).then(tupleSum, is:36)

/// Custom operators from time to time?
expect(004 | doubleTuple => (04, 08)).then(tupleSum => 12)
expect(008 | doubleTuple => (08, 16)).then(tupleSum => 24)
expect(012 | doubleTuple => (12, 24)).then(tupleSum => 36)

/// You took the red pill, and all you see is tests, tests, test.
expectAll(4,
  in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum,
  is: (04, 08)    • 12       • (12, 24)    • 36
)

/// Maybe table based is even better for your eyes?
expect(
   4 |  doubleTuple => (04, 08)
     |> tupleSum    => (12)
     |> doubleTuple => (12, 24)
     |> tupleSum    => (36)
 )

```

### TODOS

##### Find a away to avoid 'expectAll'

Right now expect cannot be overloaded to work on the upper examples and this one.
There might be a chance if upper examples are also written in a protocol manner.

##### Try new syntax for comninations

```swift
//This could possibly be a better way of writing it.
expect(4 | runA => 8
         + runB => 16
         + runB => 32)

expect(4 | runA => 6 + runB => 8 + runA => 8)
```
