//: [Previous](@previous)

//: Step 1: The initial code we want to enhance. You can tap on the view
//: to create a point, swipe to draw path or clear.

//: This code has some major problems that we want to address.
//: The primary problems are twofold:
//:   1) We have no clear definition of the possible states
//:   2) We have responsibility spaghetti between VC and view

import UIKit
import PlaygroundSupport
import CoreGraphics

class DrawingViewController: UIViewController {
    
    var points: [CGPoint] = []
    var shapeView: ShapeView!
    var showingPoints: Bool = true

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
        
        if showingPoints {
            let point = recognizer.location(in: self.view)
            points.append(point)
            shapeView.points = points
            shapeView.setNeedsDisplay()
        }
    }
    
    func swipeRecognized(recognizer: UISwipeGestureRecognizer) {
        
        if showingPoints {
            let path = CGMutablePath()
            path.addLines(between: points)
            shapeView.path = path
            shapeView.drawPoints = false
            shapeView.drawPath = true
            showingPoints = false
        } else {
            points = []
            shapeView.points = points
            showingPoints = true
            shapeView.drawPoints = true
            shapeView.drawPath = false
        }
        shapeView.setNeedsDisplay()
    }
}

class ShapeView: UIView {

    var points: [CGPoint]?
    var path: CGPath?
    var drawPoints: Bool = true
    var drawPath: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            
            if drawPoints {
                if let points = points {
                    for point in points {
                        context.setFillColor(UIColor.red.cgColor)
                        context.beginPath()
                        context.addArc(center: point, radius: 10.0, startAngle: 0.0, endAngle: 2.0*CGFloat(M_PI), clockwise: true)
                        context.fillPath()
                    }
                }
            } else if drawPath {
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
