import SwiftUI

struct MealPlanView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedMeal: Meal?
    @State private var showingMealDetail = false
    
    private let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("This Week's Plan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Text("Based on your \(dataManager.userPreferences.dietaryPreference.displayName.lowercased()) preferences and \(dataManager.userPreferences.cookingSkillLevel.displayName.lowercased()) cooking skills")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        
                        // Week heading
                        Text(getWeekHeading())
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    // Meal Plan Grid
                    if let mealPlan = dataManager.currentMealPlan {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                            ForEach(mealPlan.meals) { meal in
                                MealCard(meal: meal) {
                                    selectedMeal = meal
                                    showingMealDetail = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text("No meal plan generated yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Complete onboarding to get your personalized meal plan")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 60)
                    }
                    
                    // Regenerate Button
                    if dataManager.currentMealPlan != nil {
                        Button(action: {
                            let newMealPlan = MealPlanGenerator.shared.generateWeeklyMealPlan(for: dataManager.userPreferences)
                            dataManager.currentMealPlan = newMealPlan
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Generate New Meal Plan")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationDestination(isPresented: $showingMealDetail) {
                if let meal = selectedMeal {
                    MealDetailView(meal: meal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func getWeekHeading() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        
        let today = Date()
        let calendar = Calendar.current
        
        // Get the start of the current week (Monday)
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        // Get the end of the current week (Sunday)
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? today
        
        let startString = formatter.string(from: weekStart)
        let endString = formatter.string(from: weekEnd)
        
        return "\(startString) - \(endString)"
    }
}

struct MealCard: View {
    let meal: Meal
    let action: () -> Void
    
    private let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dayNames[meal.dayOfWeek - 1])
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(meal.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                            Text("\(meal.prepTime + meal.cookTime) min")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        Text(meal.difficulty.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(difficultyColor.opacity(0.2))
                            .foregroundColor(difficultyColor)
                            .cornerRadius(6)
                    }
                }
                
                // Description
                Text(meal.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Dietary Tags
                if !meal.dietaryTags.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(meal.dietaryTags, id: \.self) { tag in
                            Text(tag.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Arrow indicator
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var difficultyColor: Color {
        switch meal.difficulty {
        case .easy:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

#Preview {
    MealPlanView()
} 