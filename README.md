#  Creating Custom XCGrapher plugins

⚠️⚠️ Work In Progress! ⚠️⚠️

```swift
let package = Package(
    name: "MyPlugin",
    products: [
        .library(name: "MyPlugin", type: .dynamic, targets: ["MyPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/maxchuquimia/XCGrapherPluginSupport.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "MyPlugin", 
            dependencies: [
                .product(name: "XCGrapherPluginSupport", package: "xcgrapher")
            ]
        ),
    ]
)
```

```swift
import XCGrapherPluginSupport

class MyPlugin: XCGrapherPlugin {

    // Conform to XCGrapherPlugin
    
}
```

Somewhere in your library, 
```swift
import XCGrapherPluginSupport

@_cdecl("createXCGrapherPlugin")
public func createXCGrapherPlugin() -> UnsafeMutableRawPointer {
    Unmanaged.passRetained(MyPluginBuilder()).toOpaque()
}

final class MyPluginBuilder: XCGrapherPluginBuilder {

    override func build() -> XCGrapherPlugin {
        MyPlugin()
    }
    
}
```

Build your plugin
```bash
swift build -c release --disable-sandbox
```

Run `xcgrapher` and use your plugin

```
xcgrapher --project .. --target .. --spm .. --plugin /path/to/libMyPlugin.dylib # Find the path inside the .build/release directory 
```
