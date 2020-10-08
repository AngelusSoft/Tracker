//
//  AddNewActivityInteractor.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation

protocol AddNewActivityInteractable {
    func saveNewActivity(data: RawActivityData)
}

class AddNewActivityInteractor: AddNewActivityInteractable {
    let presenter: AddNewActivityPresentable
    let remoteStorageWorker: RemoteStorageWorkable
    let localStorageWorker: LocalStorageWorkable
    
    init(presenter: AddNewActivityPresentable,
         remoteStorageWorker: RemoteStorageWorkable = RemoteStorageWorker(),
         localStorageWorker: LocalStorageWorkable = LocalStorageWorker()) {
        self.presenter = presenter
        self.remoteStorageWorker = remoteStorageWorker
        self.localStorageWorker = localStorageWorker
    }
    
    func saveNewActivity(data: RawActivityData) {
        switch validateData(data) {
        case .success(let activityData):
            switch data.destination {
            case .local:
                localStorageWorker.saveActivity(activityData) { result in
                    switch result {
                    case .success:
                        presenter.saveDone()
                    case .failure(let error):
                        presenter.saveFailed(error: error)
                    }
                    
                }
            case .remote:
                remoteStorageWorker.saveActivity(activityData) { [weak self] result in
                    switch result {
                    case .success:
                        self?.presenter.saveDone()
                    case .failure(let error):
                        self?.presenter.saveFailed(error: error)
                    }
                }
            }
        case .failure(let error):
            presenter.validationFailed(reason: error)
        }
    }
    
    func validateData(_ data: RawActivityData) -> Result<ActivityData, RawActivityData.ValidationError> {
        guard let name = data.name, name.isEmpty == false else {
            return .failure(.name)
        }
        guard let place = data.place, place.isEmpty == false else {
            return .failure(.place)
        }
        guard let date = data.dateOfBegining else {
            return .failure(.dateOfBegining)
        }
        guard let duration = data.duration else {
            return .failure(.dateOfBegining)
        }
        return .success(ActivityData(name: name, place: place, dateOfBegining: date, duration: duration))
    }
}

