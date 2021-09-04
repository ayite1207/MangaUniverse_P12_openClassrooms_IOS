//
//  FileMockCoreDataMangaCollection.swift
//  MangaUniverTests
//
//  Created by ayite on 04/09/2021.
//

import MangaUniver
import Foundation
import CoreData

final class MockCoreDataMangaCollectionTest: CoreDataStack {

    // MARK: - Initializer

    convenience init() {
        self.init(modelName: "MangaUniver")
    }

    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
