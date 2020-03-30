import UIKit

internal final class BarPlotView: UIView, Plotable {
    var maxValue: Double = 0 {
        didSet { setNeedsLayout() }
    }
    var minValue: Double = 0 {
        didSet { setNeedsLayout() }
    }
    var spacing: CGFloat {
        get { return barPlotLayer.spacing }
        set { barPlotLayer.spacing = newValue }
    }
    var plots: [Double] = [] {
        didSet { setNeedsLayout() }
    }

    private var barPlotLayer: BarPlotLayer {
        return layer as! BarPlotLayer
    }

    override class var layerClass: AnyClass {
        return BarPlotLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resetLayer()
    }

    private func resetLayer() {
        barPlotLayer.barOrigin = convertPlotToPosition(0)
        barPlotLayer.points = plots.map { convertPlotToPosition($0) }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: barPlotLayer.spacing * CGFloat(plots.count),
                      height: UIView.noIntrinsicMetric)
    }
}

private final class BarPlotLayer: CAShapeLayer {

    fileprivate var points: [CGFloat] = [] {
        didSet {
            setNeedsLayout()
            animatePoints(from: oldValue, to: points)
        }
    }

    fileprivate var barOrigin: CGFloat?

    fileprivate var spacing: CGFloat = DefaultValues.Plots.plotSpacing {
        didSet { drawBars() }
    }

    fileprivate var colour: UIColor = DefaultValues.Bars.barColor {
        didSet { fillColor = colour.cgColor }
    }

    fileprivate var barWidth: CGFloat = DefaultValues.Bars.barWidth {
        didSet { drawBars() }
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        drawBars()
    }

    private func animatePoints(from oldPoints: [CGFloat], to newPoints: [CGFloat]) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = barsPath(for: oldPoints).cgPath
        animation.toValue = barsPath(for: newPoints).cgPath
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
        animation.duration = 1.6
        add(animation, forKey: nil)
    }

    private func drawBars() {
        path = barsPath(for: points).cgPath
    }

    private func barsPath(for points: [CGFloat]) -> UIBezierPath {
        let path = UIBezierPath()
        for (offset, point) in points.enumerated() {
            let startPoint = barOrigin ?? bounds.height // If there is no origin point start from the bottom
            let inset: CGFloat = 2
            let startPointWithInset = point < startPoint ? startPoint - inset : startPoint + inset
            let origin = CGPoint(x: (CGFloat(offset) * spacing) + ((spacing / 2) - (barWidth / 2)), y: point)
            let size = CGSize(width: barWidth, height: startPointWithInset - point)
            let frame = CGRect(origin: origin, size: size)
            path.append(UIBezierPath(rect: frame))
        }
        return path
    }
}
