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
    
    @FetchRequest(entity: TravelEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TravelEntry.startDate, ascending: false)])
    
    var entries: FetchedResults<TravelEntry>
    
    @State private var isShowingConfetti: Bool = false
    @State private var activeAlert: ActiveAlert?
    @State private var activeSheet: ActiveSheet?
    
    public var daysToGo: Double {
        entries.map { $0.daysContribution }.reduce(1095, -)
    }
    
    public var isOverlapped: Bool {
        var prevEntryDate: Date?
        for entry in entries {
            if let startDate = entry.startDate {
                if startDate > entry.endDate ?? Date() {
                    return true
                } else if let prevEntryDate = prevEntryDate {
                    if prevEntryDate < startDate || prevEntryDate < entry.endDate ?? Date() {
                        return true
                    }
                }
            }
            prevEntryDate = entry.endDate ?? Date()
        }
        return false
    }
    
    var earliestEligibleDate: Date? {
        Calendar.current.date(byAdding: .day, value: Int(daysToGo), to: Date())
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
                    
                    ZStack(alignment: .bottomTrailing) {
                        if entries.isEmpty {
                            noEntriesMessage
                        } else {
                            entriesList
                        }
                        
                        Button(action: { activeSheet = .addEntry }) {
                            Image(systemName: "plus")
                        }
                            .buttonStyle(.image)
                            .padding()
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
        VStack(spacing: 4) {
            if daysToGo >= 0 {
                VStack(spacing: 0) {
                    Text(daysToGo.formatToWholeNumberOrOneDecimalPoint())
                        .font(.system(size: 72).weight(.black))
                    Text("days to go")
                        .font(.title3.weight(.medium))
                }
                if let earliestEligibleDate = earliestEligibleDate {
                    Text("Earliest eligibility on \(earliestEligibleDate.formatted(date: .long, time: .omitted))")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 0) {
                    let daysToGo = -daysToGo
                    Text(daysToGo.formatToWholeNumberOrOneDecimalPoint())
                        .font(.system(size: 72).weight(.black))
                    Text("days since you became eligible")
                        .font(.title3.weight(.medium))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            if isOverlapped {
                WarningMessage(text: "A date overlap has been detected. The number you see above may be inaccurate until you correct the dates.")
            }
            
            ForEach(entries) { entry in
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
        .id(UUID())
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
