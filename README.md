

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest logo">
</p>

# BlackNest - Reusable Testing

# Test like a spec

We start a very simple function.

```swift
func asTuple(_ int: Int) -> (Int, Int) {
  return (int, int * 2)
}
```

Before we write a test for that function we add the spec. The spec is a function,
taking `Input` and `Expected`, it returns `Output` or it throws an Error (Return type is optional).

Inside the function, all assertions are performed by a DSL.
For `Input` and `Expected` you can take whatever you want - Real Types, Tuples, Optionals.


```swift
/// This is the spec.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act: do the tuple
  let subject = asTuple(input)

  // Assert: check all proofs
  try "First entry should still be the same"
    => subject.0 == expect.0
  try "Second entry should be double the first"
    => subject.1 == expect.1

  return subject
}
```
The DSL makes the test look like equations.
Easy to read.
Now we perform different combinations for the test.

```swift
// Named arguments
expect(004, in:doubleTuple, is:(04, 08))
expect(008, in:doubleTuple, is:(08, 16))
expect(012, in:doubleTuple, is:(12, 24))
expect(100, in:doubleTuple, is:(100, 200))

// Named Arguments and Operators
expect(004, in: doubleTuple => (04, 08))
expect(008, in: doubleTuple => (08, 16))
expect(012, in: doubleTuple => (12, 24))
expect(100, in: doubleTuple => (100, 200))

// Operators only
expect(004 | doubleTuple => (04, 08))
expect(008 | doubleTuple => (08, 16))
expect(012 | doubleTuple => (12, 24))
expect(100 | doubleTuple => (100, 200))
```

In case one spec fails, you will see why:

   <img  src="https://github.com/elm4ward/BlackNest/blob/master/resources/error.png?raw=true" alt="error output by BlackNest">

# Test combinations

Add one more function.

```swift
func asSum(_ tuple: Int, Int) -> Int {
  return tuple.0 + tuple.1
}
```

And one more spec for this.

```swift
func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
  // Act: do the sum
  let subject = asSum(input)

  // Assert: check the spec
  try "sum calculation"
    => subject == expect

  return subject
}
```

Now you can __combine both__.

Each call to a function can return and can take __individual expectations__. __Return values will be carried on__ to the next test run.
Same code - no duplication - and again - easy to remember.

```swift
///
expect(04, in:doubleTuple, is:(04, 08)).then(tupleSum, is:12)
expect(08, in:doubleTuple, is:(08, 16)).then(tupleSum, is:24)
expect(12, in:doubleTuple, is:(12, 24)).then(tupleSum, is:36)

///
expect(004 | doubleTuple => (04, 08)).then(tupleSum => 12)
expect(008 | doubleTuple => (08, 16)).then(tupleSum => 24)
expect(012 | doubleTuple => (12, 24)).then(tupleSum => 36)

///
expect(
   4 |  doubleTuple => (04, 08)
     |~ tupleSum    => (12)
     |~ doubleTuple => (12, 24)
     |~ tupleSum    => (36)
 )

///
expect(4,
  in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum,
  is: (04, 08)    • 12       • (12, 24)    • 36
)

```

# More  examples

> We have a Birdwatcher and depending on his skills we show a display name.

```swift
struct BirdWatcher {
  var name: String
  var experience: Int?
  var birdsSeen: Int?

  init(_ name: String) {
    self.name = name
  }

  var display: String {
    switch (experience, birdsSeen) {
    case let (y?, s?) where y > 10 && s > 100:
      return name + " - The Great Master."
    case let (y?, s?) where y > 5 && s > 50:
      return name + " - The Master."
    case let (y?, s?) where y < 1 && s < 1:
      return name + " - The Bloody Rookie."
    case let (y?, s?) where y < 5 && s < 5:
      return name + " - The Rookie."
    case let (y?, s?) where y < 1 && s > 10:
      return name + " - The Talent."
    default: return name
    }
  }
}
```

The Spec should provide a clear picture of what you test.

```swift
/// typealias for Input
typealias BirdWatcherInput = (name: String, experience: Int?, birdsSeen: Int?)
/// typealias for Expected Data Tuple
typealias Data = (name: String, experience: Int?, birdsSeen: Int?, display: String)

/// the function that returns our breeding function.
func birdWatcher(_ input: BirdWatcherInput, expect: Data) throws {
  // Act:
  let subject = BirdWatcher(
    name: input.name,
    experience: input.experience,
    birdsSeen: input.birdsSeen
  )
  // Assert:
  try "name is correct"
    => subject.name == expect.name
  try "birdsSeen is correct"
    => subject.birdsSeen == expect.birdsSeen
  try "experience is correct"
    => subject.experience == expect.experience
  try "display is built correctly"
    => subject.display == expect.display
}

expect(("Burt", nil, 100) |  birdWatcher => ("Burt", nil, 100, "Burt"))
expect(("Burt", 20, 100)  |  birdWatcher => ("Burt", 20, 100, "Burt - The Master."))
expect(("Burt", 20, 0)    |  birdWatcher => ("Burt", 0, 100, "Burt - The Talent."))
expect(("Burt", nil, 0)   |  birdWatcher => ("Burt", 0, 0, "Burt - The Bloody Rookie."))
```

# Why BlackNest?

Named after [Black-nest Swiftlet](https://en.wikipedia.org/wiki/Black-nest_swiftlet).

> All we want to do in tests is taking care of the precious specRuns.
> None should get a crack. That's it - taking care of your code.


# Requirements
Swift 4.2

# Installation

### CocoaPods

```
pod 'BlackNest', '1.0.1'
```


# Credits & License
Corridor is owned and maintained by [Symentis GmbH](http://symentis.com).

Developed by: Elmar Kretzer
[![Twitter](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)

All modules are released under the MIT license. See LICENSE for details.
