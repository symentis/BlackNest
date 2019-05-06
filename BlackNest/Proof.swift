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
// MARK: - Proof
// --------------------------------------------------------------------------------

/// Proof contains `requirement` and `probe`
public struct Proof<P> {
  public let requirement: String
  public let probe: P?

  public init(requirement: String, probe: P?) {
    self.requirement = requirement
    self.probe = probe
  }

  public func mismatched<V>(expected: V?, currentProbe: V?) -> ProofError {
    let expectedString = String(describing: expected)
    let probeString = String(describing: currentProbe)
    let message = "\(requirement) \nExpected: \(expectedString) Input: \(probeString)"
    return ProofError(message: message)
  }

  public func mismatched(expected: P?) -> ProofError {
    return mismatched(expected: expected, currentProbe: probe)
  }
}

// --------------------------------------------------------------------------------
// MARK: - ProofError
// --------------------------------------------------------------------------------

/// ProofError
public struct ProofError: Error, CustomStringConvertible {
  public let message: String

  public init(message: String) {
    self.message = message
  }

  public var description: String {
    return message
  }
}

public prefix func ...| <T>(_ t: @escaping @autoclosure () -> T) -> () -> T {
  return { t() }
}

// --------------------------------------------------------------------------------
// MARK: - Proof => Operators
// --------------------------------------------------------------------------------

public func => <P>(lhs: String, rhs: P?) -> Proof<P>
  where P: Equatable {
    return Proof(requirement: lhs, probe: rhs)
}

public func => <P>(lhs: String, rhs: P) -> Proof<P>
  where P: Equatable {
    return Proof(requirement: lhs, probe: rhs)
}

public func => <P>(lhs: String, rhs: @escaping () -> P?) -> Proof<() -> P?>
  where P: Equatable {
    return Proof(requirement: lhs, probe: rhs)
}

// --------------------------------------------------------------------------------
// MARK: - Proof == Operators
// --------------------------------------------------------------------------------

/// Lifts expected P? into the `Proof` for a `==`.
/// - parameter param: lhs Proof<S>
/// - parameter param: rhs P?
/// - throws: ProofError
public func == <P>(lhs: Proof<P>, rhs: P?) throws
  where P: Equatable {
  guard lhs.probe == rhs else {
    throw lhs.mismatched(expected: rhs)
  }
}

public func == <P>(lhs: Proof<P>, rhs: P) throws
  where P: Equatable {
  guard lhs.probe == rhs else {
    throw lhs.mismatched(expected: rhs)
  }
}

public func == <P>(lhs: Proof<() -> P?>, rhs: P?) throws
  where P: Equatable {
    guard await({ lhs.probe?() == rhs }) else {
      throw lhs.mismatched(expected: rhs, currentProbe: lhs.probe?())
    }
}

// --------------------------------------------------------------------------------
// MARK: - Proof != Operators
// --------------------------------------------------------------------------------

/// Lifts expected P? into the `Proof` for a `!=`.
/// - parameter param: lhs Proof<S>
/// - parameter param: lhs P?
/// - throws: ProofError
public func != <P>(lhs: Proof<P>, rhs: P?) throws
  where P: Equatable {
    guard lhs.probe != rhs else {
      throw lhs.mismatched(expected: rhs)
    }
}

public func != <P>(lhs: Proof<P>, rhs: P) throws
  where P: Equatable {
    guard lhs.probe != rhs else {
      throw lhs.mismatched(expected: rhs)
    }
}

public func != <P>(lhs: Proof<() -> P?>, rhs: P?) throws
  where P: Equatable {
    guard await({ lhs.probe?() != rhs }) else {
      throw lhs.mismatched(expected: rhs, currentProbe: lhs.probe?())
    }
}

// --------------------------------------------------------------------------------
// MARK: - Waiting
// --------------------------------------------------------------------------------

func await(until: Date = Date().addingTimeInterval(2), _ condition:() -> Bool) -> Bool {
  while condition() == false || Date() < until {
    if condition() || Date() > until {
      break
    }
    RunLoop.current.run(until: until)
  }
  return condition()
}

//func wait(for duration: TimeInterval, _ condition: @escaping () -> Bool) -> Bool {
//  let waitExpectation = XCTestExpectation(description: "wait")
//  let when = DispatchTime.now() + duration
//  DispatchQueue.main.asyncAfter(deadline: when) {
//    if condition() {
//      waitExpectation.fulfill()
//    }
//  }
//  switch XCTWaiter.wait(for: [waitExpectation], timeout: duration + 0.5) {
//  case .completed:
//    return true
//  default:
//    return false
//  }
//}

public func a(_ s: String, _ f: String = #file, _ l: UInt = #line) -> String {
  let path = NSURL(fileURLWithPath: f).filePathURL!
  let c = try? String(contentsOf: path, encoding: .utf8)
  let lines = c?.components(separatedBy: "\n")
  let s2 = lines?[Int(l)].trimmingCharacters(in: CharacterSet(charactersIn: " ")) ?? ""
  return s + ":\n" + s2
}
