import UIKit

internal final class PlotsContainerView: UIView {

    internal var maxValue: Double {
        get { plotViews.map { $0.maxValue }.max() ?? 0 }
        set { plotViews.forEach { $0.maxValue = newValue } }
    }
    internal var minValue: Double {
        get { plotViews.map { $0.minValue }.max() ?? 0 }
        set { plotViews.forEach { $0.minValue = newValue } }
    }
    internal var spacing: CGFloat = DefaultValues.Plots.plotSpacing {
        didSet { plotViews.forEach { $0.spacing = spacing } }
    }

    private var plotViews: [PlotView] = []

    internal func insert(plotView: PlotView) {
        plotViews.append(plotView)

        plotView.translatesAutoresizingMaskIntoConstraints = false
//        plotView.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(plotView)

        NSLayoutConstraint.activate([
            plotView.leadingAnchor.constraint(equalTo: leadingAnchor),
            plotView.trailingAnchor.constraint(equalTo: trailingAnchor),
            plotView.topAnchor.constraint(equalTo: topAnchor),
            plotView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    internal func removeAllViews() {
        plotViews.forEach { $0.removeFromSuperview() }
        plotViews.removeAll()
    }

    internal func hideView(at index: Int) {
        guard let view = plotView(at: index) else { return }
        view.isHidden = true
    }

    internal func showView(at index: Int) {
        guard let view = plotView(at: index) else { return }
        view.isHidden = false
    }

    private func plotView(at index: Int) -> PlotView? {
        guard plotViews.indices.contains(index) else { return nil }
        return plotViews[index]
    }
}
