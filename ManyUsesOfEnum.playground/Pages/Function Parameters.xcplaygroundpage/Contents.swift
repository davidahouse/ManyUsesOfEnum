/*:

 # We can use enums to provide clarity to our function parameters

 */
import Foundation

// Instead of this:
func configureOriginal(data: Data, fromCache: Bool) {

    if fromCache {
        // ...
    } else {
        // ...
    }
}

// Do this!:

// Now we know what the other case is other than fromCache
enum DataSource {
    case cache
    case server
}

func configure(data: Data, source: DataSource) {

    // Switch gives us a safer way to handle the cases since the compiler
    // will remind us to deal with any new case we add to the source enum
    switch source {
    case .cache:
        break
    case .server:
        break
    }
}

//: [Previous](@previous) | [Next](@next)
