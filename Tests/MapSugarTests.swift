import Foundation
import Testing

@testable import MapSugar

@Test func mapKeys() async throws {
  let newDictionary = ["a": 1, "b": 2].mapKeys { $0.uppercased() }

  #expect(newDictionary == ["A": 1, "B": 2])
}

@Test func mapValuesUsingKeys() async throws {
  let newDictionary = ["a": 1, "b": 2].mapValuesUsingKeys { value, key in "\(key)\(value)" }

  #expect(newDictionary == ["a": "a1", "b": "b2"])
}

@Test func mapKeysAndValues() async throws {
  let newDictionary = ["a": "x", "b": "y"]
    .mapKeysAndValues { key, value in (key.uppercased(), value.uppercased()) }

  #expect(newDictionary == ["A": "X", "B": "Y"])
}
