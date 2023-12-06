//
//  NoteViewModel.swift
//  My Notes
//
//  Created by Tamim on 2/12/2023.
//

import Foundation
import CoreData

@MainActor
class NoteViewModel: ObservableObject {
    let note: Note
    @Published var noteTitle: String = ""
    @Published var noteContent: String = ""
    @Published var saveButtonDisabled: Bool = true
    
    var newNote: Bool = false
    
    let editContext: NSManagedObjectContext

    init(editContext: NSManagedObjectContext, note: Note, newNote: Bool) {
        self.editContext = editContext
        self.note = note
        self.newNote = newNote
        noteTitle = note.title ?? ""
        noteContent = note.content ?? ""
        saveButtonDisabled = !note.objectID.isTemporaryID
    }
    
    //validate input fields and changes
    func validateSaveButton() {
        if noteTitle == "" {
            //Notes can't be saved with empty titles
            saveButtonDisabled = true
        } else {
            saveButtonDisabled = noteTitle == note.title && noteContent == note.content
        }
    }
    
    //if the note is not saved, delete it from editContext
    func onDisappear() {
        if newNote {
            editContext.delete(note)
        }
    }
    
    //Save the updated note to edit context
    func saveNote() throws -> Note{
        note.title = noteTitle
        note.content = noteContent
        note.timestamp = Date()
        try editContext.save()
        try editContext.parent?.save()
        newNote = false
        return note
    }
}
