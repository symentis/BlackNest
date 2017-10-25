//
//  specRunShell.swift
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
import Foundation

// --------------------------------------------------------------------------------
// MARK: - Spec
// --------------------------------------------------------------------------------

/// Spec contains `expectation` and `expected`
public struct Spec<E> {
  let expectation: String
  let expected: E?

  func shellCracked<V>(by value: V?, insteadOf: V?) -> SpecError {
    let valueString = String(describing: value)
    let expectedString = String(describing: insteadOf)
    let message = "\(expectation) \nExpected: \(valueString) \nResult: \(expectedString)"
    return SpecError(message: message)
  }

  func shellCracked<V>(by value: V?) -> SpecError {
    let valueString = String(describing: value)
    let expectedString = String(describing: expected)
    let message = "\(expectation) \nExpected: \(valueString) \nResult: \(expectedString)"
    return SpecError(message: message)
  }
}

// --------------------------------------------------------------------------------
// MARK: - ShellCrackError
// --------------------------------------------------------------------------------

/// ShellCrackError
struct SpecError: Error, CustomStringConvertible {
  let message: String

  var description: String {
    return message
  }
}

public prefix func ...| <T>(_ t: @escaping @autoclosure () -> T) -> () -> T {
  return { t() }
}

// --------------------------------------------------------------------------------
// MARK: - Spec => Operators
// --------------------------------------------------------------------------------

public func => <E>(spec: String, expected: E?) -> Spec<E>
  where E: Equatable {
    return Spec(expectation: spec, expected: expected)
}

public func => <E>(spec: String, expected: E) -> Spec<E>
  where E: Equatable {
    return Spec(expectation: spec, expected: expected)
}

public func => <E>(spec: String, expected: @escaping () -> E?) -> Spec<() -> E?>
  where E: Equatable {
    return Spec(expectation: spec, expected: expected)
}

// --------------------------------------------------------------------------------
// MARK: - Spec == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `Spec` for a `==`.
/// - parameter param: lhs Spec<S>
/// - parameter param: lhs S?
/// - throws: ShellCrackError
public func == <E>(lhs: Spec<E>, rhs: E?) throws
  where E: Equatable {
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

public func == <E>(lhs: Spec<E>, rhs: E) throws
  where E: Equatable {
  guard lhs.expected == rhs else {
    throw lhs.shellCracked(by: rhs)
  }
}

public func == <E>(lhs: Spec<() -> E?>, rhs: E?) throws
  where E: Equatable {
    guard await(for: 1, { lhs.expected?() == rhs }) else {
      throw lhs.shellCracked(by: rhs, insteadOf: lhs.expected?())
    }
}

func await(until: Date = Date().addingTimeInterval(1), _ condition:() -> Bool) -> Bool {
  while condition() == false || Date() < until {
    if condition() || Date() > until {
      break
    }
    RunLoop.current.run(until: until)
  }
  return condition()
}

func wait(for duration: TimeInterval, _ condition: @escaping () -> Bool) -> Bool {
  let waitExpectation = XCTestExpectation(description: "wait")
  let when = DispatchTime.now() + duration
  DispatchQueue.main.asyncAfter(deadline: when) {
    if condition() {
      waitExpectation.fulfill()
    }
  }
  switch XCTWaiter.wait(for: [waitExpectation], timeout: duration + 0.5) {
  case .completed:
      return true
  default:
    return false
  }
}

// --------------------------------------------------------------------------------
// MARK: - Spec != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `Spec` for a `!=`.
/// - parameter param: lhs Spec<S>
/// - parameter param: lhs S?
/// - throws: ShellCrackError
public func != <E>(lhs: Spec<E>, rhs: E?) throws
  where E: Equatable {
    guard lhs.expected != rhs else {
      throw lhs.shellCracked(by: rhs)
    }
}

public func != <E>(lhs: Spec<E>, rhs: E) throws
  where E: Equatable {
    guard lhs.expected != rhs else {
      throw lhs.shellCracked(by: rhs)
    }
}

public func != <E>(lhs: Spec<() -> E?>, rhs: E?) throws
  where E: Equatable {
    guard await({ lhs.expected?() != rhs }) else {
      throw lhs.shellCracked(by: rhs, insteadOf: lhs.expected?())
    }
}

public func a(_ s: String, _ f: String = #file, _ l: UInt = #line) -> String {
  let path = NSURL(fileURLWithPath: f).filePathURL!
  let c = try? String(contentsOf: path, encoding: .utf8)
  let lines = c?.components(separatedBy: "\n")
  let s2 = lines?[Int(l)].trimmingCharacters(in: CharacterSet(charactersIn: " ")) ?? ""
  return s + ":\n" + s2
}
