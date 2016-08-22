//
//  BlackNestTests.swift
//  BlackNestTests
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import XCTest
@testable import BlackNest

class BlackNestTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testExample() {

    func runInt(input: Int, expect: (Int, Int)) throws {

      let subject = (input, input + input)

      try "first is same" ?>
        subject.0 == expect.0

      try "second is duplicate" ?>
        subject.1 == expect.1
    }

    expect(runInt
      <| 4
      |> (4, 8)
    )

    expect(runInt <| 8  |> (8, 16))
    expect(runInt <| 12 |> (12, 24))

    expect(runInt,
           at: 100,
           is: (100, 200)
    )
  }
  
  
}
