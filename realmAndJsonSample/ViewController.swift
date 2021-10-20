//
//  ViewController.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/07.
//  Copyright © 2020 snowman. All rights reserved.
//

import UIKit
import RealmSwift

enum EvaluateError: Error {
    case isEmpty
    case isNotValidEmailAddress
    case isNotValidEmailLength
}

extension Double {
    
    //degree to radian
    func getRadian() -> CGFloat {
        return CGFloat(self * (.pi / 180.0))
    }
    
    func getDegree() -> CGFloat {
        return  CGFloat(self * (180.0 / .pi))
    }
}

class ViewController: UIViewController {
    
    let lineWidth =  20.0
    let fillColor = UIColor.clear // 塗り色
    
    let radius = CGFloat(100.0)
    
    let colorPath = UIBezierPath()
    
    var touchStart =  CGPoint(x: 0.0, y: 0.0)
    var touchEnd =  CGPoint(x: 0.0, y: 0.0)
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let startDegree = 0.0
        let endDegree = 270.0
        
        startTextField.text = String(startDegree)
        endTextField.text = String(endDegree)
        
        startTextField.delegate = self
        endTextField.delegate = self
        
        drawCirclesCustom(startDegree: String(startDegree), endDegree: String(endDegree))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func addTabGesture() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchAction))
        circleView.addGestureRecognizer(touchGesture)
    }
    
    @objc func touchAction(_ sender: UITapGestureRecognizer) {
        print("\(#function) start ")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: circleView)
            if (location.x != touchStart.x && location.y != touchStart.y ) {
                touchStart =  CGPoint(x:location.x , y: location.y)
                print("\(#function) \(touchStart.debugDescription) ")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            
            let location = touch.location(in: circleView)
            if (location.x != touchEnd.x && location.y != touchEnd.y ) {
                touchEnd =  CGPoint(x:location.x , y: location.y)
                print("\(#function) \(touchEnd.debugDescription) ")
            }
        }
       _ =  calcDegreeFromTouchLocation()
    }
    
    func calcDegreeFromTouchLocation() -> CGFloat {
        
        print("\(#function) start:\(touchStart.debugDescription) , end: \(touchEnd.debugDescription) ")
        
        let  diffX = abs(touchStart.x - touchEnd.x)
        let  diffY = abs(touchStart.y - touchEnd.y)
        let radians = Double(atan2(diffX, diffY))
        let degree = radians.getDegree()
        
        print("\(#function) radians = \(radians) ,degree = \(degree)")
        return degree
    }
    
    func drawCirclesBase() {
        //let grayColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0) // 線の色
        
        
        let startBaseDegree = 0.0
        let endBaseDegree = 360.0
        
        let startBaseAngle = startBaseDegree.getRadian()
        let endBaseAngle = endBaseDegree.getRadian()
        drawCircleColor(color: UIColor.yellow, start: startBaseAngle, end: endBaseAngle)
        
    }
    
    func refreshCircle() {
        colorPath.removeAllPoints()
        circleView.layer.sublayers?.removeAll()
        
        drawCirclesCustom(startDegree: startTextField.text, endDegree: endTextField.text )
    }
    
    func drawCirclesCustom(startDegree: String?,
                           endDegree: String? ) {
        
        guard let startDegree = startDegree, let endDegree = endDegree else {
            return
        }
        drawCirclesCustom(color: UIColor.green,
                          startDegree: startDegree,
                          endDegree: endDegree)
        
//        let blueColor = UIColor(red: 0.33, green: 0.44, blue: 0.98, alpha: 0.7) // 線の色
        
//        let startBlueAngle = CGFloat(.pi * 0.0)
//        let endBlueAngle = CGFloat(.pi * 1.5)
//
//        drawCirclesCustom(color: blueColor,
//                          startGreenAngle: startBlueAngle,
//                          endGreenAngle: endBlueAngle)
    
    }
    
    func drawCirclesCustom(color: UIColor,
                               startGreenAngle: CGFloat,
                               endGreenAngle: CGFloat ) {
            
        print("\(#function) startGreenAngle= \(startGreenAngle),endGreenAngle=\(endGreenAngle)")
        
        drawCircleColor(color: color, start: startGreenAngle, end: endGreenAngle)
            
    }
    
    
    func drawCirclesCustom(color: UIColor,
                           startDegree: String?,
                           endDegree: String? ) {
        
        guard let startDegree = startDegree, let endDegree = endDegree else {
            return
        }
    
        let startGreenAngle = Double(startDegree)!.getRadian()
        let endGreenAngle = Double(endDegree)!.getRadian()
        
        print("\(#function) startGreenAngle= \(startGreenAngle),endGreenAngle=\(endGreenAngle)")
        
        drawCircleColor(color: color, start: startGreenAngle, end: endGreenAngle)
        
    }
    
    func drawCircleColor(color: UIColor,
                         start startAngle: CGFloat,
                         end endAngle: CGFloat) {
        
        
        let radius = CGFloat(100.0)
        let lineWidth =  20.0
        let fillColor = UIColor.clear // 塗り色
        
        
        //let startAngle = CGFloat(0.0)
        //let endAngle = CGFloat(.pi * 2.0)
       
        colorPath.addArc(withCenter: getCenterPoint(circleView), // 中心
            radius: radius, // 半径
            startAngle: startAngle, // 開始角度
            endAngle: endAngle, // 終了角度
            clockwise: true) // 時計回り
        
        drawCircleColor(baseView: circleView,
                        colorPath: colorPath,
                        fillColor: fillColor,
                        strokeColor: color,
                        lineWidth: CGFloat(lineWidth))
        
    }
    
    
    func getCenterPoint(_ baseView: UIView) -> CGPoint  {
        let kCenterPos = CGFloat(150.0)
        return CGPoint(x: (baseView.frame.size.width / 2.0) , y: kCenterPos)
    }
    
    func drawCircleColor(baseView: UIView,
                         colorPath: UIBezierPath,
                         fillColor: UIColor,
                         strokeColor: UIColor,
                         lineWidth: CGFloat ) {
        
        
        let colorLayer = CAShapeLayer()
        colorLayer.path = colorPath.cgPath
        colorLayer.fillColor = fillColor.cgColor // 塗り色
        colorLayer.strokeColor = strokeColor.cgColor
        colorLayer.lineWidth = lineWidth // 線の幅
        baseView.layer.addSublayer(colorLayer)
        
    }
    
    @IBAction func touchedStartPlus(_ button: UIButton) {
        
        startTextField.text = changeTextFieldValue(startTextField.text, isPlus: true)
        refreshCircle()
    }
    
    @IBAction func touchedEndPlus(_ button: UIButton) {
        endTextField.text = changeTextFieldValue(endTextField.text, isPlus: true)
        refreshCircle()
    }
    
    @IBAction func touchedStartMinus(_ button: UIButton) {
        startTextField.text = changeTextFieldValue(startTextField.text, isPlus: false)
        refreshCircle()
    }
    
    @IBAction func touchedEndMinus(_ button: UIButton) {
        endTextField.text = changeTextFieldValue(endTextField.text, isPlus: false)
        refreshCircle()
    }
    
    @IBAction func touchedImagePicker(_ button: UIButton) {
        //self.imageVc =  ImagePickerViewController()
        //imageVc.delegate = self
        //self.present(imageVc, animated: true, completion: nil)
        
    }
    
    func changeTextFieldValue(_ valueStr: String?, isPlus: Bool) -> String {
        guard let valueStr = valueStr, let value = Double(valueStr) else {
            return "0"
        }
        let unit = 5.0
        var result = 0.0
        
        if isPlus {
            result = min(value + unit, 360.0)
        } else {
            result = max(value - unit, 0.0)
        }
    
        return String(result)
    }

}

extension ViewController {
    
    func checkInputValidation(string: String) -> Bool {
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
        
//        if isValid(input: string,
//                   regEx: emailRegEx,
//                   predicateFormat: "SELF MATCHES[c] %@") == false {
//            throw EvaluateError.isNotValidEmailAddress
//        }
        
        if maxLength(emailAddress: string) == false {
            throw EvaluateError.isNotValidEmailLength
        }
    }
    
    private func maxLength(emailAddress: String) -> Bool {
        // 64 chars before domain and total 80. '@' key is part of the domain.
        guard emailAddress.count <= 80 else {
            return false
        }

        guard let domainKey = emailAddress.firstIndex(of: "@") else { return false }

        return emailAddress[..<domainKey].count <= 64
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing\n")
        
        drawCirclesCustom(startDegree: startTextField.text, endDegree: endTextField.text )
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn before responder\n")
        textField.resignFirstResponder()
        print("textFieldShouldReturn\n")
        return true
    }
}

