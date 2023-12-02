//
//  NotesListViewModel.swift
//  My Notes
//
//  Created by Tamim on 2/12/2023.
//

import Foundation
import CoreData

class NotesListViewModel: NSObject, ObservableObject {
    @Published var notesController: NSFetchedResultsController<Note>
    @Published var selectedNote: Note?
    
    let viewContext: NSManagedObjectContext
    let username: String
    let databaseService: DatabaseServiceProtocol

    init(username: String, databaseService: DatabaseServiceProtocol) {
        self.viewContext = databaseService.container.viewContext
        self.databaseService = databaseService
        self.username = username
        //create notes fetched results controller
        let request: NSFetchRequest<Note> = NSFetchRequest<Note>(entityName: "Note")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)]
        let predicate = NSPredicate(format: "username = %@", username)
        request.predicate = predicate
        self.notesController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchItems()
    }
    
    func fetchItems() {
        self.notesController.delegate = self
        try? self.notesController.performFetch()
    }
    
    func didSelectNote(_ note: Note) {
        selectedNote = note
    }
    
    func createNote() -> Note{
        let newItem = Note(context: databaseService.editContext)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = username
        return newItem
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            if let note = notesController.fetchedObjects?[index] {
                viewContext.delete(note)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    var notes: [Note] {
        return notesController.fetchedObjects ?? []
    }
    
    func logOut() {
        databaseService.setLoginStatus(isLoggedIn: false, username: nil)
    }
}

extension NotesListViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
}
