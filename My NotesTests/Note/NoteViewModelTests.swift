//
//  NoteViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 3/12/2023.
//

import XCTest
@testable import My_Notes

final class NoteViewModelTests: XCTestCase {
    var noteViewModel: NoteViewModel!
    fileprivate let database = MockDatabaseService()

    override func setUpWithError() throws {
        let context = PersistenceController.preview.container.viewContext
        let notesListModel = NotesListViewModel(viewContext: context, username: "username", databaseService: database)
        notesListModel.fetchItems()
        noteViewModel = NoteViewModel(viewContext: context, note: notesListModel.notes[0])
    }

    override func tearDownWithError() throws {
        noteViewModel = nil
    }
    
    func testVariables() throws {
        XCTAssertEqual(noteViewModel.noteTitle, noteViewModel.note.title, "Title is not same")
        XCTAssertEqual(noteViewModel.noteContent, noteViewModel.note.content, "Content is not same")

    }
    
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
    
    func testSaveNote() throws {
        let note = try? noteViewModel.saveNote()
        XCTAssertNotNil(note, "Note is nil.")
    }
    
}

fileprivate class MockDatabaseService: DatabaseServiceProtocol {
    var isLoggedIn: Bool = true
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}
