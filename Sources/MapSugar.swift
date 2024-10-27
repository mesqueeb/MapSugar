import Foundation

/// Functions that make mapping dictionaries easier
extension Dictionary {
  /// Helper method to map keys of a dictionary!
  ///
  /// Returns a new dictionary containing the keys and values of this dictionary with the
  /// keys transformed by the given closure.
  ///
  /// - Parameters:
  ///     - transform: A closure that transforms a key. `transform`
  ///       accepts each key of the dictionary as its parameter and returns a
  ///       transformed key of the same or of a different type.
  /// - Returns: A dictionary containing the transformed keys and values of this dictionary.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = ["a": 1, "b": 2]
  ///   .mapKeys { $0.uppercased() }
  ///
  /// print(newDictionary) // ["A": 1, "B": 2]
  /// ```
  @inlinable public func mapKeys<K: Hashable>(_ transform: (Key) -> K) -> [K: Value] {
    return self.reduce(into: [K: Value]()) { result, pair in
      let (key, value) = pair
      result[transform(key)] = value
    }
  }

  /// Helper method to map values of a dictionary!
  /// The difference with `mapValues` being you also get the key in the closure.
  ///
  /// Returns a new dictionary containing the keys of this dictionary with the
  /// values transformed by the given closure.
  ///
  /// - Parameters:
  ///     - transform: A closure that transforms a value. `transform`
  ///       accepts each value of the dictionary as its parameter and returns a
  ///       transformed value of the same or of a different type.
  /// - Returns: A dictionary containing the keys and transformed values of this dictionary.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = ["a": 1, "b": 2].mapValuesUsingKeys { value, key in
  ///   return "\(key)\(value)"
  /// }
  ///
  /// print(newDictionary) // ["a": "a1", "b": "b2"]
  /// ```
  @inlinable public func mapValuesUsingKeys<T>(_ transform: (Value, Key) -> T) -> [Key: T] {
    return self.reduce(into: [Key: T]()) { result, pair in
      let (key, value) = pair
      result[key] = transform(value, key)
    }
  }

  /// Helper method to map both values and keys of a dictionary at the same time!
  ///
  /// Returns a new dictionary containing the keys and values of this dictionary
  /// transformed by the given closure.
  ///
  /// - Parameters:
  ///     - transform: A closure that transforms a key and value. `transform`
  ///       accepts each key and value of the dictionary as its parameter and returns a
  ///       transformed key and value of the same or of a different type.
  /// - Returns: A dictionary containing the transformed keys and values of this dictionary.
  ///
  /// - Complexity: O(*n*), where *n* is the length of the dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = ["a": "x", "b": "y"].mapKeysAndValues { key, value in
  ///   return (key.uppercased(), value.uppercased())
  /// }
  ///
  /// print(newDictionary) // ["A": "X", "B": "Y"]
  /// ```
  @inlinable public func mapKeysAndValues<K: Hashable, V>(
    _ transform: (Key, Value) -> (K, V)
  ) -> [K: V] {
    return self.reduce(into: [K: V]()) { result, pair in
      let (newKey, newValue) = transform(pair.key, pair.value)
      result[newKey] = newValue
    }
  }
}

/// Functions that make mapping dictionaries asynchronously easier (providing async closures)
extension Dictionary {
  /// Helper method to map keys of a dictionary asynchronously!
  ///
  /// Returns a new dictionary containing the keys and values of this dictionary with the
  /// keys transformed by the given async closure.
  ///
  /// - Parameters:
  ///     - transform: An async closure that transforms a key. `transform`
  ///       accepts each key of the dictionary as its parameter and returns a
  ///       transformed key of the same or of a different type.
  /// - Returns: A dictionary containing the transformed keys and values of this dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = await ["a": 1, "b": 2].mapKeysAsync { key in
  ///   try! await Task.sleep(for: .milliseconds(100))
  ///   return key.uppercased()
  /// }
  /// print(newDictionary) // ["A": 1, "B": 2]
  /// ```
  @inlinable public func mapKeysAsync<K>(
    _ transform: @Sendable @escaping (Key) async -> K
  ) async -> [K: Value] where K: Hashable & Sendable, Key: Sendable, Value: Sendable {
    return await withTaskGroup(of: (K, Value).self) { group in
      for (key, value) in self { group.addTask { (await transform(key), value) } }
      return await group.reduce(into: [K: Value]()) { result, pair in result[pair.0] = pair.1 }
    }
  }

