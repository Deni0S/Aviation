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
    @IBOutlet weak var speedIndicatorPicker: UIPickerView! {
        didSet {
            speedIndicatorPicker.delegate = self
            speedIndicatorPicker.dataSource = self
        }
    }
    @IBOutlet weak var trendSpeedUIView: UIView!
    @IBOutlet weak var trendSpeed: UIImageView!
    
    var timeIntervalData: Double = 0.1
    var timeAnimation: Double = 14
    var speed: Int = 0
    var trend: Double = 0.0
    var speedPicker: [String] = ["0","9","8","7","6","5","4","3","2","1","0","9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Скрыть точку тренда на начальном экране
        trendSpeedUIView.transform.scaledBy(x: 1, y: 0)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        demoActionPFD()
    }
    
    // Запустить демонстрацию работы PFD
    func demoActionPFD() {
        DispatchQueue.global().async {
            var speedUP = 0
            Timer.scheduledTimer(withTimeInterval: self.timeIntervalData, repeats: true) { timer in
                self.speed += speedUP
                DispatchQueue.main.async {
                    self.speedIndicatorAction()
                    self.skylineAction()
                }
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                speedUP += 1
                self.trend += 50
            }
            RunLoop.current.run(until: Date()+self.timeAnimation)
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+timeAnimation) {
            self.trend = 0
            var speedDown = 0
            Timer.scheduledTimer(withTimeInterval: self.timeIntervalData, repeats: true) { timer in
                self.speed -= speedDown
                DispatchQueue.main.async {
                    self.speedIndicatorAction()
                    self.skylineAction()
                }
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                speedDown += 1
                self.trend -= 50
            }
            RunLoop.current.run(until: Date()+self.timeAnimation)
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+timeAnimation*2) {
            self.trend = 0
            DispatchQueue.main.async {
                self.speedIndicatorAction()
                self.skylineAction()
            }
        }
    }
    
    // Действия индикторов скорости
    func speedIndicatorAction() {
        self.speedIndicatorSmall.text = "\(self.speed/10)"
        self.speedIndicatorPicker.selectRow(10-self.speed%10, inComponent: 0, animated: false)
        self.trendSpeedUIView.transform = CGAffineTransform (scaleX: 1, y: CGFloat(self.trend)).translatedBy(x: 0, y: -0.5)
        UIView.animate(withDuration: self.timeIntervalData,
                       delay: 0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {
                        self.speedRulerUIView.transform = CGAffineTransform(translationX: 0, y: CGFloat(10*self.speed))
        })
    }

    // Количество компонентов в PickerView
    func numberOfComponents(in SpeedIndicatorPicker: UIPickerView) -> Int {
        return 1
    }
    
    // Количество значений в PickerView
    func pickerView(_ SpeedIndicatorPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speedPicker.count
    }
    
    // Значение очередной строки в PickerView
    func pickerView(_ SpeedIndicatorPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speedPicker[row]
    }
    
    // Внешний вид индикатора скорости PickerView
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.speedPicker[row], attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.strokeWidth:9,  NSAttributedString.Key.kern:50,  NSAttributedString.Key.underlineStyle:false,  NSAttributedString.Key.strokeColor:UIColor.white
            ])
    }
    
    // Движение линии горизонта
    func skylineAction() {
    }
    
}

