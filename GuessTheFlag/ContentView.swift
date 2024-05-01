//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Vishrut Jha on 4/27/24.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}

extension View {
    func largeBlueTitle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var turns = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.67, green: 0.88, blue: 0.69), location: 0.3), // Soft green
                .init(color: Color(red: 0.56, green: 0.74, blue: 0.98), location: 0.3), // Light blue
            ], center: .top, startRadius: 245, endRadius: 400)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Fun with Flags! :)")
//                    .foregroundStyle(.white)
//                    .font(.largeTitle.weight(.bold))
                    .largeBlueTitle()
                
                
                VStack(spacing: 40){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
            Button("Reset Game", role: .destructive, action: resetGame)
        } message: {
            if turns > 0 {
                Text("Your score is \(score). You have \(turns) turns left.")
            } else {
                Text("Game Over. Your final score is \(score). Tap 'Reset Game' to play again!")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if turns > 0 {
            if number == correctAnswer {
                scoreTitle = "Correct! That's the flag of \(countries[number])"
                score += 1
            } else {
                scoreTitle = "Wrong. That's the flag of \(countries[number])"
                score -= 1
            }
            
            turns -= 1
            if turns == 0 {
                scoreTitle += "\nGame Over. Your final score is \(score)."
            }
            
            showingScore = true
        }
    }
    
    func askQuestion() {
        if turns > 0 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        } else {
            resetGame()
        }
    }
    
    func resetGame() {
        scoreTitle = "Game Over. Your final score was \(score)."
        score = 0
        turns = 8
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingScore = false
    }

       
}

#Preview {
    ContentView()
}
