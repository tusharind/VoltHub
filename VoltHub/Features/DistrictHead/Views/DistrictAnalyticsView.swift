import SwiftUI

struct DistrictAnalyticsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var analytics = DistrictAnalytics.samples
    @State private var selectedPeriod = "This Month"

    private let periods = [
        "This Week", "This Month", "Last Month", "Quarter", "Year",
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Performance Analytics")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Menu {
                        ForEach(periods, id: \.self) { period in
                            Button(period) {
                                selectedPeriod = period
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedPeriod)
                                .font(.subheadline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(themeManager.current.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(themeManager.current.primary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 16
                ) {
                    ForEach(analytics) { analytic in
                        AnalyticCard(analytic: analytic)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Revenue Trend")
                        .font(.headline)

                    RevenueTrendChart()
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("City Comparison")
                        .font(.headline)

                    CityComparisonChart()
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Performing Cities")
                        .font(.headline)

                    VStack(spacing: 12) {
                        TopCityRow(
                            rank: 1,
                            cityName: "Ahmedabad East",
                            score: 92.5,
                            color: .green
                        )
                        TopCityRow(
                            rank: 2,
                            cityName: "Ahmedabad West",
                            score: 88.0,
                            color: Color(red: 0.2, green: 0.5, blue: 0.8)
                        )
                        TopCityRow(
                            rank: 3,
                            cityName: "Ahmedabad South",
                            score: 85.5,
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Insights")
                        .font(.headline)

                    VStack(spacing: 12) {
                        InsightCard(
                            icon: "arrow.up.right.circle.fill",
                            title: "Revenue Growth",
                            description:
                                "District revenue increased by 10.9% compared to last month",
                            color: .green
                        )

                        InsightCard(
                            icon: "exclamationmark.triangle.fill",
                            title: "Attention Required",
                            description:
                                "Ahmedabad North showing 28% below revenue target",
                            color: .orange
                        )

                        InsightCard(
                            icon: "star.fill",
                            title: "Best Performer",
                            description:
                                "Ahmedabad East achieved 109% of monthly target",
                            color: Color(red: 0.2, green: 0.5, blue: 0.8)
                        )

                        InsightCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Collection Efficiency",
                            description:
                                "Overall collection rate improved to 94.5%",
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct AnalyticCard: View {
    let analytic: DistrictAnalytics
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: analytic.icon)
                    .font(.title3)
                    .foregroundColor(themeManager.current.primary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: trendIcon)
                        .font(.caption)
                    Text(
                        String(format: "%.1f%%", abs(analytic.percentageChange))
                    )
                    .font(.caption)
                    .fontWeight(.semibold)
                }
                .foregroundColor(trendColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(trendColor.opacity(0.1))
                .cornerRadius(6)
            }

            Text(analytic.metric)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(analytic.currentValue)
                .font(.title3)
                .fontWeight(.bold)

            Text("vs \(analytic.previousValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private var trendIcon: String {
        switch analytic.trend {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }

    private var trendColor: Color {
        // For metrics like outages and complaints, down is good
        if analytic.metric.contains("Outage")
            || analytic.metric.contains("Complaint")
        {
            return analytic.trend == .down ? .green : .red
        }
        // For other metrics, up is good
        return analytic.trend == .up ? .green : .red
    }
}

struct RevenueTrendChart: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("₹15.75 Cr")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Current Month Revenue")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.caption)
                    Text("10.9%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.green)
            }

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<6) { index in
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                index == 5
                                    ? Color.green
                                    : Color(red: 0.2, green: 0.5, blue: 0.8)
                                        .opacity(0.6)
                            )
                            .frame(height: CGFloat.random(in: 60...120))
                    }
                }
            }
            .frame(height: 120)

            HStack {
                ForEach(["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], id: \.self)
                { month in
                    Text(month)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct CityComparisonChart: View {
    var body: some View {
        VStack(spacing: 12) {
            ComparisonBar(cityName: "East", value: 92.5, color: .green)
            ComparisonBar(
                cityName: "West",
                value: 88.0,
                color: Color(red: 0.2, green: 0.5, blue: 0.8)
            )
            ComparisonBar(cityName: "South", value: 85.5, color: .purple)
            ComparisonBar(cityName: "North", value: 72.0, color: .orange)
        }
    }
}

struct ComparisonBar: View {
    let cityName: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(cityName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 50, alignment: .leading)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(red: 0.94, green: 0.95, blue: 0.96))
                            .cornerRadius(4)

                        Rectangle()
                            .fill(color)
                            .frame(width: geometry.size.width * (value / 100))
                            .cornerRadius(4)
                    }
                }
                .frame(height: 24)

                Text(String(format: "%.1f", value))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 40, alignment: .trailing)
            }
        }
    }
}

struct TopCityRow: View {
    let rank: Int
    let cityName: String
    let score: Double
    let color: Color

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(cityName)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("Performance Score")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(String(format: "%.1f", score))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    DistrictAnalyticsView()
        .environmentObject(ThemeManager())
}
