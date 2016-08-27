//
//  Nest.swift
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
// MARK: - BLNBreeding
// --------------------------------------------------------------------------------

/// Typealias for a breeding function.
public typealias BLNBreeding<I, E, O> = (I, E) throws -> O

// --------------------------------------------------------------------------------
// MARK: - BLNBreedable
// --------------------------------------------------------------------------------

public protocol BLNBreedable {
  associatedtype I
  associatedtype E
  associatedtype O
  var breeding: (I, E) throws -> O { get }
}

public protocol BLNBreedableExpected: BLNBreedable {
  var expected: E { get }
  func breed(_ input: I) throws -> O
}

public struct BLNBreeder<I, E, O>: BLNBreedable {
  public let breeding: BLNBreeding<I, E, O>
}

public struct BLNBreederInput<I, E, O>: BLNBreedable {
  public let breeding: BLNBreeding<I, E, O>
  let input: I
}

public struct BLNBreederExpected<I, E, O>: BLNBreedableExpected {
  public let breeding: BLNBreeding<I, E, O>
  public let expected: E

  public func breed(_ input: I) throws -> O {
    return try breeding(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - Nest
// --------------------------------------------------------------------------------

public protocol BLNHatchable: BLNBreedable {
  var input: I { get }
  var expected: E { get }
  func breed() throws -> O
}

/// BLNNest
public struct BLNNest<I, E, O>: BLNHatchable {
  public let breeding: BLNBreeding<I, E, O>
  public let input: I
  public let expected: E

  public func breed() throws -> O {
    return try breeding(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - Branch
// --------------------------------------------------------------------------------

public struct BLNBranch<I> {
  let input: I?

  @discardableResult
  public func then<E, O>(_ breeding: BLNBreeding<I, E, O>,
                   is expected: E,
                   line: UInt = #line,
                   file: StaticString = #file) -> BLNBranch<O> {
    guard let input = input else { return BLNBranch<O>(input: nil) }
    return expect(input, in: breeding => expected, line: line, file: file)
  }

  @discardableResult
  public func then<E, O>(_ breeder: BLNBreederExpected<I, E, O>,
                   line: UInt = #line,
                   file: StaticString = #file) -> BLNBranch<O> {
    guard let input = input else { return BLNBranch<O>(input: nil) }
    return expect(input, in: breeder.breeding => breeder.expected, line: line, file: file)
  }
}

// --------------------------------------------------------------------------------
// MARK: - BLNBranchable
// --------------------------------------------------------------------------------

public protocol BLNBranchable {
  associatedtype L
  associatedtype R

  var left: L { get }
  var right: R { get }
}

// --------------------------------------------------------------------------------
// MARK: - Tree
// --------------------------------------------------------------------------------

public struct BLNTree<A, B>: BLNBranchable {
  public let left: A
  public let right: B
}
