

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest.png">
</p>

## BlackNest - Swift Test Breeding - Spec Based - Data Driven


Working:
```swift
// --------------------------------------------------------------------------------
// MARK: - Plain test
//
// We wann test a function that takes an Int and returns a tuple.
// Normally we test sth more complex, like different optional parameters.
// But for now lets go with the easiest example.
// --------------------------------------------------------------------------------

/// This is the spec.
/// Every failing rule will be marked as an error.
/// The error message contains the values.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act:
  let subject = (input, input * 2)

  // Assert:
  try subject.0 == expect.0
    => "first entry should be the same"
  try subject.1 == expect.1
    => "second entry should be duplicate"
}

// Now we can call it in as many combinations as we want to.
expect(004, in:doubleTuple, is:(04, 08))
expect(008, in:doubleTuple, is:(08, 16))
expect(012, in:doubleTuple, is:(12, 24))
expect(100, in:doubleTuple, is:(100, 200))

expect(004, in: doubleTuple => (04, 08))
expect(008, in: doubleTuple => (08, 16))
expect(012, in: doubleTuple => (12, 24))
expect(100, in: doubleTuple => (100, 200))

expect(004 | doubleTuple => (04, 08))
expect(008 | doubleTuple => (08, 16))
expect(012 | doubleTuple => (12, 24))
expect(100 | doubleTuple => (100, 200))

// --------------------------------------------------------------------------------
// MARK: - Combinations
//
// When we do this tuple test, there might be another thing we want to test
// afterwards. And maybe we even need to repeat that thing.
// Thats why the breeding function can return.
// And those functions can be stacked.
// --------------------------------------------------------------------------------

/// Imagine testing a function that creates a tuple.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act: 
  let subject = (input, input * 2)

  // Assert:
  try subject.0 == expect.0
    => "first entry should be the same"
  try subject.1 == expect.1
    => "second entry should be duplicate"

  return subject
}

/// Imagine testing a function that creates a sum on a tuple.
func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
  // Act:
  let subject = input.0 + input.1

  // Assert:
  try subject == expect
    => "sum calculation"
    
  return subject
}

expect(4, in:doubleTuple, is:(04, 08)).then(tupleSum, is:12)
expect(8, in:doubleTuple, is:(08, 16)).then(tupleSum, is:24)
expect(12, in:doubleTuple, is:(12, 24)).then(tupleSum, is:36)

expect(004 | doubleTuple => (04, 08))
         .then(tupleSum => 12)
expect(008 | doubleTuple => (08, 16))
         .then(tupleSum => 24)
expect(012 | doubleTuple => (12, 24))
         .then(tupleSum => 36)
expect(100 | doubleTuple => (100, 200))
         .then(tupleSum => 300)

// right now expect cannot be overloaded to work
// on the upper examples and this one.
// there might be a chance if upper examples
// are also written in a protocol manner.
expectAll(4, 
  in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum,
  is: (04, 08)    • 12       • (12, 24)    • 36
)

// This could possibly be a better way of writing it.
// expect(4 | runA => 8
            + runB => 16
            + runB => 32)

// expect(4 | runA => 6 + runB => 8 + runA => 8)
```


Todo:
 - find a away to avoid 'expectAll' 
