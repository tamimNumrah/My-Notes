//
//  NoteViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 3/12/2023.
//

import XCTest
import CoreData
@testable import My_Notes

@MainActor
final class NoteViewModelTests: XCTestCase {
    var noteViewModel: NoteViewModel!
    fileprivate let database = MockDatabaseService()

    override func setUpWithError() throws {
        let notesListModel = NotesListViewModel(username: "username", databaseService: database)
        notesListModel.fetchItems()
        noteViewModel = NoteViewModel(editContext: database.editContext, note: notesListModel.notes[0], newNote: false)
    }

    override func tearDownWithError() throws {
        noteViewModel = nil
    }
    
    //Test if Note core data object properly sets data to @Published variabls
    func testVariables() throws {
        XCTAssertEqual(noteViewModel.noteTitle, noteViewModel.note.title, "Title is not same")
        XCTAssertEqual(noteViewModel.noteContent, noteViewModel.note.content, "Content is not same")

    }
    
    //Test if save button gets enabled for unsaved notes
    func testSaveButtonEnabledForUnsavedNote() throws {
        let newItem = Note(context: database.editContext)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = "username"
        let viewModel = NoteViewModel(editContext: database.editContext, note: newItem, newNote: true)
        XCTAssertFalse(viewModel.saveButtonDisabled, "Save button disabled but Note is unsaved")
    }
    
    //Test if save button gets enabled properly
    func testSaveButtonEnable() throws {
        noteViewModel.validateSaveButton()
        
        XCTAssertTrue(noteViewModel.saveButtonDisabled, "Save button enabled but nothing has changed")
        
        noteViewModel.noteTitle = ""
        noteViewModel.noteContent = ""
        
        noteViewModel.validateSaveButton()
        XCTAssertTrue(noteViewModel.saveButtonDisabled, "Save button enabled for empty content")
        
        noteViewModel.noteTitle = "123"
        noteViewModel.noteContent = "1234"
        
        noteViewModel.validateSaveButton()
        XCTAssertFalse(noteViewModel.saveButtonDisabled, "Save button disabled for empty content")
        
    }
    
    //Test save/update note
    func testSaveNote() throws {
        let note = try? noteViewModel.saveNote()
        XCTAssertNotNil(note, "Note is nil.")
    }
    
    //Test if new note gets deleted even after saving
    func testOnDisapperForSavedNote() throws {
        noteViewModel.onDisappear()
        XCTAssertFalse(noteViewModel.note.isDeleted, "Note is deleted")
    }
    
    //Test if new note gets deleted automatically
    func testOnDisapperForUnsavedNote() throws {
        let newItem = Note(context: database.editContext)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = "username"
        let viewModel = NoteViewModel(editContext: database.editContext, note: newItem, newNote: true)
        viewModel.onDisappear()
        XCTAssertTrue(viewModel.note.isDeleted, "Note is not deleted")
    }
    
    
}

fileprivate class MockDatabaseService: DatabaseServiceProtocol {
    var editContext: NSManagedObjectContext = PersistenceController.preview.editContext
    
    var container: NSPersistentContainer = PersistenceController.preview.container
    
    var isLoggedIn: Bool = true
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}
