//
//  ContentView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI
import CoreData

struct NotesListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Note>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        NoteView()
                    } label: {
                        Text(item.title!)
                    }
                    .foregroundStyle(.white)
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color.contentBackground)
            }
            .scrollContentBackground(.hidden)
            .background(.viewBackground)

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: addItem) {
                        Text("Logout")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Note(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = "New Note"
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    NotesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
