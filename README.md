

<p align="left">
   <img width="400px" src="https://github.com/elm4ward/BlackNest/blob/master/resources/blacknest.png?raw=true" alt="blacknest.png">
</p>

## BlackNest - Swift Test Breeding - Spec Based - Data Driven 


Working:
```swift
// --------------------------------------------------------------------------------
// MARK: - Single Run - Inline
// --------------------------------------------------------------------------------

func run1(input: Int, expected: Int) throws {

    try input == expected  
      => "number matches"
          
}

// inline ... blazing fast
expect(run1 => 4 == 4)
expect(run1 => 5 == 5)
expect(run1 => 6 == 6)
expect(run1 => 7 == 7)

// --------------------------------------------------------------------------------
// MARK: - Single Run - Multiline
// --------------------------------------------------------------------------------

typealias Input_Run2 = (Int?, Int?, String?)
typealias Expected_Run2 = (Int, Int, String)
func run2(input: Input_Run2, expected: Expected_Run2) throws {

    try input.0 == expected.0
      => "first is same"
        
    try input.1 == expected.1
      => "second is the same"
        
    try input.2 == expected.2 
      => "third is the same"
        
}

// multiline ... clean
expect(run2,
    at: (1, 2, "3"),
    is: (1, 2, "3")
)
expect(run2,
    at: (2, 3, "4"),
    is: (2, 3, "4")
)
```

Next up:
```swift
// --------------------------------------------------------------------------------
// MARK: - Combined Run - Multi and Single
// --------------------------------------------------------------------------------

func runA(input: Int, expected: Int) throws -> Int {

    let subject = input * 2
    
    try subject == expected 
        => "subject is double"
        
    return subject
}

func runB(input: Int, expected: Int) throws {

    let subject = input * 3
    
    try subject == expected 
        => "number is tripple"   
}

// inline versatile
expect(runA • runB => 4 == 8 • 16)
expect(runA • runA • runB => 4 == 8 • 16 • 32)

// clearer?
expect(when: 8, 
       runA => 8 
     | runB => 16
     | runB => 32
)

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
