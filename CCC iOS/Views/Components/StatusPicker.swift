//
//  StatusPicker.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-10.
//

import SwiftUI

struct StatusPicker: View {
    
    @Binding var selection: EntryStatus?
    
    var body: some View {
        NavigationLink(destination: StatusPickerView(selection: $selection)) {
            HStack {
                Text("Entry Status").formLabelStyle()
                Spacer()
                Text(selection?.rawValue ?? "")
            }
        }.buttonStyle(.plain)
    }
}

private struct StatusPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selection: EntryStatus?
    
    var body: some View {
        Form {
            Section {
                ForEach(EntryStatus.allCases, id: \.self) { status in
                    Button(action: { selection = status; dismiss() }) {
                        VStack(alignment: .leading) {
                            Text(status.rawValue)
                            Text("Counts for \(status.daysContributionString) for each day spent inside Canada")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }.buttonStyle(.plain)
                }
            }
        }
            .navigationTitle("Select Entry Status")
            .navigationBarTitleDisplayMode(.inline)
    }
}
