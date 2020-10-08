//
//  RemoteStorageManager.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import CloudKit

class RemoteStorageManager {
    enum Key: String {
        case activities
    }
    
    static let shared = RemoteStorageManager()
    private lazy var database = CKContainer.default().privateCloudDatabase
    
    private init() {}

    func fetchActivities(completion: @escaping (Result<[Activity], Error>)->()) {
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "ActivityData", predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        
        var activities: [Activity] = []
        operation.recordFetchedBlock = { record in
            guard let name = record["name"] as? String else { return }
            guard let place = record["place"] as? String else { return }
            guard let idString = record["id"] as? String, let id = UUID(uuidString: idString) else { return }
            guard let duration = record["duration"] as? TimeInterval else { return }
            guard let date = record["date"] as? Date else { return }
            
            let activity = Activity(id: id,
                                    name: name,
                                    place: place,
                                    dateOfBegining: date,
                                    duration: duration,
                                    origin: .remote)
            activities.append(activity)
        }
        
        operation.queryCompletionBlock = { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(activities))
                }
            }
        }
        
        database.add(operation)
    }
    
    func saveActivity(_ activity: ActivityData, completion: @escaping (Result<(),Error>)->())  {
        let ckAktivityData = activity.getCKRecord()
        database.save(ckAktivityData) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    
}

private extension ActivityData {
    func getCKRecord() -> CKRecord {
        let ckActivityData = CKRecord(recordType: "ActivityData")
        ckActivityData["id"] = UUID().uuidString as CKRecordValue
        ckActivityData["name"] = self.name as CKRecordValue
        ckActivityData["place"] = self.place as CKRecordValue
        ckActivityData["date"] = self.dateOfBegining as CKRecordValue
        ckActivityData["duration"] = self.duration as CKRecordValue
        return ckActivityData
    }
}

