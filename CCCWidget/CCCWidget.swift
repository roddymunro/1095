//
//  CCCWidget.swift
//  CCCWidget
//
//  Created by Roddy Munro on 2021-06-10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.Canada-Citizenship-Countdown")
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), daysToGo: 128)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), daysToGo: 128)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if let data = ud?.object(forKey: "travelEntries") as? Data {
            if let entries = try? JSONDecoder().decode([TravelEntry].self, from: data) {
                let daysToGo = self.calculateDaysToGo(for: entries)
                
                completion(Timeline(
                    entries: [SimpleEntry(date: Date(), daysToGo: daysToGo)],
                    policy: .after(Calendar.current.startOfDay(for: Date.tomorrow))
                ))
            } else {
                completion(Timeline(
                    entries: [SimpleEntry(date: Date(), daysToGo: 1095)],
                    policy: .after(Calendar.current.startOfDay(for: Date.tomorrow))
                ))
            }
        } else {
            completion(Timeline(
                entries: [SimpleEntry(date: Date(), daysToGo: 1095)],
                policy: .after(Calendar.current.startOfDay(for: Date.tomorrow))
            ))
        }
    }
    
    private func calculateDaysToGo(for entries: [TravelEntry]) -> Int {
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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var daysToGo: Int
}

struct CCCWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\(entry.daysToGo)")
                .minimumScaleFactor(0.4)
                .font(Font.system(size: 72).weight(.black))
                .lineLimit(1)
            Text("days to go")
                .font(.title3.weight(.medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

@main
struct CCCWidget: Widget {
    let kind: String = "CCCWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CCCWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Citizenship Countdown Widget")
        .description("This widget will show the number of days remaining until you can apply for Canadian citizenship.")
        .supportedFamilies([.systemSmall])
    }
}

struct CCCWidget_Previews: PreviewProvider {
    static var previews: some View {
        CCCWidgetEntryView(entry: SimpleEntry(date: Date(), daysToGo: 128))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
