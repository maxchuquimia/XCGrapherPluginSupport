
import Foundation

/// Describes a source file from the main project target or from an SPM package.
public struct XCGrapherFile {

    /// The origin of the file.
    public enum Origin {
        /// The file originated from the main --target of the xcgrapher executable.
        case target(name: String)

        /// The file came from the Swift Package module called `importName`.
        case spm(importName: String)
    }

    /// The name of the file, e.g. `General.swift`.
    public let filename: String

    /// The full path to the file.
    public let filepath: String

    /// The string contents of the file.
    public let fileContents: String

    /// The origin of the file.
    public let origin: Origin

    public init(filename: String, filepath: String, fileContents: String, origin: Origin) {
        self.filename = filename
        self.filepath = filepath
        self.fileContents = fileContents
        self.origin = origin
    }

}
