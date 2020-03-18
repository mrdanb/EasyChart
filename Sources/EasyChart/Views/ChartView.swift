import UIKit

internal class ChartView: UIView {

    internal var maxValue: Double = 0
    internal var minValue: Double = 0

    private lazy var gridView = GridView()

    internal init() {
        super.init(frame: .zero)
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
    }

    private func constrainSubviews() {
        [gridView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridView.topAnchor.constraint(equalTo: topAnchor),
            gridView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
