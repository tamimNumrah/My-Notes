//
//  Persistence.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import CoreData

let isLoggedInUserDefaultsKey = "isLoggedIn"
let loggedInUserDefaultsKey = "loggedInUser"

protocol DatabaseServiceProtocol {
    var isLoggedIn: Bool { get set }
    func setLoginStatus(isLoggedIn: Bool, username: String?)
}

class PersistenceController: DatabaseServiceProtocol, ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey:isLoggedInUserDefaultsKey)
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        UserDefaults.standard.setValue(isLoggedIn, forKey: isLoggedInUserDefaultsKey)
        UserDefaults.standard.setValue(username, forKey: loggedInUserDefaultsKey)
        self.isLoggedIn = isLoggedIn
    }
}
