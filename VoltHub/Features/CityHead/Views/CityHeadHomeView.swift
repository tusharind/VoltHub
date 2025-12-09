import SwiftUI

struct CityHeadHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingDrawer = false
    @State private var selectedSection: CityHeadSection = .dashboard
    
    var body: some View {
        ZStack {
            NavigationView {
                mainContent
                    .navigationTitle(selectedSection.rawValue)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation {
                                    showingDrawer.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(themeManager.current.primary)
                            }
                        }
                    }
            }
            
            if showingDrawer {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingDrawer = false
                        }
                    }
                
                HStack {
                    drawerMenu
                        .frame(width: 280)
                        .background(themeManager.current.background)
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
            CityHeadDashboardView()
        case .areas:
            AreasView()
        case .workers:
            WorkersView()
        case .reports:
            ReportsView()
        }
    }
    
    private var drawerMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.current.primary)
                
                Text("VoltHub")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("City Head Portal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .padding(.top, 20)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(CityHeadSection.allCases, id: \.self) { section in
                        CityHeadMenuItem(
                            section: section,
                            isSelected: selectedSection == section,
                            action: {
                                selectedSection = section
                                withAnimation {
                                    showingDrawer = false
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Logged in as")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("City Head")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Adani Client Team")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        }
    }
}

struct CityHeadMenuItem: View {
    let section: CityHeadSection
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? themeManager.current.primary : .secondary)
                    .frame(width: 24)
                
                Text(section.rawValue)
                    .font(.body)
                    .foregroundColor(isSelected ? themeManager.current.primary : .primary)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(themeManager.current.primary)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(isSelected ? themeManager.current.primary.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum CityHeadSection: String, CaseIterable {
    case dashboard = "Dashboard"
    case areas = "Areas"
    case workers = "Workers"
    case reports = "Reports"
    
    var icon: String {
        switch self {
        case .dashboard:
            return "chart.bar.fill"
        case .areas:
            return "map.fill"
        case .workers:
            return "person.3.fill"
        case .reports:
            return "doc.text.fill"
        }
    }
}

#Preview {
    CityHeadHomeView()
        .environmentObject(ThemeManager())
}
