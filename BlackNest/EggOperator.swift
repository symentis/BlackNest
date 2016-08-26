//
//  EggOperator.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 26.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------
// MARK: - BLNEgg => Operators
// --------------------------------------------------------------------------------

/// Returns a BLNEgg that contains the `spec` and
/// the `subject` S which must conform to `Comparable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEgg<S>
public func => <S>(subject: S?, spec: String) -> BLNEgg<S>
  where S: Comparable {
    return BLNEgg(expectation: spec, subject: subject)
}

/// Returns a BLNEgg that contains the `spec` and
/// the `subject` S which must conform to `RawRepresentable`.
/// - parameter spec: String
/// - parameter subject: S?
/// - returns: BLNEgg<S>
public func => <S>(subject: S?, spec: String) -> BLNEgg<S>
  where S: RawRepresentable {
    return BLNEgg(expectation: spec, subject: subject)
}

// --------------------------------------------------------------------------------
// MARK: - BLNEgg == Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEgg` for a `==`.
/// - parameter param: lhs BLNEgg<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrack
public func == <S>(rhs: S?, lhs: BLNEgg<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation, "is >\(lhs.subject)<", "expected >\(rhs)<")
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BLNEgg` for a `==`.
/// - parameter param: lhs BLNEgg<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrack
public func == <S>(rhs: S?, lhs: BLNEgg<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else { return }
    guard lhs.subject == rhs else {
      throw shellCracked(lhs.expectation)
    }
}

// --------------------------------------------------------------------------------
// MARK: - BLNEgg != Operators
// --------------------------------------------------------------------------------

/// Lifts expected S? into the `BLNEgg` for a `!=`.
/// - parameter param: lhs BLNEgg<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrack
public func != <S>(rhs: S?, lhs: BLNEgg<S>) throws
  where S: Comparable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation, "got", lhs.subject, "but expected", rhs)
    }
}

/// Lifts expected S? conforming to RawRepresentable into the `BLNEgg` for a `!=`.
/// - parameter param: lhs BLNEgg<S>
/// - parameter param: lhs S?
/// - throws: BLNShellCrack
public func != <S>(rhs: S?, lhs: BLNEgg<S>) throws
  where S: Equatable {
    guard lhs.subject != nil && rhs != nil else {
      //throw yell(lhs.lookingAt, "got", lhs.subject, "but expected", rhs)
      return
    }
    guard lhs.subject != rhs else {
      throw shellCracked(lhs.expectation)
    }
}
