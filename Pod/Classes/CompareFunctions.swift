/**
Combines two compare functions into a new compare function, such that
the first function is used as the first-order comparison and the second
function as second-order comparison.

- parameter f: first-order compare function
- parameter g: second-order compare function

- returns: composed compare function
*/
public func combineCompareFunctions<T>(f: (T, T) -> Bool, g: (T, T) -> Bool) -> ((T, T) -> Bool) {
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
infix operator <|> { associativity left }
public func <|><T>(f: (T, T) -> Bool, g: (T, T) -> Bool) -> ((T, T) -> Bool) {
  return combineCompareFunctions(f, g: g)
}

/**
Generates a compare function (suitable for Swift Arrays' sort methods)
using the provided transformation function f. Elements are sorted by
the result of applying each element to f.

- parameter f: the transformation function

- returns: the generated compare function
*/
public func sortingBy<T, C: Comparable>(f: T -> C) -> ((T, T) -> Bool) {
  return { a, b in
    f(a) < f(b)
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