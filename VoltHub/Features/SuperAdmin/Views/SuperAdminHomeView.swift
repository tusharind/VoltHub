import SwiftUI

struct SuperAdminHomeView: View {
    @State private var isDrawerOpen = false
    @State private var selectedSection: SuperAdminSection = .dashboard
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { withAnimation { isDrawerOpen.toggle() } }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Super Admin Portal")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell.badge.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color(red: 0.2, green: 0.5, blue: 0.8))
                
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
            NationalDashboardView()
        case .districts:
            DistrictsOverviewView()
        case .states:
            StatesPerformanceView()
        case .districtHeads:
            DistrictHeadsManagementView()
        case .reports:
            NationalReportsView()
        }
    }
    
    private var drawer: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Super Admin")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("India Head")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 4) {
                    SuperAdminMenuItem(
                        icon: "chart.bar.xaxis",
                        text: "National Dashboard",
                        isSelected: selectedSection == .dashboard
                    ) {
                        selectedSection = .dashboard
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    SuperAdminMenuItem(
                        icon: "building.2.fill",
                        text: "Districts",
                        isSelected: selectedSection == .districts
                    ) {
                        selectedSection = .districts
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    SuperAdminMenuItem(
                        icon: "map.fill",
                        text: "States Performance",
                        isSelected: selectedSection == .states
                    ) {
                        selectedSection = .states
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    SuperAdminMenuItem(
                        icon: "person.3.fill",
                        text: "District Heads",
                        isSelected: selectedSection == .districtHeads
                    ) {
                        selectedSection = .districtHeads
                        withAnimation { isDrawerOpen = false }
                    }
                    
                    SuperAdminMenuItem(
                        icon: "doc.text.fill",
                        text: "National Reports",
                        isSelected: selectedSection == .reports
                    ) {
                        selectedSection = .reports
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

struct SuperAdminMenuItem: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
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
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8))
                        .frame(width: 8, height: 8)
                }
            }
            .foregroundColor(isSelected ? Color(red: 0.2, green: 0.5, blue: 0.8) : Color(red: 0.3, green: 0.4, blue: 0.5))
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(isSelected ? Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1) : Color.clear)
        }
    }
}

enum SuperAdminSection {
    case dashboard
    case districts
    case states
    case districtHeads
    case reports
}

#Preview {
    SuperAdminHomeView()
}