  /// Helper method to map values of a dictionary asynchronously!
  /// The difference with `mapValuesAsync` being you also get the key in the closure.
  ///
  /// - Parameters:
  ///     - transform: An async closure that transforms a value. `transform`
  ///       accepts each value of the dictionary as its parameter and returns a
  ///       transformed value of the same or of a different type.
  /// - Returns: A dictionary containing the transformed keys and values of this dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = await ["a": 1, "b": 2].mapValuesUsingKeysAsync { value, key in
  ///   try! await Task.sleep(for: .milliseconds(100))
  ///   return "\(key)\(value)"
  /// }
  /// print(newDictionary) // ["a": "a1", "b": "b2"]
  /// ```
  @inlinable public func mapValuesUsingKeysAsync<V>(
    _ transform: @Sendable @escaping (Value, Key) async -> V
  ) async -> [Key: V] where Key: Sendable, Value: Sendable, V: Sendable {
    return await withTaskGroup(of: (Key, V).self) { group in
      for (key, value) in self { group.addTask { (key, await transform(value, key)) } }
      return await group.reduce(into: [Key: V]()) { result, pair in result[pair.0] = pair.1 }
    }
  }

  /// Helper method to map both values and keys of a dictionary asynchronously!
  ///
  /// - Parameters:
  ///     - transform: An async closure that transforms a key and value. `transform`
  ///       accepts each key and value of the dictionary as its parameter and returns a
  ///       transformed key and value of the same or of a different type.
  /// - Returns: A dictionary containing the transformed keys and values of this dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = await ["a": "x", "b": "y"].mapKeysAndValuesAsync { key, value in
  ///   try! await Task.sleep(for: .milliseconds(100))
  ///   return (key.uppercased(), value.uppercased())
  /// }
  /// print(newDictionary) // ["A": "X", "B": "Y"]
  /// ```
  @inlinable public func mapKeysAndValuesAsync<K, V>(
    _ transform: @Sendable @escaping (Key, Value) async -> (K, V)
  ) async -> [K: V] where K: Hashable & Sendable, V: Sendable, Key: Sendable, Value: Sendable {
    return await withTaskGroup(of: (K, V).self) { group in
      for (key, value) in self { group.addTask { await transform(key, value) } }
      return await group.reduce(into: [K: V]()) { result, pair in result[pair.0] = pair.1 }
    }
  }

  /// Helper method to map values of a dictionary asynchronously!
  ///
  /// - Parameters:
  ///     - transform: An async closure that transforms a value. `transform`
  ///       accepts each value of the dictionary as its parameter and returns a
  ///       transformed value of the same or of a different type.
  /// - Returns: A dictionary containing the keys and transformed values of this dictionary.
  ///
  /// Usage Example:
  /// ```swift
  /// let newDictionary = await ["a": 1, "b": 2].mapValuesAsync { value in
  ///   try! await Task.sleep(for: .milliseconds(100))
  ///   return "\(value)!"
  /// }
  /// print(newDictionary) // ["a": "1!", "b": "2!"]
  /// ```
  @inlinable public func mapValuesAsync<V>(
    _ transform: @Sendable @escaping (Value) async -> V
  ) async -> [Key: V] where V: Sendable, Key: Sendable, Value: Sendable {
    return await withTaskGroup(of: (Key, V).self) { group in
      for (key, value) in self { group.addTask { (key, await transform(value)) } }
      return await group.reduce(into: [Key: V]()) { result, pair in result[pair.0] = pair.1 }
    }
  }
}
