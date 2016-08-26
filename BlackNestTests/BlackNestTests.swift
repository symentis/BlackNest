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

  func testPlain() {

    func asTupleWithDoubledValue(_ int: Int) -> (Int, Int) {
      return (int, int * 2)
    }

    func runTupleWithDoubled(input: (Int), expect: (Int, Int)) throws {

      let subject = asTupleWithDoubledValue(input)

      try subject.0 == expect.0
        => "first entry is still the same"
      try subject.1 == expect.1
        => "second entry is duplicate"
    }

    expect(04 | runTupleWithDoubled => (04, 08))
    expect(08 | runTupleWithDoubled => (08, 16))
    expect(12 | runTupleWithDoubled => (12, 24))

    expect(runTupleWithDoubled,
           at: 100,
           is: (100, 200)
    )

    XCTAssertThrowsError(try (12 | runTupleWithDoubled => (13, 24)).runIt()) { e in
        guard let _ = e as? BLNShellCrack else {
          return XCTFail("BLNShellCrack not coming")
        }
    }
  }

  func testWithReturn() {

    func asTupleWithDoubledValue(_ int: Int) -> (Int, Int) {
      return (int, int * 2)
    }
    func asTupleSum(_ tuple: (Int, Int)) -> (Int) {
      return tuple.0 + tuple.1
    }


    func runTupleWithDoubled(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
      let subject = asTupleWithDoubledValue(input)

      try subject.0 == expect.0
        => "first entry is still the same"
      try subject.1 == expect.1
        => "second entry is duplicate"

      return subject
    }

    func runTupleSum(input: (Int, Int), expect: (Int)) throws {
      let subject = asTupleSum(input)

      try subject == expect
        => "sum is correct"
    }

    if let sum = expect(04 | runTupleWithDoubled => (04, 08)) {
      _ = expect(sum | runTupleSum => 12)
    }
    _ = expect(08 | runTupleWithDoubled => (08, 16))
    _ = expect(12 | runTupleWithDoubled => (12, 24))

    _ = expect(runTupleWithDoubled,
           at: 100,
           is: (100, 200)
    )

    XCTAssertThrowsError(try (12 | runTupleWithDoubled => (13, 24)).runIt()) { e in
      guard let _ = e as? BLNShellCrack else {
        return XCTFail("BLNShellCrack not coming")
      }
    }
  }


}
