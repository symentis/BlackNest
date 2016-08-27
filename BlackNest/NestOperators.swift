//
//  NestOperators.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
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

import Foundation

// --------------------------------------------------------------------------------
// MARK: - BlackNest Operators
// --------------------------------------------------------------------------------

/// in order to make `==` evaluate after `?>`
/// we reduce the Precedence of the Blacknest operator
precedencegroup BLNSpecPrecedence {
  higherThan: ComparisonPrecedence, BLNBreedChainPrecedence
  lowerThan: AdditionPrecedence
}

precedencegroup BLNBreedPrecedence {
  higherThan: BLNSpecPrecedence
  associativity: right
}

precedencegroup BLNBreedChainPrecedence {
  associativity: right
}


infix operator => : BLNSpecPrecedence
infix operator • : BLNBreedPrecedence
infix operator ◦ : BLNBreedPrecedence
infix operator |> : BLNBreedChainPrecedence

// --------------------------------------------------------------------------------
// MARK: - BLNBreeding Operators
// --------------------------------------------------------------------------------

/// Lift Input into BLNBreeding and get BLNBreeder
public func | <I, E, O>(rhs: I, lhs: BLNBreeding<I, E, O>) -> BLNBreederInput<I, E, O> {
  return BLNBreederInput(breeding: lhs, input: rhs)
}

/// Lift BLNBreeding and E into BLNBreederExpected
public func => <I, E, O>(lhs: BLNBreeding<I, E, O>, rhs: E) -> BLNBreederExpected<I, E, O> {
  return BLNBreederExpected(breeding: lhs, expected: rhs)
}

/// Lift Expected into BLNBreeder and get BLNNest
public func => <I, E, O>(lhs: BLNBreederInput<I, E, O>, rhs: E) -> BLNNest<I, E, O> {
  return BLNNest(breeding: lhs.breeding, input: lhs.input, expected: rhs)
}

func ◦ <I, E, O, J, P>(lhs: @escaping (I, E) throws -> O, rhs: @escaping (O, J) throws -> P)
  -> BLNTree<BLNBreeder<I, E, O>, BLNBreeder<O, J, P>> {
    return BLNTree(left: BLNBreeder(breeding: lhs), right: BLNBreeder(breeding: rhs))
}

func ◦ <I, E, O, L, R>(lhs: @escaping (I, E) throws -> O, rhs: BLNTree<L, R>)
  -> BLNTree<BLNBreeder<I, E, O>, BLNTree<L, R>> {
    return BLNTree(left: BLNBreeder(breeding: lhs), right: rhs)
}

func • <L, R>(lhs: L, rhs: R) -> BLNTree<L, R> {
  return BLNTree(left: lhs, right: rhs)
}

func |> <I, E, O, L, R>(lhs: BLNNest<I, E, O>, rhs: BLNTree<L, R>) ->
  BLNTree<BLNNest<I, E, O>, BLNTree<L, R>> {
  return BLNTree(left: lhs, right: rhs)
}

func |> <I, E, O, F, P>(lhs: BLNNest<I, E, O>, rhs: BLNBreederExpected<O, F, P>) ->
  BLNTree<BLNNest<I, E, O>, BLNBreederExpected<O, F, P>> {
    return BLNTree(left: lhs, right: rhs)
}

func |> <I, E, O, L, R>(lhs: BLNBreederExpected<I, E, O>, rhs: BLNTree<L, R>) ->
  BLNTree<BLNBreederExpected<I, E, O>, BLNTree<L, R>> {
    return BLNTree(left: lhs, right: rhs)
}

func |> <I, E, O, F, P>(lhs: BLNBreederExpected<I, E, O>, rhs: BLNBreederExpected<O, F, P>) ->
  BLNTree<BLNBreederExpected<I, E, O>, BLNBreederExpected<O, F, P>> {
    return BLNTree(left: lhs, right: rhs)
}
