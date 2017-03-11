/*:

 # Even types we don't own aren't safe from our nesting!

 */
import UIKit

extension UIImage {

    enum Colors {

        static let titleColor = UIColor.darkGray
    }
}

let x = UIImage.Colors.titleColor


//: [Previous](@previous) | [Next](@next)
