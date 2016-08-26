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

  // --------------------------------------------------------------------------------
  // MARK: - Specs
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

  func tupleSum(input: (Int, Int), expect: (Int)) throws {
    // Act:
    let subject = input.0 + input.1

    // Assert:
    try subject == expect
      => "sum calculation"
  }

  // --------------------------------------------------------------------------------
  // MARK: - Tests
  // --------------------------------------------------------------------------------

  func testPlain() {

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

    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).runIt()) { e in
        guard let _ = e as? BLNShellCrack else {
          return XCTFail("BLNShellCrack not coming")
        }
    }
  }

  func testChain() {

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


    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).runIt()) { e in
      guard let _ = e as? BLNShellCrack else {
        return XCTFail("BLNShellCrack not coming")
      }
    }
  }


}
