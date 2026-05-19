# some

<!--
 * SPDX-FileCopyrightText: 2026 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: 0BSD
-->


Swift **so**urce **me**rger command plugin. Useful to create a complete source to work with LLM.

## usage

Add dependency to your Package.swift

```swift
let Package = Package(
  // ...
  dependencies: [
    .package(url: "https://github.com/bastie/some.git", from: "1.0.0"), // swift package some
  ],
  // ...
)
```

Use Swift package manager with command `some` to create a single source code file.

```bash
swift package some [clean|usage]
```


