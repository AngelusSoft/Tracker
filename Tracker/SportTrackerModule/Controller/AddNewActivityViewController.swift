//
//  AddNewActivityViewController.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit


protocol AddNewActivityDisplayable: class {
    func validationFailed(toast: String, reason: RawActivityData.ValidationError)
    func saveFailed(toast: String)
    func saveDone(toast: String)
}

protocol AddNewActivityViewControllerDelegate: class {
    func dismissed()
}

class AddNewActivityViewController: UIViewController {
    //MARK: - Strings
    enum StaticStrings {
        static let title = "add_new_activity_title"
        static let name = "add_new_activity_name"
        static let location = "add_new_activity_location"
        static let date = "add_new_activity_date"
        static let duration = "add_new_activity_duration"
        static let saveType = "add_new_activity_saving_type"
        static let discardChanges = "add_new_discard_changes"
        static let cancel = "add_new_discard_cancel"
        static let save = "add_new_save"
    }
    
    private var interactor: AddNewActivityInteractable?
    let keyboardEvents = KeyboardEvents()
    weak var delegate: AddNewActivityViewControllerDelegate?
    
    private let centralButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: AppTheme.bottomViewButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = AppTheme.Colors.toolbarButtonText
        button.layer.cornerRadius = AppTheme.bottomViewButtonSize.height / 2
        button.backgroundColor = AppTheme.Colors.toolbarButtonBackground
        return button
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var containerStackView: UIStackView?
    private let scrollView = UIScrollView()
    
    let ivName = InputView(title: StaticStrings.name.localized(), type: .textfield)
    let ivLocation = InputView(title: StaticStrings.location.localized(), type: .textfield)
    let ivDate = InputView(title: StaticStrings.date.localized(), type: .datePicker)
    let ivDuration = InputView(title: StaticStrings.duration.localized(), type: .durationPicker)
    let ivSaveType = InputView(title: StaticStrings.saveType.localized(), type: .segmentedControl(["Local", "iCloud"]))
    
    //MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardEvents.startObservingKeyboardEvents(showHandler: { [unowned self] (size) in
            KeyboardEvents.adjustScrollViewInsets(self.scrollView, keyboardSize: size)
        }) { [unowned self] in
            KeyboardEvents.revertScrollViewInsets(self.scrollView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardEvents.stopObservingKeyboardEvents()
        delegate?.dismissed()
    }
    
    //MARK: - Inits
    init() {
        super.init(nibName: nil, bundle: nil)
        initialSetup()
    }
    /// Used for tests
    init(interactor: AddNewActivityInteractable) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        let presenter = AddNewActivityPresenter(self)
        interactor = AddNewActivityInteractor(presenter: presenter)
    }
    
    func presentAnimation() {
        UIView.animate(withDuration: 0.35) {
            self.centralButton.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 4)
        } completion: { (_) in
            self.ivDuration.fixPickerGlitch()
        }
    }
    
    // MARK: - ACTIONS
    @objc func handleCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        interactor?.saveNewActivity(data: .init(name: ivName.text,
                                                place: ivLocation.text,
                                                dateOfBegining: ivDate.text.isEmpty ? nil : ivDate.datePicker.date,
                                                duration: ivDuration.text.isEmpty ? nil : ivDuration.datePicker.countDownDuration,
                                                destination: ivSaveType.selectedIndex == 0 ? .local : .remote))
    }
    
}

//MARK: - Keyboard, Transitions etc.
extension AddNewActivityViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss( _ presentationController: UIPresentationController) {
        delegate?.dismissed()
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        handleDismiss()
    }
    
    func handleDismiss() {
        guard isModalInPresentation else { dismiss(animated: true, completion: nil); return }
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet)
        
        let discardChanges = UIAlertAction(
            title: StaticStrings.discardChanges.localized(),
            style: .destructive) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(
            title: StaticStrings.cancel.localized(), style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        
        alertController.addAction(discardChanges)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            containerStackView?.axis = .horizontal
        default:
            containerStackView?.axis = .vertical
        }
    }
    
    func handleKeyboard() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard(_:)))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AddNewActivityViewController: InputViewDelegate {
    func textDidChange(inputView: InputView, text: String) {
        if inputView == ivDuration, ivDate.text.isEmpty {
            ivDate.setDate(Date())
        }
        isModalInPresentation = true
    }
    
    func dateDidChanged(inputView: InputView, date: Date) {
        ivDuration.startDate = date
    }
}

extension AddNewActivityViewController: AddNewActivityDisplayable {
    func saveFailed(toast: String) {
        self.toast(text: toast)
    }
    
    func validationFailed(toast: String, reason: RawActivityData.ValidationError) {
        self.toast(text: toast)
        switch reason {
        case .dateOfBegining:
            ivDate.shake()
        case .duration:
            ivDuration.shake()
        case .name:
            ivName.shake()
        case .place:
            ivLocation.shake()
        }
    }
    
    func saveDone(toast: String) {
        self.toast(text: toast)
        view.isUserInteractionEnabled = false
        2 ~> {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Setup
extension AddNewActivityViewController {
    func setUpLayout() {
        presentationController?.delegate = self

        view.addSubview(mainView)
        view.addSubview(centralButton)
        
        centralButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        centralButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        centralButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        centralButton.heightAnchor.constraint(equalToConstant: AppTheme.bottomViewButtonSize.height).isActive = true
        centralButton.widthAnchor.constraint(equalToConstant: AppTheme.bottomViewButtonSize.width).isActive = true
        
        mainView.topAnchor.constraint(equalTo: centralButton.centerYAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.clipsToBounds = true
        
        mainView.addSubview(scrollView)
        scrollView.createConstraintsToFill(view: mainView, 20, 0, -20, 0)
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.createConstraintsToFill(view: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let lblTitle = UILabel()
        lblTitle.accessibilityIdentifier = "title_label"
        lblTitle.numberOfLines = 0
        lblTitle.adjustsFontForContentSizeCategory = true
        lblTitle.font = AppTheme.Fonts.detailTitle
        contentView.addSubview(lblTitle)
        lblTitle.text = StaticStrings.title.localized()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        let leftStackView = UIStackView(arrangedSubviews: [ivName,
                                                           ivLocation])
        let rightStackView = UIStackView(arrangedSubviews: [ivDate,
                                                            ivDuration])
        
        let containerStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        self.containerStackView = containerStackView
        [leftStackView, rightStackView].forEach({
            $0.spacing = 15
            $0.axis = .vertical
            $0.distribution = .fillEqually
        })
        [ivName, ivLocation, ivDate, ivDuration, ivSaveType].forEach({ $0.delegate = self })
        
        ivName.accessibilityIdentifier = "ivName"
        ivLocation.accessibilityIdentifier = "ivLocation"
        ivDate.accessibilityIdentifier = "ivDate"
        ivDuration.accessibilityIdentifier = "ivDuration"
        ivSaveType.accessibilityIdentifier = "ivSaveType"
        
        let saveButton = UIButton(type: .custom)
        saveButton.backgroundColor = AppTheme.Colors.toolbarButtonBackground
        saveButton.setTitleColor(AppTheme.Colors.toolbarButtonText, for: .normal)
        saveButton.setTitle(StaticStrings.save.localized(), for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        saveButton.accessibilityIdentifier = "save_button"
        
        let mainStackView = UIStackView(arrangedSubviews: [containerStackView, ivSaveType, saveButton])
        mainStackView.axis = .vertical
        
        containerStackView.axis = UIDevice.current.orientation.isLandscape ? .horizontal : .vertical
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 15
        mainStackView.spacing = 15
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20).isActive = true
        handleKeyboard()
    }
}
