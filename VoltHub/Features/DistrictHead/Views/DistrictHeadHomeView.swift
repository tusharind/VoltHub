import SwiftUI

struct DistrictHeadHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isDrawerOpen = false
    @State private var selectedSection: DistrictSection = .dashboard
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { withAnimation { isDrawerOpen.toggle() } }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(themeManager.current.textOnPrimary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .font(.title3)
                        Text("District Head Portal")
                            .font(.headline)
                    }
                    .foregroundColor(themeManager.current.textOnPrimary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.current.textOnPrimary)
                    }
                }
                .padding()
                .background(themeManager.current.primary)
                
                mainContent
            }
            
            if isDrawerOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isDrawerOpen = false
                        }
                    }
                
                HStack {
                    drawer
                        .transition(.move(edge: .leading))
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        switch selectedSection {
        case .dashboard:
            DashboardOverviewView()
        case .cities:
            CitiesPerformanceView()
        case .cityHeads:
            CityHeadsManagementView()
        case .reports:
            DistrictReportsView()
        case .analytics:
            DistrictAnalyticsView()
        }
    }
    
    private var drawer: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 40))
                    .foregroundColor(themeManager.current.primary)
                
                Text("District Head")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Ahmedabad District")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 4) {
                    DistrictMenuItem(
                        icon: "chart.bar.fill",
                        text: "Dashboard",
                        isSelected: selectedSection == .dashboard
                    ) {
                        selectedSection = .dashboard
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    DistrictMenuItem(
                        icon: "building.2.fill",
                        text: "Cities Performance",
                        isSelected: selectedSection == .cities
                    ) {
                        selectedSection = .cities
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    DistrictMenuItem(
                        icon: "person.3.fill",
                        text: "City Heads",
                        isSelected: selectedSection == .cityHeads
                    ) {
                        selectedSection = .cityHeads
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    DistrictMenuItem(
                        icon: "doc.text.fill",
                        text: "Reports",
                        isSelected: selectedSection == .reports
                    ) {
                        selectedSection = .reports
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    DistrictMenuItem(
                        icon: "chart.line.uptrend.xyaxis",
                        text: "Analytics",
                        isSelected: selectedSection == .analytics
                    ) {
                        selectedSection = .analytics
                        withAnimation { isDrawerOpen = false }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
            
            Divider()
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Logout")
                }
                .foregroundColor(.red)
                .padding()
            }
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
    }
}

struct DistrictMenuItem: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(text)
                    .font(.body)
                Spacer()
                if isSelected {
                    Circle()
                        .fill(themeManager.current.primary)
                        .frame(width: 8, height: 8)
                }
            }
            .foregroundColor(isSelected ? themeManager.current.primary : .primary)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(isSelected ? themeManager.current.primary.opacity(0.1) : Color.clear)
        }
    }
}

enum DistrictSection {
    case dashboard
    case cities
    case cityHeads
    case reports
    case analytics
}

#Preview {
    DistrictHeadHomeView()
        .environmentObject(ThemeManager())
}
