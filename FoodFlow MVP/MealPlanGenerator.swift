import Foundation

class MealPlanGenerator {
    static let shared = MealPlanGenerator()
    
    private init() {}
    
    func generateWeeklyMealPlan(for preferences: UserPreferences) -> WeeklyMealPlan {
        let meals = (1...7).map { day in
            generateMeal(for: preferences, dayOfWeek: day)
        }
        
        return WeeklyMealPlan(meals: meals)
    }
    
    private func generateMeal(for preferences: UserPreferences, dayOfWeek: Int) -> Meal {
        let mealTemplates = getMealTemplates(for: preferences)
        let randomMeal = mealTemplates.randomElement()!
        
        return Meal(
            name: randomMeal.name,
            description: randomMeal.description,
            ingredients: randomMeal.ingredients,
            instructions: randomMeal.instructions,
            prepTime: randomMeal.prepTime,
            cookTime: randomMeal.cookTime,
            difficulty: randomMeal.difficulty,
            dietaryTags: randomMeal.dietaryTags,
            dayOfWeek: dayOfWeek
        )
    }
    
    private func getMealTemplates(for preferences: UserPreferences) -> [MealTemplate] {
        var templates: [MealTemplate] = []
        
        // Add meals based on dietary preferences
        switch preferences.dietaryPreference {
        case .vegetarian:
            templates += vegetarianMeals
        case .vegan:
            templates += veganMeals
        case .keto:
            templates += ketoMeals
        case .glutenFree:
            templates += glutenFreeMeals
        case .none:
            templates += allMeals
        }
        
        // Filter by cooking skill level
        return templates.filter { meal in
            switch preferences.cookingSkillLevel {
            case .easy:
                return meal.difficulty == .easy
            case .intermediate:
                return meal.difficulty == .easy || meal.difficulty == .intermediate
            case .advanced:
                return true
            }
        }
    }
    
    // MARK: - Meal Templates
    private struct MealTemplate {
        let name: String
        let description: String
        let ingredients: [String]
        let instructions: [String]
        let prepTime: Int
        let cookTime: Int
        let difficulty: CookingSkillLevel
        let dietaryTags: [DietaryPreference]
    }
    
    private var allMeals: [MealTemplate] {
        [
            MealTemplate(
                name: "Grilled Chicken Salad",
                description: "Fresh mixed greens with grilled chicken breast, cherry tomatoes, and balsamic vinaigrette",
                ingredients: ["Chicken breast", "Mixed greens", "Cherry tomatoes", "Cucumber", "Balsamic vinegar", "Olive oil", "Salt", "Pepper"],
                instructions: ["Season chicken with salt and pepper", "Grill chicken for 6-8 minutes per side", "Chop vegetables", "Mix salad ingredients", "Drizzle with balsamic vinaigrette"],
                prepTime: 10,
                cookTime: 15,
                difficulty: .easy,
                dietaryTags: [.none]
            ),
            MealTemplate(
                name: "Pasta Primavera",
                description: "Colorful vegetable pasta with light cream sauce",
                ingredients: ["Pasta", "Broccoli", "Carrots", "Bell peppers", "Heavy cream", "Parmesan cheese", "Garlic", "Olive oil"],
                instructions: ["Cook pasta according to package", "Sauté vegetables in olive oil", "Add cream and cheese", "Combine with pasta", "Season to taste"],
                prepTime: 15,
                cookTime: 20,
                difficulty: .intermediate,
                dietaryTags: [.vegetarian]
            )
        ]
    }
    
    private var vegetarianMeals: [MealTemplate] {
        [
            MealTemplate(
                name: "Quinoa Buddha Bowl",
                description: "Nutritious quinoa bowl with roasted vegetables and tahini dressing",
                ingredients: ["Quinoa", "Sweet potato", "Chickpeas", "Kale", "Tahini", "Lemon", "Olive oil", "Spices"],
                instructions: ["Cook quinoa", "Roast sweet potato and chickpeas", "Massage kale with olive oil", "Make tahini dressing", "Assemble bowl"],
                prepTime: 15,
                cookTime: 25,
                difficulty: .easy,
                dietaryTags: [.vegetarian, .vegan, .glutenFree]
            ),
            MealTemplate(
                name: "Caprese Pasta",
                description: "Fresh mozzarella, tomatoes, and basil with pasta",
                ingredients: ["Pasta", "Fresh mozzarella", "Cherry tomatoes", "Fresh basil", "Olive oil", "Balsamic glaze", "Salt", "Pepper"],
                instructions: ["Cook pasta", "Chop tomatoes and mozzarella", "Tear basil leaves", "Combine ingredients", "Drizzle with olive oil and balsamic"],
                prepTime: 10,
                cookTime: 15,
                difficulty: .easy,
                dietaryTags: [.vegetarian]
            )
        ]
    }
    
