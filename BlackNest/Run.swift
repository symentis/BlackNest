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

/// Typealias for a run function.
/// Run is when we have:
/// - input `I`
/// - expected `E`
/// - output `O`
/// - throws Error
public typealias RunFunction<I, E, O> = (I, E) throws -> O

// --------------------------------------------------------------------------------
// MARK: - HasRun
// --------------------------------------------------------------------------------

/// This protocol wraps a `RunFunction`.
/// It helps to work with operators and so forth.
/// It's a formal protocol for a concrete Type
/// wrapping away the run function.
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
  /// The run function.
  /// Can take Input, Expected and return Output or throws.
  /// Can be anything - Tuple, Optional, Whatever
  var run: RunFunction<I, E, O> { get }
}

/// Build on top of HasRun.
/// This protocol wraps a `RunFunction` and expected `E`.
/// It is waiting for an input `I` which can be provided by `evaluate(_:)`.
public protocol HasRunAndExpected: HasRun {
  var expected: E { get }
  func evaluate(_ input: I) throws -> O
}

// --------------------------------------------------------------------------------
// MARK: - Run Types
//
// These types are intermediate types.
// Waiting for Input, Expected, or both.
// They are used when combining tests.
// They conform to the protocols defined above.
// --------------------------------------------------------------------------------

/// Just a `RunFunction` function as a Type.
public struct Run<I, E, O>: HasRun {
  public let run: RunFunction<I, E, O>
}

/// A `RunFunction` function and a input `I`.
public struct RunWithInput<I, E, O>: HasRun {
  public let run: RunFunction<I, E, O>
  let input: I
}

/// A `RunFunction` function and a expected `E`.
public struct RunWithExpected<I, E, O>: HasRunAndExpected {
  public let run: RunFunction<I, E, O>
  public let expected: E

  /// - parameter input: `I` will be passed in and run starts.
  public func evaluate(_ input: I) throws -> O {
    return try run(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - Run Operators
// --------------------------------------------------------------------------------

/// Lifts Input `I` and related RunFunction into RunWithInput.
/// The return Type waits for Expected `E`.
///
///      // `100 | doubleTuple`
///      expect(100 | doubleTuple => (100, 200))
///
///
public func | <I, E, O>(lhs: I, rhs: @escaping RunFunction<I, E, O>) -> RunWithInput<I, E, O> {
  return RunWithInput(run: rhs, input: lhs)
}

/// Lifts Input `I` and related RunFunction into RunWithInput.
/// The return Type waits for Expected `E`.
///
///      // `100 | doubleTuple`
///      expect(doubleTuple | 100 => (100, 200))
///
///
public func | <I, E, O>(lhs: @escaping RunFunction<I, E, O>, rhs: I) -> RunWithInput<I, E, O> {
  return RunWithInput(run: lhs, input: rhs)
}

/// Lifts RunFunction and related Expected `E` into RunWithExpected.
/// The return Type waits for Input `I`.
///
///      // `doubleTuple => (100, 200)`
///      expect(100, in: doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: @escaping RunFunction<I, E, O>, rhs: E) -> RunWithExpected<I, E, O> {
  return RunWithExpected(run: lhs, expected: rhs)
}

/// Lifts RunWithInput and related Expected `E` into Spec.
/// The return Type is ready for evaluate.
///
///      // `100 | doubleTuple` will be evaluated first.
///      // then `=> (100, 200)` is called
///      expect(100 | doubleTuple => (100, 200))
///
///
public func => <I, E, O>(lhs: RunWithInput<I, E, O>, rhs: E) -> Spec<I, E, O> {
  return Spec(run: lhs.run, input: lhs.input, expected: rhs)
}
