
import Foundation

/// An interface of a dynamically loadable `xcgrapher` plugin
open class XCGrapherPlugin {

    // The objects produced by the processing functions can be anything and will be returned in the makeArrows(from:) function.
    // Using a generic type here overcomplicates plugin loading and doesn't allow use of multiple types.
    // But, you can imagine the following is true:
    // associatedtype Any

    required public init() { }

    /// Produces a list of graph nodes based on the contents of a source file.
    open func process(file: XCGrapherFile) throws -> [Any] {
        []
    }

    /// Produces a list of graph nodes based on an `import X` line.
    open func process(library: XCGrapherImport) throws -> [Any] {
        []
    }

    /// Produces a list of `XCGrapherArrow` from the results of `process(file:)` and `process(library:)`.
    /// Duplicate `XCGrapherArrow`s will automatically be discarded.
    open func makeArrows(from processResults: [Any]) throws -> [XCGrapherArrow] {
        []
    }

}
