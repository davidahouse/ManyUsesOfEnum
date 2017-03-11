/*:

 # We can nest namespaces as well to provide further clarity.

 */

import UIKit

class MyFancyViewController: UIViewController {

    enum Constants {

        enum Colors {
            static let headerColor = UIColor.red
            static let bodyColor = UIColor.black
        }

        enum Fonts {
            static let headerFont = UIFont.systemFont(ofSize: 24)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let color = Constants.Colors.headerColor
        let font = Constants.Fonts.headerFont
    }
}

//: [Previous](@previous) | [Next](@next)
