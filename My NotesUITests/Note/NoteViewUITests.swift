//
//  NoteViewUITests.swift
//  My NotesUITests
//
//  Created by Tamim on 3/12/2023.
//

import XCTest

final class NoteViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    //test if note view appears from Add note button
    func testNoteViewAppearFromAddButton() throws {
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
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        app.terminate()
    }
    
    //test if note view appears from notes list
    func testNoteViewAppearFromNotesList() throws {
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
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
        _ = cell.waitForExistence(timeout: 5)
        XCTAssertTrue(cell.exists, "No note is not present.")
        cell.tap()
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        app.terminate()
    }
    //test if note can be saved without changing anything
    func testNoteSaveWithoutUpdate() throws {
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
        let saveButton1 = app.buttons["Save"]
        XCTAssertTrue(saveButton1.exists, "Save button is not present.")
        saveButton1.tap()
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
        _ = cell.waitForExistence(timeout: 5)
        XCTAssertTrue(cell.exists, "No note is not present.")
        cell.tap()
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        
        //find saveButton
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //check if moved back
        let editButton = app.buttons["Edit"]
        XCTAssertFalse(editButton.exists, "Edit button is present.")
        app.terminate()
    }
    
    //test if note can be updated
    func testNoteUpdateAndSave() throws {
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
        let saveButton1 = app.buttons["Save"]
        XCTAssertTrue(saveButton1.exists, "Save button is not present.")
        saveButton1.tap()
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
        _ = cell.waitForExistence(timeout: 5)
        XCTAssertTrue(cell.exists, "No note is not present.")
        cell.tap()
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
        _ = backButton.waitForExistence(timeout: 5)
        XCTAssertTrue(backButton.exists, "Back button is not present.")
        
        //find title textField
        let titleTextField = app.textFields.element
        XCTAssertTrue(titleTextField.exists, "Not a note title textField")
        titleTextField.tap()
        titleTextField.clearAndEnterText(text: "Updated title")
        
        //find content textField
        let contentTextView = app.textViews.element
        XCTAssertTrue(contentTextView.exists, "Not a note content textView")
        contentTextView.tap()
        contentTextView.clearAndEnterText(text: "Updated content")
        
        //find saveButton
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button is not present.")
        saveButton.tap()
        
        //check if updated back
        let newCell = app.staticTexts["Updated title"]
        XCTAssertFalse(newCell.exists, "New Note is not present.")
        app.terminate()
    }

}
