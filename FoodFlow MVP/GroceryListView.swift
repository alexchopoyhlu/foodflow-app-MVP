import SwiftUI

struct GroceryListView: View {
    @ObservedObject private var generator = MealPlanGenerator.shared
    @State private var checkedItems: Set<String> = []
    
    // Ingredient categories
    enum Category: String, CaseIterable, Identifiable {
        case fresh = "🥦 Fresh"
        case meatFish = "🥩 Meat & Fish"
        case dairyEggs = "🥛 Dairy & Eggs"
        case other = "🍲 Other"
        var id: String { rawValue }
    }
    
    // Categorize ingredient by simple keyword matching
    func categorize(_ ingredient: String) -> Category {
        let lower = ingredient.lowercased()
        if lower.contains("lettuce") || lower.contains("tomato") || lower.contains("onion") || lower.contains("carrot") || lower.contains("broccoli") || lower.contains("spinach") || lower.contains("apple") || lower.contains("banana") || lower.contains("potato") || lower.contains("avocado") || lower.contains("pepper") || lower.contains("cucumber") || lower.contains("herb") || lower.contains("lime") || lower.contains("lemon") || lower.contains("mushroom") {
            return .fresh
        }
        if lower.contains("chicken") || lower.contains("beef") || lower.contains("pork") || lower.contains("fish") || lower.contains("salmon") || lower.contains("tuna") || lower.contains("shrimp") || lower.contains("egg") || lower.contains("bacon") || lower.contains("turkey") {
            return .meatFish
        }
        if lower.contains("milk") || lower.contains("cheese") || lower.contains("yogurt") || lower.contains("cream") || lower.contains("butter") || lower.contains("egg") {
            return .dairyEggs
        }
        return .other
    }
    
    // Gather all unique ingredients from the week's meals
    var categorizedIngredients: [Category: [String]] {
        var dict: [Category: Set<String>] = [:]
        for meal in generator.weeklyMeals {
            for ingredient in meal.ingredientList {
                let trimmed = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { continue }
                let cat = categorize(trimmed)
                dict[cat, default: []].insert(trimmed)
            }
        }
        // Convert sets to sorted arrays
        var result: [Category: [String]] = [:]
        for cat in Category.allCases {
            result[cat] = Array(dict[cat] ?? []).sorted()
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Category.allCases) { category in
                    if let items = categorizedIngredients[category], !items.isEmpty {
                        Section(header: Text(category.rawValue)) {
                            ForEach(items, id: \.self) { ingredient in
                                HStack {
                                    Image(systemName: checkedItems.contains(ingredient) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(checkedItems.contains(ingredient) ? .green : .gray)
                                        .onTapGesture {
                                            toggle(ingredient)
                                        }
                                    Text(ingredient)
                                        .strikethrough(checkedItems.contains(ingredient))
                                        .foregroundColor(checkedItems.contains(ingredient) ? .secondary : .primary)
                                        .animation(.easeInOut, value: checkedItems)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggle(ingredient)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Grocery List")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func toggle(_ ingredient: String) {
        if checkedItems.contains(ingredient) {
            checkedItems.remove(ingredient)
        } else {
            checkedItems.insert(ingredient)
        }
    }
}

#Preview {
    GroceryListView()
} 