/*:

 # Service endpoints also provide an opportunity to use enums

 */
import UIKit

enum NASAApiEndpoint: String {
    case pictureOfTheDay = "planetary/apod"
    case earthImages = "planetary/earth/imagery"
    case marsRoverImages = "mars-photos/api/v1/rovers"

    func url() -> String {
        return "https://api.nasa.gov/\(self.rawValue)?api_key=DEMO_KEY"
    }
}

// This part is great!
let apodURL = NASAApiEndpoint.pictureOfTheDay.url()

// HOLY MOTHER OF FORCED UWRAPPING! Chuthulu is proud.
// Needless to say, don't do this:
let apodData = try? Data(contentsOf: URL(string: apodURL)!)
let apodString = String(data: apodData!, encoding: .utf8)
let parts = apodString?.components(separatedBy: "\"")
let apodImageURL = parts![parts!.count-2]
let apodImageData = try? Data(contentsOf: URL(string: apodImageURL)!)
let apodImage = UIImage(data: apodImageData!)


//: [Previous](@previous) | [Next](@next)
