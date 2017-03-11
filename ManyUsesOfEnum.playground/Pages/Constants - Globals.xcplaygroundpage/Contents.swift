/*:

 # Enum can be used as a namespace, until we get an official one!

 */

import UIKit

enum GlobalConstants {

    enum Colors {
        static let title = UIColor.red
        static let body = UIColor.blue
    }

    enum Fonts {
        static let title = UIFont.systemFont(ofSize: 24)
    }
}

let x = GlobalConstants.Colors.title

//: [Previous](@previous) | [Next](@next)
