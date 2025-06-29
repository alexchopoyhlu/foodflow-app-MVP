import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Today Tab
            TodayView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            
            // Meal Plan Tab
            MealPlanView()
                .tabItem {
                    Image(systemName: "fork.knife")
                }
                .tag(1)
            
            // Grocery List Tab
            GroceryListView()
                .tabItem {
                    Image(systemName: "checklist")
                }
                .tag(2)
            
            // Chat Tab
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                }
                .tag(3)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .environmentObject(dataManager)
    }
}

// MARK: - Tab Views

struct TodayView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Today")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your daily meal plan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Today's Meals")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Your daily meal recommendations will appear here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GroceryListView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Grocery List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Ingredients for your meals")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "checklist")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Shopping List")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Your grocery list will be generated based on your meal plan")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("AI Nutritionist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Chat with your personal nutritionist")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple)
                    
                    Text("Chat Assistant")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Get personalized nutrition advice and meal suggestions")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your account and preferences")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("User Profile")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Manage your account and preferences")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Settings button
                Button(action: {
                    showingSettings = true
                }) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
} 