//
//  NoteViewModel.swift
//  My Notes
//
//  Created by Tamim on 2/12/2023.
//

import Foundation
import CoreData

@MainActor class NoteViewModel: ObservableObject {
    let note: Note
    init(note: Note) {
        self.note = note
    }
}
