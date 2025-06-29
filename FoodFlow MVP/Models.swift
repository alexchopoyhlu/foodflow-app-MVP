import Foundation

// MARK: - User Preferences
struct UserPreferences: Codable {
    var dietaryPreference: DietaryPreference
    var cookingSkillLevel: CookingSkillLevel
    
    init(dietaryPreference: DietaryPreference = .none, cookingSkillLevel: CookingSkillLevel = .easy) {
        self.dietaryPreference = dietaryPreference
        self.cookingSkillLevel = cookingSkillLevel
    }
}

enum DietaryPreference: String, CaseIterable, Codable {
    case none = "No Restrictions"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case keto = "Keto"
    case glutenFree = "Gluten-Free"
    
    var displayName: String {
        return rawValue
    }
}

enum CookingSkillLevel: String, CaseIterable, Codable {
    case easy = "Easy"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var displayName: String {
        return rawValue
    }
}

// MARK: - Meal Plan Models
struct WeeklyMealPlan: Codable, Identifiable {
    let id = UUID()
    let weekStartDate: Date
    let meals: [Meal]
    
    init(weekStartDate: Date = Date(), meals: [Meal] = []) {
        self.weekStartDate = weekStartDate
        self.meals = meals
    }
}

struct Meal: Codable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let ingredients: [String]
    let instructions: [String]
    let prepTime: Int // in minutes
    let cookTime: Int // in minutes
    let difficulty: CookingSkillLevel
    let dietaryTags: [DietaryPreference]
    let dayOfWeek: Int // 1-7 for Monday-Sunday
    
    init(name: String, description: String, ingredients: [String], instructions: [String], prepTime: Int, cookTime: Int, difficulty: CookingSkillLevel, dietaryTags: [DietaryPreference], dayOfWeek: Int) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.difficulty = difficulty
        self.dietaryTags = dietaryTags
        self.dayOfWeek = dayOfWeek
    }
} 