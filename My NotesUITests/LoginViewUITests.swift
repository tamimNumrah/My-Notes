//
//  LoginViewUITests.swift
//  My NotesUITests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }

    //Test to see if user can see the login screen
    func testLoginScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedOut"]
        app.launch()

        //Check login button
        let button = app.buttons["Login"]
        XCTAssertTrue(button.exists, "Not a login screen")
        XCTAssertTrue(!button.isEnabled, "Login button enabled for empty textfields")
    }
    
    //test to see if user can see failed login UI
    func testFailedLogin() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedOut"]
        app.launch()
        
        //find username textfield
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("testUser")
        
        //find password textfield
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("test")
        
        //find and tap login button
        let button = app.buttons["Login"]
        XCTAssertTrue(button.exists, "Not a login button")
        button.tap()
        
        //wait for 2 seconds in order to finish the async API call
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        //check for Login Failed popup
        let label = app.staticTexts["Login failed"]
        XCTAssertTrue(label.exists, "Login did not fail")
    }
    
    //test to see if user can successfully log in
    func testSuccessfulLogin() throws {
        let app = XCUIApplication()
        //add flags to ignore authentication service request
        app.launchArguments = ["-passAuthentication", "-userLoggedOut"]
        app.launch()
        
        //find username textfield
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("test")
        
        //find password textfield
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("test")
        
        //find and tap login button
        let button = app.buttons["Login"]
        XCTAssertTrue(button.exists, "Not a login button")
        button.tap()
        
        //wait for 2 seconds in order to finish the async API call
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        //check for Login successful
        let label = app.staticTexts["Login successful"]
        XCTAssertTrue(label.exists, "Login failed")
    }
    
    //test to see if users can see the homescreen after successful login
    func testHomescreenAfterSuccessfulLogin() {
        let app = XCUIApplication()
        //add flags to ignore authentication service request
        app.launchArguments = ["-passAuthentication", "-userLoggedOut"]
        app.launch()
        
        //find username textfield
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("test")
        
        //find password textfield
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("test")
        
        //find and tap login button
        let button = app.buttons["Login"]
        XCTAssertTrue(button.exists, "Not a login button")
        button.tap()
        
        //wait for 2 seconds in order to finish the async API call
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        //check for Login successful
        let label = app.staticTexts["Login successful"]
        XCTAssertTrue(label.exists, "Login failed")
        
        //find okay button in the popup and tap it
        let okayButton = app.buttons["Okay"]
        XCTAssertTrue(okayButton.exists, "Successful popup not present.")
        okayButton.tap()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
    }
    
    //test to see if user can see the notes screen directly
    func testAutoLogin() {
        let app = XCUIApplication()
        //pass arguments to make user logged in
        app.launchArguments = ["-userLoggedIn"]
        app.launch()
        
        //check for logout button
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout is not present.")
    }
}
