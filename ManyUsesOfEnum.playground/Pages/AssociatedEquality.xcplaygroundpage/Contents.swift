/*:

 # We have to make enums with assocated values equatable ourselves

 */
import Foundation

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

extension NASAImage: Equatable {

    static func == (lhs: NASAImage, rhs: NASAImage) -> Bool {
        switch(lhs, rhs) {
        case (.imageOfTheDay, .imageOfTheDay):
            return true
        case (let .earth(lhs_latitude, lhs_longitude), let .earth(rhs_latitude, rhs_longitude)):
            return (lhs_latitude == rhs_latitude) && (lhs_longitude == rhs_longitude)
        case (let .rover(lhs_rover, lhs_camera, lhs_sol, lhs_frame), let .rover(rhs_rover, rhs_camera, rhs_sol, rhs_frame)):
            return (lhs_rover == rhs_rover) && (lhs_camera == rhs_camera) && (lhs_sol == rhs_sol) && (lhs_frame == rhs_frame)
        default:
            return false
        }
    }
}

let first = NASAImage.imageOfTheDay
let second = NASAImage.imageOfTheDay
let third = NASAImage.earth(latitude: 10.0, longitude: 43.0)
let fourth = NASAImage.earth(latitude: 10.0, longitude: 43.1)
let fifth = NASAImage.rover(rover: .curiosity, camera: .MAHLI, sol: 120, frame: 3)
let sixth = NASAImage.rover(rover: .curiosity, camera: .MAHLI, sol: 120, frame: 3)

let tests = [("first & second", first, second),
             ("first & third", first, third),
             ("third & fourth", third, fourth),
             ("fourth & fifth", fourth, fifth),
             ("fifth & sixth", fifth, sixth)]
tests.forEach {
    print("equal: \($0.0) \($0.1 == $0.2)")
}

//: [Previous](@previous) | [Next](@next)
