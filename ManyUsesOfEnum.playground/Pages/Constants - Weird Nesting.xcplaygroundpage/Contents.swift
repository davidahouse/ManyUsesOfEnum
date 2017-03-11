/*:

 # You can nest namespaces as well, but things get weird...

 # This is not a great pattern so be careful when nesting not to get to complex.
 */

import Foundation

enum TopThing {
    
    case first
    case second
    case third
    
    struct InnerThingData {
        let dataX: String
        let dataY: String
    }
    
    enum InnerThing {
        
        case inner1(InnerThingData)
        case inner2
        case inner3
    }
}

let x = TopThing.first
// Guess what the type of y is here below?
let y = TopThing.InnerThing.inner1
// Hint, it is a function!
let y2 = y(TopThing.InnerThingData(dataX: "111", dataY: "222"))
let y1 = TopThing.InnerThing.inner1(TopThing.InnerThingData(dataX: "123", dataY: "456"))
let z = TopThing.InnerThing.inner3

//: [Previous](@previous) | [Next](@next)
