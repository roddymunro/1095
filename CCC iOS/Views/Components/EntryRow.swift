//
//  EntryRow.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-10.
//

import SwiftUI

struct EntryRow: View {
    
    let entry: TravelEntry
    
    private var daysContribution: Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: entry.startDate)
        let endDate = calendar.startOfDay(for: entry.endDate ?? Date())

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        if entry.entryStatus == .visitor {
            return (components.day ?? 0) / 2
        } else if entry.entryStatus == .permanentResident {
            return components.day ?? 0
        }
        return 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                Text("\(daysContribution)")
                    .minimumScaleFactor(0.4)
                    .allowsTightening(true)
                    .font(.largeTitle.weight(.bold))
                    .lineLimit(1)
                Text(daysContribution == 1 ? "day" : "days")
            }
                .frame(width: 48)
            VStack(alignment: .leading, spacing: 4) {
                if let endDate = entry.endDate {
                    Text("\(entry.startDate.formatted(date: .abbreviated, time: .omitted)) to \(endDate.formatted(date: .abbreviated, time: .omitted)) as a \(entry.entryStatus.rawValue)")
                        .fontWeight(.bold)
                } else {
                    Text("Since \(entry.startDate.formatted(date: .abbreviated, time: .omitted)) as a \(entry.entryStatus.rawValue)")
                        .fontWeight(.bold)
                }
                
                if !entry.details.isEmpty {
                    Text(entry.details)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
    }
}

struct EntryRow_Preview: PreviewProvider {
    
    static var previews: some View {
        List {
            EntryRow(entry: .init(
                id: "123",
                entryStatus: .permanentResident,
                startDate: Date(timeIntervalSince1970: 1612249552),
                details: "Been here for a while now."
            ))
            EntryRow(entry: .init(
                id: "123",
                entryStatus: .visitor,
                startDate: Date(timeIntervalSince1970: 1622249552),
                endDate: Date(timeIntervalSince1970: 1623249552),
                details: "Entered at this airport and left at another one."
            ))
        }
    }
}
