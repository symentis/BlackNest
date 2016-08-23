# BlackNest

<p align="center">
  <img width="200px" src="https://raw.githubusercontent.com/elm4ward/BlackNest/master/resources/blacknest.png">
</p>

BlackNest - possibly a spec-based-data-driven Swift TestSuite


Working:
```swift

/// the first run
func run1(input: Int, expected: Int) throws {

    try "number matches" ?>
        input == expected    
}
/// inline ... blazing fast
expect(run1 =/ 4 => 4)
expect(run1 =/ 5 => 5)
expect(run1 =/ 6 => 6)
expect(run1 =/ 7 => 7)

/// the second run
typealias Input_Run2 = (Int?, Int?, String?)
typealias Expected_Run2 = (Int, Int, String)
func run2(input: Input_Run2, expected: Expected_Run2) throws {

    try "first matches" ?>
        input.0 == expected.0
        
    try "second matches" ?>
        input.1 == expected.1
        
    try "third matches" ?>
        input.2 == expected.2
}
// multiline ... clean
expect(run1,
    at: (1, 2, "3"),
    is: (1, 2, "3")
)
expect(run1,
    at: (2, 3, "4"),
    is: (2, 3, "4")
)
```

Next up:
```swift
/// run a
func runA(input: Int, expected: Int) throws -> Int {

    let subject = input * 2
    
    try "number matches" ?>
        subject == expected 
        
    return subject
}
// run b
func runB(input: Int, expected: Int) throws {

    let subject = input * 3
    
    try "number matches" ?>
        subject == expected   
}
/// inline versatile
expect(runA • runB =/ 4 => 8 • 16)
expect(runA • runA • runB =/ 4 => 8  • 16 • 32)

// multiline
expect(runA • runB,
    at: 4,
    is: 8 • 16
)
expect(runA • runA • runB,
    at: 4,
    is: 8 • 16 • 32
)
```

