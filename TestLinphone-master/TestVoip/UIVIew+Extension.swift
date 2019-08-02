//
//  UIVIew+Extension.swift
//  TestVoip
//
//  Created by Edmund on 8/2/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func UnderLine(_ color: UIColor, _ height: CGFloat) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.self.height - height, width: self.frame.self.width, height: self.frame.size.height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
