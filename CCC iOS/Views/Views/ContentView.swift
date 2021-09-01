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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TravelEntry.entity(), sortDescriptors: [])
    
    var entries: FetchedResults<TravelEntry>
    
    @State private var isShowingConfetti: Bool = false
    @State private var activeAlert: ActiveAlert?
    @State private var activeSheet: ActiveSheet?
    
    public var daysToGo: Int {
        var daysToGo = 1095
        for entry in entries {
            if let start = entry.startDate {
                let calendar = Calendar.current
                let startDate = calendar.startOfDay(for: start)
                let endDate = calendar.startOfDay(for: entry.endDate ?? Date())

                let components = calendar.dateComponents([.day], from: startDate, to: endDate)
                
                daysToGo -= (components.day ?? 0) / entry.entryStatus.divider
            }
        }
        return daysToGo
    }
    
    var body: some View {
        content
            .alert(using: $activeAlert) { alert in
                switch alert {
                    case .error(let error):
                        return Alert(title: Text(error.title), message: Text(error.message))
                }
            }
            .sheet(using: $activeSheet) { sheet in
                switch sheet {
                    case .welcome:
                        WelcomeView()
                    case .addEntry:
                        EntryFormView()
                    case .editEntry(let entry):
                        EntryFormView(entryToEdit: entry)
                    case .settings:
                        SettingsView(viewModel: .init())
                }
            }
            .onAppear(perform: {
                if !welcomeShown {
                    activeSheet = .welcome
                    welcomeShown = true
                } else if shouldPlayConfetti && daysToGo <= 0 {
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
                    if entries.isEmpty {
                        noEntriesMessage
                    } else {
                        entriesList
                    }
                }
                
                Button(action: { activeSheet = .settings }, label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .font(.title3)
                        .padding()
                })
                
                ConfettiCelebrationView(isShowingConfetti: $isShowingConfetti, timeLimit: 3.0)
            }
        }
    }
    
    var countdown: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if daysToGo >= 0 {
                    Text("\(daysToGo)")
                        .font(.system(size: 72).weight(.black))
                    Text("days to go")
                        .font(.title3.weight(.medium))
                } else {
                    Text("\(-daysToGo)")
                        .font(.system(size: 72).weight(.black))
                    Text("days since you became eligible")
                        .font(.title3.weight(.medium))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: { activeSheet = .addEntry }) {
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
            ForEach(entries.sorted { $0.startDate! > $1.startDate! }) { entry in
                Button(action: { activeSheet = .editEntry(entry) }) {
                    EntryRow(entry: entry)
                }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewContext.delete([entry])
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        Button(action: {
                            activeSheet = .editEntry(entry)
                        }, label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }).tint(.orange)
                    }
            }
        }
    }
}

extension ContentView {
    enum ActiveAlert { case error(_ error: ErrorModel) }
    enum ActiveSheet { case welcome, addEntry, editEntry(_ entry: TravelEntry), settings }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
