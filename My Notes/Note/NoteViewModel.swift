//
//  NoteViewModel.swift
//  My Notes
//
//  Created by Tamim on 2/12/2023.
//

import Foundation
import CoreData

class NoteViewModel: ObservableObject {
    let note: Note
    @Published var noteTitle: String = ""
    @Published var noteContent: String = ""
    @Published var saveButtonDisabled: Bool = true
    
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext, note: Note) {
        self.viewContext = viewContext
        self.note = note
        noteTitle = note.title ?? ""
        noteContent = note.content ?? ""
    }
    
    func validateSaveButton() {
        if noteTitle == "" {
            //Notes can't be saved with empty titles
            saveButtonDisabled = true
        } else {
            saveButtonDisabled = noteTitle == note.title && noteContent == note.content
        }
    }
    
    func saveNote() throws -> Note{
        note.title = noteTitle
        note.content = noteContent
        note.timestamp = Date()
        try viewContext.save()
        return note
    }
}
