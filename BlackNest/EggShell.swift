//
//  EggShell.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
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

import XCTest

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell
// --------------------------------------------------------------------------------

/// BLNEggShell contains `expectation` and `expected`
public struct BLNEggShell<E> {
  let expectation: String
  let expected: E?

  func shellCracked(by value: E?) -> BLNShellCrackError {
    let message = "\(expectation) - got \(String(describing: value)) expected \(String(describing: expected))"
    return BLNShellCrackError(message: message)
  }
}

// --------------------------------------------------------------------------------
// MARK: - ShellCrackError
// --------------------------------------------------------------------------------

/// BLNShellCrackError
struct BLNShellCrackError: Error {
  let message: String
}

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell => Operators
// --------------------------------------------------------------------------------

/// Returns a BLNEggShell that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEggShell<S>
public func => <E>(expected: E?, spec: String) -> BLNEggShell<E>
  where E: Equatable {
    return BLNEggShell(expectation: spec, expected: expected)
}

/// Returns a BLNEggShell that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEggShell<S>
public func => <E>(expected: E, spec: String) -> BLNEggShell<E>
  where E: Equatable {
    return BLNEggShell(expectation: spec, expected: expected)
}

/// Returns a BLNEggShell that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEggShell<S>
public func .= <E>(spec: String, expected: E?) -> BLNEggShell<E>
  where E: Equatable {
    return BLNEggShell(expectation: spec, expected: expected)
}

public func .= <E>(spec: String, expected: E) -> BLNEggShell<E>
  where E: Equatable {
    return BLNEggShell(expectation: spec, expected: expected)
}

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEggShell` for a `==`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func == <E>(rhs: E?, lhs: BLNEggShell<E>) throws
  where E: Equatable {
  guard lhs.expected != nil && rhs != nil else { return }
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

public func == <E>(rhs: E, lhs: BLNEggShell<E>) throws
  where E: Equatable {
  guard lhs.expected != nil else { return }
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

/// Lifts expected S? into the `BLNEggShell` for a `==`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func == <E>(lhs: BLNEggShell<E>, rhs: E?) throws
  where E: Equatable {
  guard lhs.expected != nil && rhs != nil else { return }
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

public func == <E>(lhs: BLNEggShell<E>, rhs: E) throws
  where E: Equatable {
  guard lhs.expected != nil else { return }
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEggShell` for a `!=`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func != <E>(rhs: E?, lhs: BLNEggShell<E>) throws
  where E: Equatable {
    guard lhs.expected != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.expected != rhs else {
      throw lhs.shellCracked(by: rhs)
    }
}

public func != <E>(rhs: E, lhs: BLNEggShell<E>) throws
  where E: Equatable {
    guard lhs.expected != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.expected != rhs else {
      throw lhs.shellCracked(by: rhs)
    }
}