    private var veganMeals: [MealTemplate] {
        [
            MealTemplate(
                name: "Chickpea Curry",
                description: "Spicy chickpea curry with coconut milk and vegetables",
                ingredients: ["Chickpeas", "Coconut milk", "Onion", "Garlic", "Ginger", "Curry powder", "Spinach", "Rice"],
                instructions: ["Sauté onion, garlic, and ginger", "Add curry powder", "Add chickpeas and coconut milk", "Simmer for 15 minutes", "Add spinach", "Serve with rice"],
                prepTime: 10,
                cookTime: 20,
                difficulty: .intermediate,
                dietaryTags: [.vegan, .glutenFree]
            ),
            MealTemplate(
                name: "Vegan Buddha Bowl",
                description: "Colorful bowl with quinoa, roasted vegetables, and avocado",
                ingredients: ["Quinoa", "Broccoli", "Carrots", "Avocado", "Tahini", "Lemon", "Seeds", "Olive oil"],
                instructions: ["Cook quinoa", "Roast vegetables", "Make tahini sauce", "Slice avocado", "Assemble bowl", "Sprinkle with seeds"],
                prepTime: 15,
                cookTime: 20,
                difficulty: .easy,
                dietaryTags: [.vegan, .glutenFree]
            )
        ]
    }
    
    private var ketoMeals: [MealTemplate] {
        [
            MealTemplate(
                name: "Keto Chicken Alfredo",
                description: "Creamy alfredo sauce with chicken over zucchini noodles",
                ingredients: ["Chicken breast", "Heavy cream", "Parmesan cheese", "Zucchini", "Garlic", "Butter", "Salt", "Pepper"],
                instructions: ["Spiralize zucchini", "Cook chicken", "Make alfredo sauce", "Combine with zucchini noodles", "Season to taste"],
                prepTime: 15,
                cookTime: 20,
                difficulty: .intermediate,
                dietaryTags: [.keto, .glutenFree]
            ),
            MealTemplate(
                name: "Keto Salmon with Vegetables",
                description: "Baked salmon with roasted asparagus and cauliflower rice",
                ingredients: ["Salmon fillet", "Asparagus", "Cauliflower", "Olive oil", "Lemon", "Garlic", "Herbs", "Butter"],
                instructions: ["Season salmon", "Roast asparagus", "Make cauliflower rice", "Bake salmon", "Serve together"],
                prepTime: 10,
                cookTime: 25,
                difficulty: .easy,
                dietaryTags: [.keto, .glutenFree]
            )
        ]
    }
    
    private var glutenFreeMeals: [MealTemplate] {
        [
            MealTemplate(
                name: "Gluten-Free Stir Fry",
                description: "Colorful vegetable stir fry with tamari sauce and rice",
                ingredients: ["Rice", "Broccoli", "Bell peppers", "Carrots", "Tamari sauce", "Ginger", "Garlic", "Sesame oil"],
                instructions: ["Cook rice", "Chop vegetables", "Stir fry vegetables", "Add tamari sauce", "Serve over rice"],
                prepTime: 15,
                cookTime: 15,
                difficulty: .easy,
                dietaryTags: [.glutenFree, .vegan]
            ),
            MealTemplate(
                name: "Gluten-Free Pizza",
                description: "Cauliflower crust pizza with fresh toppings",
                ingredients: ["Cauliflower", "Eggs", "Cheese", "Tomato sauce", "Mozzarella", "Basil", "Olive oil", "Italian herbs"],
                instructions: ["Make cauliflower crust", "Bake crust", "Add sauce and toppings", "Bake until cheese melts"],
                prepTime: 20,
                cookTime: 30,
                difficulty: .intermediate,
                dietaryTags: [.glutenFree, .vegetarian]
            )
        ]
    }
} 