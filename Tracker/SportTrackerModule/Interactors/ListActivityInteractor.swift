//
//  AddNewActivityInteractor.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation

protocol ListActivityInteractable {
    func fetchActivities()
}

class ListActivityInteractor: ListActivityInteractable {
    let presenter: ListActivityPresentable
    let remoteStorageWorker: RemoteStorageWorkable
    let localStorageWorker: LocalStorageWorkable
    
    init(presenter: ListActivityPresentable,
         remoteStorageWorker: RemoteStorageWorkable = RemoteStorageWorker(),
         localStorageWorker: LocalStorageWorkable = LocalStorageWorker()) {
        self.presenter = presenter
        self.remoteStorageWorker = remoteStorageWorker
        self.localStorageWorker = localStorageWorker
    }
    
    var activities: [Activity] = []
    
    
    func fetchActivities() {
        activities.removeAll()
        localStorageWorker.fetchActivities { result in
            switch result {
            case .success(let activities):
                self.activities.append(contentsOf: activities)
                self.activities.sort(by: { $0.dateOfBegining < $1.dateOfBegining  })
                presenter.presentActivityList(self.activities)
            case .failure(let error):
                presenter.localFetchFailure(error: error)
            }
        }
        
        remoteStorageWorker.fetchActivities { [weak self] (result) in
            switch result {
            case .success(let activities):
                self?.activities.append(contentsOf: activities)
                self?.activities.sort(by: { $0.dateOfBegining < $1.dateOfBegining  })
                guard let sortedActivities = self?.activities else { return }
                self?.presenter.presentActivityList(sortedActivities)
            case .failure(let error):
                self?.presenter.localFetchFailure(error: error)
            }
        }
    }
   
}

