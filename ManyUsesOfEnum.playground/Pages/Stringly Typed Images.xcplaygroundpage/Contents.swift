/*:

 # Using an enum to manage resources identified by strings allows the compiler to help us!

 */
import UIKit

// Images are from here
// https://blackpixel.com/writing/2016/10/introducing-luminance-a-black-pixel-icon-set.html


enum AppConstants {

    enum Assets: String {
        case addIcon = "Add_16.png"
        case addressIcon = "Address_16.png"
        case airplaneIcon = "Airplane_16.png"
        case airplayIcon = "Airplay_16.png"

        // We could chose many options here for how to deal with missing images:
        // 1) Return an optional
        // 2) Throw a preconditionFailure if these assets must be included in the app
        // 3) Return an empty UIImage like below
        func image() -> UIImage {
            return UIImage(named: self.rawValue) ?? UIImage()
        }
    }
}

let add = AppConstants.Assets.addIcon.image()

//: [Previous](@previous) | [Next](@next)
