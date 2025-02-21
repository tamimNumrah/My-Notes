//
//  MockDatabaseService.swift
//  My Notes
//
//  Created by Tamim Ibn Aman on 21/2/2025.
//

import Foundation
import CoreData
import SwiftUI
@testable import My_Notes

@MainActor final class MockDatabaseService: @preconcurrency DatabaseServiceProtocol {
    var editContext: NSManagedObjectContext = PersistenceController.preview.editContext
    
    var container: NSPersistentContainer = PersistenceController.preview.container
    
    var isLoggedIn: Bool = true
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}
