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

    func runInt(input: (String, Int), expect: (Int, Int, String)) throws {

      let subject = (input.1, input.1 + input.1)

      try "first is same" ?>
        subject.0 == expect.0

      try "second is duplicate" ?>
        subject.1 == expect.1
    }

    expect(runInt =/ ("A", 04) => (04, 08, "A"))
    expect(runInt =/ ("B", 08) => (08, 16, "A"))
    expect(runInt =/ ("C", 12) => (12, 24, "A"))

    expect(runInt,
           at: ("A", 100),
           is: (100, 200, "A")
    )


    XCTAssertThrowsError(try (runInt =/ ("C", 12) => (13, 24, "A")).runIt()) { e in
        guard let _ = e as? BlacknestHatchOutError else {
          return XCTFail("BlacknestHatchOutError not coming")
        }
    }

  }
}
