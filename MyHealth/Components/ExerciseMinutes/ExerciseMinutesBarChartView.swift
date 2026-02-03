//
//  ExerciseMinutesBarChartView.swift
//  MyHealth
//
//  Created by Codex.
//

import Charts
import Models
import SwiftUI

public struct ExerciseMinutesBarChartView: View {
    private let days: [ExerciseMinutesDayDetail]
    private let window: ExerciseMinutesWindow

    public init(days: [ExerciseMinutesDayDetail], window: ExerciseMinutesWindow) {
        self.days = days
        self.window = window
    }

    public var body: some View {
        Group {
            if days.isEmpty {
                Text("No exercise minutes recorded.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Chart(sortedDays) { day in
                    BarMark(
                        x: .value("Date", day.date),
                        y: .value("Minutes", day.minutes)
                    )
                    .foregroundStyle(Color.green.gradient)
                }
                .chartXAxis {
                    AxisMarks(values: xAxisValues) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: xAxisFormat, centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 3))
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }
}

private extension ExerciseMinutesBarChartView {
    var sortedDays: [ExerciseMinutesDayDetail] {
        days.sorted { $0.date < $1.date }
    }

    var xAxisValues: AxisMarkValues {
        switch window {
        case .day:
            return .automatic(desiredCount: 4)
        case .week, .month, .sixMonths, .year:
            return .automatic(desiredCount: 5)
        }
    }

    var xAxisFormat: Date.FormatStyle {
        switch window {
        case .day:
            return .dateTime.hour().minute()
        case .week:
            return .dateTime.weekday(.abbreviated)
        case .month, .sixMonths, .year:
            return .dateTime.month().day()
        }
    }
}

#if DEBUG
#Preview {
    let days = (0..<7).map { offset in
        ExerciseMinutesDayDetail(
            date: Calendar.current.date(byAdding: .day, value: -offset, to: Date()) ?? Date(),
            minutes: Double(20 + offset * 3),
            goalMinutes: 30
        )
    }
    return ExerciseMinutesBarChartView(days: days, window: .week)
        .padding()
}
#endif
