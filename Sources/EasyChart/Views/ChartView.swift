import UIKit

internal class ChartView: UIView {

    internal var maxValue: Double = 0
    internal var minValue: Double = 0

    private lazy var gridView = GridView()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var plotsContainer = PlotsContainerView()

    internal init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubviews()
        constrainSubviews()
    }

    private func addSubviews() {
        addSubview(gridView)
        addSubview(scrollView)
        scrollView.addSubview(plotsContainer)
    }

    private func constrainSubviews() {
        [gridView, scrollView, plotsContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridView.topAnchor.constraint(equalTo: topAnchor),
            gridView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            plotsContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            plotsContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            plotsContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            plotsContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            plotsContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
}

internal extension ChartView {
    func addPlots(for data: Series, type: Chart.PlotType) {
        
    }
}
