//
//  BreederOperator.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 26.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------
// MARK: - BlackNestEgg => Operators
// --------------------------------------------------------------------------------

/// Returns a BlackNestEgg that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BlackNestEgg<S>
public func => <S>(subject: S?, spec: String) -> BlackNestEgg<S>
  where S: Comparable {
    return BlackNestEgg(expectation: spec, subject: subject)
}

/// Returns a BlackNestEgg that contains the `spec` and
/// the `subject` S which must conform to `RawRepresentable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BlackNestEgg<S>
public func => <S>(subject: S?, spec: String) -> BlackNestEgg<S>
  where S: RawRepresentable {
    return BlackNestEgg(expectation: spec, subject: subject)
}

// --------------------------------------------------------------------------------
// MARK: - BlackNestEgg == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BlackNestEgg` for a `==`.
/// - parameter param: lhs BlackNestEgg<S>
/// - parameter param: lhs S?
/// - throws: BlackNestShellCrack
public func == <S>(rhs: S?, lhs: BlackNestEgg<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation, "is >\(lhs.subject)<", "expected >\(rhs)<")
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BlackNestEgg` for a `==`.
/// - parameter param: lhs BlackNestEgg<S>
/// - parameter param: lhs S?
/// - throws: BlackNestShellCrack
public func == <S>(rhs: S?, lhs: BlackNestEgg<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation)
    }
}

// --------------------------------------------------------------------------------
// MARK: - BlackNestEgg != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BlackNestEgg` for a `!=`.
/// - parameter param: lhs BlackNestEgg<S>
/// - parameter param: lhs S?
/// - throws: BlackNestShellCrack
public func != <S>(rhs: S?, lhs: BlackNestEgg<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation, "got", lhs.subject, "but expected", rhs)
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BlackNestEgg` for a `!=`.
/// - parameter param: lhs BlackNestEgg<S>
/// - parameter param: lhs S?
/// - throws: BlackNestShellCrack
public func != <S>(rhs: S?, lhs: BlackNestEgg<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation)
    }
}
