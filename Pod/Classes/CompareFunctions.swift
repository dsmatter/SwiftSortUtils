/**
 Combines two compare functions into a new compare function, such that
 the first function is used as the first-order comparison and the second
 function as second-order comparison.
 
 - parameter f: first-order compare function
 - parameter g: second-order compare function
 
 - returns: composed compare function
 */
public func combineCompareFunctions<T>(_ f: @escaping (T, T) -> Bool, _ g: @escaping (T, T) -> Bool) -> ((T, T) -> Bool) {
    return { (a, b) in
        let isLesser = f(a, b)
        if isLesser {
            return true
        }
        
        let isGreater = f(b, a)
        if isGreater {
            return false
        }
        
        return g(a, b)
    }
}

/**
 *  Infix operator for combineCompareFunctions
 */
precedencegroup CompareFunctionCompositionPrecedence {
    lowerThan: AssignmentPrecedence
    associativity: left
}
infix operator <|>: CompareFunctionCompositionPrecedence
public func <|><T>(f: @escaping (T, T) -> Bool, g: @escaping (T, T) -> Bool) -> ((T, T) -> Bool) {
    return combineCompareFunctions(f, g)
}


/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation function `f`.
 
 The resulting compare function compares elements by applying `f` and comparing the results:
 `{ a, b in f(a) < f(b) }`
 
 If the ordering parameter indicates a descending order the resulting
 compare function is reversed.
 
 - parameter ordering: the desired element ordering
 - parameter f: the transformation function
 
 - returns: the generated compare function
 */
public func compareBy<T, C: Comparable>(_ ordering: Ordering, _ f: @escaping (T) -> C) -> ((T, T) -> Bool) {
    switch ordering {
    case .ascending:
        return compareBy(f)
    case .descending:
        return reverseComparator(compareBy(f))
    }
}

/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation function `f`.
 
 The resulting compare function compares elements by applying `f` and comparing the results:
 `{ a, b in f(a) < f(b) }`
 
 - parameter f: the transformation function
 
 - returns: the generated compare function
 */
public func compareBy<T, C: Comparable>(_ f: @escaping (T) -> C) -> ((T, T) -> Bool) {
    return { a, b in f(a) < f(b) }
}

/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation functions fs.
 
 The resulting compare function compares elements using the transformation functions in descending priority.
 
 Example:
 Let fs = [f1, f2, ..., f9]. The resulting compare function is equivalent to: f1 <|> f2 <|> ... <|> f9.
 
 If the ordering parameter indicates a descending order the resulting
 compare function is reversed.
 
 - parameter ordering: the desired element ordering
 - parameter fs: the transformation functions
 
 - returns: the generated compare function
 */
public func compareBy<T, C: Comparable>(_ ordering: Ordering, _ fs: [(T) -> C]) -> ((T, T) -> Bool) {
    return fs.reduce(identityCompareFunction()) { cmp, f in cmp <|> compareBy(ordering, f) }
}

/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation functions fs.
 
 The resulting compare function compares elements using the transformation functions in descending priority.
 
 Example:
 Let fs = [f1, f2, ..., f9]. The resulting compare function is equivalent to: f1 <|> f2 <|> ... <|> f9.
 
 - parameter fs: the transformation functions
 
 - returns: the generated compare function
 */
public func compareBy<T, C: Comparable>(_ fs: [(T) -> C]) -> ((T, T) -> Bool) {
    return fs.reduce(identityCompareFunction()) { cmp, f in cmp <|> compareBy(f) }
}

/**
 Reverses a given compare function.
 
 - parameter f: the compare function
 
 - returns: the reversed compare function
 */
public func reverseComparator<T>(_ f: @escaping (T, T) -> Bool) -> (T, T) -> Bool {
    return { (a, b) in
        f(b, a)
    }
}

/**
 The identity element in the monoid of compare functions.
 It always returns false, i.e. treats all elements as equal.
 
 - returns: the compare function identity
 */
func identityCompareFunction<T>() -> ((T, T) -> Bool) {
    return { a, b in false }
}

public enum Ordering {
    case ascending
    case descending
}

// MARK: - Deprecated Functions

/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation function f.
 Elements are sorted by the result of applying each element to f.
 
 If the ordering parameter indicates a descending order the resulting
 compare function is reversed.
 
 - parameter ordering: the desired element ordering
 - parameter f: the transformation function
 
 - returns: the generated compare function
 */
@available(*, deprecated, renamed: "compareBy")
public func sortingBy<T, C: Comparable>(_ ordering: Ordering, f: @escaping (T) -> C) -> ((T, T) -> Bool) {
    switch ordering {
    case .ascending:
        return sortingBy(f)
    case .descending:
        return reverseComparator(sortingBy(f))
    }
}

/**
 Generates a compare function (suitable for Swift Arrays' sort methods)
 using the provided transformation function f. Elements are sorted by
 the result of applying each element to f.
 
 - parameter f: the transformation function
 
 - returns: the generated compare function
 */
@available(*, deprecated, renamed: "compareBy")
public func sortingBy<T, C: Comparable>(_ f: @escaping (T) -> C) -> ((T, T) -> Bool) {
    return { a, b in
        f(a) < f(b)
    }
}
