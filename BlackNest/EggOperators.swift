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

/// Lift Input with BLNBreeding into BLNWaitingForExpected.
public func | <I, E, O>(rhs: I, lhs: BLNBreeding<I, E, O>) -> BLNWaitingForExpected<I, E, O> {
  return BLNWaitingForExpected(breeding: lhs, input: rhs)
}

/// Lift BLNBreeding and Expected into BLNWaitingForInput.
public func => <I, E, O>(lhs: BLNBreeding<I, E, O>, rhs: E) -> BLNWaitingForInput<I, E, O> {
  return BLNWaitingForInput(breeding: lhs, expected: rhs)
}

/// Lift BLNWaitingForExpected and Expected into Egg
public func => <I, E, O>(lhs: BLNWaitingForExpected<I, E, O>, rhs: E) -> BLNEgg<I, E, O> {
  return BLNEgg(breeding: lhs.breeding, input: lhs.input, expected: rhs)
}

// --------------------------------------------------------------------------------
// MARK: - Combinators - multi line
// --------------------------------------------------------------------------------

func |> <I, E, O, L, R>(lhs: BLNEgg<I, E, O>,
         rhs: BLNCouple<L, R>)
  -> BLNCouple<BLNEgg<I, E, O>, BLNCouple<L, R>> {
  return BLNCouple(left: lhs, right: rhs)
}

func |> <I, E, O, F, P>(lhs: BLNEgg<I, E, O>,
         rhs: BLNWaitingForInput<O, F, P>)
  -> BLNCouple<BLNEgg<I, E, O>, BLNWaitingForInput<O, F, P>> {
    return BLNCouple(left: lhs, right: rhs)
}

func |> <I, E, O, L, R>(lhs: BLNWaitingForInput<I, E, O>,
         rhs: BLNCouple<L, R>)
  -> BLNCouple<BLNWaitingForInput<I, E, O>, BLNCouple<L, R>> {
    return BLNCouple(left: lhs, right: rhs)
}

func |> <I, E, O, F, P>(lhs: BLNWaitingForInput<I, E, O>,
         rhs: BLNWaitingForInput<O, F, P>)
  -> BLNCouple<BLNWaitingForInput<I, E, O>, BLNWaitingForInput<O, F, P>> {
    return BLNCouple(left: lhs, right: rhs)
}

// --------------------------------------------------------------------------------
// MARK: - Combinators - inline
// --------------------------------------------------------------------------------

func ◦ <I, E, O, F, P>(lhs: BLNBreeding<I, E, O>, rhs: BLNBreeding<O, F, P>)
  -> BLNCouple<BLNBreeder<I, E, O>, BLNBreeder<O, F, P>> {
    return BLNCouple(left: BLNBreeder(breeding: lhs), right: BLNBreeder(breeding: rhs))
}

func ◦ <I, E, O, L, R>(lhs: BLNBreeding<I, E, O>, rhs: BLNCouple<L, R>)
  -> BLNCouple<BLNBreeder<I, E, O>, BLNCouple<L, R>> {
    return BLNCouple(left: BLNBreeder(breeding: lhs), right: rhs)
}

func • <L, R>(lhs: L, rhs: R) -> BLNCouple<L, R> {
  return BLNCouple(left: lhs, right: rhs)
}
