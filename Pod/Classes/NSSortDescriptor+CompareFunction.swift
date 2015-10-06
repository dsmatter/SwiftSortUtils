//
//  NSSortDescriptor+CompareFunction.swift
//  Pods
//
//  Created by Daniel Strittmatter on 06/10/15.
//
//

import Foundation

public extension NSSortDescriptor {
  
  /**
  Generates a compare function (suitable for Swift Arrays' sort methods)
  from a NSSortDescriptor.
  
  - returns: the generate compare function
  */
  func toCompareFunction<T: AnyObject>() -> ((T, T) -> Bool) {
    return { (a, b) in
      self.compareObject(a, toObject: b) == NSComparisonResult.OrderedAscending
    }
  }
  
}

public extension SequenceType where Self.Generator.Element == NSSortDescriptor {
  
  /**
  Generates a compare function (suitable for Swift Arrays' sort methods)
  from a list of NSSortDescriptors
  
  - returns: the generated compare function
  */
  func toCompareFunction<T: AnyObject>() -> ((T, T) -> Bool) {
    let compareFunctions: [(T, T) -> Bool] = map { a in a.toCompareFunction() }
    return compareFunctions.reduce(identityCompareFunction(), combine: combineCompareFunctions)
  }
  
}
