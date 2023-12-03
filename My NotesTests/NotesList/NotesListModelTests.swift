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
    fileprivate let database = MockDatabaseService()

    @MainActor override func setUpWithError() throws {
        notesListModel = NotesListViewModel(username: "username", databaseService: database)
    }

    override func tearDownWithError() throws {
        notesListModel = nil
    }
    
    //Test fetch notes
    @MainActor func testFetchItems() throws{
        notesListModel.fetchItems()
        
        XCTAssertTrue(notesListModel.notes.count > 1, "Notes list is empty")
    }
    
    //Test note selection
    @MainActor func testDidSelectNote() throws {
        let note = notesListModel.notes[0]
        notesListModel.didSelectNote(note)
        
        XCTAssertNotNil(notesListModel.selectedNote, "Selected note is nil")
    }
    
    //Test note creation
    func testCreateNote() throws {
        let note = notesListModel.createNote()
        XCTAssertNotNil(note.title, "Note is nil.")
    }
    
    //Test prepare to delete notes using IndexSet
    @MainActor func testPrepareToDeleteItems() throws {
        let notesToDelete = IndexSet([0])
        notesListModel.prepareToDeleteItems(at: notesToDelete)
        XCTAssertTrue(notesListModel.deleteNotesAlertPresent, "Alert is not displayed")
        XCTAssertTrue(notesListModel.notesOffsetsToDelete == notesToDelete, "notesToDelete is wrong")
    }
    
    //Test prepare to delete multiple notes using IndexSet
    @MainActor func testPrepareToDeleteMultipleItems() throws {
        let notesToDelete = Set(notesListModel.notes[0..<3])
        notesListModel.prepareToDeleteMultipleItems(notes: notesToDelete)
        XCTAssertTrue(notesListModel.deleteNotesAlertPresent, "Alert is not displayed")
        XCTAssertTrue(notesListModel.notesToDelete == notesToDelete, "notesToDelete is wrong")
    }
    
    //Test note deletion using IndexSet
    @MainActor func testDeleteNoteUsingOffsets() throws {
        let previousCount = notesListModel.notes.count
        notesListModel.deleteItemsUsingOffsets(at: IndexSet([0]))
        let newCount = notesListModel.notes.count
        XCTAssert(newCount == previousCount - 1, "Note could not be deleted")
    }
    
    //Test multiple notes deletion
    @MainActor func testDeleteMultipleNotes() throws {
        let previousCount = notesListModel.notes.count
        let set = Set(notesListModel.notes[0..<3])
        notesListModel.deleteMultipleNotes(notes: set)
        let newCount = notesListModel.notes.count
        XCTAssert(newCount == previousCount - 3, "Notes could not be deleted")
    }
    
    //Test logout feature
    func testLogOut() throws {
        notesListModel.logOut()
        XCTAssertEqual(database.isLoggedIn, false, "testSetLoginStatus is true")
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
