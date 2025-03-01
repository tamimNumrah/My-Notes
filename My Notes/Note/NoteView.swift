//
//  NoteView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.dismiss) var dismiss
    @State var model: NoteViewModel
    enum FocusField: Hashable {
        case title
        case content
    }
    
    @FocusState private var focusedField: FocusField?
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $model.noteTitle)
                    .foregroundColor(.white)
                    .onChange(of: model.noteTitle) { newValue, oldValue in
                        model.validateSaveButton()
                    }
                    .focused($focusedField, equals: .title)
                    .onAppear {
                        self.focusedField = .title
                    }
            } header: {
                Text("Title")
                    .foregroundColor(.white)
            }
            .listRowBackground(Color.contentBackground)
            
            Section {
                TextEditor(text: $model.noteContent)
                    .foregroundColor(.white)
                    .onChange(of: model.noteContent) { newValue, oldValue in
                        model.validateSaveButton()
                    }
                    .focused($focusedField, equals: .content)
            } header: {
                Text("Content")
                    .foregroundColor(.white)
            }
            .listRowBackground(Color.contentBackground)
            
        }
        .scrollContentBackground(.hidden)
        .background(.viewBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    if let timestamp = model.note.timestamp{
                        Text(timestamp, formatter: itemFormatter)
                            .foregroundColor(.white)
                    }
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    _ = try? model.saveNote()
                    self.dismiss()
                }
                .disabled(model.saveButtonDisabled)
            }
        }
        .onDisappear {
            model.onDisappear()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct NoteViewPreview: View {
    let note: Note
    let context = PersistenceController.preview.editContext
    init() {
        let newItem = Note(context: context)
        newItem.timestamp = Date()
        newItem.title = "New Note"
        newItem.username = "username"
        newItem.content = "Content"
        self.note = newItem
    }
    var body: some View {
        NavigationStack {
            NoteView(model: NoteViewModel(editContext: context, note: note, newNote: true))
        }
    }
}
#Preview {
    NoteViewPreview()
}
