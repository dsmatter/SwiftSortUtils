//
//  Sequence+SortedByComparing.swift
//  SwiftSortUtils
//
//  Created by Daniel on 28.10.21.
//

import Foundation

public extension Sequence {
    /**
     Returns the elements of the sequence, sorted using the given transformation function `f`.
     
     Elements are compared by the results of applying the transformation function.
     Calling this method with ascending order is equivalent to: `sorted(by: { f($0) < f($1) })`.
     
     - parameter byComparing: the transformation function
     - parameter ordering: the ordering (ascending or descending)
 
     - returns: a sorted array of the sequence's elements.
     */
    func sorted<C: Comparable>(byComparing f: (Element) -> C, ordering: Ordering = .ascending) -> [Element] {
        // Re-using the `compareBy` function would require an escaping closure.
        switch ordering {
        case .ascending:
            return sorted(by: { f($0) < f($1) })
        case .descending:
            return sorted(by: { f($0) > f($1) })
        }
    }
    
    /**
     Returns the elements of the sequence, sorted using the given transformation functions `fs`.
     
     Elements are compared by applying the transformation functions in descending priority.
     The compare function used for sorting is equivalent to: `compareBy(ordering, fs)`.
     
     - parameter byComparing: the transformation functions
     - parameter ordering: the ordering (ascending or descending)
 
     - returns: a sorted array of the sequence's elements.
     */
    func sorted<C: Comparable>(byComparing fs: [(Element) -> C], ordering: Ordering = .ascending) -> [Element] {
        return sorted(by: compareBy(ordering, fs))
    }
}
