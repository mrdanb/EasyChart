import UIKit

internal final class LinePlotView: UIView, Plotable {
    var maxValue: Double = 0 {
        didSet { setNeedsLayout() }
    }
    var minValue: Double = 0 {
        didSet { setNeedsLayout() }
    }
    var spacing: CGFloat {
        get { return lineLayer.spacing }
        set { lineLayer.spacing = newValue }
    }
    var plots: [Double] = [] {
        didSet{ setNeedsLayout() }
    }

    override class var layerClass: AnyClass {
        return LinePlotLayer.self
    }

    private var lineLayer: LinePlotLayer {
        return layer as! LinePlotLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resetLayer()
    }

    private func resetLayer() {
        lineLayer.points = plots.map { convertPlotToPosition($0) }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: lineLayer.spacing * CGFloat(plots.count),
                      height: UIView.noIntrinsicMetric)
    }
}

private final class LinePlotLayer: CALayer {

    private lazy var pointsLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()

    private lazy var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.fillColor = nil
        layer.lineWidth = DefaultValues.Line.lineWidth
        return layer
    }()

    fileprivate var points: [CGFloat] = [] {
        didSet {
            setNeedsLayout()
            if oldValue != points {
                animatePoints(from: oldValue, to: points)
            }
        }
    }

    fileprivate var colour: UIColor = DefaultValues.Line.lineColour {
        didSet {
            pointsLayer.strokeColor = colour.cgColor
            lineLayer.strokeColor = colour.cgColor
        }
    }

    fileprivate var spacing: CGFloat = DefaultValues.Plots.plotSpacing {
        didSet { redraw() }
    }

    fileprivate var pointSize: CGFloat = DefaultValues.Line.pointSize {
        didSet { redraw() }
    }

    override init() {
        super.init()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSublayer(lineLayer)
        addSublayer(pointsLayer)
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        pointsLayer.frame = bounds
        lineLayer.frame = bounds
    }
    
    private func animatePoints(from oldPoints: [CGFloat], to newPoints: [CGFloat]) {
        let time: CFTimeInterval = 0.6
        let curve = CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)

        let pointsAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        pointsAnimation.fromValue = pointsLayer.presentation()?.path ?? pointsPath(for: oldPoints).cgPath
        pointsAnimation.toValue = pointsPath(for: points).cgPath
        pointsAnimation.timingFunction = curve
        pointsAnimation.duration = time
        pointsLayer.add(pointsAnimation, forKey: nil)

        let lineAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        lineAnimation.fromValue = lineLayer.presentation()?.path ?? linePath(for: oldPoints).cgPath
        lineAnimation.toValue = linePath(for: points).cgPath
        lineAnimation.timingFunction = curve
        lineAnimation.duration = time
        lineLayer.add(pointsAnimation, forKey: nil)
    }

    private func redraw() {
        drawPoints()
        drawLine()
    }

    private func drawPoints() {
        pointsLayer.path = pointsPath(for: points).cgPath
    }

    private func drawLine() {
        lineLayer.path = linePath(for: points).cgPath
    }

    private func pointsPath(for points: [CGFloat]) -> UIBezierPath {
        let path = UIBezierPath()
        for (offset, point) in points.enumerated() {
            let origin = CGPoint(x: (CGFloat(offset) * spacing) + ((spacing / 2) - (pointSize / 2)),
                                 y: point - (pointSize / 2))
            let size = CGSize(width: pointSize, height: pointSize)
            let frame = CGRect(origin: origin, size: size)
            path.append(UIBezierPath(roundedRect: frame, cornerRadius: pointSize / 2))
        }
        return path
    }

    private func linePath(for points: [CGFloat]) -> UIBezierPath {
        let path = UIBezierPath()
        guard let firstPoint = points.first else { return path }
        path.move(to: CGPoint(x: spacing / 2, y: firstPoint))
        for (offset, yPos) in points.enumerated() {
            guard offset > 0 else { continue }
            let point = CGPoint(x: (CGFloat(offset) * spacing) + (spacing / 2), y: yPos)
            path.addLine(to: point)
        }
        return path
    }
}
