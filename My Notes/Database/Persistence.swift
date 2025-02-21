//
//  Persistence.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import CoreData

let isLoggedInUserDefaultsKey = "isLoggedIn"
let loggedInUserNameUserDefaultsKey = "loggedInUser"

//Database service protocol

protocol DatabaseServiceProtocol: Sendable {
    var editContext: NSManagedObjectContext { get }
    var container: NSPersistentContainer { get }
    var isLoggedIn: Bool { get set }
    func setLoginStatus(isLoggedIn: Bool, username: String?)
}

@MainActor
@Observable public final class PersistenceController: @preconcurrency DatabaseServiceProtocol, Sendable {
    static let shared = PersistenceController()

    //preview instance for testing and preview purposes
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newItem = Note(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = "Note \(index)"
            newItem.content = "Note \(index) Content here"
            newItem.username = "username"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "My_Notes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var editContext: NSManagedObjectContext {
        //let editContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        //editContext.parent = self.container.viewContext
        //return editContext
        return self.container.viewContext
    }
    
    
    var isLoggedIn: Bool = UserDefaults.standard.bool(forKey:isLoggedInUserDefaultsKey)
    
    //Set login status and user name to local storage
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        UserDefaults.standard.setValue(isLoggedIn, forKey: isLoggedInUserDefaultsKey)
        UserDefaults.standard.setValue(username, forKey: loggedInUserNameUserDefaultsKey)
        self.isLoggedIn = isLoggedIn
    }
}
