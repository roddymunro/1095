//
//  ContentView.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("welcomeShown") var welcomeShown: Bool = false
    @AppStorage("shouldPlayConfetti") var shouldPlayConfetti: Bool = true
    
    @State private var isShowingConfetti: Bool = false
    
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
                    case .settings:
                        SettingsView(viewModel: .init())
                }
            }
            .onAppear(perform: {
                if !welcomeShown {
                    viewModel.showWelcome()
                    welcomeShown = true
                } else if shouldPlayConfetti && viewModel.daysToGo <= 0 {
                    NotificationCenter.default.post(name: Notification.Name.playConfettiCelebration, object: Bool.self)
                }
            })
    }
    
    var content: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                VStack {
                    countdown
                        .frame(height: geo.size.height / 3)
                    if viewModel.entries.isEmpty {
                        noEntriesMessage
                    } else {
                        entriesList
                    }
                }
                
                Button(action: viewModel.openSettings, label: {
                    Image(systemName: "gear")
                }).padding()
                    .imageScale(.large)
                
                ConfettiCelebrationView(isShowingConfetti: $isShowingConfetti, timeLimit: 3.0)
            }
        }
    }
    
    var countdown: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if viewModel.daysToGo >= 0 {
                    Text("\(viewModel.daysToGo)")
                        .font(Font.system(size: 72).weight(.black))
                    Text("days to go")
                        .font(.title3.weight(.medium))
                } else {
                    Text("\(-viewModel.daysToGo)")
                        .font(Font.system(size: 72).weight(.black))
                    Text("days since you became eligible")
                        .font(.title3.weight(.medium))
                }
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
