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
    @IBOutlet weak var speedIndicatorPicker: UIPickerView! {
        didSet {
            speedIndicatorPicker.delegate = self
            speedIndicatorPicker.dataSource = self
        }
    }
    @IBOutlet weak var trendSpeedUIView: UIView!
    @IBOutlet weak var trendSpeed: UIImageView!
    @IBOutlet weak var altimeterIndicatorSmall: UILabel!
    @IBOutlet weak var altimeterRuler: UIImageView!
    @IBOutlet weak var altimeterRulerUIView: UIView!
    @IBOutlet weak var altimeterIndicatorPicker: UIPickerView! {
        didSet {
            altimeterIndicatorPicker.delegate = self
            altimeterIndicatorPicker.dataSource = self
        }
    }
    @IBOutlet weak var variometerArrowView: UIView!
    @IBOutlet weak var skyline: UIImageView!
    
    var timeIntervalData: Double = 0.1
    var timeAnimation: Double = 14
    var speed: Int = 0
    var trend: Double = 0.0
    var altimeter: Int = 0
    var variometer: Int = 0
    var radian: Double = 0.0
    var speedPicker: [String] = ["0","9","8","7","6","5","4","3","2","1","0","9"]
    var altimeterPicker: [String] = ["000","990","980","970","960","950","940","930","920","910","900","890","880","870","860","850","840","830","820","810","800","790","780","770","760","750","740","730","720","710","700","690","680","670","660","650","640","630","620","610","600","590","580","570","560","550","540","530","520","510","500","490","480","470","460","450","440","430","420","410","400","390","380","370","360","350","340","330","320","310","300","290","280","270","260","250","240","230","220","210","200","190","190","170","160","150","140","130","120","110","100","090","080","070","060","050","040","030","020","010","000"]
    
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
        // Взлет
        DispatchQueue.global().async {
            var speedUP = 0
            var altimeterUP = 0
            Timer.scheduledTimer(withTimeInterval: self.timeIntervalData, repeats: true) { timer in
                self.speed += speedUP
                self.altimeter += altimeterUP
                DispatchQueue.main.async {
                    self.speedIndicatorAction()
                    self.skylineAction()
                    self.altimeterIndicatorAction()
                }
            }
            // Ускорение
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                speedUP += 1
                self.trend += 50
                altimeterUP += 20
                self.variometer += 5
            }
            RunLoop.current.run(until: Date()+self.timeAnimation)
        }
        // Посадка
        DispatchQueue.global().asyncAfter(deadline: .now()+timeAnimation) {
            var speedDown = 0
            self.trend = 0
            var altimeterDown = 0
            self.variometer = 0
            Timer.scheduledTimer(withTimeInterval: self.timeIntervalData, repeats: true) { timer in
                self.speed -= speedDown
                self.altimeter -= altimeterDown
                DispatchQueue.main.async {
                    self.speedIndicatorAction()
                    self.skylineAction()
                    self.altimeterIndicatorAction()
                }
            }
            // Замедление
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                speedDown += 1
                self.trend -= 50
                altimeterDown += 20
                self.variometer -= 5
            }
            RunLoop.current.run(until: Date()+self.timeAnimation)
        }
        // Остановка
        DispatchQueue.global().asyncAfter(deadline: .now()+timeAnimation*2) {
            self.speed = 0
            self.trend = 0
            self.altimeter = 0
            self.variometer = 0
            DispatchQueue.main.async {
                self.speedIndicatorAction()
                self.skylineAction()
                self.altimeterIndicatorAction()
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
    
    // Перевести вариометр в радианы
    func variometerInRadian() -> Double {
        if 20 < self.variometer && self.variometer <= 30 {
            radian = (Double(self.variometer-20)*15+2500)/1000
        } else if 10 < self.variometer && self.variometer<=20 {
            radian = (Double(self.variometer-10)*50+2000)/1000
        } else if 0 <= self.variometer && self.variometer <= 10 {
            radian = (Double(self.variometer)*200)/1000
        } else if -10 <= self.variometer && self.variometer < 0 {
            radian = (Double(self.variometer)*200)/1000
        } else if -20 <= self.variometer && self.variometer < -10 {
            radian = (Double(self.variometer+10)*50-2000)/1000
        } else if -30 <= self.variometer && self.variometer < -20 {
            radian = (Double(self.variometer+20)*15-2500)/1000
        }
        return radian
    }
    
    // Действия индикторов высоты
    func altimeterIndicatorAction() {
        self.altimeterIndicatorSmall.text = "\(self.altimeter/1000)"
        self.altimeterIndicatorPicker.selectRow(100-self.altimeter%1000/10, inComponent: 0, animated: false)
        UIView.animate(withDuration: self.timeIntervalData,
                       delay: 0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {
                        self.altimeterRulerUIView.transform = CGAffineTransform(translationX: 0, y: CGFloat(12*self.altimeter/10))
                        self.variometerArrowView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi*self.variometerInRadian()/6))//self.variometerInRadian()/6
        })
    }

    // Количество компонентов в PickerView
    func numberOfComponents(in pikerView: UIPickerView) -> Int {
        if pikerView == speedIndicatorPicker {
            return 1
        }
        if pikerView == altimeterIndicatorPicker {
            return 1
        }
        return 0
    }
    
    // Количество значений в PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == speedIndicatorPicker {
            return speedPicker.count
        }
        if pickerView == altimeterIndicatorPicker {
            return altimeterPicker.count
        }
        return 0
    }
    
    // Значение очередной строки в PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == speedIndicatorPicker {
            return speedPicker[row]
        }
        if pickerView == altimeterIndicatorPicker {
            return altimeterPicker[row]
        }
        return ""
    }
    
    // Внешний вид индикатора скорости PickerView
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == speedIndicatorPicker {
            return NSAttributedString(string: self.speedPicker[row], attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.strokeWidth:9,  NSAttributedString.Key.kern:50,  NSAttributedString.Key.underlineStyle:false,  NSAttributedString.Key.strokeColor:UIColor.white
            ])
        }
        if pickerView == altimeterIndicatorPicker {
            return NSAttributedString(string: self.altimeterPicker[row], attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.strokeWidth:9,  NSAttributedString.Key.kern:7,  NSAttributedString.Key.underlineStyle:false,  NSAttributedString.Key.strokeColor:UIColor.white
            ])
        }
        return nil
    }
    
    // Движение линии горизонта
    func skylineAction() {
    }
    
}

