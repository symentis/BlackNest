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
public func expectAll<A, B, C>(_ input: C,
                      in breeding: B,
                      is expected: A,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.BB.BO?
  where
  A: BLNBranchable,
  B: BLNBranchable,
  B.BA: BLNBreedable,
  B.BB: BLNBreedable,
  B.BA.BI == C,
  B.BA.BE == A.BA,
  B.BB.BI == B.BA.BO,
  B.BB.BE == A.BB {
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
public func expectAll<A, B, C>(_ input: C,
                              in breeding: B,
                              is expected: A,
                              line: UInt = #line,
                              file: StaticString = #file) -> B.BB.BB.BO?
  where
  A: BLNBranchable,
  B: BLNBranchable,
  A.BB: BLNBranchable,
  B.BB: BLNBranchable,
  B.BA: BLNBreedable,
  B.BB.BA: BLNBreedable,
  B.BB.BB: BLNBreedable,
  B.BA.BI == C,
  B.BA.BE == A.BA,
  B.BB.BA.BI == B.BA.BO,
  B.BB.BA.BE == A.BB.BA,
  B.BB.BB.BI == B.BB.BA.BO,
  B.BB.BB.BE == A.BB.BB {
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
public func expectAll<A, B, C>(_ input: C,
                      in breeding: B,
                      is expected: A,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.BB.BB.BB.BO?
  where
  A: BLNBranchable,
  B: BLNBranchable,
  A.BB: BLNBranchable,
  A.BB.BB: BLNBranchable,
  B.BB: BLNBranchable,
  B.BB.BB: BLNBranchable,
  B.BA: BLNBreedable,
  B.BB.BA: BLNBreedable,
  B.BB.BB.BA: BLNBreedable,
  B.BB.BB.BB: BLNBreedable,
  B.BA.BI == C,
  B.BA.BE == A.BA,
  B.BB.BA.BI == B.BA.BO,
  B.BB.BA.BE == A.BB.BA,
  B.BB.BB.BA.BI == B.BB.BA.BO,
  B.BB.BB.BA.BE == A.BB.BB.BA,
  B.BB.BB.BB.BI == B.BB.BB.BA.BO,
  B.BB.BB.BB.BE == A.BB.BB.BB {
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
public func expectAll<A, B, C>(_ input: C,
                      in breeding: B,
                      is expected: A,
                      line: UInt = #line,
                      file: StaticString = #file) -> B.BB.BB.BB.BB.BO?
  where
  A: BLNBranchable,
  B: BLNBranchable,
  A.BB: BLNBranchable,
  A.BB.BB: BLNBranchable,
  A.BB.BB.BB: BLNBranchable,
  B.BB: BLNBranchable,
  B.BB.BB: BLNBranchable,
  B.BB.BB.BB: BLNBranchable,
  B.BA: BLNBreedable,
  B.BB.BA: BLNBreedable,
  B.BB.BB.BA: BLNBreedable,
  B.BB.BB.BB.BA: BLNBreedable,
  B.BB.BB.BB.BB: BLNBreedable,
  B.BA.BI == C,
  B.BA.BE == A.BA,
  B.BB.BA.BI == B.BA.BO,
  B.BB.BA.BE == A.BB.BA,
  B.BB.BB.BA.BI == B.BB.BA.BO,
  B.BB.BB.BA.BE == A.BB.BB.BA,
  B.BB.BB.BB.BA.BI == B.BB.BB.BA.BO,
  B.BB.BB.BB.BA.BE == A.BB.BB.BB.BA,
  B.BB.BB.BB.BB.BI == B.BB.BB.BB.BA.BO,
  B.BB.BB.BB.BB.BE == A.BB.BB.BB.BB {
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
