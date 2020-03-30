import UIKit
import EasyChart

class ViewController: UIViewController {

    private var chart: Chart!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        chart = createChart()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        chart = createChart()
    }

    private func createChart() -> Chart {
        // 1. Create a chart.
        let chart = Chart()

        // 2. Create a `Series` object with some data.
        let data: [Double] = [1,102,2,1,2,213,123,4,5,1,213,6,41,1,5,3,1,3,4,5,6,679,23,9,873,2]
        let series = Series(plots: data, colour: .blue)

        // 3. Add the series to the chart.
        chart.append(data: series, type: .bar)

        return chart
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constrainSubviews()
    }

    private func addSubviews() {
        view.addSubview(chart)
    }

    private func constrainSubviews() {
        [chart].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chart.topAnchor.constraint(equalTo: view.topAnchor),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chart.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

