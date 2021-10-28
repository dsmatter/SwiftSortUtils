# SwiftSortUtils

[![CI Status](https://img.shields.io/travis/dsmatter/SwiftSortUtils.svg?style=flat)](https://travis-ci.org/dsmatter/SwiftSortUtils.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/SwiftSortUtils.svg?style=flat)](http://cocoapods.org/pods/SwiftSortUtils)
[![License](https://img.shields.io/cocoapods/l/SwiftSortUtils.svg?style=flat)](http://cocoapods.org/pods/SwiftSortUtils)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSortUtils.svg?style=flat)](http://cocoapods.org/pods/SwiftSortUtils)

## Motivation

This library takes a shot at making comparing and sorting in Swift more pleasant. It also allows you to reuse your old `NSSortDescriptor` instances in Swift.

## Examples

```swift
let somePeople: [Person] = ...

// Sort by a comparable attribute
let ... = somePeople.sort(by: compareBy { $0.firstname })
let ... = somePeople.sort(by: compareBy(\.firstname))
let ... = somePeople.sort(by: compareBy(.descending, \.firstname))
let ... = somePeople.sort(byComparing: \.firstname)
let ... = somePeople.sort(byComparing: \.firstname, ordering: .descending)

// Sort by multiple attributes
let ... = somePeople.sort(by:
  compareBy { $0.age } <|>
  compareBy { $0.lastname } <|>
  compareBy(\.firstname)
)
let ... = somePeople.sort(byComparing: [\.age, \.firstname, \.lastname])

// Append any comparator function
let ... = somePeople.sort(
  compareBy { $0.age } <|>
  { (p1, p2) in p1.wearsGlasses() && !p2.wearsGlasses() }
)

// Reverse compare functions
let ... = somePeople.sort(
  compareBy(.descending) { $0.age } <|>
  compareBy { $0.lastname } <|>
  reverseComparator(compareBy(\.firstname)) // reverse any compare function
)

// Use an NSSortDescriptor
let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
let ... = somePeople.sort(ageSortDescriptor.toCompareFunction())

// Even Use multiple NSSortDescriptors
let nameSortDescriptors = [
  NSSortDescriptor(key: "lastname", ascending: true),
  NSSortDescriptor(key: "firstname", ascending: true)
]
let ... = somePeople.sort(nameSortDescriptors.toCompareFunction())
```

See the tests for more examples.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### Swift Version

This Version of SwiftSortUtils is meant to be used with Swift 5.

### CocoaPods

SwiftSortUtils is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftSortUtils"
```

### Manually

Download the files in [`Pod/Classes`](https://github.com/dsmatter/SwiftSortUtils/tree/master/Pod/Classes) and drop them into your project.

## Author

Daniel Strittmatter, daniel@smattr.de

## License

SwiftSortUtils is available under the MIT license. See the LICENSE file for more info.
