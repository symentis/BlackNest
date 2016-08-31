

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest logo">
</p>

# BlackNest - Swift Test Breeding - Spec Based - Data Driven

## Want to test input combinations for a SUT?

Let's write a very simple function. The functio is that simple - it can hardly fail.
Looks like this:

```swift
/// Easy
func asTuple(_ int: Int) -> (Int, Int) {
  return (int, int * 2)
}
```

Before we write a test for that function we add the specification, which is a function, taking `Input` and `Expected`, it return `Output` or it throws an Error.

Inside the function, all assertions are performed via a DSL. For `Input` and `Expected` you can take whatever you want - Real Types, Tuples, Optionals. Feel free.


```swift
/// This is the spec.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act: do the tuple
  let subject = asTuple(input)

  // Assert: check the spec
  try subject.0 == expect.0
    => "First entry should still be the same"
  try subject.1 == expect.1
    => "Second entry should be double the first"

  return subject
}
```
_Looks like an equation?_

__Yeah__  - no Boilerplate - pure definitions.
Easy to re-read and remember.
Now we perform different combinations for the test.

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

Let's add one more simple function.

```swift
/// Cool. 👍
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
  try subject == expect
    => "sum calculation"

  return subject
}
```

Now you can __combine both__.

Each call to a function can return and can take __individual expectations__. __Return values will be carried on__ to the next test run.
Same code - no duplication - and again - easy to remember.

```swift
/// Again, you prefer multiline named arguments: Cool!
expect(04, in:doubleTuple, is:(04, 08)).then(tupleSum, is:12)
expect(08, in:doubleTuple, is:(08, 16)).then(tupleSum, is:24)
expect(12, in:doubleTuple, is:(12, 24)).then(tupleSum, is:36)

/// Custom operators from time to time?
expect(004 | doubleTuple => (04, 08)).then(tupleSum => 12)
expect(008 | doubleTuple => (08, 16)).then(tupleSum => 24)
expect(012 | doubleTuple => (12, 24)).then(tupleSum => 36)

/// Maybe table based is even better for your eyes?
expect(
   4 |  doubleTuple => (04, 08)
     |> tupleSum    => (12)
     |> doubleTuple => (12, 24)
     |> tupleSum    => (36)
 )

/// HIGHLY EXPERIMENTAL
/// ~ the egg operator ~
/// You took the red pill, and all you see is tests, tests, test.
expect(4,
  in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum,
  is: (04, 08)    • 12       • (12, 24)    • 36
)

```

## Please more complex examples?

__Of course__ - _it will not make sense to use this approach everywhere_.<br />

But some things are really neat. Look at the following example:

> We have a Birdwatcher and depending on his skills we show a display name.

```swift
struct BirdWatcher {
  var name: String
  var experience: Int?
  var birdsSeen: Int?

  init(_ name: String) {
    self.name = name
  }
  /// 😱 Oh damn ...
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

Better test that in an easy way.

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
  try subject.name == expect.name
    => "name is correct"
  try subject.birdsSeen == expect.birdsSeen
    => "birdsSeen is correct"
  try subject.experience == expect.experience
    => "experience is correct"
  try subject.display == expect.display
    => "display is built correctly"
}

expect(("Burt", nil, 100) |  birdWatcher => ("Burt", nil, 100, "Burt"))
expect(("Burt", 20, 100)  |  birdWatcher => ("Burt", 20, 100, "Burt - The Master."))
expect(("Burt", 20, 0)    |  birdWatcher => ("Burt", 0, 100, "Burt - The Talent."))
expect(("Burt", nil, 0)   |  birdWatcher => ("Burt", 0, 0, "Burt - The Bloody Rookie."))
```

Quite a lot tests - but still easy to understand.

More examples to come.

## Why BlackNest?

Named after [Black-nest Swiftlet](https://en.wikipedia.org/wiki/Black-nest_swiftlet).

> All we want to do in tests is taking care of the precious eggs.
> None should get a crack. That's it - taking care of your code.

## Why Custom Operators?

__You are not forced to use them.__
But when comparing both versions, sometimes custom
operators are easier to reason about.

How we call them? Just like their named argument counterpart.

`|`  is called _in_

`=>` is called _is_

 `|>` is called _then_


## Credits
BlackNest is owned and maintained by [Symentis GmbH](http://symentis.com).

Developed by: Elmar Kretzer &amp; Madhava Jay

Follow for more Swift Goodness:
[![Twitter](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)
[![Twitter](https://img.shields.io/badge/twitter-@madhavajay-blue.svg?style=flat)](http://twitter.com/madhavajay)

## License
BlackNest is released under the Apache 2.0 license. See LICENSE for details.
