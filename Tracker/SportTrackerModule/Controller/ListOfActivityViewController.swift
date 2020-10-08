//
//  ListOfActivityViewController.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

protocol ListActivityDisplayable: class {
    func showError(text: String)
    func presentActivity(model: [ActivityViewModel])
}

class ListOfActivityViewController: UIViewController {
    var interactor: ListActivityInteractor?
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    lazy var datasource: ListOfActivityDatasource = ListOfActivityDatasource(collectionView: collectionView)
    
    enum StaticStrings {
        static let title = "list_activity_title"
    }
    
    var bottomView: BottomView?
    private var cnsButtonOutside: NSLayoutConstraint?
    
    var model: [ActivityViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StaticStrings.title.localized()
        view.backgroundColor = .white
        setupLayout()
        setUp()
        
        collectionView.delegate = self
        datasource.addHeader { [weak self] (category) in
            guard let self = self else { return }
            switch category {
            case .all:
                self.datasource.applySnapshot(model: self.model)
            case .local:
                self.datasource.applySnapshot(model: self.model.filter({ $0.origin == .local}))
            case .remote:
                self.datasource.applySnapshot(model: self.model.filter({ $0.origin == .remote}))
            }
        }
        fetchActivities()
    }
    
    func fetchActivities() {
        interactor?.fetchActivities()
    }
    
    func setUp() {
        let presenter = ListActivityPresenter(self)
        self.interactor = ListActivityInteractor(presenter: presenter)
    }
    
    func handleAddAction() {
        animatePresenting(duration: 0.1)
        0.1 ~> {
            ListActivityRouter(self).navigate(to: .addNewActivity)
        }
    }
    
    
}

//MARK: - Transitions related etc.
extension ListOfActivityViewController {
   
    func animatePresenting(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.cnsButtonOutside?.priority = .init(999)
            self.bottomView?.layoutIfNeeded()
        })
    }
    
    func animateDismissing(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.cnsButtonOutside?.priority = .init(1)
            self.bottomView?.layoutIfNeeded()
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

//MARK: Delegate AddNew...
extension ListOfActivityViewController: AddNewActivityViewControllerDelegate {
    func dismissed() {
        animateDismissing(duration: 0.1)
        2 ~> {
            self.fetchActivities()
        }
    }
}

//MARK: - Collection Views related
extension ListOfActivityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return CGSize(width: collectionView.frame.width / 2 - 10, height: 100)
        default:
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

}

extension ListOfActivityViewController: ListActivityDisplayable {
    func showError(text: String) {
        toast(text: text)
    }
    
    func presentActivity(model: [ActivityViewModel]) {
        self.model = model
        datasource.applySnapshot(model: model)
    }
}

//MARK: - SetupLayout
extension ListOfActivityViewController {
    
    func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        let bottomView = BottomView { [weak self] in
            self?.handleAddAction()
        }
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true
       
        self.bottomView = bottomView
        let buttonTopCns = bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        buttonTopCns.priority = .init(500)
        buttonTopCns.isActive = true
        
        cnsButtonOutside = bottomView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        cnsButtonOutside?.priority = .init(1)
        cnsButtonOutside?.isActive = true
        
    }

}
