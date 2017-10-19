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
// But finally - this is BlackNest - so play the Nest/specRun Metaphor.
// =)
// --------------------------------------------------------------------------------

/// Typealias for a breeding function.
/// Breeding is when we have:
/// - input `I`
/// - expected `E`
/// - output `O`
/// - throws Error
public typealias Run<I, E, O> = (I, E) throws -> O

// --------------------------------------------------------------------------------
// MARK: - Breedable
// --------------------------------------------------------------------------------

/// This protocol wraps a `Breeding`.
/// It helps to work with operators and so forth.
/// It's a formal protocol for a concrete Type
/// wrapping away the breeding function.
public protocol HasRun {
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
  var run: Run<I, E, O> { get }
}

/// Build on top of Breedable.
/// This protocol wraps a `Breeding` and expected `E`.
/// It is waiting for an input `I` which can be provided by `breed(_:)`.
public protocol HasRunAndExpected: HasRun {
  var expected: E { get }
  func evaluate(_ input: I) throws -> O
}

// --------------------------------------------------------------------------------
// MARK: - Breedable Types
//
// These types are intermediate types.
// Waiting for Input, Expected, or both.
// They are used when combining tests.
// They conform to the protocols defined above.
// --------------------------------------------------------------------------------

/// Just a `Breeding` function as a Type.
public struct Runner<I, E, O>: HasRun {
  public let run: Run<I, E, O>
}

/// A `Breeding` function and a input `I`.
public struct RunnerWithInput<I, E, O>: HasRun {
  public let run: Run<I, E, O>
  let input: I
}

/// A `Breeding` function and a expected `E`.
public struct RunnerWithExpected<I, E, O>: HasRunAndExpected {
  public let run: Run<I, E, O>
  public let expected: E

  /// - parameter input: `I` will be passed in and breeding starts.
  public func evaluate(_ input: I) throws -> O {
    return try run(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - Breeding Operators
// --------------------------------------------------------------------------------

/// Lifts Input `I` and related Breeding into WaitingForExpected.
/// The return Type waits for Expected `E`.
///
///      // `100 | doubleTuple`
///      expect(100 | doubleTuple => (100, 200))
///
///
public func | <I, E, O>(lhs: I, rhs: @escaping Run<I, E, O>) -> RunnerWithInput<I, E, O> {
  return RunnerWithInput(run: rhs, input: lhs)
}

/// Lifts Input `I` and related Breeding into WaitingForExpected.
/// The return Type waits for Expected `E`.
///
///      // `100 | doubleTuple`
///      expect(doubleTuple | 100 => (100, 200))
///
///
public func | <I, E, O>(lhs: @escaping Run<I, E, O>, rhs: I) -> RunnerWithInput<I, E, O> {
  return RunnerWithInput(run: lhs, input: rhs)
}

/// Lifts Breeding and related Expected `E` into WaitingForInput.
/// The return Type waits for Input `I`.
///
///      // `doubleTuple => (100, 200)`
///      expect(100, in: doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: @escaping Run<I, E, O>, rhs: E) -> RunnerWithExpected<I, E, O> {
  return RunnerWithExpected(run: lhs, expected: rhs)
}

/// Lifts WaitingForExpected and related Expected `E` into specRun.
/// The return Type is ready for breed.
///
///      // `100 | doubleTuple` will be evaluated first.
///      // then `=> (100, 200)` is called
///      expect(100 | doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: RunnerWithInput<I, E, O>, rhs: E) -> SpecRun<I, E, O> {
  return SpecRun(run: lhs.run, input: lhs.input, expected: rhs)
}
