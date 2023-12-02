//
//  NotesListModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 2/12/2023.
//

import XCTest
@testable import My_Notes

final class NotesListModelTests: XCTestCase {
    var notesListModel: NotesListViewModel!
    fileprivate let database = MockDatabaseService()

    override func setUpWithError() throws {
        notesListModel = NotesListViewModel(viewContext: PersistenceController.preview.container.viewContext, username: "username", databaseService: database)
    }

    override func tearDownWithError() throws {
        notesListModel = nil
    }
    
    func testFetchItems() throws{
        notesListModel.fetchItems()
        
        XCTAssertTrue(notesListModel.notes.count > 1, "Notes list is empty")
    }
    
    func testDidSelectNote() throws {
        let note = notesListModel.notes[0]
        notesListModel.didSelectNote(note)
        
        XCTAssertNotNil(notesListModel.selectedNote, "Selected note is nil")
    }
    
    func testCreateNote() throws {
        let note = try? notesListModel.createNote()
        XCTAssertNotNil(note, "Note is nil.")
    }
    
    func testDeleteNote() throws {
        let previousCount = notesListModel.notes.count
        notesListModel.deleteItems(at: IndexSet([0]))
        let newCount = notesListModel.notes.count
        XCTAssert(newCount < previousCount, "Not could not be deleted")
    }
    
    func testLogOut() throws {
        notesListModel.logOut()
        XCTAssertEqual(database.isLoggedIn, false, "testSetLoginStatus is true")
    }
}

fileprivate class MockDatabaseService: DatabaseServiceProtocol {
    var isLoggedIn: Bool = true
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}
