//
//  specRun.swift
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

// --------------------------------------------------------------------------------
// MARK: - EvaluatableSpec
// --------------------------------------------------------------------------------

/// Build on top of HasRun.
/// This protocol wraps `run`, `input` and `expected`.
/// Run starts by calling `evaluate`
public protocol EvaluatableSpec: HasRun {
  var input: I { get }
  var expected: E { get }
  func evaluate() throws -> O
}

// --------------------------------------------------------------------------------
// MARK: - Spec
//
// This has everything. The input, the expected, the run.
// We can start to run!
// --------------------------------------------------------------------------------

/// Spec
/// A Spec has all: input, expected and run.
public struct Spec<I, E, O>: EvaluatableSpec {
  public let run: RunFunction<I, E, O>
  public let input: I
  public let expected: E

  public func evaluate() throws -> O {
    return try run(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - SpecCombinator which moves on
// --------------------------------------------------------------------------------

/// It's called SpecCombinator because why not.
/// This is a Type for using the method `then` in order to combine tests.
public struct SpecCombinator<I> {

  let input: I?

  @discardableResult
  public func then<E, O>(_ breeding: @escaping RunFunction<I, E, O>,
                         is expected: E,
                         line: UInt = #line,
                         file: StaticString = #file) -> SpecCombinator<O> {
    guard let input = input else { return SpecCombinator<O>(input: nil) }
    return expect(input, in: breeding => expected, line: line, file: file)
  }

  @discardableResult
  public func then<E, O>(_ waitingForInput: RunWithExpected<I, E, O>,
                         line: UInt = #line,
                         file: StaticString = #file) -> SpecCombinator<O> {
    guard let input = input else { return SpecCombinator<O>(input: nil) }
    return expect(input, in: waitingForInput.run => waitingForInput.expected, line: line, file: file)
  }
}
