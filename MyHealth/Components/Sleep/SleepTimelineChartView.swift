//
//  SleepTimelineChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct SleepTimelineChartView: View {
    private let entries: [SleepEntry]
    private let colorProvider: (SleepEntryCategory) -> Color

    public init(entries: [SleepEntry], colorProvider: @escaping (SleepEntryCategory) -> Color) {
        self.entries = entries
        self.colorProvider = colorProvider
    }

    private struct TimelineBar: Identifiable {
        let id: UUID
        let entry: SleepEntry
        let lane: Double
    }

    public var body: some View {
        let lanes = Self.orderedCategories
        let laneMap = Dictionary(uniqueKeysWithValues: lanes.enumerated().map { ($0.element, Double($0.offset)) })
        let bars = entries.compactMap { entry -> TimelineBar? in
            guard let lane = laneMap[entry.category] else { return nil }
            return TimelineBar(id: entry.id, entry: entry, lane: lane)
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Timeline")
                .font(.headline)
            Chart(bars) { bar in
                RectangleMark(
                    xStart: .value("Start", bar.entry.startDate),
                    xEnd: .value("End", bar.entry.endDate),
                    yStart: .value("Stage", bar.lane - 0.18),
                    yEnd: .value("Stage", bar.lane + 0.18)
                )
                .foregroundStyle(colorProvider(bar.entry.category))
                .cornerRadius(3)
            }
            .chartYScale(domain: -0.5...(Double(lanes.count) - 0.5))
            .chartYAxis {
                AxisMarks(position: .leading, values: lanes.indices.map { Double($0) }) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let index = value.as(Double.self),
                           let intIndex = Int(exactly: index),
                           lanes.indices.contains(intIndex) {
                            Text(lanes[intIndex].title)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(date: .omitted, time: .shortened))
                        }
                    }
                }
            }
            .frame(height: 150)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    private static let orderedCategories: [SleepEntryCategory] = [
        .awake,
        .asleepREM,
        .asleepCore,
        .asleepDeep,
        .asleep,
        .inBed
    ]
}

#if DEBUG
#Preview {
    let now = Date()
    SleepTimelineChartView(
        entries: [
            SleepEntry(
                id: UUID(),
                startDate: now.addingTimeInterval(-8 * 3600),
                endDate: now.addingTimeInterval(-6 * 3600),
                category: .asleepDeep,
                isUserEntered: false,
                sourceName: "MyHealth",
                deviceName: "Apple Watch"
            ),
            SleepEntry(
                id: UUID(),
                startDate: now.addingTimeInterval(-6 * 3600),
                endDate: now.addingTimeInterval(-4 * 3600),
                category: .asleepCore,
                isUserEntered: false,
                sourceName: "MyHealth",
                deviceName: "Apple Watch"
            ),
            SleepEntry(
                id: UUID(),
                startDate: now.addingTimeInterval(-4 * 3600),
                endDate: now.addingTimeInterval(-2 * 3600),
                category: .asleepREM,
                isUserEntered: false,
                sourceName: "MyHealth",
                deviceName: "Apple Watch"
            )
        ],
        colorProvider: { _ in .indigo }
    )
    .padding()
}
#endif
