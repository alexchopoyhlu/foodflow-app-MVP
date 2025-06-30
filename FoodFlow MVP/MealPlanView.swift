import SwiftUI
import UIKit

struct MealPlanView: View {
    @ObservedObject private var generator = MealPlanGenerator.shared
    @State private var selectedMeal: MealDBMeal?
    @State private var showingMealDetail = false
    @Binding var showingProfile: Bool
    @State private var isLoading = false
    @State private var selectedView: ViewType = .list
    @State private var selectedDate: Date? = Calendar.current.startOfDay(for: Date())
    @State private var favoriteMealIDs: Set<String> = []
    var calendarToMealSpacing: CGFloat = 16
    var profileTopSpacing: CGFloat = 20
    
    enum ViewType: String, CaseIterable, Identifiable {
        case list = "List"
        case calendar = "Calendar"
        var id: String { rawValue }
    }
    
    private let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    // Helper: Map meals to their date (assuming 1 meal per day, Mon-Sun of current week)
    private var mealsByDate: [Date: [MealDBMeal]] {
        guard !generator.weeklyMeals.isEmpty else { return [:] }
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        var dict: [Date: [MealDBMeal]] = [:]
        for (i, meal) in generator.weeklyMeals.prefix(7).enumerated() {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStart) {
                dict[calendar.startOfDay(for: date), default: []].append(meal)
            }
        }
        return dict
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("This Week's Plan")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                // Week heading
                                Text(getWeekHeading())
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .padding(.top, 4)
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
                        .padding(.top, profileTopSpacing)
                        .padding(.horizontal, 20)
                        
                        // Segmented Control
                        Picker("View Type", selection: $selectedView) {
                            ForEach(ViewType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 4)
                    }
                    if selectedView == .list {
                        if generator.isLoading {
                            ProgressView("Loading meals...")
                                .padding(.top, 40)
                        } else if !generator.weeklyMeals.isEmpty {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                                ForEach(Array(generator.weeklyMeals.enumerated()), id: \.element.id) { index, meal in
                                    MealCard(meal: meal, dayOfWeek: index + 1, isFavorite: favoriteMealIDs.contains(meal.id), toggleFavorite: {
                                        if favoriteMealIDs.contains(meal.id) {
                                            favoriteMealIDs.remove(meal.id)
                                        } else {
                                            favoriteMealIDs.insert(meal.id)
                                        }
                                    }) {
                                        selectedMeal = meal
                                        showingMealDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 60))
                                    .foregroundColor(.secondary)
                                
                                Text("No meal plan generated yet")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text("Tap below to generate your weekly meal plan")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        }
                    } else if selectedView == .calendar {
                        Spacer().frame(height: 65)
                        // Add spacing between segmented control and calendar
                        Spacer().frame(height: 55)
                        CalendarWrapper(selectedDate: $selectedDate, mealDates: Array(mealsByDate.keys))
                            .frame(height: 270)
                        Spacer().frame(height: 90)
                        VStack(spacing: 8) {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 28))
                                .foregroundColor(.secondary)
                            Text("Tap on dates with a dot to see")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Text("the meal for that day.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        // Show meal(s) for selected date
                        if let selectedDate = selectedDate,
                           let meals = mealsByDate[Calendar.current.startOfDay(for: selectedDate)], !meals.isEmpty {
                            // Sheet will be shown for selectedMeal
                        } else {
                            Text("No meal planned for this day.")
                                .foregroundColor(.secondary)
                                .padding(.top, 24)
                        }
                    }
                }
                
                // Blur effect overlay at the bottom
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: 0)
                        .allowsHitTesting(false)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .onAppear {
                if generator.weeklyMeals.isEmpty {
                    generator.generateWeeklyMealPlan { _ in }
                }
                // Automatically select today when switching to calendar view
                if selectedView == .calendar {
                    let today = Calendar.current.startOfDay(for: Date())
                    selectedDate = today
                    if let meals = mealsByDate[today], let firstMeal = meals.first {
                        selectedMeal = firstMeal
                    } else {
                        selectedMeal = nil
                    }
                }
            }
            .onChange(of: selectedDate) { newDate in
                if selectedView == .calendar, let newDate = newDate {
                    let day = Calendar.current.startOfDay(for: newDate)
                    if let meals = mealsByDate[day], let firstMeal = meals.first {
                        selectedMeal = firstMeal
                    } else {
                        selectedMeal = nil
                    }
                }
            }
            .sheet(item: $selectedMeal) { meal in
                MealDetailView_MealDB(meal: meal)
            }
        }
    }
    
    private func getWeekHeading() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        
        let today = Date()
        let calendar = Calendar.current
        
        // Get the start of the current week (Monday)
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        // Get the end of the current week (Sunday)
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? today
        
        let startString = formatter.string(from: weekStart)
        let endString = formatter.string(from: weekEnd)
        
        return "\(startString) - \(endString)"
    }
}

