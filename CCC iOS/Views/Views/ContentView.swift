//
//  ContentView.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("welcomeShown") var welcomeShown: Bool = false
    
    @ObservedObject var viewModel: EntriesViewModel
    
    var body: some View {
        content
            .alert(using: $viewModel.activeAlert) { alert in
                switch alert {
                    case .error(let error):
                        return Alert(title: Text(error.title), message: Text(error.message))
                }
            }
            .sheet(using: $viewModel.activeSheet) { sheet in
                switch sheet {
                    case .welcome:
                        WelcomeView()
                    case .addEntry:
                        EntryFormView(viewModel: viewModel)
                    case .editEntry(let entry):
                        EntryFormView(viewModel: viewModel, entryToEdit: entry)
                }
            }
            .onAppear(perform: {
                if !welcomeShown {
                    viewModel.showWelcome()
                    welcomeShown = true
                }
            })
    }
    
    var content: some View {
        GeometryReader { geo in
            VStack {
                countdown
                    .frame(height: geo.size.height / 3)
                if viewModel.entries.isEmpty {
                    noEntriesMessage
                } else {
                    entriesList
                }
            }
        }
    }
    
    var countdown: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Text(viewModel.daysToGo)
                    .font(Font.system(size: 72).weight(.black))
                Text("days to go")
                    .font(.title3.weight(.medium))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: viewModel.addEntryTapped) {
                Image(systemName: "plus")
            }
                .buttonStyle(.image)
                .padding()
            
        }
    }
    
    var noEntriesMessage: some View {
        VStack {
            Text("No Entries Found")
                .font(.largeTitle.weight(.bold))
            Text("Tap the '+' button to add your first entry.")
                .font(.title3.weight(.medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
    }
    
    var entriesList: some View {
        List {
            ForEach(viewModel.entries.sorted { $0.startDate > $1.startDate }) { entry in
                Button(action: { viewModel.editEntryTapped(entry) }) {
                    EntryRow(entry: entry)
                }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.removeEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        Button(action: {
                            viewModel.editEntryTapped(entry)
                        }, label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }).tint(.orange)
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EntriesViewModel())
    }
}
