import UIKit

public struct Series {
    public let plots: [Double]
    public let colour: UIColor?

    private(set) internal var isEnabled = true

    public init(plots: [Double], colour: UIColor? = nil) {
        self.plots = plots
        self.colour = colour
    }
}

internal extension Series {
    mutating func enable() { isEnabled = true }
    mutating func disable() { isEnabled = false }
}
