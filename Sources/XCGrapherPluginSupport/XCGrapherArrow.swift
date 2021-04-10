
import Foundation

/// Defines a GraphViz "edge" (arrow) in the output graph.
public struct XCGrapherArrow: Hashable {

    /// The name of the graph node that the arrow should originate from.
    public let origin: String

    /// The name of the graph node that the arrow should point to.
    public let destination: String

    /// The color of the arrow, e.g. `#FF0000`
    public let color: String

    public init(origin: String, destination: String, color: String = "#000000") {
        self.origin = origin
        self.destination = destination
        self.color = color
    }

}
