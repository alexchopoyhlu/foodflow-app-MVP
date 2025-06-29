import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            
                            Text(meal.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                    
                    // Time and Difficulty Info
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("\(meal.prepTime + meal.cookTime) min")
                                .font(.caption)
                                .fontWeight(.medium)
                            Text("Total Time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "timer")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text("\(meal.prepTime) min")
                                .font(.caption)
                                .fontWeight(.medium)
                            Text("Prep Time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text("\(meal.cookTime) min")
                                .font(.caption)
                                .fontWeight(.medium)
                            Text("Cook Time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // Difficulty Badge
                    HStack {
                        Text(meal.difficulty.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(difficultyColor.opacity(0.2))
                            .foregroundColor(difficultyColor)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Dietary Tags
                if !meal.dietaryTags.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dietary Tags")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 8) {
                            ForEach(meal.dietaryTags, id: \.self) { tag in
                                Text(tag.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Ingredients Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(meal.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.blue)
                                    .padding(.top, 8)
                                
                                Text(ingredient)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Instructions Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "number")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(meal.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 16) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Color.blue)
                                    .cornerRadius(14)
                                
                                Text(instruction)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
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
    NavigationStack {
        MealDetailView(meal: Meal(
            name: "Sample Meal",
            description: "A delicious sample meal for testing",
            ingredients: ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
            instructions: ["Step 1", "Step 2", "Step 3"],
            prepTime: 10,
            cookTime: 20,
            difficulty: .easy,
            dietaryTags: [.vegetarian],
            dayOfWeek: 1
        ))
    }
} 