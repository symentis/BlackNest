

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest logo">
</p>

# BlackNest - Swift Test Breeding - Spec Based - Data Driven

## Want to test input combinations for a SUT?

Let's write a test for a very simple function. The function, which is by the way so simple that it can hardly fail, looks like this:

```swift
/// Easy 👍
func asTuple(_ int: Int) -> (Int, Int) {
  return (int, int * 2)
}
```

Before we write a test we add the specification, which is a function, taking `Input` and `Expected`.

Inside the function, all assertions are performed via a DSL. For `Input` and `Expected` you can take whatever you want - Real Types, Tuples, Optionals. Feel free.


```swift
/// This is the spec.
func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
  // Act: do the tuple
  let subject = asTuple(input)

  // Assert: check the spec
  try subject.0 == expect.0
    => "first entry should be the same"
  try subject.1 == expect.1
    => "second entry should be duplicate"

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

Let's add another simple function.

```swift
/// Cool. 👍
func asSum(_ tuple: Int, Int) -> Int {
  return tuple.0 + tuple.1
}
```

And another spec function for this.

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

Each call to the test function can return and can take __individual expectations__. __Return values will be carried on__ to the next test run.
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
/// Typealias for closure
typealias ChangeBirdWatcher = @escaping (inout BirdWatcher) -> ()
/// Typealias for Expected Data Tuple
typealias Data = (name: String, experience: Int?, birdsSeen: Int?, display: String)

/// The function that returns our breeding function.
func set(_ handler: ChangeBirdWatcher) -> (BirdWatcher, Data) throws -> BirdWatcher {
  return { input, expect in
    // Act:
    var subject = input
    handler(&subject)
    // Assert:
    try subject.name == expect.name
      => "name is correct"
    try subject.birdsSeen == expect.birdsSeen
      => "birdsSeen is correct"
    try subject.experience == expect.experience
      => "experience is correct"
    try subject.display == expect.display
      => "display is built correctly"
    return subject
  }
}

/// Now lets change the properties and do all checks!
expect(
  BirdWatcher("Burt") |  set { $0.birdsSeen = 100 } => ("Burt", nil, 100, "Burt")
                      |> set { $0.experience = 20 } => ("Burt", 20, 100, "Burt - The Master.")
                      |> set { $0.experience = 0 }  => ("Burt", 0, 100, "Burt - The Talent.")
                      |> set { $0.birdsSeen = 0 }   => ("Burt", 0, 0, "Burt - The Bloody Rookie.")
)
```

Quite a lot tests - but still easy to understand.

## Why BlackNest

Named after [Black-nest Swiftlet](https://en.wikipedia.org/wiki/Black-nest_swiftlet).
All we want do in our tests, is take care of the precious eggs.
None should get a crack. That's it - taking care of your code.

## Why Custom Operators?

__You are not forced to use them.__
But when comparing both versions, sometimes custom
operators are easier to reason about.

How we call them? Just like their named argument counterpart.

`|`  is called _in_

`=>` is called _is_

 `|>` is called _then_
