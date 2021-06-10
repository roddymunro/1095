//
//  EntryFormView.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

struct EntryFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: EntriesViewModel
    
    var entryToEdit: TravelEntry?
    
    @State var id: String = UUID().uuidString
    @State var entryStatus: EntryStatus?
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var details: String = ""
    
    @State var ongoing: Bool = false
    
    @State var isSaving: Bool = false
    
    @FocusState private var focusedField: Field?
    
    init(viewModel: EntriesViewModel, entryToEdit: TravelEntry?=nil) {
        self.viewModel = viewModel
        self.entryToEdit = entryToEdit
        
        if let entryToEdit = entryToEdit {
            self._id = State(initialValue: entryToEdit.id)
            self._entryStatus = State(initialValue: entryToEdit.entryStatus)
            self._startDate = State(initialValue: entryToEdit.startDate)
            if let endDate = entryToEdit.endDate {
                self._endDate = State(initialValue: endDate)
            } else {
                self._ongoing = State(initialValue: true)
            }
            self._details = State(initialValue: entryToEdit.details)
        }
    }
    
    private var isNew: Bool {
        entryToEdit == nil
    }
    
    private var daysContribution: Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: startDate)
        let endDate = calendar.startOfDay(for: ongoing ? Date() : endDate)

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        if let entryStatus = entryStatus {
            return (components.day ?? 0) / entryStatus.divider
        } else {
            return 9
        }
    }
    
    @ViewBuilder var trailingBarButton: some View {
        if isSaving {
            ProgressView()
        } else {
            Button(isNew ? "Add" : "Save", action: isNew ? addEntryTapped : updateEntryTapped)
        }
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Travel Details")
                .navigationBarItems(
                    leading: Button("Cancel", action: { dismiss() }),
                    trailing: trailingBarButton
                )
        }
    }
    
    var content: some View {
        Form {
            Section(
                header: Text("Enter your Travel Details"),
                footer: Text("You will get \(daysContribution) day\(daysContribution == 1 ? "" : "s") from this entry")
            ) {
                StatusPicker(selection: $entryStatus)
                
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .font(.body.weight(.medium))
                
                Toggle("Ongoing Trip?", isOn: $ongoing)
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    .font(.body.weight(.medium))
                
                if !ongoing {
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .font(.body.weight(.medium))
                }
                
                FormField("Details", value: $details, placeholder: "Details about this trip")
                    .focused($focusedField, equals: .details)
                    .onSubmit(isNew ? addEntryTapped : updateEntryTapped)
                    .submitLabel(.done)
            }
        }
    }
    
    private func addEntryTapped() {
        guard let entryStatus = entryStatus else { return }
        
        viewModel.addEntry(.init(
            id: id,
            entryStatus: entryStatus,
            startDate: startDate,
            endDate: ongoing ? nil : endDate,
            details: details
        ))
        
        resetForm()
    }
    
    private func updateEntryTapped() {
        guard let entryStatus = entryStatus else { return }
        
        viewModel.updateEntry(.init(
            id: id,
            entryStatus: entryStatus,
            startDate: startDate,
            endDate: ongoing ? nil : endDate,
            details: details
        ))
        
        dismiss()
    }
    
    private func resetForm() {
        id = UUID().uuidString
        entryStatus = nil
        startDate = Date()
        endDate = Date()
        ongoing = false
        details = ""
    }
    
    enum Field { case details }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(viewModel: .init())
    }
}
