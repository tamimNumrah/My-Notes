//
//  NoteView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var model: NoteViewModel
    
    var body: some View {
        Text(model.note.title!)
    }
}


struct NoteViewPreview: View {
    let note: Note
    init() {
        let context = PersistenceController.preview.container.viewContext
        let newItem = Note(context: context)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = "username"
        newItem.content = "Content"
        self.note = newItem
    }
    var body: some View {
        NoteView(model: NoteViewModel(note: note))
    }
}
#Preview {
    NoteViewPreview()
}
