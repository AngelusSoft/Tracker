//
//  UIView.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation
import UIKit

extension UIView {
    public func createConstraintsToFill(view: UIView,
                                        _ left: CGFloat = 0,
                                        _ top: CGFloat = 0,
                                        _ right: CGFloat = 0,
                                        _ bottom: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right).isActive = true
    }
    
    public dynamic func shake() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        shake.duration = 0.6
        shake.values = [ -20, 20, -20, 20, -10, 10, -5, 5, 0]
        self.layer.add(shake, forKey: "shake")
    }
}