struct MealCard: View {
    let meal: MealDBMeal
    let dayOfWeek: Int
    var isFavorite: Bool
    var toggleFavorite: () -> Void
    let action: () -> Void
    
    private let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: action) {
                HStack(alignment: .top, spacing: 12) {
                    // Meal image
                    AsyncImage(url: URL(string: meal.imageUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 56, height: 56)
                                .cornerRadius(10)
                                .clipped()
                        } else if phase.error != nil {
                            Color.gray.frame(width: 56, height: 56).cornerRadius(10)
                        } else {
                            ProgressView().frame(width: 56, height: 56)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Header
                        Text(dayNames[dayOfWeek - 1])
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(meal.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        // Category/Area
                        HStack(spacing: 8) {
                            if let category = meal.category, !category.isEmpty {
                                Text(category)
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            if let area = meal.area, !area.isEmpty {
                                Text(area)
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    Spacer()
                    // Arrow indicator
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .padding(8)
            }
        }
    }
}

// MARK: - Meal Detail View for API Meals
struct MealDetailView_MealDB: View {
    let meal: MealDBMeal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: URL(string: meal.imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(16)
                                    .clipped()
                            } else if phase.error != nil {
                                Color.gray.frame(width: 80, height: 80).cornerRadius(16)
                            } else {
                                ProgressView().frame(width: 80, height: 80)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            if let category = meal.category, !category.isEmpty {
                                Text(category)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            if let area = meal.area, !area.isEmpty {
                                Text(area)
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // TikTok and Instagram Search Buttons
                VStack(alignment: .leading, spacing: 8) {
                    // TikTok Search Button
                    Button(action: {
                        let query = meal.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let tiktokURL = URL(string: "tiktok://search?q=\(query)")!
                        let safariURL = URL(string: "https://www.tiktok.com/search?q=\(query)")!
                        if UIApplication.shared.canOpenURL(tiktokURL) {
                            UIApplication.shared.open(tiktokURL)
                        } else {
                            UIApplication.shared.open(safariURL)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image("tiktok_logo")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text("Search on TikTok")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background(Color.black)
                        .cornerRadius(20)
                    }

                    // Instagram Search Button
                    Button(action: {
                        let query = meal.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let instagramURL = URL(string: "instagram://tag?name=\(query)")!
                        let safariURL = URL(string: "https://www.instagram.com/explore/tags/\(query)/")!
                        if UIApplication.shared.canOpenURL(instagramURL) {
                            UIApplication.shared.open(instagramURL)
                        } else {
                            UIApplication.shared.open(safariURL)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image("insta_logo")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text("Search on Instagram")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.99, green: 0.84, blue: 0.36), Color(red: 0.99, green: 0.49, blue: 0.42), Color(red: 0.89, green: 0.27, blue: 0.67), Color(red: 0.42, green: 0.23, blue: 0.85)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)

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
                        ForEach(meal.ingredientList, id: \.self) { ingredient in
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
                    Text(meal.instructions)
                        .font(.body)
                        .multilineTextAlignment(.leading)
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
}

// MARK: - UIKit Calendar Wrapper
struct CalendarWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date?
    var mealDates: [Date]

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.calendar = Calendar.current
        calendarView.fontDesign = .rounded
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Update selection
        if let selectedDate = selectedDate {
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            (uiView.selectionBehavior as? UICalendarSelectionSingleDate)?.setSelected(comps, animated: true)
        }
        uiView.reloadDecorations(forDateComponents: mealDates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarWrapper

        init(_ parent: CalendarWrapper) {
            self.parent = parent
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                parent.selectedDate = date
            }
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            // Show a dot if this date is in mealDates
            if let date = dateComponents.date {
                let day = Calendar.current.startOfDay(for: date)
                if parent.mealDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: day) }) {
                    return .default(color: .systemBlue, size: .small)
                }
            }
            return nil
        }
    }
}

#Preview {
    MealPlanView(showingProfile: .constant(false))
}
