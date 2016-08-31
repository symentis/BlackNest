//
//  Breeding.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 31.08.16.
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

// --------------------------------------------------------------------------------
// MARK: - Breeding
//
// In order to have clear naming we call the function that is called
// with Input and Expected and return Output or throws: Breeding.
// We were searching for something like TestRunner, or TestFunction or whatever.
// But finally - this is BlackNest - so play the Nest/Egg Metaphor.
// =)
// --------------------------------------------------------------------------------

/// Typealias for a breeding function.
/// Breeding is when we have:
/// - input `I`
/// - expected `E`
/// - output `O`
/// - throws Error
public typealias BLNBreeding<I, E, O> = (I, E) throws -> O

// --------------------------------------------------------------------------------
// MARK: - Breedable
// --------------------------------------------------------------------------------

/// This protocol wraps a `BLNBreeding`.
/// It helps to work with operators and so forth.
/// It's a formal protocol for a concrete Type
/// wrapping away the breeding function.
public protocol BLNBreedable {
  /// The Input Type
  /// Can be anything - Tuple, Optional, Whatever
  associatedtype I
  /// The Expected Type
  /// Can be anything - Tuple, Optional, Whatever
  associatedtype E
  /// The Output Type
  /// Can be anything - Tuple, Optional, Whatever
  associatedtype O
  /// The Breeding function.
  /// Can take Input, Expected and return Output or throws.
  /// Can be anything - Tuple, Optional, Whatever
  var breeding: (I, E) throws -> O { get }
}

/// Build on top of BLNBreedable.
/// This protocol wraps a `Breeding` and expected `E`.
/// It is waiting for an input `I` which can be provided by `breed(_:)`.
public protocol BLNBreedableExpected: BLNBreedable {
  var expected: E { get }
  func breed(_ input: I) throws -> O
}

// --------------------------------------------------------------------------------
// MARK: - Breedable Types
//
// These types are intermediate types.
// Waiting for Input, Expected, or both.
// They are used when combining tests.
// They conform to the protocols defined above.
// --------------------------------------------------------------------------------

/// Just a `BLNBreeding` function as a Type.
public struct BLNBreeder<I, E, O>: BLNBreedable {
  public let breeding: BLNBreeding<I, E, O>
}

/// A `BLNBreeding` function and a input `I`.
public struct BLNWaitingForExpected<I, E, O>: BLNBreedable {
  public let breeding: BLNBreeding<I, E, O>
  let input: I
}

/// A `BLNBreeding` function and a expected `E`.
public struct BLNWaitingForInput<I, E, O>: BLNBreedableExpected {
  public let breeding: BLNBreeding<I, E, O>
  public let expected: E

  /// - parameter input: `I` will be passed in and breeding starts.
  public func breed(_ input: I) throws -> O {
    return try breeding(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - BLNBreeding Operators
// --------------------------------------------------------------------------------

/// Lifts Input `I` and related BLNBreeding into BLNWaitingForExpected.
/// The return Type waits for Expected `E`.
///
///      // `100 | doubleTuple`
///      expect(100 | doubleTuple => (100, 200))
///
///
public func | <I, E, O>(lhs: I, rhs: BLNBreeding<I, E, O>) -> BLNWaitingForExpected<I, E, O> {
  return BLNWaitingForExpected(breeding: rhs, input: lhs)
}

/// Lifts BLNBreeding and related Expected `E` into BLNWaitingForInput.
/// The return Type waits for Input `I`.
///
///      // `doubleTuple => (100, 200)`
///      expect(100, in: doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: BLNBreeding<I, E, O>, rhs: E) -> BLNWaitingForInput<I, E, O> {
  return BLNWaitingForInput(breeding: lhs, expected: rhs)
}

/// Lifts BLNWaitingForExpected and related Expected `E` into BLNEgg.
/// The return Type is ready for breed.
///
///      // `100 | doubleTuple` will be evaluated first.
///      // then `=> (100, 200)` is called
///      expect(100 | doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: BLNWaitingForExpected<I, E, O>, rhs: E) -> BLNEgg<I, E, O> {
  return BLNEgg(breeding: lhs.breeding, input: lhs.input, expected: rhs)
}
