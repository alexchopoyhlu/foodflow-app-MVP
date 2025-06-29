import Foundation
import SwiftUI

class MealPlanGenerator: ObservableObject {
    static let shared = MealPlanGenerator()
    
    @Published var weeklyMeals: [MealDBMeal] = []
    @Published var isLoading: Bool = false
    
    private init() {}
    
    func generateWeeklyMealPlan(completion: @escaping ([MealDBMeal]) -> Void) {
        isLoading = true
        var meals: [MealDBMeal] = []
        let group = DispatchGroup()
        for _ in 1...7 {
            group.enter()
            MealDBAPI.shared.fetchRandomMeal { meal in
                if let meal = meal {
                    meals.append(meal)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.weeklyMeals = meals
            self.isLoading = false
            completion(meals)
        }
    }
} 