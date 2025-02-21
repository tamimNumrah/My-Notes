//
//  ContentView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI
import CoreData

struct NotesListView: View {
    @State var model: NotesListViewModel
    @State private var navPath = NavigationPath()
    @State var editMode: EditMode = .inactive
    @State var selection = Set<Note>()

    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                ForEach(model.notes) { note in
                    HStack {
                        Text(note.title!)
                            .foregroundStyle(.white)
                        Spacer()
                        if selection.contains(note) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .foregroundStyle(.white)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(note)
                    }
                }
                .onDelete(perform: { indexSet in
                    model.prepareToDeleteItems(at: indexSet)
                })
                .listRowBackground(Color.contentBackground)
            }
            .scrollContentBackground(.hidden)
            .environment(\.editMode, self.$editMode)
            .background(.viewBackground)
            .navigationDestination(for: Note.self, destination: { note in
                NoteView(model: NoteViewModel(editContext: model.databaseService.editContext, note: note, newNote: note.objectID.isTemporaryID))
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.editMode.toggle()
                        self.selection = Set<Note>()
                    } label: {
                        Text(self.editMode.title)
                    }
                }
                ToolbarItem {
                    if self.editMode == .inactive {
                        Button {
                            let note = model.createNote()
                            navPath.append(note)
                        } label: {
                            Label("Add Note", systemImage: "plus")
                        }
                    } else {
                        Button {
                            model.prepareToDeleteMultipleItems(notes: self.selection)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
            .alert(isPresented: $model.deleteNotesAlertPresent) {
                Alert(title: Text("Are you sure?"), message: nil, primaryButton: .destructive(Text("Delete")) {
                    if let notesOffsetsToDelete = model.notesOffsetsToDelete {
                        model.deleteItemsUsingOffsets(at: notesOffsetsToDelete)
                        model.notesOffsetsToDelete = nil
                    } else if let notesToDelete = model.notesToDelete {
                        model.deleteMultipleNotes(notes: notesToDelete)
                        model.notesToDelete = nil
                    }
                    }, secondaryButton: .cancel() {
                        model.notesOffsetsToDelete = nil
                        model.notesToDelete = nil
                    }
                )
            }
        }
    }
    
    func toggleSelection(_ note: Note) {
        if editMode == .inactive {
            navPath.append(note)
            return
        }
        if selection.contains(note) {
            selection.remove(note)
        } else {
            selection.insert(note)
        }
    }
}

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

#Preview {
    NotesListView(model: NotesListViewModel(username: "username", databaseService: PersistenceController.preview))
}
