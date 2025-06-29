import SwiftUI

struct OnboardingView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDietaryPreference: DietaryPreference = .none
    @State private var selectedCookingSkillLevel: CookingSkillLevel = .easy
    @State private var showingMealPlan = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to FoodFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Let's personalize your meal planning experience")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Dietary Preferences Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dietary Preferences")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(DietaryPreference.allCases, id: \.self) { preference in
                            PreferenceCard(
                                title: preference.displayName,
                                isSelected: selectedDietaryPreference == preference,
                                action: {
                                    selectedDietaryPreference = preference
                                }
                            )
                        }
                    }
                }
                
                // Cooking Skill Level Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Cooking Skill Level")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        ForEach(CookingSkillLevel.allCases, id: \.self) { skillLevel in
                            PreferenceCard(
                                title: skillLevel.displayName,
                                isSelected: selectedCookingSkillLevel == skillLevel,
                                action: {
                                    selectedCookingSkillLevel = skillLevel
                                }
                            )
                        }
                    }
                }
                
                Spacer()
                
                // Generate Meal Plan Button
                Button(action: {
                    dataManager.userPreferences = UserPreferences(
                        dietaryPreference: selectedDietaryPreference,
                        cookingSkillLevel: selectedCookingSkillLevel
                    )
                    
                    let mealPlan = MealPlanGenerator.shared.generateWeeklyMealPlan(for: dataManager.userPreferences)
                    dataManager.currentMealPlan = mealPlan
                    
                    showingMealPlan = true
                }) {
                    HStack {
                        Text("Generate My Meal Plan")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $showingMealPlan) {
                MealPlanView()
            }
        }
    }
}

struct PreferenceCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OnboardingView()
} 