//
//  KeyboardEvent.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation
import UIKit

/**
call start and end methods at appear/disapper

override func viewWillAppear(_ animated: Bool)
override func viewWillDisappear(_ animated: Bool)

for default you may use `adjustScrollViewInsets` to put input on top of keyboard

*/
open class KeyboardEvents: NSObject {

    var showHandler: ((CGSize)->())?
    var hideHandler: (()->())?

    var showing: Bool = false
    var hiding: Bool = false

    /// insert into `override func viewWillAppear(_ animated: Bool)`
    open func startObservingKeyboardEvents(showHandler: @escaping (CGSize) -> (),
                                           hideHandler: @escaping () -> ()) {

        self.showHandler = showHandler
        self.hideHandler = hideHandler

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KeyboardEvents.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KeyboardEvents.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    /// insert into `override func viewWillDisappear(_ animated: Bool)`
    open func stopObservingKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            let keyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
            self.hideTask?.invalidate()
            self.hideTask = nil
            showHandler?(keyboardSize)
        }
    }

    var hideTask: Timer?
    /**
    Keyboard will hide, but
    
    if keyboard will appear just again, action should be canceled
    */
    @objc func keyboardWillHide(_ notification: Notification) {
        if #available(iOS 10.0, *) {
            hideTask = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { [weak self] (_) in
                self?.hideHandler?()
                self?.hideTask = nil
            }
        } else {
            self.hideHandler?()
        }
    }

    public static func adjustScrollViewInsets(_ scrollView: UIScrollView,
                                              keyboardSize: CGSize,
                                              defaultInsets: UIEdgeInsets = .zero) {
        let contentInset = UIEdgeInsets(top: defaultInsets.top,
                                        left: defaultInsets.left,
                                        bottom: keyboardSize.height + defaultInsets.bottom,
                                        right: defaultInsets.right)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    public static func revertScrollViewInsets(_ scrollView: UIScrollView, defaultInsets: UIEdgeInsets = .zero) {
        let contentInset = defaultInsets
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

}
