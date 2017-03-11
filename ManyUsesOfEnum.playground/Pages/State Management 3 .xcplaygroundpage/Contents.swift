/*:
 Use associated values to enhance our enum to contain the data that is valid
 at each step.
 */
import UIKit
import PlaygroundSupport
import CoreGraphics

enum DrawingState {
    case empty
    case drawPoints([CGPoint])
    case drawPath(CGPath)
}

class DrawingViewController: UIViewController {
    
    var shapeView: ShapeView!
    
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
        
        let point = recognizer.location(in: self.view)
        switch shapeView.state {
        case .empty:
            shapeView.state = .drawPoints([point])
        case .drawPoints(var points):
            points.append(point)
            shapeView.state = .drawPoints(points)
        case .drawPath:
            break
        }
        shapeView.setNeedsDisplay()
    }
    
    func swipeRecognized(recognizer: UISwipeGestureRecognizer) {
        
        switch shapeView.state {
        case .empty:
            break
        case .drawPoints(let points):
            let path = CGMutablePath()
            path.addLines(between: points)
            shapeView.state = .drawPath(path)
        case .drawPath:
            shapeView.state = .empty
        }
        shapeView.setNeedsDisplay()
    }
}

class ShapeView: UIView {
    
    var state: DrawingState = .empty
    
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

