/*:

 # We can improve Foundation callbacks too!

 */
import Foundation
import PlaygroundSupport

let x = URLSession(configuration: .default)
let task = x.dataTask(with: URL(string: "www.google.com")!) { (data, response, error) in

    print("response!")
}
task.resume()


enum DataTaskResponseStatus {
    case success(data: Data)
    case error(error: Error)
}

extension URLSession {

    func httpDataTask(with url: URL, completionHandler: @escaping (DataTaskResponseStatus, Int, [AnyHashable: Any] ) -> Swift.Void) -> URLSessionDataTask {

        let task = self.dataTask(with: url) { (data, response, error) in

            guard let response = response as? HTTPURLResponse else {
                fatalError("Only valid for HTTP requests!")
            }

            if let data = data {
                completionHandler(.success(data: data), response.statusCode, response.allHeaderFields)
            } else if let error = error {
                completionHandler(.error(error: error), response.statusCode, response.allHeaderFields)
            } else {
                fatalError("API will return either data or error")
            }
        }
        return task
    }
}


let secondTask = x.httpDataTask(with: URL(string: "http://www.google.com")!) { (status, statusCode, allHeaderFields) in

    switch status {
    case .success(let data):
        print("data: \(data)")
    case .error(let error):
        print("error: \(error)")
    }
    print("statusCode: \(statusCode)")
    print("allHeaderFields: \(allHeaderFields)")
}
secondTask.resume()

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Previous](@previous) | [Next](@next)
