//
//  CoreDataStack.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 23/9/24.
//

import Foundation
import CoreData

enum CoreDataOperation {
    case success
    case failed
}

final class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "MoviesDB")
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error loading container \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
 

    func saveContext(completion: @escaping (CoreDataOperation) -> ()) {
        let context = managedContext
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving data \(nsError)")
                completion(.failed)
            }
            completion(.success)
    }

    func fetchEntities<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let dataFetched = try managedContext.fetch(fetchRequest)
            return dataFetched
        } catch {
            let nsError = error as NSError
            print("Error fetching data for entity \(entity), \(nsError)")
            return nil
        }
    }
}
