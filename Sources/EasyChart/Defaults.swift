import UIKit

internal struct DefaultValues {

    internal struct Plots {
        internal static let plotSpacing: CGFloat = 100
    }

    internal struct Bars {
        internal static let barColor: UIColor = .black
        internal static let barWidth: CGFloat = 10
    }

    internal struct Line {
        internal static let lineColour: UIColor = .black
        internal static let pointSize: CGFloat = 4
        internal static let lineWidth: CGFloat = 2
    }

    internal struct Axis {
        internal static let divisions: Int = 4
        internal static let lineThickness: CGFloat = 0.7
        internal static let lineColour: UIColor = .gray
    }
}
