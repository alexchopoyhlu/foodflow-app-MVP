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
    
    var emoji: String {
        switch self {
        case .none:
            return "🍽️"
        case .vegetarian:
            return "🥬"
        case .vegan:
            return "🌱"
        case .keto:
            return "🥑"
        case .glutenFree:
            return "🌾"
        }
    }
}

enum CookingSkillLevel: String, CaseIterable, Codable {
    case easy = "Easy"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var displayName: String {
        return rawValue
    }
    
    var description: String {
        switch self {
        case .easy:
            return "Simple recipes with basic techniques"
        case .intermediate:
            return "Some cooking experience required"
        case .advanced:
            return "Complex recipes for experienced cooks"
        }
    }
    
    var emoji: String {
        switch self {
        case .easy:
            return "👶"
        case .intermediate:
            return "👨‍🍳"
        case .advanced:
            return "🧑‍🍳"
        }
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