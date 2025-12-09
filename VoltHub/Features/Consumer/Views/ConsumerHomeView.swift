import SwiftUI

struct ConsumerHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingDrawer = false
    @State private var selectedSection: ConsumerSection = .bills
    
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
        case .bills:
            BillsView()
        case .newConnection:
            NewConnectionView()
        case .complaints:
            ComplaintsView()
        }
    }
    
    private var drawerMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.current.primary)
                
                Text("VoltHub")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Consumer Portal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .padding(.top, 20)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(ConsumerSection.allCases, id: \.self) { section in
                        DrawerMenuItem(
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
                
                Text("Consumer User")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("ACC123456")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        }
    }
}

struct DrawerMenuItem: View {
    let section: ConsumerSection
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

enum ConsumerSection: String, CaseIterable {
    case bills = "Bills"
    case newConnection = "New Connection"
    case complaints = "Complaints"
    
    var icon: String {
        switch self {
        case .bills:
            return "doc.text.fill"
        case .newConnection:
            return "bolt.badge.checkmark"
        case .complaints:
            return "exclamationmark.bubble.fill"
        }
    }
}

#Preview {
    ConsumerHomeView()
        .environmentObject(ThemeManager())
}