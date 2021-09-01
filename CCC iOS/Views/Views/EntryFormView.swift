//
//  EntryFormView.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

struct EntryFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    var entryToEdit: TravelEntry?
    
    @State var id: UUID = UUID()
    @State var entryStatus: EntryStatus?
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var details: String = ""
    
    @State var ongoing: Bool = false
    
    @State var isSaving: Bool = false
    
    @FocusState private var focusedField: Field?
    
    init(entryToEdit: TravelEntry?=nil) {
        self.entryToEdit = entryToEdit
        
        if let entryToEdit = entryToEdit {
            self._id = State(initialValue: entryToEdit.id ?? UUID())
            self._entryStatus = State(initialValue: entryToEdit.entryStatus)
            self._startDate = State(initialValue: entryToEdit.startDate ?? Date())
            if let endDate = entryToEdit.endDate {
                self._endDate = State(initialValue: endDate)
            } else {
                self._ongoing = State(initialValue: true)
            }
            self._details = State(initialValue: entryToEdit.details ?? "")
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
                    leading: Button("Close", action: { dismiss() }),
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
        
        let newEntry = TravelEntry(context: viewContext)
        newEntry.id = id
        newEntry.entryStatus = entryStatus
        newEntry.startDate = startDate
        newEntry.endDate = ongoing ? nil : endDate
        newEntry.details = details
        viewContext.saveContext()
        
        resetForm()
    }
    
    private func updateEntryTapped() {
        guard let entryStatus = entryStatus else { return }
        
        viewContext.performAndWait {
            if let entry = entryToEdit {
                entry.id = id
                entry.entryStatus = entryStatus
                entry.startDate = startDate
                entry.endDate = ongoing ? nil : endDate
                entry.details = details
                viewContext.saveContext()
                dismiss()
            }
        }
    }
    
    private func resetForm() {
        id = UUID()
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
        EntryFormView()
    }
}
