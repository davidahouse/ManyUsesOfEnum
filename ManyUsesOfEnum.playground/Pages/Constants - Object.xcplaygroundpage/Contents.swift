/*:

 # Namespaces are good inside objects as well! Don't pollute the global namespace if you can help it.

 */

import UIKit

class MyFancyViewController: UIViewController {

    enum Constants {
        static let rowHeight = 45.0
        static let cellWidth = 125.0
        static let headerColor = UIColor.red
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let color = Constants.headerColor
    }
}

//: [Previous](@previous) | [Next](@next)
