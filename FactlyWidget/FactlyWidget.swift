//
//  FactlyWidget.swift
//  FactlyWidget
//
//  Created by Moshkina on 07.10.2021.
//  Copyright © 2021 Joey Tawadrous. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), fact: "–", image: "canada")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var _: Bool = true
        let factFromServer: String = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: "lastFactQuestion") ?? "–snapshot"
        print("new fact: \(factFromServer)")
        
        let entry: SimpleEntry
        let date = Date()
        
        if context.isPreview {//&& hasFetchedFact{
            entry = SimpleEntry(date: date, fact: "Some interesting facts", image: "canada")
        } else {
            entry = SimpleEntry(date: date, fact: factFromServer, image: "canada")
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        
        let currentDate = Date()
        print("Curr Date: \(currentDate)")
        
        // Create a date that's 5 minutes in the future.
        let entryDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        print("Next Date: \(entryDate)")
        // Create a timeline entry for "now."
        let fact = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: "lastFactQuestion") ?? "Cannot load the new fact, sorry :("
        
        // Get & set random picture bg
        let pictures: [String] = ["australia", "canada", "fire", "forest", "iceland", "italy", "mountain", "mountains", "night", "night_house", "snow", "switzerland"]
        let randomPic = pictures[Int(arc4random_uniform(UInt32(pictures.count)))]
        
        let entry = SimpleEntry(date: currentDate, fact: fact, image: randomPic)
        entries.append(entry)

        // Create the timeline with the entry and a reload policy with the date
        // for the next update.
        let timeline = Timeline(entries: entries, policy: .after(entryDate))
        
        // Call the completion to pass the timeline to WidgetKit.
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let fact: String
    let image: String
}

struct FactlyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.fact).font(.title3).padding()
//            Image(entry.image)
        }
    }
}

@main
struct FactlyWidget: Widget {
    let kind: String = "FactlyWidget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FactlyWidgetEntryView(entry: entry)
                .background(Image(entry.image))
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FactlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        FactlyWidgetEntryView(entry: SimpleEntry(date: Date(), fact: "It's simple preview", image: "canada"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
