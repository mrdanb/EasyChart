import UIKit

open class Chart: UIView {

    public enum PlotType: CaseIterable {
        case line, bar
    }

    private var series: [Series] = []

    private lazy var chartView: ChartView = {
        let view = ChartView()
        return view
    }()

    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }

    public func append(data: Series, type: PlotType) {
        series.append(data)
//        chartView.addPlots()
        recalculateAxisValues()
    }

    public func hideData(at index: Int) {
        guard series.indices.contains(index) else { return }
        series[index].disable()
        recalculateAxisValues()
    }

    public func showData(at index: Int) {
        guard series.indices.contains(index) else { return }
        series[index].enable()
        recalculateAxisValues()
    }
}

// MARK: - Setup
private extension Chart {

    func setup() {
        addSubviews()
        constraintSubviews()
    }

    func addSubviews() {
        addSubview(chartView)
    }

    func constraintSubviews() {
        [chartView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Axis calculation
private extension Chart {

    func recalculateAxisValues() {
        let visbilePlots = series.filter { $0.isEnabled }.flatMap { $0.plots }

        let maxVisiblePlot = visbilePlots.max() ?? 0
        let minVisiblePlot = visbilePlots.min() ?? 0

        let step = stepFor(largestValue: Double.maximum(abs(maxVisiblePlot), abs(minVisiblePlot)))

        var maxAxis: Double
        var minAxis: Double

        if minVisiblePlot < 0 && maxVisiblePlot > 0 {
            // 1. Round the min and max plots to the nearest step away from zero
            let upper = maxVisiblePlot.round(to: step, rule: .awayFromZero)
            let lower = minVisiblePlot.round(to: step, rule: .awayFromZero)
            // 2. Determine which valye is the furthest away from zero. This will be the end of the y-axis
            let furthestAwayFromZero = Double.maximum(abs(upper), abs(lower))
            // 3. Multiply by -1 to get the inverse so the oppisite axis matches
            maxAxis = Double.maximum(furthestAwayFromZero, furthestAwayFromZero * -1)
            minAxis = Double.minimum(furthestAwayFromZero, furthestAwayFromZero * -1)
        } else {
            maxAxis = Double.maximum(maxVisiblePlot, 0).round(to: step, rule: .awayFromZero)
            minAxis = Double.minimum(minVisiblePlot, 0).round(to: step, rule: .awayFromZero)
        }

        // TODO: Guard against NaN?
        chartView.maxValue = maxAxis
        chartView.minValue = minAxis
    }

    func stepFor(largestValue: Double) -> Double {
        guard largestValue.isZero == false else { return 0 }
        var offset: Double = 1
        while(largestValue > offset) {
            offset = offset * 10
        }
        return offset * 0.5
    }
}

private extension Double {
    func round(to factor: Double, rule: FloatingPointRoundingRule) -> Double {
        return factor * (self / factor).rounded(rule)
    }
}
