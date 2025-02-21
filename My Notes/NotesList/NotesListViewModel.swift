//
//  NotesListViewModel.swift
//  My Notes
//
//  Created by Tamim on 2/12/2023.
//

import Foundation
import CoreData

@MainActor
@Observable class NotesListViewModel: NSObject {
    var notesController: NSFetchedResultsController<Note>
    var selectedNote: Note?
    @ObservationIgnored var notesOffsetsToDelete: IndexSet?
    @ObservationIgnored var notesToDelete: Set<Note>?
    var deleteNotesAlertPresent: Bool = false
    var notes: [Note] = []
    
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
    
    //fetch notes using NSFetchedResultsController
    func fetchItems() {
        self.notesController.delegate = self
        try? self.notesController.performFetch()
        loadNotes()
    }
    
    //Select a note
    func didSelectNote(_ note: Note) {
        selectedNote = note
    }
    
    //create temporary note in edit context
    func createNote() -> Note{
        let newItem = Note(context: databaseService.editContext)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = username
        return newItem
    }
    
    //prepare to multiple delete notes
    func prepareToDeleteMultipleItems(notes: Set<Note>) {
        self.notesToDelete = notes
        self.deleteNotesAlertPresent = true
    }
    
    //prepare to delete notes using indexset
    func prepareToDeleteItems(at offsets: IndexSet) {
        self.notesOffsetsToDelete = offsets
        self.deleteNotesAlertPresent = true
    }
    
    //delete notes using IndexSet
    func deleteItemsUsingOffsets(at offsets: IndexSet) {
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
    
    //delete multiple notes at the same time
    func deleteMultipleNotes(notes: Set<Note>) {
        for note in notes {
            viewContext.delete(note)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    //load notes core data objects as Notes array for SwiftUI View
    func loadNotes() {
        notes = notesController.fetchedObjects ?? []
    }
    
    //set login status false and move to login screen
    func logOut() {
        databaseService.setLoginStatus(isLoggedIn: false, username: nil)
    }
}

extension NotesListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            loadNotes()
        }
    }
}
