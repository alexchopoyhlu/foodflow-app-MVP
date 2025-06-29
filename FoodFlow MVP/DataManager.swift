import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var userPreferences: UserPreferences {
        didSet {
            saveUserPreferences()
        }
    }
    
    @Published var currentMealPlan: WeeklyMealPlan? {
        didSet {
            saveCurrentMealPlan()
        }
    }
    
    private let userPreferencesKey = "userPreferences"
    private let currentMealPlanKey = "currentMealPlan"
    
    private init() {
        // Load user preferences
        if let data = UserDefaults.standard.data(forKey: userPreferencesKey),
           let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            self.userPreferences = preferences
        } else {
            self.userPreferences = UserPreferences()
        }
        
        // Load current meal plan
        if let data = UserDefaults.standard.data(forKey: currentMealPlanKey),
           let mealPlan = try? JSONDecoder().decode(WeeklyMealPlan.self, from: data) {
            self.currentMealPlan = mealPlan
        } else {
            self.currentMealPlan = nil
        }
    }
    
    private func saveUserPreferences() {
        if let encoded = try? JSONEncoder().encode(userPreferences) {
            UserDefaults.standard.set(encoded, forKey: userPreferencesKey)
        }
    }
    
    private func saveCurrentMealPlan() {
        if let mealPlan = currentMealPlan,
           let encoded = try? JSONEncoder().encode(mealPlan) {
            UserDefaults.standard.set(encoded, forKey: currentMealPlanKey)
        } else {
            UserDefaults.standard.removeObject(forKey: currentMealPlanKey)
        }
    }
    
    func hasCompletedOnboarding() -> Bool {
        return userPreferences.dietaryPreference != .none || userPreferences.cookingSkillLevel != .easy
    }
    
    func clearData() {
        userPreferences = UserPreferences()
        currentMealPlan = nil
        UserDefaults.standard.removeObject(forKey: userPreferencesKey)
        UserDefaults.standard.removeObject(forKey: currentMealPlanKey)
    }
} 