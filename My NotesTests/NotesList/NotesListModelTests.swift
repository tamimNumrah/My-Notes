//
//  NotesListModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 2/12/2023.
//

import XCTest
import CoreData
@testable import My_Notes

final class NotesListModelTests: XCTestCase {
    var notesListModel: NotesListViewModel!
    var database: MockDatabaseService!

    override func setUp() async throws {
        try await super.setUp()
        database = await MockDatabaseService()
        notesListModel = await NotesListViewModel(username: "username", databaseService: database)
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        notesListModel = nil
        database = nil
    }
    
    //Test fetch notes
    @MainActor
    func testFetchItems() async throws {
        notesListModel.fetchItems()
        
        XCTAssertTrue(notesListModel.notes.count > 1, "Notes list is empty")
    }
    
    //Test note selection
    @MainActor
    func testDidSelectNote() async throws {
        let note = notesListModel.notes[0]
        notesListModel.didSelectNote(note)
        
        XCTAssertNotNil(notesListModel.selectedNote, "Selected note is nil")
    }
    
    //Test note creation
    @MainActor
    func testCreateNote() async throws {
        let note = notesListModel.createNote()
        XCTAssertNotNil(note.title, "Note is nil.")
    }
    
    //Test prepare to delete notes using IndexSet
    @MainActor
    func testPrepareToDeleteItems() async throws {
        let notesToDelete = IndexSet([0])
        notesListModel.prepareToDeleteItems(at: notesToDelete)
        XCTAssertTrue(notesListModel.deleteNotesAlertPresent, "Alert is not displayed")
        XCTAssertTrue(notesListModel.notesOffsetsToDelete == notesToDelete, "notesToDelete is wrong")
    }
    
    //Test prepare to delete multiple notes using IndexSet
    @MainActor
    func testPrepareToDeleteMultipleItems() async throws {
        let notesToDelete = Set(notesListModel.notes[0..<3])
        notesListModel.prepareToDeleteMultipleItems(notes: notesToDelete)
        XCTAssertTrue(notesListModel.deleteNotesAlertPresent, "Alert is not displayed")
        XCTAssertTrue(notesListModel.notesToDelete == notesToDelete, "notesToDelete is wrong")
    }
    
    //Test note deletion using IndexSet
    @MainActor
    func testDeleteNoteUsingOffsets() async throws {
        let previousCount = notesListModel.notes.count
        notesListModel.deleteItemsUsingOffsets(at: IndexSet([0]))
        notesListModel.fetchItems()
        let newCount = notesListModel.notes.count
        XCTAssert(newCount == previousCount - 1, "Note could not be deleted")
    }
    
    //Test multiple notes deletion
    @MainActor
    func testDeleteMultipleNotes() async throws {
        let previousCount = notesListModel.notes.count
        let set = Set(notesListModel.notes[0..<3])
        notesListModel.deleteMultipleNotes(notes: set)
        notesListModel.fetchItems()
        let newCount = notesListModel.notes.count
        XCTAssert(newCount == previousCount - 3, "Notes could not be deleted")
    }
    
    //Test logout feature
    @MainActor
    func testLogOut() async throws {
        notesListModel.logOut()
        let isLoggedIn = database.isLoggedIn
        XCTAssertEqual(isLoggedIn, false, "testSetLoginStatus is true")
    }
}
