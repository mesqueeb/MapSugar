import Foundation
import Testing

@testable import MapSugar

@Test func mapKeys() throws {
  let newDictionary = ["a": 1, "b": 2].mapKeys { $0.uppercased() }

  #expect(newDictionary == ["A": 1, "B": 2])
}

@Test func mapValues() throws {
  let newDictionary = ["a": 1, "b": 2].mapValues { value in "\(value)!" }

  #expect(newDictionary == ["a": "1!", "b": "2!"])
}

@Test func mapValuesUsingKeys() throws {
  let newDictionary = ["a": 1, "b": 2].mapValuesUsingKeys { value, key in "\(key)\(value)" }

  #expect(newDictionary == ["a": "a1", "b": "b2"])
}

@Test func mapKeysAndValues() throws {
  let newDictionary = ["a": "x", "b": "y"]
    .mapKeysAndValues { key, value in (key.uppercased(), value.uppercased()) }

  #expect(newDictionary == ["A": "X", "B": "Y"])
}

@Test func mapKeysAsync() async throws {
  let newDictionary = await ["a": 1, "b": 2]
    .mapKeysAsync { key in
      try! await Task.sleep(nanoseconds: 10_000_000)
      return key.uppercased()
    }

  #expect(newDictionary == ["A": 1, "B": 2])
}

@Test func mapValuesAsync() async throws {
  let newDictionary = await ["a": 1, "b": 2]
    .mapValuesAsync { value in
      try! await Task.sleep(nanoseconds: 10_000_000)
      return "\(value)!"
    }

  #expect(newDictionary == ["a": "1!", "b": "2!"])
}

@Test func mapValuesUsingKeysAsync() async throws {
  let newDictionary = await ["a": 1, "b": 2]
    .mapValuesUsingKeysAsync { value, key in
      try! await Task.sleep(nanoseconds: 10_000_000)
      return "\(key)\(value)"
    }

  #expect(newDictionary == ["a": "a1", "b": "b2"])
}

@Test func mapKeysAndValuesAsync() async throws {
  let newDictionary = await ["a": "x", "b": "y"]
    .mapKeysAndValuesAsync { key, value in
      try! await Task.sleep(nanoseconds: 10_000_000)
      return (key.uppercased(), value.uppercased())
    }

  #expect(newDictionary == ["A": "X", "B": "Y"])
}
