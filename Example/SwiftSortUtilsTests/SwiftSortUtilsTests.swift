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
    @objc var firstName: String
    @objc var lastName: String
    
    required init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

class Tests: XCTestCase {
    
    // MARK: Tests
    
    func testCombinedComparatorFunctions() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: compareBy { $0.x } <|> compareBy{ $0.y })
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testCombinedReversedComparatorFunctions() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: compareBy(.descending) { $0.x } <|> compareBy(.descending) { $0.y })
        assertSorted(points: testee, ordering: .descending)
    }
    
    func testCombinedArrayComparator() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: compareBy([{ $0.x }, { $0.y }]))
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testCombinedKeyPaths() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: compareBy([\.x, \.y]))
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testCombinedKeyPathsReversed() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: compareBy(.descending, [\.x, \.y]))
        assertSorted(points: testee, ordering: .descending)
    }
    
    func testTransformerChain() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(by: \.x <|> \.y <|> \.x)
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testMixedSyntax() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(
            by: compareBy(.ascending, \.x) <|> \.y <|> reverseComparator(compareBy(.descending, { $0.x }))
        )
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testSortByComparing() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(byComparing: [\.x, \.y])
        assertSorted(points: testee, ordering: .ascending)
    }
    
    func testSortByComparingReversed() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(byComparing: [\.x, \.y], ordering: .descending)
        assertSorted(points: testee, ordering: .descending)
    }
    
    func testSortByComparingSingle() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(byComparing: \.x)
        XCTAssertEqual(testee, testArray.sorted(by: { $0.x < $1.x }))
    }
    
    func testSortByComparingSingleReversed() {
        let testArray = (0..<1000).map { _ in randomPoint() }
        let testee = testArray.sorted(byComparing: \.y, ordering: .descending)
        XCTAssertEqual(testee, testArray.sorted(by: { $0.y > $1.y }))
    }
    
    func testSortDescriptorCompareFunction() {
        let testArray = (0..<1000).map { _ in randomName() }
        
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
        let sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        let testee = testArray.sorted(by: sortDescriptors.toCompareFunction())
        let expected = (testArray as NSArray).sortedArray(using: sortDescriptors) as! [FullName]
        
        for i in 0..<expected.count {
            let expectedName = expected[i]
            let testeeName = testee[i]
            
            XCTAssert(expectedName.firstName == testeeName.firstName && expectedName.lastName == testeeName.lastName)
        }
    }
    
    // MARK: Assertion
    
    func assertSorted(points: [Point], ordering: Ordering) {
        for i in 1..<points.count {
            let a = points[i - 1]
            let b = points[i]
            
            switch ordering {
            case .ascending:
                XCTAssert(a.x <= b.x)
                if (a.x == b.x) {
                    XCTAssert(a.y <= b.y)
                }
            case .descending:
                XCTAssert(a.x >= b.x)
                if (a.x == b.x) {
                    XCTAssert(a.y >= b.y)
                }
            }
        }
    }
    
    // MARK: Random Generation
    
    func randomPoint() -> Point {
        let x = Int(arc4random_uniform(100))
        let y = Int(arc4random_uniform(100))
        return Point(x: x, y: y)
    }
    
    func randomStringWithLength (_ len : Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
    func randomName() -> FullName {
        let firstName = randomStringWithLength(10)
        let lastName = randomStringWithLength(10)
        
        return FullName(firstName: firstName, lastName: lastName)
    }
    
    
}
