import UIKit

internal protocol Plotable: AnyObject {
    var maxValue: Double { get set }
    var minValue: Double { get set }
    var spacing: CGFloat { get set }
    var plots: [Double] { get set }
}

internal extension Plotable where Self: UIView {

    func convertPlotToPosition(_ plot: Double) -> CGFloat {
        guard plot > minValue else { return bounds.height }
        guard plot < maxValue else { return 0 }

        let dataMap = Map(lower: CGFloat(minValue), upper: CGFloat(maxValue))
        let viewMap = Map(lower: CGFloat(bounds.minY), upper: CGFloat(bounds.maxY))
        let mapper = self.mapper(from: dataMap, to: viewMap)

        return bounds.height - mapper(CGFloat(plot))
    }

    private func mapper(from start: Map, to end: Map) -> (CGFloat) -> (CGFloat) {
        let rise = end.upper - end.lower
        let run = start.upper - start.lower
        let slope = rise / run
        let intercept = end.lower - start.lower * slope
        return { slope * $0 + intercept }
    }
}

internal extension Plotable where Self: UIView {

    func visiblePlots(in rect: CGRect) -> [Double] {
        return plots.enumerated().filter { offset, plot in
            let x = CGFloat(offset) * spacing + (spacing / 2)
            let y = convertPlotToPosition(plot)
            return rect.contains(CGPoint(x: x, y: y))
        }.map { $0.element }
    }
}

private struct Map {
    let lower: CGFloat
    let upper: CGFloat
}
