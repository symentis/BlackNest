//
//  EggOperator.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 26.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell => Operators
// --------------------------------------------------------------------------------

/// Returns a BLNEggShell that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEggShell<S>
public func => <S>(subject: S?, spec: String) -> BLNEggShell<S>
  where S: Comparable {
    return BLNEggShell(expectation: spec, subject: subject)
}

/// Returns a BLNEggShell that contains the `spec` and
/// the `subject` S which must conform to `RawRepresentable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEggShell<S>
public func => <S>(subject: S?, spec: String) -> BLNEggShell<S>
  where S: Equatable {
    return BLNEggShell(expectation: spec, subject: subject)
}

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEggShell` for a `==`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func == <S>(rhs: S?, lhs: BLNEggShell<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation, "is >\(rhs)<", "expected >\(lhs.subject)<")
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BLNEggShell` for a `==`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func == <S>(rhs: S?, lhs: BLNEggShell<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation)
    }
}

// --------------------------------------------------------------------------------
// MARK: - BLNEggShell != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEggShell` for a `!=`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func != <S>(rhs: S?, lhs: BLNEggShell<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation, "got", lhs.subject, "but expected", rhs)
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BLNEggShell` for a `!=`.
/// - parameter param: lhs BLNEggShell<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrackError
public func != <S>(rhs: S?, lhs: BLNEggShell<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation)
    }
}
