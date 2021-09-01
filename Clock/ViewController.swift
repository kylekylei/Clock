//
//  ViewController.swift
//  Clock
//
//  Created by Kyle Lei on 2021/8/29.
//

import UIKit

extension CGFloat {
    var degree: CGFloat {
        self * CGFloat.pi / 180
    }
}

class ViewController: UIViewController {
      
    @IBOutlet var shadowStatus: UISwitch! {
        didSet{
            shadowStatus.onTintColor = UIColor.orange
        }
    }
    @IBOutlet var sliderIndex: UISegmentedControl!{
        didSet{
            sliderIndex.selectedSegmentTintColor = UIColor.white
            sliderIndex.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        }
    }
    @IBOutlet var radiusSlider: UISlider! {
        didSet{
            radiusSlider.tintColor = UIColor.orange
            radiusSlider.maximumValue = 166
            radiusSlider.minimumValue = 24
            radiusSlider.value = 100
        }
    }
    var timer = Timer()
    
    let center = CGPoint(x: UIScreen.main.bounds.width/2, y: 300)
    let lightBlue: UIColor = UIColor(red: 222/255, green: 235/255, blue: 255/255, alpha: 1)
    var lableBgPath = UIBezierPath()
    let lableBgShape = CAShapeLayer()
    var lableRadius: CGFloat = 166
    var textAlphaLayer = CALayer()
    var textNumberLayer  = CALayer()
    let radius:CGFloat = 150 // pinter
    
    func circleString(center: CGPoint,
                      radius: CGFloat,
                      startAngle: CGFloat,
                      offsetAngle: CGFloat,
                      color: UIColor,
                      fontSize: CGFloat,
                      rotate: Bool,
                      lable: Array<String>
                      ) -> CALayer {
        
        let layer = CALayer()
        layer.frame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        
        for (index, text) in lable.enumerated() {
            
            let currentAngle: CGFloat = startAngle + (CGFloat(index + 1) * offsetAngle)
            let textLayer = CATextLayer()
            
            let x: CGFloat = radius * cos(currentAngle.degree) + radius - CGFloat(fontSize / 2)
            let y: CGFloat = radius * sin(currentAngle.degree) + radius - CGFloat(fontSize / 2)
            textLayer.frame = CGRect(x: x, y: y, width: fontSize + 6, height: fontSize)

            textLayer.fontSize = fontSize
            textLayer.foregroundColor = color.cgColor
            textLayer.alignmentMode = .center
            textLayer.string = String(text)
            
            if rotate == true {
                var transform = CATransform3DIdentity
                transform.m34 = -1 / 100
                textLayer.transform = CATransform3DRotate(transform, currentAngle.degree - (3 * CGFloat.pi / 2), 0, 0, 1)
            }
            
            layer.addSublayer(textLayer)
        }
        return layer
    }
    
