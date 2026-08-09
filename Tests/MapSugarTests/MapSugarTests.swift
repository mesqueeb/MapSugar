import Foundation
import Testing

@testable import MapSugar

@Test func mapKeys() throws {
  let newDictionary = ["a": 1, "b": 2].mapKeys { $0.uppercased() }

  #expect(newDictionary == ["A": 1, "B": 2])
}

@Test func mapKeysRethrows() {
  enum TestError: Error { case bad }

  #expect(throws: TestError.bad) { _ = try ["a": 1].mapKeys { _ -> String in throw TestError.bad } }
}

@Test func mapValues() throws {
  let newDictionary = ["a": 1, "b": 2].mapValues { value in "\(value)!" }

  #expect(newDictionary == ["a": "1!", "b": "2!"])
}

@Test func mapValuesUsingKeys() throws {
  let newDictionary = ["a": 1, "b": 2].mapValuesUsingKeys { value, key in "\(key)\(value)" }

  #expect(newDictionary == ["a": "a1", "b": "b2"])
}

@Test func mapValuesUsingKeysRethrows() {
  enum TestError: Error { case bad }

  #expect(throws: TestError.bad) {
    _ = try ["a": 1].mapValuesUsingKeys { _, _ -> String in throw TestError.bad }
  }
}

@Test func mapKeysAndValues() throws {
  let newDictionary = ["a": "x", "b": "y"]
    .mapKeysAndValues { key, value in (key.uppercased(), value.uppercased()) }

  #expect(newDictionary == ["A": "X", "B": "Y"])
}

@Test func mapKeysAndValuesRethrows() {
  enum TestError: Error { case bad }

  #expect(throws: TestError.bad) {
    _ = try ["a": "x"].mapKeysAndValues { _, _ -> (String, String) in throw TestError.bad }
  }
}

@Test func mapKeysAsync() async throws {
  let newDictionary = await ["a": 1, "b": 2]
    .mapKeysAsync { key in
      try! await Task.sleep(nanoseconds: 10_000_000)
      return key.uppercased()
    }

  #expect(newDictionary == ["A": 1, "B": 2])
}

@Test func mapKeysAsyncRethrows() async {
  enum TestError: Error { case bad }

  await #expect(throws: TestError.bad) {
    _ = try await ["a": 1].mapKeysAsync { _ -> String in throw TestError.bad }
  }
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
