//
//  Egg.swift
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
// MARK: - Hatchable
// --------------------------------------------------------------------------------

/// Build on top of BLNBreedable.
/// This protocol wraps `BLNBreeding`, `input` and `expected`.
/// Breeding starts by calling `breed`
public protocol BLNHatchable: BLNBreedable {
  var input: I { get }
  var expected: E { get }
  func breed() throws -> O
}

// --------------------------------------------------------------------------------
// MARK: - Egg a.k.a Hatchable
//
// This has everything. The input, the expected, the breeding.
// We can start to breed!
// --------------------------------------------------------------------------------

/// Egg
/// A egg has all: input, expected and breeding.
/// Let's hope it does not get a crack.
public struct BLNEgg<I, E, O>: BLNHatchable {
  public let breeding: BLNBreeding<I, E, O>
  public let input: I
  public let expected: E

  public func breed() throws -> O {
    return try breeding(input, expected)
  }
}

// --------------------------------------------------------------------------------
// MARK: - FreeRangeEgg which moves on
// --------------------------------------------------------------------------------

/// It's called FreeRangeEgg because why not.
/// This is a Type for using the method `then` in order to combine tests.
/// So the egg is moving... kinda. you know?
public struct BLNFreeRangeEgg<I> {
  let input: I?

  @discardableResult
  public func then<E, O>(_ breeding: @escaping BLNBreeding<I, E, O>,
                         is expected: E,
                         line: UInt = #line,
                         file: StaticString = #file) -> BLNFreeRangeEgg<O> {
    guard let input = input else { return BLNFreeRangeEgg<O>(input: nil) }
    return expect(input, in: breeding => expected, line: line, file: file)
  }

  @discardableResult
  public func then<E, O>(_ breeder: BLNWaitingForInput<I, E, O>,
                         line: UInt = #line,
                         file: StaticString = #file) -> BLNFreeRangeEgg<O> {
    guard let input = input else { return BLNFreeRangeEgg<O>(input: nil) }
    return expect(input, in: breeder.breeding => breeder.expected, line: line, file: file)
  }
}
