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
        app.terminate()
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
        let initialCount = list.cells.countForHittables
        
        //find add note button
        let addNote = app.buttons["Add Note"]
        XCTAssertTrue(addNote.exists, "Add Note is not present.")
        addNote.tap()
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the final count
        let finalCount = list.cells.countForHittables
        
        //compare
        XCTAssertEqual(initialCount + 1, finalCount, "Note was not added")
        app.terminate()
    }
    
    //test delete popup functionality
    func testNoteDeletionPopup() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //swipe to delete it
        cell.swipeLeft(velocity: XCUIGestureVelocity.slow)
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button is not present.")
        deleteButton.tap()
        
        //find in popup
        let deletePopup = app.staticTexts["Are you sure?"]
        XCTAssertTrue(deletePopup.exists, "Delete popup is not present.")
        app.terminate()
    }
    
    //test delete notes popup cancel functionality
    func testNoteDeletionPopupCancel() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.countForHittables
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //swipe to delete it
        cell.swipeLeft(velocity: XCUIGestureVelocity.slow)
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button is not present.")
        deleteButton.tap()
        
        //find in popup
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Delete popup is not present.")
        cancelButton.tap()
        
        //get the final count
        let finalCount = list.cells.countForHittables
        
        //compare
        XCTAssertEqual(initialCount, finalCount, "Note was deleted")
        app.terminate()
    }
    
    //test delete notes popup confirm functionality
    func testNoteDeletionPopupConfirm() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.countForHittables
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //swipe to delete it
        cell.swipeLeft(velocity: XCUIGestureVelocity.slow)
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button is not present.")
        deleteButton.tap()
        
        //find in popup
        let deletePopupButton = app.buttons["Delete"]
        XCTAssertTrue(deletePopupButton.exists, "Delete popup is not present.")
        deletePopupButton.tap()
        
        //get the final count
        let finalCount = list.cells.countForHittables
        
        //compare
        XCTAssertEqual(initialCount - 1, finalCount, "Note was deleted")
        app.terminate()
    }
    
    //test multiple notes delete popup functionality
    func testMultipleNoteDeletionPopup() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        
        //tap the Edit button to enable selection
        let editButton = app.buttons["Edit"]
        _ = editButton.waitForExistence(timeout: 5)
        XCTAssertTrue(editButton.exists, "Edit button is not present.")
        editButton.tap()
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //tap to select it
        cell.tap()
        
        //find the trashButton
        let trashButton = app.buttons["Delete"]
        XCTAssertTrue(trashButton.exists, "Trash button is not present.")
        trashButton.tap()
        
        //find in popup
        let deletePopup = app.staticTexts["Are you sure?"]
        XCTAssertTrue(deletePopup.exists, "Delete popup is not present.")
        app.terminate()
    }
    
    //test delete notes popup cancel functionality
    func testMultipleNoteDeletionPopupCancel() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.countForHittables
                
        //tap the Edit button to enable selection
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "Edit button is not present.")
        editButton.tap()
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        //tap to select it
        cell.tap()
        
        //find the trashButton
        let trashButton = app.buttons["Delete"]
        XCTAssertTrue(trashButton.exists, "Trash button is not present.")
        trashButton.tap()
        
        //find in popup
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Delete popup is not present.")
        cancelButton.tap()
        
        //get the final count
        let finalCount = list.cells.countForHittables
        
        //compare
        XCTAssertEqual(initialCount, finalCount, "Note was deleted")
        app.terminate()
    }
    
    //test delete notes popup confirm functionality
    func testMultipleNoteDeletionPopupConfirm() throws {
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
        
        //find save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //find the list and get the initial count
        let list = app.collectionViews
        let initialCount = list.cells.countForHittables
                
        //tap the Edit button to enable selection
        let editButton = app.buttons["Edit"]
        _ = editButton.waitForExistence(timeout: 5)
        XCTAssertTrue(editButton.exists, "Delete button is not present.")
        editButton.tap()
        
        //find first cell
        let cell = list.cells.element(boundBy: 0)
        
        //tap to select it
        cell.tap()
        
        //find the trashButton
        let trashButton = app.buttons["Delete"]
        XCTAssertTrue(trashButton.exists, "Trash button is not present.")
        trashButton.tap()
            
        //find in popup
        
        let deletePopupButton = app.alerts.buttons["Delete"]
        XCTAssertTrue(deletePopupButton.exists, "Delete popup is not present.")
        deletePopupButton.tap()
        
        //get the final count
        let finalCount = list.cells.countForHittables
        
        //compare
        XCTAssertEqual(initialCount - 1, finalCount, "Note was deleted")
        app.terminate()
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
        app.terminate()
    }
    
}

extension XCUIElementQuery {
    var countForHittables: UInt {
        return UInt(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}
