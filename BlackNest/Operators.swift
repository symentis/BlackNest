//
//  specRunOperators.swift
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
// MARK: - BlackNest Operators
// --------------------------------------------------------------------------------

/// In order to make `==` evaluate after `=>`
/// we increase the Precedence of the `=>` operator
precedencegroup SpecCreatingPrecedence {
  higherThan: ComparisonPrecedence, CombinableWaitingPrecedence
  lowerThan: AdditionPrecedence
}

/// In order to make `•` and `•´ evaluate after `=>`
/// we decrease the Precedence of those operators.
/// Associativity is right, as we build up the recursive type.
precedencegroup CombinablePrecedence {
  higherThan: SpecCreatingPrecedence
  associativity: right
}

/// Associativity is right, as we build up the recursive type.
precedencegroup CombinableWaitingPrecedence {
  associativity: right
}

infix operator => : SpecCreatingPrecedence
infix operator •  : CombinablePrecedence
infix operator ◦  : CombinablePrecedence
infix operator |~ : CombinableWaitingPrecedence

prefix operator ...|
