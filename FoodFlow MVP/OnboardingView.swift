import SwiftUI


struct OnboardingView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var currentPage = 0
    @State private var selectedDietaryPreference: DietaryPreference = .none
    @State private var selectedCookingSkillLevel: CookingSkillLevel = .easy
    @State private var selectedBudget: BudgetOption = .medium
    @State private var budgetPeriod: BudgetPeriod = .weekly
    @State private var showingMealPlan = false
    
    private let totalPages = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    // Page 1: Welcome
                    WelcomePage()
                        .tag(0)
                    
                    // Page 2: Dietary Preferences
                    DietaryPreferencesPage(selectedPreference: $selectedDietaryPreference)
                        .tag(1)
                    
                    // Page 3: Cooking Skill Level
                    CookingSkillPage(selectedSkillLevel: $selectedCookingSkillLevel)
                        .tag(2)
                    
                    // Page 4: Budget
                    BudgetPage(selectedBudget: $selectedBudget, budgetPeriod: $budgetPeriod)
                        .tag(3)
                    
                    // Page 5: All Set
                    AllSetPage()
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom Button Area
                VStack(spacing: 16) {
                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { page in
                            Circle()
                                .fill(page == currentPage ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Action Button
                    Button(action: handleButtonAction) {
                        HStack {
                            if currentPage == totalPages - 1 {
                                Text("Generate Meal Plans")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                            } else {
                                Text("Continue")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $showingMealPlan) {
                MainTabView()
            }
        }
    }
    
    private func handleButtonAction() {
        if currentPage < totalPages - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            // Generate meal plan and navigate
            dataManager.userPreferences = UserPreferences(
                dietaryPreference: selectedDietaryPreference,
                cookingSkillLevel: selectedCookingSkillLevel
            )
            
            MealPlanGenerator.shared.generateWeeklyMealPlan { _ in
                // Optionally handle completion, e.g., update UI or state
            }
            
            showingMealPlan = true
        }
    }
}

// MARK: - Page Views

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("FoodFlow")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Your Personal Meal Planning Assistant")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct DietaryPreferencesPage: View {
    @Binding var selectedPreference: DietaryPreference
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("What's your dietary preference?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("We'll customize your meal plans based on your dietary needs")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            VStack(spacing: 16) {
                ForEach(DietaryPreference.allCases, id: \.self) { preference in
                    PreferenceCardWithEmoji(
                        emoji: preference.emoji,
                        title: preference.displayName,
                        isSelected: selectedPreference == preference,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedPreference = preference
                            }
                        }
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
    }
}

struct CookingSkillPage: View {
    @Binding var selectedSkillLevel: CookingSkillLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("What's your cooking skill level?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("We'll adjust recipe complexity to match your experience")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            VStack(spacing: 16) {
                ForEach(CookingSkillLevel.allCases, id: \.self) { skillLevel in
                    PreferenceCardWithEmoji(
                        emoji: skillLevel.emoji,
                        title: skillLevel.displayName,
                        subtitle: skillLevel.description,
                        isSelected: selectedSkillLevel == skillLevel,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedSkillLevel = skillLevel
                            }
                        }
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
    }
}

struct BudgetPage: View {
    @Binding var selectedBudget: BudgetOption
    @Binding var budgetPeriod: BudgetPeriod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("What's your budget?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("We'll suggest meals that fit your budget")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            // Budget Period Selector (moved above budget options)
            VStack(alignment: .leading, spacing: 16) {
                Text("Budget Period")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    ForEach(BudgetPeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                budgetPeriod = period
                            }
                        }) {
                            Text(period.displayName)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(budgetPeriod == period ? .white : .primary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(budgetPeriod == period ? Color.blue : Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(budgetPeriod == period ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .scaleEffect(budgetPeriod == period ? 1.05 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: budgetPeriod)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            VStack(spacing: 16) {
                ForEach(BudgetOption.allCases, id: \.self) { budget in
                    PreferenceCardWithEmoji(
                        emoji: budget.emoji,
                        title: budget.getDisplayTitle(for: budgetPeriod),
                        subtitle: budget.description,
                        isSelected: selectedBudget == budget,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedBudget = budget
                            }
                        }
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
    }
}

struct AllSetPage: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.green)
                
                VStack(spacing: 16) {
                    Text("You're All Set!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("We're ready to create your personalized weekly meal plan")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Supporting Views

struct PreferenceCardWithEmoji: View {
    let emoji: String
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(emoji: String, title: String, subtitle: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.emoji = emoji
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.title)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .scaleEffect(isSelected ? 1.0 : 0.8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Models

enum BudgetOption: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case unlimited = "Unlimited"
    
    var displayName: String {
        return rawValue
    }
    
    func getDisplayTitle(for period: BudgetPeriod) -> String {
        switch self {
        case .low:
            return period == .weekly ? "Low (£10-£20)" : "Low (£40-£80)"
        case .medium:
            return period == .weekly ? "Medium (£20-£40)" : "Medium (£80-£160)"
        case .high:
            return period == .weekly ? "High (£40-£70)" : "High (£160-£280)"
        case .unlimited:
            return "Unlimited (∞)"
        }
    }
    
    var description: String {
        switch self {
        case .low:
            return "Budget-friendly options"
        case .medium:
            return "Balanced quality and cost"
        case .high:
            return "Premium ingredients"
        case .unlimited:
            return "No budget constraints"
        }
    }
    
    var emoji: String {
        switch self {
        case .low:
            return "💰"
        case .medium:
            return "💳"
        case .high:
            return "💎"
        case .unlimited:
            return "🏆"
        }
    }
}

enum BudgetPeriod: String, CaseIterable, Codable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var displayName: String {
        return rawValue
    }
}

#Preview {
    OnboardingView()
} 
