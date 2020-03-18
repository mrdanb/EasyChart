//

import UIKit

internal class GridView: UIView {

    override class var layerClass: AnyClass {
        return GridLayer.self
    }

    private var gridLayer: GridLayer {
        return layer as! GridLayer
    }
}

private class GridLayer: CAShapeLayer {

    fileprivate var divisions: Int = DefaultValues.Axis.divisions {
        didSet { setNeedsLayout() }
    }

    fileprivate var lineThickness: CGFloat = DefaultValues.Axis.lineThickness {
        didSet { lineWidth = lineThickness }
    }

    fileprivate var lineColour: UIColor = DefaultValues.Axis.lineColour {
        didSet { strokeColor = lineColour.cgColor }
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        drawLines()
    }

    private func drawLines() {
        path = pathForLines().cgPath
        lineDashPattern = [2, 2]
        lineWidth = lineThickness
        strokeColor = lineColour.cgColor
        fillColor = nil
    }

    private func pathForLines() -> UIBezierPath {
        let path = UIBezierPath()
        for position in linePositions() {
            path.move(to: CGPoint(x: 0, y: position))
            path.move(to: CGPoint(x: bounds.width, y: position))
        }
        return path
    }

    private func linePositions() -> [CGFloat] {
        let spacing = bounds.height / CGFloat(divisions)
        return (0...divisions).map { spacing * CGFloat($0) }
    }
}
