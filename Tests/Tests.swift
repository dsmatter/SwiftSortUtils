//
//  Tests.swift
//  Pods
//
//  Created by Daniel Strittmatter on 06/10/15.
//
//

import Foundation

import UIKit
import XCTest
import SwiftSortUtils

struct Point: Equatable {
  var x: Int
  var y: Int
}

func ==(lhs: Point, rhs: Point) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

class FullName: NSObject {
  var firstName: String
  var lastName: String
  
  required init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

class Tests: XCTestCase {
  
  // MARK: Tests
  
  func testCombinedComparatorFunctions() {
    let testArray = (0..<1000).map { _ in randomPoint() }
    let testee = testArray.sort(sortingBy { $0.x } <|> sortingBy{ $0.y })
    
    for i in 1..<testee.count {
      let a = testee[i - 1]
      let b = testee[i]
      
      XCTAssert(a.x <= b.x)
      if (a.x == b.x) {
        XCTAssert(a.y <= b.y)
      }
    }
  }
  
  func testCombinedReversedComparatorFunctions() {
    let testArray = (0..<1000).map { _ in randomPoint() }
    let testee = testArray.sort(sortingBy(.Descending) { $0.x } <|> sortingBy(.Descending) { $0.y })
    
    for i in 1..<testee.count {
      let a = testee[i - 1]
      let b = testee[i]
      
      XCTAssert(a.x >= b.x)
      if (a.x == b.x) {
        XCTAssert(a.y >= b.y)
      }
    }
  }
  
  func testSortDescriptorCompareFunction() {
    let testArray = (0..<1000).map { _ in randomName() }
    
    let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
    let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
    let sortDescriptors = [sortDescriptor1, sortDescriptor2]
    
    let testee = testArray.sort(sortDescriptors.toCompareFunction())
    let expected = (testArray as NSArray).sortedArrayUsingDescriptors(sortDescriptors)
    
    for i in 0..<expected.count {
      let expectedName = expected[i]
      let testeeName = testee[i]
      
      XCTAssert(expectedName.firstName == testeeName.firstName && expectedName.lastName == testeeName.lastName)
    }
  }
  
  // MARK: Random Generation
  
  func randomPoint() -> Point {
    let x = Int(arc4random_uniform(100))
    let y = Int(arc4random_uniform(100))
    return Point(x: x, y: y)
  }
  
  func randomStringWithLength (len : Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i = 0; i < len; i++){
      let length = UInt32 (letters.length)
      let rand = arc4random_uniform(length)
      randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString as String
  }
  
  func randomName() -> FullName {
    let firstName = randomStringWithLength(10)
    let lastName = randomStringWithLength(10)
    
    return FullName(firstName: firstName, lastName: lastName)
  }
  
  
}