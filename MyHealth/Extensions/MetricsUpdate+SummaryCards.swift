//
//  MetricsUpdate+SummaryCards.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public extension MetricsUpdate {
    func statItems() -> [(title: String, value: String)] {
        let readings = (heartRateSummary?.latest.map { [$0] } ?? []) + (heartRateSummary?.previous ?? [])
        let latestBpm = heartRateSummary?.latest?.bpm
        let maxBpm = readings.map(\.bpm).max()
        let minBpm = readings.map(\.bpm).min()
        let restingBpm = restingHeartRateSummary?.latest?.averageBpm
        let rangeValue: String
        if let minBpm, let maxBpm {
            rangeValue = "\(formatNumber(minBpm))–\(formatNumber(maxBpm)) bpm"
        } else {
            rangeValue = "—"
        }
        return [
            ("Average HR", latestBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("Peak HR", maxBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("Resting HR", restingBpm.map { "\(formatNumber($0)) bpm" } ?? "—"),
            ("HR Range", rangeValue)
        ]
    }

    func insights() -> [(title: String, detail: String)] {
        var items: [(String, String)] = []
        if restingHeartRateSummary?.latest != nil {
            items.append(("Resting heart rate", "Latest resting heart rate has been recorded for today."))
        }
        if stepsSummary?.latest != nil {
            items.append(("Steps", "Step count data is available for today."))
        }
        if items.isEmpty {
            items.append(("No insights yet", "Connect Health to see personalized trends."))
        }
        return items
    }

    func summaryCards() -> [MetricsSummaryCard] {
        var cards: [MetricsSummaryCard] = []

        let latestStepsCount = stepsSummary?.latest?.count
        let previousStepsCount = stepsSummary?.previous.first?.count
        let latestFlightsCount = flightsSummary?.latest?.count
        let previousFlightsCount = flightsSummary?.previous.first?.count
        let latestStandCount = standHoursSummary?.latest?.count
        let previousStandCount = standHoursSummary?.previous.first?.count

        cards.append(
            summaryCard(
                category: .heartRate,
                latestValue: heartRateSummary?.latest?.bpm,
                previousValue: heartRateSummary?.previous.first?.bpm,
                unit: "bpm",
                subtitle: "Latest"
            )
        )
        cards.append(
            summaryCard(
                category: .cardioFitness,
                latestValue: cardioFitnessSummary?.latest?.vo2Max,
                previousValue: cardioFitnessSummary?.previous.first?.vo2Max,
                unit: "ml/kg/min",
                subtitle: "Latest",
                formatter: { formatNumber($0, decimals: 1) }
            )
        )
        cards.append(
            summaryCard(
                category: .heartRateVariability,
                latestValue: heartRateVariabilitySummary?.latest?.milliseconds,
                previousValue: heartRateVariabilitySummary?.previous.first?.milliseconds,
                unit: "ms",
                subtitle: "Latest"
            )
        )
        cards.append(
            summaryCard(
                category: .bloodOxygen,
                latestValue: bloodOxygenSummary?.latest?.percent,
                previousValue: bloodOxygenSummary?.previous.first?.percent,
                unit: "%",
                subtitle: "Latest"
            )
        )
        cards.append(
            summaryCard(
                category: .restingHeartRate,
                latestValue: restingHeartRateSummary?.latest?.averageBpm,
                previousValue: restingHeartRateSummary?.previous.first?.averageBpm,
                unit: "bpm",
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .steps,
                latestValue: latestStepsCount.map(Double.init),
                previousValue: previousStepsCount.map(Double.init),
                unit: nil,
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .flights,
                latestValue: latestFlightsCount.map(Double.init),
                previousValue: previousFlightsCount.map(Double.init),
                unit: nil,
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .standHours,
                latestValue: latestStandCount.map(Double.init),
                previousValue: previousStandCount.map(Double.init),
                unit: "hr",
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .exerciseMinutes,
                latestValue: exerciseMinutesSummary?.latest?.minutes,
                previousValue: exerciseMinutesSummary?.previous.first?.minutes,
                unit: "min",
                subtitle: "Today"
            )
        )
        cards.append(
            summaryCard(
                category: .calories,
                latestValue: caloriesSummary?.latest?.activeKilocalories,
                previousValue: caloriesSummary?.previous.first?.activeKilocalories,
                unit: "kcal",
                subtitle: "Active"
            )
        )
        cards.append(
            summaryCard(
                category: .sleep,
                latestValue: sleepSummary?.latest?.durationSeconds,
                previousValue: sleepSummary?.previous.first?.durationSeconds,
                unit: nil,
                subtitle: "Last night",
                formatter: formatDuration
            )
        )
        cards.append(
            summaryCard(
                category: .activityRings,
                value: activityRingsValue(for: activityRingsSummary?.latest),
                subtitle: "Today",
                trend: activityRingsTrend(latest: activityRingsSummary?.latest)
            )
        )

        return cards
    }
}

private extension MetricsUpdate {
    func summaryCard(
        category: MetricsCategory,
        latestValue: Double?,
        previousValue: Double?,
        unit: String?,
        subtitle: String,
        formatter: ((Double) -> String)? = nil
    ) -> MetricsSummaryCard {
        let value: String
        if let latestValue {
            if let formatter {
                value = formatter(latestValue)
            } else if let unit {
                value = formatNumber(latestValue)
            } else {
                value = formatNumber(latestValue)
            }
        } else {
            value = "—"
        }
        let trend = trendString(latest: latestValue, previous: previousValue, unit: unit)
        return MetricsSummaryCard(category: category, value: value, unit: unit, subtitle: subtitle, trend: trend)
    }

    func summaryCard(
        category: MetricsCategory,
        value: String,
        subtitle: String,
        trend: String
    ) -> MetricsSummaryCard {
        MetricsSummaryCard(category: category, value: value, unit: nil, subtitle: subtitle, trend: trend)
    }

    func trendString(latest: Double?, previous: Double?, unit: String?) -> String {
        guard let latest, let previous else { return "—" }
        let delta = latest - previous
        let symbol = delta >= 0 ? "▲" : "▼"
        let absDelta = abs(delta)
        let deltaText = formatNumber(absDelta)
        if let unit {
            return "\(symbol) \(deltaText) \(unit)"
        }
        return "\(symbol) \(deltaText)"
    }

    func formatNumber(_ value: Double) -> String {
        formatNumber(value, decimals: 0)
    }

    func formatNumber(_ value: Double, decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        let rounded = Double(round(pow(10, Double(decimals)) * value) / pow(10, Double(decimals)))
        return formatter.string(from: NSNumber(value: rounded)) ?? "\(rounded)"
    }

    func formatDuration(_ seconds: Double) -> String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    func activityRingsValue(for day: ActivityRingsDay?) -> String {
        guard let day else { return "—" }
        return "\(day.closedRingsCount)/3"
    }

    func activityRingsTrend(latest: ActivityRingsDay?) -> String {
        guard let latest else { return "—" }
        return latest.closedRingsText
    }
}
