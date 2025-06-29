import SwiftUI

struct TodayStatsView: View {
    var calories: Int = 1284
    var fatPercent: Double = 0.29
    var proPercent: Double = 0.65
    var carbPercent: Double = 0.85
    var upcomingSectionSpacing: CGFloat = -90
    var mealBarSpacing: CGFloat = 5
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.label).opacity(0.45), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemBackground)))
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Today's Stats")
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
                                Text("\(calories, format: .number)")
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
            
            Spacer().frame(height: upcomingSectionSpacing)
            
            // Upcoming Meals Section
            UpcomingMealsSection(mealBarSpacing: mealBarSpacing)
        }
    }
}

struct StatRingView: View {
    var percent: Double
    var color: Color
    var label: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 8)
                .frame(width: 64, height: 64)
            Circle()
                .trim(from: 0, to: percent)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 64, height: 64)
                .animation(.easeOut(duration: 1.0), value: percent)
            VStack(spacing: 0) {
                Text("\(Int(percent * 100))%")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct UpcomingMealsSection: View {
    enum MealType: String, CaseIterable { case breakfast = "Breakfast", lunch = "Lunch", dinner = "Dinner" }
    
    struct MealState {
        var isCompleted: Bool = false
        var isExpanded: Bool = false
        var imageUrl: String? = nil
    }
    
    @State private var mealStates: [MealType: MealState] = [
        .breakfast: MealState(),
        .lunch: MealState(),
        .dinner: MealState()
    ]
    
    var mealBarSpacing: CGFloat = 20
    
    var body: some View {
        VStack(spacing: mealBarSpacing) {
            ForEach(MealType.allCases, id: \.self) { mealType in
                MealBar(
                    mealType: mealType,
                    state: mealStates[mealType] ?? MealState(),
                    onExpand: {
                        withAnimation {
                            mealStates[mealType]?.isExpanded.toggle()
                            if mealStates[mealType]?.imageUrl == nil && mealStates[mealType]?.isExpanded == true {
                                fetchRandomImage(for: mealType)
                            }
                        }
                    },
                    onComplete: {
                        mealStates[mealType]?.isCompleted.toggle()
                    }
                )
                .padding(.horizontal, 8)
            }
        }
    }
    
    private func fetchRandomImage(for mealType: MealType) {
        MealDBAPI.shared.fetchRandomMeal { meal in
            DispatchQueue.main.async {
                mealStates[mealType]?.imageUrl = meal?.imageUrl
            }
        }
    }
}

struct MealBar: View {
    let mealType: UpcomingMealsSection.MealType
    let state: UpcomingMealsSection.MealState
    let onExpand: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(mealType.rawValue)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(state.isCompleted ? "Completed" : "Upcoming")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(state.isCompleted ? Color.green : Color.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background((state.isCompleted ? Color.green.opacity(0.15) : Color.orange.opacity(0.15)))
                    .cornerRadius(12)
                Button(action: onExpand) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 8)
                        .rotationEffect(.degrees(state.isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.25), value: state.isExpanded)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
            
            if state.isExpanded {
                HStack(alignment: .center, spacing: 0) {
                    if let url = state.imageUrl, let imgUrl = URL(string: url) {
                        AsyncImage(url: imgUrl) { phase in
                            if let image = phase.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Color.gray
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 175, height: 140)
                        .cornerRadius(16)
                        .clipped()
                    } else {
                        Color.gray.frame(width: 175, height: 140).cornerRadius(16)
                    }
                    VStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 24) {
                            VStack {
                                Text("100k").font(.title2).fontWeight(.bold)
                                Text("Calories").font(.headline)
                            }
                            VStack {
                                Text("58g").font(.title2).fontWeight(.bold)
                                Text("Carbs").font(.headline)
                            }
                        }
                        HStack(spacing: 24) {
                            VStack {
                                Text("15g").font(.title2).fontWeight(.bold)
                                Text("Protein").font(.headline)
                            }
                            VStack {
                                Text("20g").font(.title2).fontWeight(.bold)
                                Text("Fat").font(.headline)
                            }
                        }
                        Button(action: onComplete) {
                            Text("Completed")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 140)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .padding(.top, 4)
                    }
                    .frame(width: 180)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.label).opacity(0.55), lineWidth: 3)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayStatsView()
} 
