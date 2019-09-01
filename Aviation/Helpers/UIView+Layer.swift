//
//  UIView+Layer.swift
//  Aviation
//
//  Created by Денис Баринов on 26/08/2019.
//  Copyright © 2019 Денис Баринов. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Размер скругления
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // MARK: - Размер границы
    @IBInspectable var borderWigth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // MARK: - Цвет границы
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
