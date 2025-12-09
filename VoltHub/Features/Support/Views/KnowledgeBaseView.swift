import SwiftUI

struct KnowledgeBaseView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var articles = KnowledgeArticle.samples
    @State private var searchText = ""
    @State private var selectedCategory: ArticleCategory?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search articles...", text: $searchText)
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

            if filteredArticles.isEmpty {
                EmptyStateView(
                    icon: "book",
                    message: "No articles found",
                    description: "Try adjusting your search or filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredArticles) { article in
                            ArticleCard(article: article)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredArticles: [KnowledgeArticle] {
        var result = articles

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
                    || $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.views > $1.views }
    }
}

struct ArticleCard: View {
    let article: KnowledgeArticle
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.current.primary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)

                    Text(article.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor.opacity(0.2))
                        .foregroundColor(categoryColor)
                        .cornerRadius(6)
                }

                Spacer()
            }

            Divider()

            Text(article.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.secondary)
                    Text("\(article.views) views")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Updated \(article.lastUpdated, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button(action: {}) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Read More")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundColor(themeManager.current.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(themeManager.current.primary.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }

    private var categoryColor: Color {
        switch article.category {
        case .troubleshooting:
            return .red
        case .howTo:
            return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .policies:
            return .purple
        case .technical:
            return .orange
        }
    }
}

struct ArticleFilterChip: View {
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
                .background(
                    isSelected
                        ? themeManager.current.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(
                    isSelected ? themeManager.current.textOnPrimary : .primary
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    KnowledgeBaseView()
        .environmentObject(ThemeManager())
}
