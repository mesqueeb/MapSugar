# MapSugar 🗺️

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmesqueeb%2FMapSugar%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mesqueeb/MapSugar)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmesqueeb%2FMapSugar%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mesqueeb/MapSugar)

```
.package(url: "https://github.com/mesqueeb/MapSugar", from: "0.1.4")
```

Swift helpers to easier map things like `.mapKeys`, `.mapKeysAndValues`, `.mapValuesUsingKeys`

## Examples

.mapKeys

```swift
let newDictionary = ["a": 1, "b": 2]
  .mapKeys { $0.uppercased() }

print(newDictionary) // ["A": 1, "B": 2]
```

.mapValuesUsingKeys

```swift
let newDictionary = ["a": 1, "b": 2].mapValuesUsingKeys { value, key in
  return "\(key)\(value)"
}

print(newDictionary) // ["a": "a1", "b": "b2"]
```

.mapKeysAndValues

```swift
let newDictionary = ["a": "x", "b": "y"].mapKeysAndValues { key, value in
  return (key.uppercased(), value.uppercased())
}

print(newDictionary) // ["A": "X", "B": "Y"]
```

## Documentation

See the [documentation](https://swiftpackageindex.com/mesqueeb/MapSugar/main/documentation/MapSugar/MapSugar) for more info.
