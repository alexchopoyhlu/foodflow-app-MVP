import SwiftUI

struct TodayStatsView: View {
    var calories: Int = 1284
    var fatPercent: Double = 0.29
    var proPercent: Double = 0.65
    var carbPercent: Double = 0.85
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.label).opacity(0.15), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemBackground)))
            
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Today's Stats")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {}) {
                        Text("View more")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
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
                .frame(width: 56, height: 56)
            Circle()
                .trim(from: 0, to: percent)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 56, height: 56)
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

#Preview {
    TodayStatsView()
} 