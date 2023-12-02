//
//  RegistrationViewUITests.swift
//  My NotesUITests
//
//  Created by Tamim on 2/12/2023.
//

import XCTest

final class RegistrationViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    //test to see if users can see the registration screen
    func testRegistrationScreen() throws {
        let app = XCUIApplication()
        //make user logged out
        app.launchArguments = ["-userLoggedOut"]
        app.launch()

        //find registration button and tap it
        let registrationButton = app.buttons["Registration"]
        XCTAssertTrue(registrationButton.exists, "Not a login screen")
        registrationButton.tap()
        
        //find Sign up button
        let button = app.buttons["Sign Up"]
        XCTAssertTrue(button.exists, "Not a Registration screen")
        XCTAssertTrue(!button.isEnabled, "Sign Up button enabled for empty textfields")
    }
    
    // test to see if users can successfully signup
    func testSuccessfulRegistration() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedOut", "-passSignUp"]
        app.launch()
        
        //find registration button in log in screen and tap it
        let registrationButton = app.buttons["Registration"]
        XCTAssertTrue(registrationButton.exists, "Not a login screen")
        registrationButton.tap()
        
        //find username text field and type invalid username
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("testUser")
        
        //find password textfield and type a password
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("testUser")
        
        //find registration button in sign up screen and tap it
        let button = app.buttons["Sign Up"]
        XCTAssertTrue(button.exists, "Not a Registration screen")
        XCTAssertTrue(button.isEnabled, "Sign Up button not enabled for non-empty textfields")
        button.tap()
        
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        let label = app.staticTexts["Sign up successful"]
        XCTAssertTrue(label.exists, "Sign up did not succeed")
        
        //find okay button in the popup and tap it
        let okayButton = app.buttons["Okay"]
        XCTAssertTrue(okayButton.exists, "Successful popup not present.")
        okayButton.tap()
        
        //check for Login button
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Not a login screen")
    }
    
    // test to see if users can move to login screen after successful signup
    func testMoveToLogin() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedOut", "-passSignUp"]
        app.launch()
        
        //find registration button in log in screen and tap it
        let registrationButton = app.buttons["Registration"]
        XCTAssertTrue(registrationButton.exists, "Not a login screen")
        registrationButton.tap()
        
        //find username text field and type invalid username
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("testUser")
        
        //find password textfield and type a password
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("test")
        
        //find registration button in sign up screen and tap it
        let button = app.buttons["Sign Up"]
        XCTAssertTrue(button.exists, "Not a Registration screen")
        XCTAssertTrue(button.isEnabled, "Sign Up button not enabled for non-empty textfields")
        button.tap()
        
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        let label = app.staticTexts["Sign up successful"]
        XCTAssertTrue(label.exists, "Sign up did not succeed")
    }
    
    // test to see if users can see failed registration popup
    func testFailedRegistration() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-userLoggedOut", "-failSignUp"]
        app.launch()
        
        //find registration button in log in screen and tap it
        let registrationButton = app.buttons["Registration"]
        XCTAssertTrue(registrationButton.exists, "Not a login screen")
        registrationButton.tap()
        
        //find username text field and type invalid username
        let usernameTextField = app.textFields.element
        XCTAssertTrue(usernameTextField.exists, "Not a username textField")
        usernameTextField.tap()
        usernameTextField.typeText("testUser")
        
        //find password textfield and type a password
        let secureTextField = app.secureTextFields.element
        XCTAssertTrue(secureTextField.exists, "Not a password textField")
        secureTextField.tap()
        secureTextField.typeText("test")
        
        //find registration button in sign up screen and tap it
        let button = app.buttons["Sign Up"]
        XCTAssertTrue(button.exists, "Not a Registration screen")
        XCTAssertTrue(button.isEnabled, "Sign Up button not enabled for non-empty textfields")
        button.tap()
        
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Expectation for a popup")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds)
        
        let label = app.staticTexts["Sign up failed"]
        XCTAssertTrue(label.exists, "Sign up did not fail")
    }
}
