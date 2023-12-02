//
//  NotesListUITests.swift
//  My NotesUITests
//
//  Created by Tamim on 2/12/2023.
//

import XCTest

final class NotesListUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
    //test if Notes List Appears for logged in users
    func testNotesListAppear() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
    }
    
    //test if New Notes Can be added
    func testNewNotesAdd() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        
        //get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.count
        
        //find add note button
        let addNote = app.buttons["Add Note"]
        XCTAssertTrue(addNote.exists, "Add Note is not present.")
        addNote.tap()
        
        //Press back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        backButton.tap()
        
        //find the list and get the final count
        let finalCount = list.cells.count
        
        //compare
        XCTAssertEqual(initialCount + 1, finalCount, "Note was not added")
    }
    
    //test delete notes functionality
    func testNoteDeletion() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        
        //find add note button
        let addNote = app.buttons["Add Note"]
        XCTAssertTrue(addNote.exists, "Add Note is not present.")
        addNote.tap()
        
        //Press back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        backButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.count
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //swipe to delete it
        cell.swipeLeft(velocity: XCUIGestureVelocity.slow)
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button is not present.")
        deleteButton.tap()
        
        //get the final count
        let finalCount = list.cells.count
        
        //compare
        XCTAssertEqual(initialCount - 1, finalCount, "Note was not deleted")
    }
    
    func testLogOutButton() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button and tap
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        logoutButton.tap()
        
        //Check login button
        let button = app.buttons["Login"]
        XCTAssertTrue(button.exists, "Not a login screen")
    }
    
}
