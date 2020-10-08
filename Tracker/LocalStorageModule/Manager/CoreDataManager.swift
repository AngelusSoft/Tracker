//
//  LocalStorageManager.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support
    func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                throw error
            }
        }
    }
    
    func fetchActivities(completion: (Result<[Activity], Error>)->()) {
        do {
            let items: [ActivityDataMO] = try context.fetch(ActivityDataMO.createfetchRequest())
            return completion(.success(items.map({$0.getActivity()})))
        } catch let error {
            return completion(.failure(error))
        }
       
    }
    
    func saveActivity(_ activity: ActivityData, completion: (Result<(),Error>)->())  {
        do {
            let activityDataMO = ActivityDataMO(context: context)
            activityDataMO.name = activity.name
            activityDataMO.duration = activity.duration
            activityDataMO.id = UUID()
            activityDataMO.date = activity.dateOfBegining
            activityDataMO.place = activity.place
            try saveContext()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
    private init() {}

}
