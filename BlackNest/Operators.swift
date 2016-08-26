//
//  Operators.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

// --------------------------------------------------------------------------------
// MARK: - BlackNest Operators
// --------------------------------------------------------------------------------

/// in order to make `==` evaluate after `?>`
/// we reduce the Precedence of the Blacknest operator
precedencegroup BlackNestSpecPrecedence {
  higherThan: ComparisonPrecedence
  lowerThan: AdditionPrecedence
}

infix operator => : BlackNestSpecPrecedence

// --------------------------------------------------------------------------------
// MARK: - BlackNest ?> Operators
// --------------------------------------------------------------------------------

/// Returns a BlackNestBreeder that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BlackNestBreeder<S>
public func => <S>(subject: S?, spec: String) -> BlackNestBreeder<S>
  where S: Comparable {
    return BlackNestBreeder(expectation: spec, subject: subject)
}

/// Returns a BlackNestBreeder that contains the `spec` and
/// the `subject` S which must conform to `RawRepresentable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BlackNestBreeder<S>
public func => <S>(subject: S?, spec: String) -> BlackNestBreeder<S>
  where S: RawRepresentable {
    return BlackNestBreeder(expectation: spec, subject: subject)
}

// --------------------------------------------------------------------------------
// MARK: - BlackNestBreeder == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BlackNestBreeder` for a `==`.
/// - parameter param: lhs BlackNestBreeder<S>
/// - parameter param: lhs S?
/// - throws: BlacknestHatchOutError
public func == <S>(rhs: S?, lhs: BlackNestBreeder<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw hatchOut(lhs.expectation, "is >\(lhs.subject)<", "expected >\(rhs)<")
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BlackNestBreeder` for a `==`.
/// - parameter param: lhs BlackNestBreeder<S>
/// - parameter param: lhs S?
/// - throws: BlacknestHatchOutError
public func == <S>(rhs: S?, lhs: BlackNestBreeder<S>) throws
  where S: RawRepresentable, S.RawValue: Comparable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject?.rawValue == rhs?.rawValue else {
      throw hatchOut(lhs.expectation)
    }
}

// --------------------------------------------------------------------------------
// MARK: - BlackNestBreeder != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BlackNestBreeder` for a `!=`.
/// - parameter param: lhs BlackNestBreeder<S>
/// - parameter param: lhs S?
/// - throws: BlacknestHatchOutError
public func != <S>(rhs: S?, lhs: BlackNestBreeder<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw hatchOut(lhs.expectation, "got", lhs.subject, "but expected", rhs)
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BlackNestBreeder` for a `!=`.
/// - parameter param: lhs BlackNestBreeder<S>
/// - parameter param: lhs S?
/// - throws: BlacknestHatchOutError
public func != <S>(rhs: S?, lhs: BlackNestBreeder<S>) throws
  where S: RawRepresentable, S.RawValue: Comparable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject?.rawValue != rhs?.rawValue else {
      throw hatchOut(lhs.expectation)
    }
}

// --------------------------------------------------------------------------------
// MARK: - BlackNestTestRunner Operators
// --------------------------------------------------------------------------------

/// Lift Input into BlackNestTestRunner and get BlackNestTestRunnerWithInput
public func | <I, E>(rhs: I, lhs: BlackNestTestRunner<I, E>) -> BlackNestTestRunnerWithInput<I, E> {
  return BlackNestTestRunnerWithInput(run: lhs, input: rhs)
}

/// Lift Expected into BlackNestTestRunnerWithInput and get BlackNestTestRun
public func => <I, E>(lhs: BlackNestTestRunnerWithInput<I, E>, rhs: E) -> BlackNestTestRun<I, E> {
  return BlackNestTestRun(run: lhs.run, input: lhs.input, expected: rhs)
}
