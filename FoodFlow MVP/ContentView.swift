//
//  ContentView.swift
//  FoodFlow MVP
//
//  Created by Alex Chopoyhlu on 29/06/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        Group {
            if dataManager.hasCompletedOnboarding() {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .environmentObject(dataManager)
    }
}

#Preview {
    ContentView()
}