    func time(format: String) -> Int {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let time = Int( formatter.string(from: now) )
     return time!
    }
    func shadowEffect(_ layer: CALayer, shadowOn: Bool) {
        if shadowOn {
            layer.shadowOffset = CGSize(width: 0, height: 8)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 16
            layer.shadowOpacity = 0.38
        }
    }
    let hour = Pointer()
    let minute = Pointer()
    let second = Pointer()
    let dot = Pointer()
    
    
    @objc func timeChange() {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        let bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        
        //---------------------- Hour Popinter ----------------------
        
        hour.angle = CGFloat( time(format: "HH") % 12 * 30 + time(format: "mm") / 12 * 6 )
        hour.path.move(to: CGPoint(x: radius, y: radius + hour.pointerTailingLength))
        hour.path.addLine(to: CGPoint(x: radius, y: radius - hour.pointerLeadingLength ))
        hour.shape.path = hour.path.cgPath
        hour.lineShape(lineWidth: 6,color: UIColor.darkGray)
        hour.shadow(true)
        
        hour.view.frame = frame
        hour.view.bounds = bounds
              
        hour.view.layer.addSublayer(hour.shape)
        hour.view.transform = CGAffineTransform.identity.rotated(by: hour.angle.degree)
        view.addSubview(hour.view)
        //---------------------- Second Popinter ----------------------
        
        minute.angle = CGFloat( time(format: "mm") * 6)
        minute.pointerLeadingLength = 120
        minute.path.move(to: CGPoint(x: radius, y: radius + minute.pointerTailingLength))
        minute.path.addLine(to: CGPoint(x: radius, y: radius - minute.pointerLeadingLength ))
        minute.shape.path = minute.path.cgPath
        minute.lineShape(lineWidth: 3,color: UIColor.darkGray)
        minute.shadow(true)
        
        minute.view.frame = frame
        minute.view.bounds = bounds
        
        minute.view.layer.addSublayer(minute.shape)
        minute.view.transform = CGAffineTransform.identity.rotated(by: minute.angle.degree)
        view.addSubview(minute.view)
        
        //---------------------- Second Popinter ----------------------
        second.angle = CGFloat( time(format: "ss") * 6)
        second.pointerLeadingLength = 150
        second.pointerTailingLength = 20
        second.path.move(to: CGPoint(x: radius, y: radius + second.pointerTailingLength))
        second.path.addLine(to: CGPoint(x: radius, y: radius - second.pointerLeadingLength ))
        second.shape.path = second.path.cgPath
        second.lineShape(lineWidth:2,color: UIColor.orange)
        second.shadow(true)
        
        dot.path.addArc(withCenter: CGPoint(x: radius, y: radius ), radius: 8, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        dot.shape.path = dot.path.cgPath
        dot.shape.fillColor = UIColor.orange.cgColor
        second.view.layer.addSublayer(dot.shape)
        
        second.view.frame = frame
        second.view.bounds = bounds
        second.view.layer.addSublayer(second.shape)
      
        second.view.transform = CGAffineTransform.identity.rotated(by: second.angle.degree)
        
        view.addSubview(second.view)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
        
       
        //---------------------- TimeBG ----------------------

        lableBgPath = UIBezierPath(roundedRect: CGRect(x: center.x - lableRadius, y: center.y - lableRadius, width: lableRadius * 2, height: lableRadius * 2), cornerRadius: 100)
        lableBgShape.path = lableBgPath.cgPath
        lableBgShape.fillColor = lightBlue.cgColor
        lableBgShape.shadowOffset = CGSize(width: 0, height: 8)
        lableBgShape.shadowColor = UIColor.black.cgColor
        lableBgShape.shadowRadius = 16
        lableBgShape.shadowOpacity = 0.2
                
        view.layer.addSublayer(lableBgShape)
        
                
        //---------------------- TimeLable ----------------------
              
        textAlphaLayer = circleString(center: center, radius: 140, startAngle: 270, offsetAngle: 30, color: UIColor.darkGray, fontSize: 30, rotate: true, lable:  ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"])
        view.layer.addSublayer(textAlphaLayer)
        textNumberLayer = circleString(center: center, radius: 140, startAngle: 270, offsetAngle: 30, color: UIColor.darkGray, fontSize: 32, rotate: false, lable:  ["1","2","3","4","5","6","7","8","9","10","11","12"])
        view.layer.addSublayer(textNumberLayer)
        textNumberLayer.isHidden = true
    
        view.backgroundColor = lightBlue
  }

    
    @IBAction func switchLable(_ sender: UISegmentedControl) {
        if sliderIndex.selectedSegmentIndex == 1 {
            textNumberLayer.isHidden = false
            textAlphaLayer.isHidden = true
            
        } else if sliderIndex.selectedSegmentIndex == 0 {
            textNumberLayer.isHidden = true
            textAlphaLayer.isHidden = false
        }
    }
    @IBAction func switchShadow(_ sender: UISwitch) {
        if sender.isOn {
            lableBgShape.shadowOpacity = 0.2
        } else if !sender.isOn {
            lableBgShape.shadowOpacity = 0
        }
    }
    @IBAction func changeRadius(_ sender: UISlider) {
        lableBgPath = UIBezierPath(roundedRect: CGRect(x: center.x - lableRadius, y: center.y - lableRadius, width: lableRadius * 2, height: lableRadius * 2), cornerRadius: CGFloat(radiusSlider.value))
        lableBgShape.path = lableBgPath.cgPath
    }
    
}
