# FoodFlow MVP

<img width="1920" height="1080" alt="foodflow-announce" src="https://github.com/user-attachments/assets/fc8fdeb1-326a-4048-aa34-6e8769aada62" />



A simple, personalized AI-generated weekly meal-planning iOS app built with SwiftUI.

## 🎯 Goal

Provide users with a simple, personalized meal-planning experience based on their dietary preferences and cooking skills.

## 👥 Target Audience

- Everyday users with limited cooking skills
- Users seeking convenient, personalized meal planning

## ✨ Core Features

### 1. User Onboarding
- Simple onboarding screen with selection of:
  - **Dietary Preferences**: Vegetarian, Vegan, Keto, Gluten-Free, No Restrictions
  - **Cooking Skill Level**: Easy, Intermediate, Advanced
- Preferences stored locally using UserDefaults

### 2. Weekly Meal Plan Generation
- Automatically generates a weekly meal plan (7 days, 1 meal per day)
- Meals filtered by user dietary preferences and skill level
- Each meal includes:
  - Recipe name and description
  - Complete ingredient list
  - Step-by-step cooking instructions
  - Prep and cook times
  - Difficulty level
  - Dietary tags

### 3. Meal Details
- Detailed view for each meal with:
  - Full recipe instructions
  - Ingredient quantities
  - Cooking time breakdown
  - Difficulty indicators
  - Dietary compliance tags

### 4. Settings & Customization
- View current preferences
- Generate new meal plans
- Reset all data
- Update preferences

## 🛠 Technical Stack

- **Framework**: SwiftUI
- **Language**: Swift
- **Data Storage**: UserDefaults (local storage)
- **Architecture**: MVVM with ObservableObject
- **Minimum iOS Version**: iOS 15.0+

## 📱 App Structure

```
FoodFlow MVP/
├── Models.swift              # Data models for preferences and meals
├── DataManager.swift         # Local data management
├── MealPlanGenerator.swift   # Meal plan generation logic
├── OnboardingView.swift      # User onboarding interface
├── MealPlanView.swift        # Weekly meal plan display
├── MealDetailView.swift      # Individual meal details
├── SettingsView.swift        # App settings and preferences
├── ContentView.swift         # Main app coordinator
└── FoodFlow_MVPApp.swift     # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 15.0+ deployment target
- macOS 12.0 or later

### Installation
1. Clone the repository
2. Open `FoodFlow MVP.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

## 📋 Success Criteria

✅ **Users can successfully complete onboarding within 30 seconds**
- Simple, intuitive interface
- Clear preference selection
- One-tap meal plan generation

✅ **Users immediately receive a relevant meal plan based on their preferences**
- Personalized meal selection
- Dietary restriction compliance
- Skill-appropriate recipes

✅ **Users clearly understand and can follow displayed recipes**
- Step-by-step instructions
- Clear ingredient lists
- Time estimates
- Difficulty indicators

## 🔮 Future Enhancements

- OpenAI API integration for dynamic meal generation
- Recipe sharing capabilities
- Shopping list generation
- Nutritional information
- Meal plan export/import
- Social features and ratings
- Recipe photos and videos

## 📄 License

This project is created as an MVP for demonstration purposes.

## 🤝 Contributing

This is an MVP project. For future iterations, contributions would be welcome for:
- Bug fixes
- Feature enhancements
- UI/UX improvements
- Performance optimizations

---

**Built with ❤️ using SwiftUI** 
