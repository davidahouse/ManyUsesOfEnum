/*:
 Create an enum to describe the 3 states, then use that to
 clear up the view state.
 */
import UIKit
import PlaygroundSupport
import CoreGraphics

enum DrawingState {
    case empty
    case drawPoints
    case drawPath
}

class DrawingViewController: UIViewController {
    
    var points: [CGPoint] = []
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
        if shapeView.state == .drawPoints {
            points.append(point)
        } else if shapeView.state == .empty {
            points = [point]
            shapeView.state = .drawPoints
        }
        shapeView.points = points
        shapeView.setNeedsDisplay()
    }
    
    func swipeRecognized(recognizer: UISwipeGestureRecognizer) {
        
        if shapeView.state == .drawPoints {
            shapeView.state = .drawPath
            let path = CGMutablePath()
            path.addLines(between: points)
            shapeView.path = path
        } else if shapeView.state == .drawPath {
            shapeView.state = .empty
        }
        
        points = []
        shapeView.points = points
        shapeView.setNeedsDisplay()
    }
}

class ShapeView: UIView {
    
    var points: [CGPoint]?
    var path: CGPath?
    var state: DrawingState = .drawPoints
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            
            switch state {
                
            case .empty:
                break
            case .drawPoints:
                if let points = points {
                    for point in points {
                        context.setFillColor(UIColor.red.cgColor)
                        context.beginPath()
                        context.addArc(center: point, radius: 10.0, startAngle: 0.0, endAngle: 2.0*CGFloat(M_PI), clockwise: true)
                        context.fillPath()
                    }
                }
                
            case .drawPath:
                if let path = path {
                    context.setStrokeColor(UIColor.green.cgColor)
                    context.addPath(path)
                    context.strokePath()
                }

            }

        }
    }
}

let vc = DrawingViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
vc.view
PlaygroundPage.current.liveView = vc.view

//: [Previous](@previous) | [Next](@next)

