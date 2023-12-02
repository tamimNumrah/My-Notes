//
//  ContentView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI
import CoreData

struct NotesListView: View {
    @ObservedObject var model: NotesListViewModel
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                ForEach(model.notes) { note in
                    NavigationLink(value: note) {
                        Text(note.title!)
                            .foregroundStyle(.white)
                    }
                    .foregroundStyle(.white)
                }
                .onDelete(perform: model.deleteItems)
                .listRowBackground(Color.contentBackground)
            }
            .scrollContentBackground(.hidden)
            .background(.viewBackground)
            .navigationDestination(for: Note.self, destination: { note in
                NoteView(model: NoteViewModel(editContext: model.databaseService.editContext, note: note))
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        let note = model.createNote()
                        navPath.append(note)
                    } label: {
                        Label("Add Note", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.model.logOut()
                    } label: {
                        Text("Logout")
                    }
                }
            }
            .toolbarBackground(.viewBackground, for: .navigationBar)
        }
    }
}

#Preview {
    NotesListView(model: NotesListViewModel(username: "username", databaseService: PersistenceController.shared))
}
