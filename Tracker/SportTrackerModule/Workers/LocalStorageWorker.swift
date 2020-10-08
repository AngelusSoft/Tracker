//
//  LocalStorageWorker.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation

protocol LocalStorageWorkable {
    func saveActivity(_ activityData: ActivityData, completion: (Result<(),Error>)->())
    func fetchActivities(completion: (Result<[Activity],Error>)->())
}

class LocalStorageWorker: LocalStorageWorkable {
    func saveActivity(_ activityData: ActivityData, completion: (Result<(),Error>)->()) {
        CoreDataManager.shared.saveActivity(activityData, completion: completion)
    }
    
    func fetchActivities(completion: (Result<[Activity],Error>)->()) {
        CoreDataManager.shared.fetchActivities(completion: completion)
    }
}

