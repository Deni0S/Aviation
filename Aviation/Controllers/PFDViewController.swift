//
//  PFDViewController.swift
//  Aviation
//
//  Created by Денис Баринов on 18/08/2019.
//  Copyright © 2019 Денис Баринов. All rights reserved.
//

import UIKit

class PFDViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var speedIndicatorSmall: UILabel!
    @IBOutlet weak var speedRuler: UIImageView!
    @IBOutlet weak var speedRulerUIView: UIView!
    @IBOutlet weak var skyline: UIImageView!
    @IBOutlet weak var SpeedIndicatorPicker: UIPickerView!
    
    var timeAnimation: Double = 10
    var centerOfActionView = CGPoint()
    var speed: [String] = ["0","9","8","7","6","5","4","3","2","1","0","9"]
    //["0","1", "2","3","4","5","6","7","8","9","0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpeedIndicatorPicker.delegate = self
        SpeedIndicatorPicker.dataSource = self
        speedRulerAction()
        speedIndicator()
        SpeedIndicatorPickerView()
    }

    // Движение линейки спидометра
    func speedRulerAction() {
        centerOfActionView = self.speedRulerUIView.center
        UIView.animate(withDuration: TimeInterval(self.timeAnimation),
                       delay: 0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {
                        self.speedRulerUIView.center = CGPoint(x: 128, y: 500)
        }) { (true) in
            UIView.animate(withDuration: TimeInterval(self.timeAnimation), animations: {
                self.speedRulerUIView.center = self.centerOfActionView
            })
        }
    }
    
    // Движение индиктора скорости
    func speedIndicator() {
        var speeds = 0
        DispatchQueue.global().async {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
//                for speed in stride(from: 0,through: 100, by: 10) {
//                autoreleasepool{
                    DispatchQueue.main.async {
                        self.speedIndicatorSmall.text = "\(speeds)"
                        self.SpeedIndicatorPicker.selectRow(10-speeds%10, inComponent: 0, animated: true)
                        speeds += 1
                    }
//                }
//                sleep(1)
            }
            RunLoop.current.run(until: Date()+11)
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+10) {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
//                for speed in stride(from: -100,through: 30, by: 10) {
//                autoreleasepool{
                    DispatchQueue.main.async {
                        speeds -= 1
                        self.speedIndicatorSmall.text = "\(speeds)"
                        self.SpeedIndicatorPicker.selectRow(10-speeds%10, inComponent: 0, animated: true)
                    }
//                }
//                sleep(1)
            }
            RunLoop.current.run(until: Date()+11)
        }
    }
    
    // Движение индиктора скорости в виде PickerView
    func SpeedIndicatorPickerView() {
    }
    
    // Количество компонентов в PickerView
    func numberOfComponents(in SpeedIndicatorPicker: UIPickerView) -> Int {
        return 1
    }
    
    // Количество значений в PickerView
    func pickerView(_ SpeedIndicatorPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speed.count
    }
    
    // Значение очередной строки в PickerView
    func pickerView(_ SpeedIndicatorPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speed[row]
    }
    
    // Сменим цвет текста в PickerView
//    func pickerView(_ SpeedIndicatorPicker: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let string = speed[indexPath.row]
//        return NSAttributedString(string: string, attributes: [NSAttributedString.key.foregroundColor: UIColor.white])
//    }
    
    // Движение линии горизонта
    func skylineAction() {
        
    }
    
}
