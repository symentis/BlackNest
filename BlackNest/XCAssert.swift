//
//  XCAssert.swift
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


private func lookAt<I, E, O>(_ nest: BLNNest<I, E, O>,
                    line: UInt,
                    file: StaticString) -> O? {
  do {
    let moveOn = try nest.breed()
    return moveOn
  } catch let error {
    XCTAssert(false, "\(error)", file: file, line: line)
  }
  return nil
}

// --------------------------------------------------------------------------------
// MARK: - Input first?
// --------------------------------------------------------------------------------

/// Expect takes a BLNNest and checks for error
///
///     expect(12 | doubleTuple => (12, 24))
///
/// - parameter run: BLNNest
/// - returns: Void
@discardableResult
public func expect<I, E, O>(_ nest: BLNNest<I, E, O>,
            line: UInt = #line,
            file: StaticString = #file) -> BLNBranch<O> {
  return BLNBranch(input: lookAt(nest, line:line, file: file))
}

/// Expect takes a BLNNest and checks for error
///
///     expect(when: 12, then: doubleTuple => (12, 24))
///
/// - parameter run: BLNNest
/// - returns: Void
@discardableResult
public func expect<I, E, O>(_ input: I,
                   in breeder: BLNBreederExpected<I, E, O>,
                   line: UInt = #line,
                   file: StaticString = #file) -> BLNBranch<O> {
  let nest = input | breeder.breeding => breeder.expected
  return BLNBranch(input: lookAt(nest, line:line, file: file))
}

/// Expect takes a BLNNest and checks for error
///
///     expect(12, in:doubleTuple, is:(12, 24))
///
/// - parameter run: BLNNest
/// - returns: Void
@discardableResult
public func expect<I, E, O>(_ input: I,
                   in breeding: BLNBreeding<I, E, O>,
                   is expected: E,
                   line: UInt = #line,
                   file: StaticString = #file) -> BLNBranch<O> {
  let nest = input | breeding => expected
  return BLNBranch(input: lookAt(nest, line:line, file: file))
}


// --------------------------------------------------------------------------------
// MARK: - Breeding first?
// --------------------------------------------------------------------------------

/// Expect takes a BLNNest and checks for error
///
///     expect(doubleTuple, at:12, is:(12, 24))
///
/// - parameter run: BLNNest
/// - returns: Void
public func expect<I, E, O>(_ breeding: BLNBreeding<I, E, O>,
            at input: I,
            is expected: E,
            line: UInt = #line,
            file: StaticString = #file) -> BLNBranch<O> {
  let nest = input | breeding => expected
  return BLNBranch(input: lookAt(nest, line:line, file: file))
}
