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
    func testNoteViewAppearFromAddButton() {
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
    }
    
    //test if note view appears from notes list
    func testNoteViewAppearFromNotesList() {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists, "No note is not present.")
        cell.tap()
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button is not present.")
    }
    //test if note can be saved without changing anything
    func testNoteSaveWithoutUpdate() {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
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
    }
    
    //test if note can be updated
    func testNoteUpdateAndSave() {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
        
        //find the list
        let list = app.collectionViews
        //find first cell and tap it
        let cell = list.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists, "No note is not present.")
        cell.tap()
        
        //find back button from Note Details screen
        let backButton = app.buttons["Back"]
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
        XCTAssertTrue(newCell.exists, "New Note is present.")
    }

}
