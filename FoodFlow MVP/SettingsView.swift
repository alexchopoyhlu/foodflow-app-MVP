import SwiftUI

struct SettingsView: View {
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Current Preferences") {
                    HStack {
                        Text("Dietary Preference")
                        Spacer()
                        Text(dataManager.userPreferences.dietaryPreference.displayName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Cooking Skill Level")
                        Spacer()
                        Text(dataManager.userPreferences.cookingSkillLevel.displayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Actions") {
                    Button("Update Preferences") {
                        // Navigate back to onboarding
                        dataManager.clearData()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Generate New Meal Plan") {
                        let newMealPlan = MealPlanGenerator.shared.generateWeeklyMealPlan(for: dataManager.userPreferences)
                        dataManager.currentMealPlan = newMealPlan
                        dismiss()
                    }
                    .foregroundColor(.green)
                    
                    Button("Reset All Data") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("FoodFlow MVP")
                        Spacer()
                        Text("Personalized meal planning")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dataManager.clearData()
                    dismiss()
                }
            } message: {
                Text("This will clear all your preferences and meal plans. You'll need to complete onboarding again.")
            }
        }
    }
}

#Preview {
    SettingsView()
} 