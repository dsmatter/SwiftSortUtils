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
using the provided transformation function f.
Elements are sorted by the result of applying each element to f.
 
If the ordering parameter indicates a descending order the resulting
compare function is reversed.

- parameter ordering: the desired element ordering
- parameter f: the transformation function

- returns: the generated compare function
*/
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
public func sortingBy<T, C: Comparable>(_ f: @escaping (T) -> C) -> ((T, T) -> Bool) {
  return { a, b in
    f(a) < f(b)
  }
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
