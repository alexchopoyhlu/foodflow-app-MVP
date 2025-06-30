import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    @State private var showingProfile = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Today Tab
                TodayView(showingProfile: $showingProfile)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .tag(0)
                
                // Meal Plan Tab
                MealPlanView(showingProfile: $showingProfile)
                    .tabItem {
                        VStack {
                            Image(systemName: "fork.knife")
                            Text("Plan")
                        }
                    }
                    .tag(1)
                
                // Grocery List Tab
                GroceryListView(showingProfile: $showingProfile)
                    .tabItem {
                        VStack {
                            Image(systemName: "checklist")
                            Text("List")
                        }
                    }
                    .tag(2)
                
                // Chat Tab
                ChatView(showingProfile: $showingProfile)
                    .tabItem {
                        VStack {
                            Image(systemName: "message.fill")
                            Text("Chat")
                        }
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .environmentObject(dataManager)
            
            // Blur effect overlay for tab bar
            VStack {
                Spacer()
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: 0)
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

// MARK: - Tab Views

struct TodayView: View {
    @Binding var showingProfile: Bool
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: -4) {
                        Text("Enjoy your Monday,")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Text("Alex")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    // Profile Icon
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Stats Rectangle
                TodayStatsView()
                
                Spacer()
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct ChatView: View {
    @Binding var showingProfile: Bool
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI Nutritionist")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Text("Chat with your personal nutritionist")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    // Profile Icon
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct ProfileView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Text("Your account and preferences")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
} 
