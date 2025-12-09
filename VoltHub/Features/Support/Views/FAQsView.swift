import SwiftUI

struct FAQsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var faqs = FAQ.samples
    @State private var searchText = ""
    @State private var selectedCategory: FAQCategory?
    @State private var expandedFAQs: Set<String> = []
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search FAQs...", text: $searchText)
                    .padding()
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            if filteredFAQs.isEmpty {
                EmptyStateView(
                    icon: "questionmark.circle",
                    message: "No FAQs found",
                    description: "Try adjusting your search or filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredFAQs) { faq in
                            FAQCard(
                                faq: faq,
                                isExpanded: expandedFAQs.contains(faq.id),
                                onToggle: {
                                    if expandedFAQs.contains(faq.id) {
                                        expandedFAQs.remove(faq.id)
                                    } else {
                                        expandedFAQs.insert(faq.id)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var filteredFAQs: [FAQ] {
        var result = faqs
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.question.localizedCaseInsensitiveContains(searchText) ||
                $0.answer.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
}

struct FAQCard: View {
    let faq: FAQ
    let isExpanded: Bool
    let onToggle: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onToggle) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(themeManager.current.primary)
                    
                    Text(faq.question)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Divider()
                
                Text(faq.answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Text(faq.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(themeManager.current.primary.opacity(0.2))
                        .foregroundColor(themeManager.current.primary)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill")
                            Text("Helpful")
                        }
                        .font(.caption)
                        .foregroundColor(themeManager.current.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct FAQFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? themeManager.current.primary : Color(red: 0.94, green: 0.95, blue: 0.96))
                .foregroundColor(isSelected ? themeManager.current.textOnPrimary : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    FAQsView()
        .environmentObject(ThemeManager())
}
