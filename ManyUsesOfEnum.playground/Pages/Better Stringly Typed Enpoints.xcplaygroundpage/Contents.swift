/*:

 # We can go beyond worrying about fixing stringly typed endpoints
 
 Instead think about using the enum to describe all possible
 endpoints.

 */

import UIKit
import PlaygroundSupport

// One way to think about using enums is to consicely describe a certain kind of thing. In this case
// we can create an enum to describe all the possible images we can get from NASA.

// Note for some cases, we need additional information to correctly describe them

enum NASAImage {
    case imageOfTheDay
    case earth(latitude: Float, longitude: Float)
    case rover(rover: NASARover, camera: NASARoverCamera, sol: Int, frame: Int)
}

enum NASARover: String {
    case curiosity
    case opportunity
    case spirit
}

enum NASARoverCamera: String {
    case FHAZ
    case RHAZ
    case MAST
    case CHEMCAM
    case MAHLI
    case MARDI
    case NAVCAM
    case PANCAM
    case MINITES
}

enum NASAApiEndpoint: String {
    case pictureOfTheDay = "planetary/apod"
    case earthImages = "planetary/earth/imagery"
    case marsRoverImages = "mars-photos/api/v1/rovers"

    func url(params: [String: String]) -> URL? {
        var queryParams = ""
        for (key, value) in params {
            queryParams += "&\(key)=\(value)"
        }
        return URL(string: "https://api.nasa.gov/\(self.rawValue)?api_key=DEMO_KEY\(queryParams)")
    }
}

extension NASAImage {

    func imageURL(completion: @escaping (URL?) -> Void) {

        // Compute the URL based on the enum values
        let endpointURL: URL? = {

            switch self {
            case .imageOfTheDay:
                return NASAApiEndpoint.pictureOfTheDay.url(params: [:])
            default: break
            }
            return nil
        }()

        // If we have no URL, just exit
        guard let imageEndpointURL = endpointURL else {
            completion(nil)
            return
        }

        // Make a service call to get the details
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let serviceTask = session.dataTask(with: imageEndpointURL) { (rawData, response, error) in

            // Parse the results
            do {
                if let data = rawData {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                        print(json)
                        if let urlString = json["url"] as? String, let url = URL(string: urlString) {
                            print(url)
                            completion(url)
                            return
                        }
                    }
                }
                completion(nil)
            } catch {
                completion(nil)
            }
        }
        serviceTask.resume()
    }
}

extension UIImageView {

    static func downloadNASAImage(image: NASAImage, completion: @escaping (UIImage) -> Void) {

        // Figure out the URL for the image we want to use
        image.imageURL { imageURL in
            if let url = imageURL {
                // Download the image and call the completion handler
                if let apodImageData = try? Data(contentsOf: url), let image = UIImage(data: apodImageData) {
                    image
                    completion(image)
                    return
                }
            }
            completion(UIImage())
        }
    }
}

let image1: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 960,height: 474))
PlaygroundPage.current.liveView = image1
UIImageView.downloadNASAImage(image: .imageOfTheDay) { downloadedImage in

    image1.image = downloadedImage
    image1.setNeedsDisplay()
}

PlaygroundPage.current.needsIndefiniteExecution = true









//: [Previous](@previous) | [Next](@next)
