//
//  ViewController.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/07.
//  Copyright © 2020 snowman. All rights reserved.
//

import UIKit
import RealmSwift

extension Double {
    
    //degree to radian
    func getRadian() -> CGFloat {
        return CGFloat((self * .pi ) / 180.0)
    }
    
    func getDegree() -> CGFloat {
        return  CGFloat((self * 180) / .pi)
    }
}

class ViewController: UIViewController {
    
    let lineWidth =  20.0
    let fillColor = UIColor.clear // 塗り色
    
    let radius = CGFloat(100.0)
    
    let colorPath = UIBezierPath()
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var circleView: UIView!
    
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
    
    func changeTextFieldValue(_ valueStr: String?, isPlus: Bool) -> String {
        guard let valueStr = valueStr, let value = Double(valueStr) else {
            return "0"
        }
        let unit = 5.0
        var result = 0.0
        
        if isPlus {
            result = value + unit
            if result >= 360.0 { result = 360.0 }
        } else {
            result = value - unit
            if result <= 0.0 { result = 0.0 }
        }
    
        return String(result)
        
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

