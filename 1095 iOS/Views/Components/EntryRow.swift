//
//  EntryRow.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-10.
//

import SwiftUI

struct EntryRow: View {
    
    let entry: TravelEntry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                Text(entry.daysContribution.formatToWholeNumberOrOneDecimalPoint())
                    .minimumScaleFactor(0.4)
                    .allowsTightening(true)
                    .font(.largeTitle.weight(.bold))
                    .lineLimit(1)
                Text(entry.daysContribution == 1 ? "day" : "days")
            }
                .frame(width: 48)
            VStack(alignment: .leading, spacing: 4) {
                if let startDate = entry.startDate {
                    if let endDate = entry.endDate {
                        Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) to \(endDate.formatted(date: .abbreviated, time: .omitted)) as a \(entry.entryStatus.rawValue)")
                            .fontWeight(.bold)
                    } else {
                        Text("Since \(startDate.formatted(date: .abbreviated, time: .omitted)) as a \(entry.entryStatus.rawValue)")
                            .fontWeight(.bold)
                    }
                }
                
                if let details = entry.details, !details.isEmpty {
                    Text(details)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
    }
}
