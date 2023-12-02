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
    
    let editContext: NSManagedObjectContext

    init(editContext: NSManagedObjectContext, note: Note) {
        self.editContext = editContext
        self.note = note
        noteTitle = note.title ?? ""
        noteContent = note.content ?? ""
        saveButtonDisabled = !note.objectID.isTemporaryID
    }
    
    func validateSaveButton() {
        if noteTitle == "" {
            //Notes can't be saved with empty titles
            saveButtonDisabled = true
        } else {
            saveButtonDisabled = noteTitle == note.title && noteContent == note.content
        }
    }
    
    func onDisappear() {
        if note.objectID.isTemporaryID {
            editContext.delete(note)
        }
    }
    
    func saveNote() throws -> Note{
        note.title = noteTitle
        note.content = noteContent
        note.timestamp = Date()
        try editContext.save()
        try editContext.parent?.save()
        return note
    }
}
