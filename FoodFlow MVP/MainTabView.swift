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
            ScrollView {
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct ChatView: View {
    @Binding var showingProfile: Bool
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hello Alex!\nHow can I help you today?", isFromAI: true)
    ]
    @State private var userInput: String = ""
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                // Chat messages
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(messages) { message in
                            HStack(alignment: .bottom, spacing: 8) {
                                if message.isFromAI {
                                    AIBubbleWithProfile(text: message.text)
                                    Spacer()
                                } else {
                                    Spacer()
                                    ChatBubble(text: message.text, isFromAI: false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                // Input bar
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $userInput)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    Button(action: { /* Camera action */ }) {
                        Image(systemName: "camera")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct AIBubbleWithProfile: View {
    let text: String
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 28, height: 28)
                Text("AI")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            ChatBubble(text: text, isFromAI: true)
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromAI: Bool
}

struct ChatBubble: View {
    let text: String
    let isFromAI: Bool
    var body: some View {
        Text(text)
            .padding(14)
            .background(isFromAI ? Color(.systemGray6) : Color.blue.opacity(0.8))
            .foregroundColor(isFromAI ? .primary : .white)
            .cornerRadius(16)
            .frame(maxWidth: 280, alignment: isFromAI ? .leading : .trailing)
    }
}

struct ProfileView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingSettings = false
    @State private var selectedTab = 0 // 0: Journal, 1: Favorites
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    HStack(alignment: .center, spacing: 16) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, Alex")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    // Replace the custom segmented control with this:
                    Picker("Section", selection: $selectedTab) {
                        Text("Journal").tag(0)
                        Text("Favourites").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)

                    // Weekly Progress Card
                    WeeklyStatsView()

                    // Latest Measurements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Latest Measurements")
                            .font(.title3)
                            .fontWeight(.bold)
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Weight")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                                        Text("72.4")
                                            .font(.system(size: 30, weight: .bold))
                                        Text("Kg")
                                            .font(.title3)
                                            .foregroundColor(.secondary)
                                    }
                                    Text("21% Fat Mass")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                // Placeholder for line chart
                                LineChartView(data: [72.8, 72.6, 72.5, 72.3, 72.4, 72.2, 72.1, 72.0, 71.9, 71.8])
                                    .frame(width: 120, height: 48)
                            }
                            Button(action: {}) {
                                Text("Track new weight")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.purple)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(18)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(.label).opacity(0.45), lineWidth: 2))
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemBackground)))
                    }
                    .padding(.horizontal, 8)

                    // Calories Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Calories")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack(alignment: .center, spacing: 18) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("1,548")
                                    .font(.system(size: 30, weight: .bold))
                                HStack(spacing: 6) {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 10))
                                    Text("89% Goal")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            // Placeholder for bar chart
                            BarChartView(data: [0.7, 0.8, 0.9, 0.6, 0.95, 0.8, 0.89, 0.92, 0.85, 0.7, 0.8, 0.9])
                                .frame(width: 120, height: 48)
                        }
                    }
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color(.label).opacity(0.45), lineWidth: 2))
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemBackground)))
                    .padding(.horizontal, 8)

                    

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
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// Replace the LineChartView implementation with this:
struct LineChartView: View {
    var data: [Double]
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let maxY = (data.max() ?? 1)
            let minY = (data.min() ?? 0)
            let yRange = maxY - minY == 0 ? 1 : maxY - minY
            let points: [CGPoint] = data.enumerated().map { i, value in
                let x = width * CGFloat(i) / CGFloat(data.count - 1)
                let y = height - ((CGFloat(value - minY) / CGFloat(yRange)) * height)
                return CGPoint(x: x, y: y)
            }
            ZStack {
                // Line
                Path { path in
                    guard points.count > 1 else { return }
                    path.move(to: points[0])
                    for pt in points.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                // Dots
                ForEach(0..<points.count, id: \ .self) { i in
                    Circle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(width: 10, height: 10)
                        .position(points[i])
                }
            }
        }
    }
}

// Simple placeholder bar chart
struct BarChartView: View {
    var data: [Double]
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width / CGFloat(data.count)
            let maxVal = (data.max() ?? 1)
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(0..<data.count, id: \ .self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green.opacity(0.6))
                        .frame(width: width * 0.7, height: geo.size.height * CGFloat(data[i] / maxVal))
                }
            }
        }
    }
}

struct WeeklyStatsView: View {
    var calories: Int = 1284
    var fatPercent: Double = 0.29
    var proPercent: Double = 0.65
    var carbPercent: Double = 0.85
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.label).opacity(0.45), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemBackground)))
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Weekly Stats")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack(alignment: .center, spacing: 12) {
                    // Calories
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calories")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 6) {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.black)
                            Text("\(calories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .fixedSize()
                                .frame(minWidth: 60, alignment: .leading)
                        }
                    }
                    .layoutPriority(1)
                    Spacer()
                    // Rings
                    HStack(spacing: 12) {
                        StatRingView(percent: fatPercent, color: .yellow, label: "Fat")
                        StatRingView(percent: proPercent, color: .blue, label: "Pro")
                        StatRingView(percent: carbPercent, color: .purple, label: "Carb")
                    }
                }
            }
            .padding(22)
        }
        .frame(height: 140)
        .padding(.horizontal, 8)
    }
}

#Preview {
    MainTabView()
} 
