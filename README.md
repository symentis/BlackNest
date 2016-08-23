# BlackNest
BlackNest - possibly a spec-based-data-driven Swift TestSuite

Working:
```swift

/// the first run
func run1(input: Int, expected: Int) throws {

    try "number matches" ?>
        input == expected    
}
/// inline
expect(run1 =/ 4 => 4)

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
// multiline
expect(run1,
    at: (1, 2, "3"),
    is: (1, 2, "3")
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
/// inline
expect(runA • runB =/ 4 => 8 • 16)
// multiline
expect(runA • runB,
    at: 4,
    is: 8 • 16
)
```

