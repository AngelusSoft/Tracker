//
//  Toast.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation
import UIKit

extension UIViewController {
    func toast(text: String) {
       let toastView = UIView()
        toastView.backgroundColor = .gray
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.text = text
        toastView.addSubview(label)
        label.createConstraintsToFill(view: toastView, 10, 10, -10, -10)
        label.textColor = .white
        toastView.alpha = 0
        
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        UIView.animate(withDuration: 0.35) {
            toastView.alpha = 1
        }
        
        toastView.layoutIfNeeded()
        toastView.layer.cornerRadius = toastView.bounds.height / 2
        
        3 ~> {
            UIView.animate(withDuration: 0.35) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
            }
            
        }
    }
    
    func waitForData() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.tag = 335
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func waitForDataDone() {
        guard let activityIndicator = view.subviews.first(where: { $0.tag == 335 }) as? UIActivityIndicatorView else { return }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        view.isUserInteractionEnabled = true
    }
}
