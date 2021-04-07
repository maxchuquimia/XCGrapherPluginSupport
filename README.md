#  Creating Custom XCGrapher plugins

Here's how you can use Swift to write a dylib plugin for [xcgrapher](https://github.com/maxchuquimia/xcgrapher).

## Setup

#### Create a Swift Package that exposes the plugin as a dynamic library

```swift
let package = Package(
    name: "MyPlugin",
    products: [
        .library(name: "MyPlugin", type: .dynamic, targets: ["MyPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/maxchuquimia/XCGrapherPluginSupport.git", from: "0.0.5"),
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
#### Subclass XCGrapherPlugin

```swift
import XCGrapherPluginSupport

class MyPlugin: XCGrapherPlugin {
    
}
```

#### Create a function that XCGrapher can call to create an instance of your plugin
This uses the `@_cdecl` attribute to force the compiler to use the symbol name `makeXCGrapherPlugin`. This snippet needs to be copied somewhere in your library with only `MyPlugin` changed to the name of your  `XCGrapherPlugin` subclass.
```swift
@_cdecl("makeXCGrapherPlugin")
public func makeXCGrapherPlugin() -> UnsafeMutableRawPointer {
    Unmanaged.passRetained(MyPlugin()).toOpaque()
}
```
## Drawing Arrows

Override functions in the subclass - TODO: add mooore info


## Building and running

Build your plugin from the command line:
```bash
swift build -c release --disable-sandbox
```
This will create your dylib at the path `.build/release/libMyPlugin.dylib`

Now you can run `xcgrapher` with the `--plugin` option and tell it to use your newly built dylib to process each file!

```bash
xcgrapher --project .. --target .. --spm .. --plugin .build/release/libMyPlugin.dylib
```
