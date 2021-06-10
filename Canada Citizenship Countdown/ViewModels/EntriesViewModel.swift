//
//  EntriesViewModel.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import Foundation
import Combine

class EntriesViewModel: ObservableObject {
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.Canada-Citizenship-Countdown")
    
    @Published var entries: [TravelEntry] = []
    
    @Published var activeAlert: ActiveAlert?
    @Published var activeSheet: ActiveSheet?
    
    public var daysToGo: String {
        "\(calculateDaysToGo())"
    }
    
    init() {
        if let data = ud?.object(forKey: "travelEntries") as? Data {
            if let entries = try? JSONDecoder().decode([TravelEntry].self, from: data) {
                self.entries = entries
            }
        }
    }
    
    public func addEntry(_ entry: TravelEntry) {
        entries.append(entry)
        syncToUserDefaults()
    }
    
    public func updateEntry(_ entry: TravelEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            self.entries[idx] = entry
            self.syncToUserDefaults()
        }
    }
    
    public func removeEntry(_ entry: TravelEntry) {
        entries.removeAll { $0 == entry }
        syncToUserDefaults()
    }
    
    private func syncToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(entries) {
            self.ud?.set(encoded, forKey: "travelEntries")
            self.ud?.synchronize()
        }
    }
    
    public func showWelcome() {
        activeSheet = .welcome
    }
    
    public func addEntryTapped() {
        activeSheet = .addEntry
    }
    
    public func editEntryTapped(_ entry: TravelEntry) {
        activeSheet = .editEntry(entry)
    }
    
    private func calculateDaysToGo() -> Int {
        var daysToGo = 1095
        for entry in entries {
            let calendar = Calendar.current
            let startDate = calendar.startOfDay(for: entry.startDate)
            let endDate = calendar.startOfDay(for: entry.endDate ?? Date())

            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            
            daysToGo -= (components.day ?? 0) / entry.entryStatus.divider
        }
        return daysToGo
    }
    
    enum ActiveAlert { case error(_ error: ErrorModel) }
    enum ActiveSheet { case welcome, addEntry, editEntry(_ entry: TravelEntry) }
}
