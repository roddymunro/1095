//
//  CCCWidget.swift
//  1095 Widget
//
//  Created by Roddy Munro on 2021-06-10.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), daysToGo: 128)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), daysToGo: 128)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let request = NSFetchRequest<TravelEntry>(entityName: "TravelEntry")
        do {
            let entries = try managedObjectContext.fetch(request)
            let daysToGo = entries.map { $0.daysContribution }.reduce(1095, -)
            
            completion(Timeline(
                entries: [SimpleEntry(date: Date(), daysToGo: daysToGo)],
                policy: .after(Calendar.current.startOfDay(for: Date.tomorrow))
            ))
        } catch {
            completion(Timeline(
                entries: [SimpleEntry(date: Date(), daysToGo: 1095)],
                policy: .after(Calendar.current.startOfDay(for: Date.tomorrow))
            ))
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var daysToGo: Double
}

struct CCCWidgetEntryView : View {
    var entry: Provider.Entry
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.Canada-Citizenship-Countdown")!

    var body: some View {
        Group {
            if ud.bool(forKey: "isPaid") {
                content
            } else {
                notPaid
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
    
    var content: some View {
        VStack {
            if entry.daysToGo >= 0 {
                Text(entry.daysToGo.formatToWholeNumberOrOneDecimalPoint())
                    .font(.system(size: 64).weight(.black))
                    .minimumScaleFactor(0.4)
                Text("days to go")
                    .font(.title3.weight(.medium))
            } else {
                let daysToGo = -entry.daysToGo
                Text(daysToGo.formatToWholeNumberOrOneDecimalPoint())
                    .font(.system(size: 64).weight(.black))
                    .minimumScaleFactor(0.4)
                Text("days since you became eligible")
                    .font(.callout.weight(.medium))
            }
        }
    }
    
    var notPaid: some View {
        VStack(spacing: 4) {
            Text("Tip Required")
                .font(.system(size: 20).weight(.bold))
                .lineLimit(1)
            Text("Please leave a tip in the app to use the widget.")
                .font(.system(size: 14).weight(.medium))
        }.multilineTextAlignment(.center)
    }
}

@main
struct CCCWidget: Widget {
    
    private let coreDataHelper = CoreDataHelper.shared
    let kind: String = "CCCWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(context: coreDataHelper.context)) { entry in
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
