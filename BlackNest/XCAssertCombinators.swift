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
public func expect<I, B, E>(_ input: I,
                            in breeding: B,
                            is expected: E,
                            line: UInt = #line,
                            file: StaticString = #file) -> B.R.O?
  where
  E: BLNCombinable,
  B: BLNCombinable,
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

@discardableResult
public func expect<T>(_ tree: T,
                      line: UInt = #line,
                      file: StaticString = #file) -> T.R.O?
  where
  T: BLNCombinable,
  T.L: BLNHatchable,
  T.R: BLNBreedableExpected,
  T.L.O == T.R.I {
    do {
      let m1 = try tree.left.breed()
      let m2 = try tree.right.breeding(m1, tree.right.expected)
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
public func expect<I, B, E>(_ input: I,
                            in breeding: B,
                            is expected: E,
                            line: UInt = #line,
                            file: StaticString = #file) -> B.R.R.O?
  where
  E: BLNCombinable,
  B: BLNCombinable,
  E.R: BLNCombinable,
  B.R: BLNCombinable,
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

@discardableResult
public func expect<T>(_ tree: T,
                      line: UInt = #line,
                      file: StaticString = #file) -> T.R.R.O?
  where
  T: BLNCombinable,
  T.R: BLNCombinable,
  T.L: BLNHatchable,
  T.R.L: BLNBreedableExpected,
  T.R.R: BLNBreedableExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.I {
    do {
      let m1 = try tree.left.breed()
      let m2 = try tree.right.left.breed(m1)
      let m3 = try tree.right.right.breed(m2)
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
public func expect<I, B, E>(_ input: I,
                            in breeding: B,
                            is expected: E,
                            line: UInt = #line,
                            file: StaticString = #file) -> B.R.R.R.O?
  where
  E: BLNCombinable,
  B: BLNCombinable,
  E.R: BLNCombinable,
  E.R.R: BLNCombinable,
  B.R: BLNCombinable,
  B.R.R: BLNCombinable,
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

@discardableResult
public func expect<T>(_ tree: T,
                      line: UInt = #line,
                      file: StaticString = #file) -> T.R.R.R.O?
  where
  T: BLNCombinable,
  T.L: BLNHatchable,
  T.R: BLNCombinable,
  T.R.R: BLNCombinable,
  T.R.L: BLNBreedableExpected,
  T.R.R.L: BLNBreedableExpected,
  T.R.R.R: BLNBreedableExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.L.I,
  T.R.R.L.O == T.R.R.R.I {
    do {
      let m1 = try tree.left.breed()
      let m2 = try tree.right.left.breed(m1)
      let m3 = try tree.right.right.left.breed(m2)
      let m4 = try tree.right.right.right.breed(m3)
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
public func expect<I, B, E>(_ input: I,
                            in breeding: B,
                            is expected: E,
                            line: UInt = #line,
                            file: StaticString = #file) -> B.R.R.R.R.O?
  where
  E: BLNCombinable,
  B: BLNCombinable,
  E.R: BLNCombinable,
  E.R.R: BLNCombinable,
  E.R.R.R: BLNCombinable,
  B.R: BLNCombinable,
  B.R.R: BLNCombinable,
  B.R.R.R: BLNCombinable,
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

@discardableResult
public func expect<T>(_ tree: T,
                      line: UInt = #line,
                      file: StaticString = #file) -> T.R.R.R.R.O?
  where
  T: BLNCombinable,
  T.L: BLNHatchable,
  T.R: BLNCombinable,
  T.R.R: BLNCombinable,
  T.R.R.R: BLNCombinable,
  T.R.L: BLNBreedableExpected,
  T.R.R.L: BLNBreedableExpected,
  T.R.R.R.L: BLNBreedableExpected,
  T.R.R.R.R: BLNBreedableExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.L.I,
  T.R.R.L.O == T.R.R.R.L.I,
  T.R.R.R.L.O == T.R.R.R.R.I {
    do {
      let m1 = try tree.left.breed()
      let m2 = try tree.right.left.breed(m1)
      let m3 = try tree.right.right.left.breed(m2)
      let m4 = try tree.right.right.right.left.breed(m3)
      let m5 = try tree.right.right.right.right.breed(m4)
      return m5
    } catch let error {
      XCTAssert(false, "\(error)", file: file, line: line)
    }
    return nil
}
