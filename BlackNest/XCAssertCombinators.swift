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
  E: IsPair,
  B: IsPair,
  B.L: HasRun,
  B.R: HasRun,
  B.L.I == I,
  B.L.E == E.L,
  B.R.I == B.L.O,
  B.R.E == E.R {
    do {
      let m1 = try breeding.left.run(input, expected.left)
      let m2 = try breeding.right.run(m1, expected.right)
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
  T: IsPair,
  T.L: RunnableSpec,
  T.R: HasRunAndExpected,
  T.L.O == T.R.I {
    do {
      let m1 = try tree.left.evaluate()
      let m2 = try tree.right.run(m1, tree.right.expected)
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
  E: IsPair,
  B: IsPair,
  E.R: IsPair,
  B.R: IsPair,
  B.L: HasRun,
  B.R.L: HasRun,
  B.R.R: HasRun,
  B.L.I == I,
  B.L.E == E.L,
  B.R.L.I == B.L.O,
  B.R.L.E == E.R.L,
  B.R.R.I == B.R.L.O,
  B.R.R.E == E.R.R {
  do {
    let m1 = try breeding.left.run(input, expected.left)
    let m2 = try breeding.right.left.run(m1, expected.right.left)
    let m3 = try breeding.right.right.run(m2, expected.right.right)
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
  T: IsPair,
  T.R: IsPair,
  T.L: RunnableSpec,
  T.R.L: HasRunAndExpected,
  T.R.R: HasRunAndExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.I {
    do {
      let m1 = try tree.left.evaluate()
      let m2 = try tree.right.left.evaluate(m1)
      let m3 = try tree.right.right.evaluate(m2)
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
  E: IsPair,
  B: IsPair,
  E.R: IsPair,
  E.R.R: IsPair,
  B.R: IsPair,
  B.R.R: IsPair,
  B.L: HasRun,
  B.R.L: HasRun,
  B.R.R.L: HasRun,
  B.R.R.R: HasRun,
  B.L.I == I,
  B.L.E == E.L,
  B.R.L.I == B.L.O,
  B.R.L.E == E.R.L,
  B.R.R.L.I == B.R.L.O,
  B.R.R.L.E == E.R.R.L,
  B.R.R.R.I == B.R.R.L.O,
  B.R.R.R.E == E.R.R.R {
    do {
      let m1 = try breeding.left.run(input, expected.left)
      let m2 = try breeding.right.left.run(m1, expected.right.left)
      let m3 = try breeding.right.right.left.run(m2, expected.right.right.left)
      let m4 = try breeding.right.right.right.run(m3, expected.right.right.right)
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
  T: IsPair,
  T.L: RunnableSpec,
  T.R: IsPair,
  T.R.R: IsPair,
  T.R.L: HasRunAndExpected,
  T.R.R.L: HasRunAndExpected,
  T.R.R.R: HasRunAndExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.L.I,
  T.R.R.L.O == T.R.R.R.I {
    do {
      let m1 = try tree.left.evaluate()
      let m2 = try tree.right.left.evaluate(m1)
      let m3 = try tree.right.right.left.evaluate(m2)
      let m4 = try tree.right.right.right.evaluate(m3)
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
  E: IsPair,
  B: IsPair,
  E.R: IsPair,
  E.R.R: IsPair,
  E.R.R.R: IsPair,
  B.R: IsPair,
  B.R.R: IsPair,
  B.R.R.R: IsPair,
  B.L: HasRun,
  B.R.L: HasRun,
  B.R.R.L: HasRun,
  B.R.R.R.L: HasRun,
  B.R.R.R.R: HasRun,
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
      let m1 = try breeding.left.run(input, expected.left)
      let m2 = try breeding.right.left.run(m1, expected.right.left)
      let m3 = try breeding.right.right.left.run(m2, expected.right.right.left)
      let m4 = try breeding.right.right.right.left.run(m3, expected.right.right.right.left)
      let m5 = try breeding.right.right.right.right.run(m4, expected.right.right.right.right)
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
  T: IsPair,
  T.L: RunnableSpec,
  T.R: IsPair,
  T.R.R: IsPair,
  T.R.R.R: IsPair,
  T.R.L: HasRunAndExpected,
  T.R.R.L: HasRunAndExpected,
  T.R.R.R.L: HasRunAndExpected,
  T.R.R.R.R: HasRunAndExpected,
  T.L.O == T.R.L.I,
  T.R.L.O == T.R.R.L.I,
  T.R.R.L.O == T.R.R.R.L.I,
  T.R.R.R.L.O == T.R.R.R.R.I {
    do {
      let m1 = try tree.left.evaluate()
      let m2 = try tree.right.left.evaluate(m1)
      let m3 = try tree.right.right.left.evaluate(m2)
      let m4 = try tree.right.right.right.left.evaluate(m3)
      let m5 = try tree.right.right.right.right.evaluate(m4)
      return m5
    } catch let error {
      XCTAssert(false, "\(error)", file: file, line: line)
    }
    return nil
}
