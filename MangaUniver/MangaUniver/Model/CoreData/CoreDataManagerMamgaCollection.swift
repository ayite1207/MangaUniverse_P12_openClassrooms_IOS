//
//  CoreDataManagerMamgaCollection.swift
//  MangaUniver
//
//  Created by ayite on 13/08/2021.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataMangaCollection: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    var mangaCollection: [MangaCollection] {
        let request: NSFetchRequest<MangaCollection> = MangaCollection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        guard let favoriteRecipes = try? managedObjectContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    // MARK: - Initializer
    
    init(coreDataMangaCollection: CoreDataStack) {
        self.coreDataMangaCollection = coreDataMangaCollection
        self.managedObjectContext = coreDataMangaCollection.mainContext
    }
    
    // MARK: - Manage FavoriteRecipe Entity
    
    func createMangaCollection(image: Data?, title: String, synopsis: String, volumes: Double?, id: Double, publishingStart: String, score: Double, type: String ) {
        let mangaCollection = MangaCollection(context: managedObjectContext)
        if let image = image {
            mangaCollection.image = image
        }
        mangaCollection.title = title
        mangaCollection.synopsis = synopsis
        mangaCollection.volumes = volumes ?? 0.0
        mangaCollection.id = id
        mangaCollection.publishingStart = publishingStart
        mangaCollection.score = score
        mangaCollection.type = type
        
        coreDataMangaCollection.saveContext()
    }
    
    func someEntityExists(tilte: String) -> Bool {
            let request: NSFetchRequest<MangaCollection> = MangaCollection.fetchRequest()
            request.predicate = NSPredicate(format: "title = %@", tilte)
            guard let manga = try? managedObjectContext.fetch(request) else { return false }
            return manga.isEmpty
    }
    
    func deleteMangaCollection(title: String){
        let request: NSFetchRequest<MangaCollection> = MangaCollection.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        guard let recipes = try? managedObjectContext.fetch(request) else { return }
        guard  let recipe = recipes.first else { return }
        managedObjectContext.delete(recipe)
        coreDataMangaCollection.saveContext()
    }
    
    var mangaFollow: [MangaFollow] {
        let request: NSFetchRequest<MangaFollow> = MangaFollow.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        guard let favoriteRecipes = try? managedObjectContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    // MARK: - Manage FavoriteRecipe Entity
    
    func createMangaFollow(image: Data?, title: String, synopsis: String, volumes: Double?, id: Double, publishingStart: String, score: Double, type: String ) {
        let mangaCollection = MangaFollow(context: managedObjectContext)
        if let image = image {
            mangaCollection.image = image
        }
        mangaCollection.title = title
        mangaCollection.synopsis = synopsis
        mangaCollection.volumes = volumes ?? 0.0
        mangaCollection.id = id
        mangaCollection.publishingStart = publishingStart
        mangaCollection.score = score
        mangaCollection.type = type
        
        coreDataMangaCollection.saveContext()
    }
    
    func someEntityExistInMangaFollow(tilte: String) -> Bool {
            let request: NSFetchRequest<MangaFollow> = MangaFollow.fetchRequest()
            request.predicate = NSPredicate(format: "title = %@", tilte)
            guard let manga = try? managedObjectContext.fetch(request) else { return false }
            return manga.isEmpty
    }
    
    func deleteMangaFollow(title: String){
        let request: NSFetchRequest<MangaFollow> = MangaFollow.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        guard let recipes = try? managedObjectContext.fetch(request) else { return }
        guard  let recipe = recipes.first else { return }
        managedObjectContext.delete(recipe)
        coreDataMangaCollection.saveContext()
    }
}

extension CoreDataManager {
    


}
