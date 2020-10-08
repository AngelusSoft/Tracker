//
//  RemoteStorageWorker.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation


protocol RemoteStorageWorkable {
    func saveActivity(_ activityData: ActivityData, completion: @escaping (Result<(),Error>)->())
    func fetchActivities(completion: @escaping (Result<[Activity],Error>)->())
}

class RemoteStorageWorker: RemoteStorageWorkable {
    func saveActivity(_ activityData: ActivityData, completion: @escaping (Result<(), Error>) -> ()) {
        RemoteStorageManager.shared.saveActivity(activityData, completion: completion)
    }
    
    func fetchActivities(completion: @escaping (Result<[Activity], Error>) -> ()) {
        RemoteStorageManager.shared.fetchActivities(completion: completion)
    }
}
