//
//  Operators.swift
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
precedencegroup BlackNestSpecPrecedence {
  higherThan: ComparisonPrecedence
  lowerThan: AdditionPrecedence
}

precedencegroup BlackNestChainPrecedence {
}

infix operator => : BlackNestSpecPrecedence
infix operator && : BlackNestChainPrecedence
// --------------------------------------------------------------------------------
// MARK: - BlackNestBreeding Operators
// --------------------------------------------------------------------------------

/// Lift Input into BlackNestBreeding and get BlackNestBreeder
public func | <I, E>(rhs: I, lhs: BlackNestBreeding<I, E>) -> BlackNestBreeder<I, E> {
  return BlackNestBreeder(run: lhs, input: rhs)
}

/// Lift Expected into BlackNestBreeder and get BlackNestBox
public func => <I, E>(lhs: BlackNestBreeder<I, E>, rhs: E) -> BlackNestBox<I, E> {
  return BlackNestBox(run: lhs.run, input: lhs.input, expected: rhs)
}
