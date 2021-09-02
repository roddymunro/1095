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
    
    @State private var id: UUID = UUID()
    @State private var entryStatus: EntryStatus?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var details: String = ""
    @State private var ongoing: Bool = false
    @State private var isSaving: Bool = false
    
    @State private var activeAlert: ActiveAlert?
    
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
    
    private var fiveYearsAgo: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: calendar.date(byAdding: DateComponents(year: -5), to: Date())!)
    }
    
    private var daysContribution: Double {
        let calendar = Calendar.current
        let startDate = startDate >= fiveYearsAgo ? calendar.startOfDay(for: startDate) : fiveYearsAgo
        let endDate = calendar.startOfDay(for: ongoing ? Date() : endDate)

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        if let entryStatus = entryStatus {
            return Double(components.day ?? 0) * entryStatus.multiplier
        } else {
            return 0
        }
    }
    
    private var footerText: String {
        if entryStatus != nil {
            var base = "You will get \(daysContribution) day\(daysContribution == 1 ? "" : "s") from this entry"
            let calendar = Calendar.current
            if calendar.startOfDay(for: startDate) < fiveYearsAgo {
                base += "\n\nDays before \(fiveYearsAgo.formatted(date: .long, time: .omitted)) will not be counted."
            }
            return base
        } else {
            return "Select an Entry Status to see how many days will count"
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
                .alert(using: $activeAlert) { alert in
                    switch alert {
                        case .error(let error):
                            return .errorAlert(error)
                    }
                }
        }
    }
    
    var content: some View {
        Form {
            Section(
                header: Text("Enter your Travel Details"),
                footer: Text(footerText)
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
    
    private func performValidation() throws {
        guard entryStatus != nil else { throw ValidationError.noEntryStatus }
        guard startDate < endDate else { throw ValidationError.startAfterEnd }
        guard startDate < Date() else { throw ValidationError.startAfterToday }
        guard endDate < Date() else { throw ValidationError.endAfterToday }
    }
    
    private func addEntryTapped() {
        do {
            try performValidation()
            
            let newEntry = TravelEntry(context: viewContext)
            newEntry.id = id
            newEntry.entryStatus = entryStatus!
            newEntry.startDate = startDate
            newEntry.endDate = ongoing ? nil : endDate
            newEntry.details = details
            viewContext.saveContext()
            
            resetForm()
        } catch {
            self.activeAlert = .error(.init("Couldn't Add Entry", error))
        }
    }
    
    private func updateEntryTapped() {
        do {
            try performValidation()
            
            viewContext.performAndWait {
                if let entry = entryToEdit {
                    entry.id = id
                    entry.entryStatus = entryStatus!
                    entry.startDate = startDate
                    entry.endDate = ongoing ? nil : endDate
                    entry.details = details
                    viewContext.saveContext()
                    dismiss()
                }
            }
        } catch {
            self.activeAlert = .error(.init("Couldn't Save Entry", error))
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

extension EntryFormView {
    enum ActiveAlert { case error(_ error: ErrorModel) }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView()
    }
}
