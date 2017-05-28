//
//  DataStore.swift
//  Dibit
//
//  Created by Shayne Torres on 5/28/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import CoreData

class DataStore : NSObject {
    
    static let instance = DataStore(type: NSSQLiteStoreType)
    
    let context: NSManagedObjectContext
    
    init(type: String) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        super.init()
        
        switch type {
        case NSSQLiteStoreType: setupSQLStore()
        default: break
        }
    }
    
    func setupSQLStore() {
        guard let url = Bundle.main.url(forResource: "dibit", withExtension: "momd") else {
            fatalError("bad url")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("bad model")
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context.persistentStoreCoordinator = coordinator
        
        
        guard let store = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("TAP.sqlite") else {
            fatalError("bad store")
        }
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: store, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            print(error)
        }
    }

}
