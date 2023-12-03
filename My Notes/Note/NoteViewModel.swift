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
    @MainActor @Published var noteTitle: String = ""
    @MainActor @Published var noteContent: String = ""
    @MainActor @Published var saveButtonDisabled: Bool = true
    
    var newNote: Bool = false
    
    @MainActor let editContext: NSManagedObjectContext

    @MainActor init(editContext: NSManagedObjectContext, note: Note, newNote: Bool) {
        self.editContext = editContext
        self.note = note
        self.newNote = newNote
        noteTitle = note.title ?? ""
        noteContent = note.content ?? ""
        saveButtonDisabled = !note.objectID.isTemporaryID
    }
    
    //validate input fields and changes
    @MainActor func validateSaveButton() {
        if noteTitle == "" {
            //Notes can't be saved with empty titles
            saveButtonDisabled = true
        } else {
            saveButtonDisabled = noteTitle == note.title && noteContent == note.content
        }
    }
    
    //if the note is not saved, delete it from editContext
    @MainActor func onDisappear() {
        if newNote {
            editContext.delete(note)
        }
    }
    
    //Save the updated note to edit context
    @MainActor func saveNote() throws -> Note{
        note.title = noteTitle
        note.content = noteContent
        note.timestamp = Date()
        try editContext.save()
        try editContext.parent?.save()
        newNote = false
        return note
    }
}
