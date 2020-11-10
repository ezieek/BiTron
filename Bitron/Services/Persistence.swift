//
//  Persistence.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class Persistence {
    
    private init () {}
    static let shared = Persistence()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptocurrencyModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: - CoreData Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Create
    func createCoreData(title: String, value: String, previousRate: String, image: String) {
        guard let userEntity = NSEntityDescription.entity(forEntityName: "CryptocurrencyModel", in: context) else { return }
             
        let newValue = NSManagedObject(entity: userEntity, insertInto: context)
        newValue.setValue(title, forKey: "title")
        newValue.setValue(value, forKey: "value")
        newValue.setValue(previousRate, forKey: "previous")
        newValue.setValue(image, forKey: "image")
        
        do {
            try context.save()
            print("Dane poprawnie zapisane")
        } catch {
            print("Problem z zapisem danych")
        }
    }
    
    // MARK: - Retrive
    func retriveCoreData() -> (name: [String], rate: [String], previousRate: [String], image: [String]) {
        var names: [String] = []
        var rates: [String] = []
        var previousRates: [String] = []
        var images: [String] = []
        
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
    
        do {
            
            let results = try context.fetch(fetchRequest)
            let emptyArrays = ([""],[""],[""],[""])
            
            for result in results {
                
                guard let readTitle = result.title else { return emptyArrays }
                names.append(readTitle)
                
                guard let readValue = result.value else { return emptyArrays }
                rates.append(readValue)
                
                guard let readPreviousRates = result.previous else { return emptyArrays }
                previousRates.append(readPreviousRates)
                
                guard let readImageName = result.image else { return emptyArrays }
                images.append(readImageName)
            }
            print("Dane poprawnie odczytane")
        } catch {
            print("Problem z odczytem danych")
        }
        
        return (names, rates, previousRates, images)
    }
    
    // MARK: - Update
    //gdy dana wartosc (Rate) zostanie zmieniony to nalezy ja od razu zapisac do pamieci telefonu
    /*func updateData(title: String, value: String, previousRate: String) {
        
        let context = persistence.context
             
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", title as CVarArg)
        fetchRequest.predicate = NSPredicate(format: "value = %@", value)
        fetchRequest.predicate = NSPredicate(format: "previous = %@", previousRate as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            for object in result {
                object.setValue(title, forKey: "title")
                object.setValue(value, forKey: "value")
                object.setValue(previousRate, forKey: "previous")
                //print(object)
                //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            }
           do {
                try context.save()
            } catch {
                print("Saving error")
            }
            
        } catch {
            print(error)
        }
    }*/
    
    //MARK: - Delete
    /*func deleteCoreData(indexPath: IndexPath, completion: @escaping () -> Void) {
        let context = persistence.context
        
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
        fetchRequest.predicate = NSPredicate(format: "title = %@", chosenCryptocurrencyNames[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "value = %@", chosenCryptocurrencyRates[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "previous = %@", chosenCryptocurrencyPreviousRates[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "image = %@", chosenCryptocurrencyImages[indexPath.row])

        do {
            if let result = try? context.fetch(fetchRequest) {
            
                for object in result {
                    context.delete(object)
                    chosenCryptocurrencyNames.remove(at: indexPath.row)
                    chosenCryptocurrencyRates.remove(at: indexPath.row)
                    chosenCryptocurrencyPreviousRates.remove(at: indexPath.row)
                    chosenCryptocurrencyImages.remove(at: indexPath.row)

                    completion()
                }
            }

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }*/
}
