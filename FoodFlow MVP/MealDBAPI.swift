import Foundation
import SwiftUI

struct MealDBMeal: Codable, Identifiable {
    let id: String
    let name: String
    let instructions: String
    let imageUrl: String
    let ingredients: [String]
    let measures: [String]
    let category: String?
    let area: String?
    let tags: [String]?
    let youtube: String?
    let source: String?
    
    var idMeal: String { id }
    
    // Helper to combine ingredients and measures
    var ingredientList: [String] {
        zip(ingredients, measures).map { ingredient, measure in
            if ingredient.isEmpty { return "" }
            return measure.isEmpty ? ingredient : "\(measure) \(ingredient)"
        }.filter { !$0.isEmpty }
    }
}

struct MealDBResponse: Codable {
    let meals: [MealDBMealRaw]
}

struct MealDBMealRaw: Codable {
    let idMeal: String?
    let strMeal: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strCategory: String?
    let strArea: String?
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    // Ingredients and measures
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
}

class MealDBAPI {
    static let shared = MealDBAPI()
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/random.php"
    
    func fetchRandomMeal(completion: @escaping (MealDBMeal?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(MealDBResponse.self, from: data),
                  let raw = decoded.meals.first else {
                completion(nil)
                return
            }
            let meal = MealDBAPI.parseMeal(from: raw)
            completion(meal)
        }.resume()
    }
    
    static func parseMeal(from raw: MealDBMealRaw) -> MealDBMeal? {
        let ingredients = [raw.strIngredient1, raw.strIngredient2, raw.strIngredient3, raw.strIngredient4, raw.strIngredient5, raw.strIngredient6, raw.strIngredient7, raw.strIngredient8, raw.strIngredient9, raw.strIngredient10, raw.strIngredient11, raw.strIngredient12, raw.strIngredient13, raw.strIngredient14, raw.strIngredient15, raw.strIngredient16, raw.strIngredient17, raw.strIngredient18, raw.strIngredient19, raw.strIngredient20].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let measures = [raw.strMeasure1, raw.strMeasure2, raw.strMeasure3, raw.strMeasure4, raw.strMeasure5, raw.strMeasure6, raw.strMeasure7, raw.strMeasure8, raw.strMeasure9, raw.strMeasure10, raw.strMeasure11, raw.strMeasure12, raw.strMeasure13, raw.strMeasure14, raw.strMeasure15, raw.strMeasure16, raw.strMeasure17, raw.strMeasure18, raw.strMeasure19, raw.strMeasure20].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return MealDBMeal(
            id: raw.idMeal ?? UUID().uuidString,
            name: raw.strMeal ?? "Unknown Meal",
            instructions: raw.strInstructions ?? "",
            imageUrl: raw.strMealThumb ?? "",
            ingredients: ingredients,
            measures: measures,
            category: raw.strCategory,
            area: raw.strArea,
            tags: raw.strTags?.components(separatedBy: ","),
            youtube: raw.strYoutube,
            source: raw.strSource
        )
    }
} 