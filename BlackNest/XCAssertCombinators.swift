//
//  XCAssertCombinators.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 26.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import XCTest

// --------------------------------------------------------------------------------
// MARK: - 2 Level
// --------------------------------------------------------------------------------

@discardableResult
public func expectAll<I, B, E>(_ input: I,
                      in breeding: B,
                      is expected: E,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.R.O?
  where
  E: BLNBranchable,
  B: BLNBranchable,
  B.L: BLNBreedable,
  B.R: BLNBreedable,
  B.L.I == I,
  B.L.E == E.L,
  B.R.I == B.L.O,
  B.R.E == E.R {
    do {
      let m1 = try breeding.left.breeding(input, expected.left)
      let m2 = try breeding.right.breeding(m1, expected.right)
      return m2
    } catch let error {
      XCTAssert(false, "\(error)", file: file, line: line)
    }
    return nil
}


// --------------------------------------------------------------------------------
// MARK: - 3 Level
// --------------------------------------------------------------------------------

@discardableResult
public func expectAll<I, B, E>(_ input: I,
                              in breeding: B,
                              is expected: E,
                              line: UInt = #line,
                              file: StaticString = #file) -> B.R.R.O?
  where
  E: BLNBranchable,
  B: BLNBranchable,
  E.R: BLNBranchable,
  B.R: BLNBranchable,
  B.L: BLNBreedable,
  B.R.L: BLNBreedable,
  B.R.R: BLNBreedable,
  B.L.I == I,
  B.L.E == E.L,
  B.R.L.I == B.L.O,
  B.R.L.E == E.R.L,
  B.R.R.I == B.R.L.O,
  B.R.R.E == E.R.R {
  do {
    let m1 = try breeding.left.breeding(input, expected.left)
    let m2 = try breeding.right.left.breeding(m1, expected.right.left)
    let m3 = try breeding.right.right.breeding(m2, expected.right.right)
    return m3
  } catch let error {
    XCTAssert(false, "\(error)", file: file, line: line)
  }
  return nil
}

// --------------------------------------------------------------------------------
// MARK: - 4 Level
// --------------------------------------------------------------------------------

@discardableResult
public func expectAll<I, B, E>(_ input: I,
                      in breeding: B,
                      is expected: E,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.R.R.R.O?
  where
  E: BLNBranchable,
  B: BLNBranchable,
  E.R: BLNBranchable,
  E.R.R: BLNBranchable,
  B.R: BLNBranchable,
  B.R.R: BLNBranchable,
  B.L: BLNBreedable,
  B.R.L: BLNBreedable,
  B.R.R.L: BLNBreedable,
  B.R.R.R: BLNBreedable,
  B.L.I == I,
  B.L.E == E.L,
  B.R.L.I == B.L.O,
  B.R.L.E == E.R.L,
  B.R.R.L.I == B.R.L.O,
  B.R.R.L.E == E.R.R.L,
  B.R.R.R.I == B.R.R.L.O,
  B.R.R.R.E == E.R.R.R {
    do {
      let m1 = try breeding.left.breeding(input, expected.left)
      let m2 = try breeding.right.left.breeding(m1, expected.right.left)
      let m3 = try breeding.right.right.left.breeding(m2, expected.right.right.left)
      let m4 = try breeding.right.right.right.breeding(m3, expected.right.right.right)
      return m4
    } catch let error {
      XCTAssert(false, "\(error)", file: file, line: line)
    }
    return nil
}

// --------------------------------------------------------------------------------
// MARK: - 5 Level
// --------------------------------------------------------------------------------

@discardableResult
public func expectAll<I, B, E>(_ input: I,
                      in breeding: B,
                      is expected: E,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.R.R.R.R.O?
  where
  E: BLNBranchable,
  B: BLNBranchable,
  E.R: BLNBranchable,
  E.R.R: BLNBranchable,
  E.R.R.R: BLNBranchable,
  B.R: BLNBranchable,
  B.R.R: BLNBranchable,
  B.R.R.R: BLNBranchable,
  B.L: BLNBreedable,
  B.R.L: BLNBreedable,
  B.R.R.L: BLNBreedable,
  B.R.R.R.L: BLNBreedable,
  B.R.R.R.R: BLNBreedable,
  B.L.I == I,
  B.L.E == E.L,
  B.R.L.I == B.L.O,
  B.R.L.E == E.R.L,
  B.R.R.L.I == B.R.L.O,
  B.R.R.L.E == E.R.R.L,
  B.R.R.R.L.I == B.R.R.L.O,
  B.R.R.R.L.E == E.R.R.R.L,
  B.R.R.R.R.I == B.R.R.R.L.O,
  B.R.R.R.R.E == E.R.R.R.R {
    do {
      let m1 = try breeding.left.breeding(input, expected.left)
      let m2 = try breeding.right.left.breeding(m1, expected.right.left)
      let m3 = try breeding.right.right.left.breeding(m2, expected.right.right.left)
      let m4 = try breeding.right.right.right.left.breeding(m3, expected.right.right.right.left)
      let m5 = try breeding.right.right.right.right.breeding(m4, expected.right.right.right.right)
      return m5
    } catch let error {
      XCTAssert(false, "\(error)", file: file, line: line)
    }
    return nil
}
