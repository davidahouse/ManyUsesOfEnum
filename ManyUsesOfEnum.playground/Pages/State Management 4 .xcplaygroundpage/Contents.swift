/*:
 Create a view model from our state so we have proper scope of concerns.
 */
import UIKit
import PlaygroundSupport
import CoreGraphics

enum DrawingState {
    case empty
    case drawPoints([CGPoint])
    case drawPath(CGPath)
    
    mutating func add(point:CGPoint) {
        switch self {
        case .empty:
            self = .drawPoints([point])
        case .drawPoints(var existingPoints):
            existingPoints.append(point)
            self = .drawPoints(existingPoints)
        case .drawPath:
            break
        }
    }
    
    mutating func next() {
        switch self {
        case .empty:
            break
        case .drawPoints(let points):
            let path = CGMutablePath()
            path.addLines(between: points)
            self = .drawPath(path)
            break
        case .drawPath:
            self = .empty
        }
    }
}

class DrawingViewController: UIViewController {
    
    var shapeView: ShapeView!
    var state: DrawingState = .empty {
        didSet {
            shapeView.state = state
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        view.addGestureRecognizer(tapRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized))
        view.addGestureRecognizer(swipeRecognizer)
        
        shapeView = ShapeView(frame: view.frame)
        shapeView.backgroundColor = .clear
        view.addSubview(shapeView)
    }
    
    func tapRecognized(recognizer: UITapGestureRecognizer) {
        
        state.add(point: recognizer.location(in: self.view))
    }
    
    func swipeRecognized(recognizer: UISwipeGestureRecognizer) {
    
        state.next()
    }
}

class ShapeView: UIView {
    
    var state: DrawingState = .empty {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            
            switch state {
                
            case .empty:
                break
            case .drawPoints(let points):
                for point in points {
                    context.setFillColor(UIColor.red.cgColor)
                    context.beginPath()
                    context.addArc(center: point, radius: 10.0, startAngle: 0.0, endAngle: 2.0*CGFloat(M_PI), clockwise: true)
                    context.fillPath()
                }
                break
            case .drawPath(let path):
                context.setStrokeColor(UIColor.green.cgColor)
                context.addPath(path)
                context.strokePath()
                break
            }
            
        }
    }
}

let vc = DrawingViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
vc.view
PlaygroundPage.current.liveView = vc.view

//: [Previous](@previous) | [Next](@next)

