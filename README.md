

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest.png">
</p>

## BlackNest - Swift Test Breeding - Spec Based - Data Driven


Working:
```swift
// --------------------------------------------------------------------------------
// MARK: - Single Run - Inline
// --------------------------------------------------------------------------------

func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act:
  let subject = (input, input * 2)

  // Assert:
  try subject.0 == expect.0
    => "first entry should be the same"
  try subject.1 == expect.1
    => "second entry should be duplicate"
}

expect(004, in:doubleTuple, is:(04, 08))
expect(008, in:doubleTuple, is:(08, 16))
expect(012, in:doubleTuple, is:(12, 24))
expect(100, in:doubleTuple, is:(100, 200))

expect(004 | doubleTuple => (04, 08))
expect(008 | doubleTuple => (08, 16))
expect(012 | doubleTuple => (12, 24))
expect(100 | doubleTuple => (100, 200))

expect(when: 004, then: doubleTuple => (04, 08))
expect(when: 008, then: doubleTuple => (08, 16))
expect(when: 012, then: doubleTuple => (12, 24))
expect(when: 100, then: doubleTuple => (100, 200))

```

Next up:
```swift
// --------------------------------------------------------------------------------
// MARK: - Combined Run - Multi and Single
// --------------------------------------------------------------------------------


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

func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
  // Act:
  let subject = input.0 + input.1

  // Assert:
  try subject == expect
    => "sum calculation"
    
  return subject
}

expect(4, in:doubleTuple, is:(04, 08))
 .then(tupleSum, is:12)
expect(8, in:doubleTuple, is:(08, 16))
 .then(tupleSum, is:24)
expect(12, in:doubleTuple, is:(12, 24))
 .then(tupleSum, is:36)

expect(004 | doubleTuple => (04, 08))
         .then(tupleSum => 12)
expect(008 | doubleTuple => (08, 16))
         .then(tupleSum => 24)
expect(012 | doubleTuple => (12, 24))
         .then(tupleSum => 36)
expect(100 | doubleTuple => (100, 200))
         .then(tupleSum => 300)

expectAll(4, 
  in: doubleTuple ◦ tupleSum ◦ doubleTuple,
  is: (04, 08)    • 12       • (12, 24)
)

// Maybe?
// expect(4 | runA • runA • runB => 8 • 16 • 32)


// Or Maybe?
// expect(4 | runA => 6 + runB => 8 + runA => 8)
```
