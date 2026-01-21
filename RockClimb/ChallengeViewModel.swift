import SwiftUI
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var challenges: [Challenge] = TempData.challenges
    @Published var selectedChallenge: Challenge?
    @Published var isPlayingChallenge = false
    @Published var challengeScore = 0
    @Published var challengeProgress:  Double = 0
    
    private var timer: AnyCancellable?
    
    func startChallenge(_ challenge: Challenge) {
        selectedChallenge = challenge
        isPlayingChallenge = true
        challengeScore = 0
        challengeProgress = 0
        startChallengeTimer()
    }
    
    func startChallengeTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.challengeProgress += 0.01
                if self.challengeProgress >= 1.0 {
                    self.completeChallenge()
                }
            }
    }
    
    func completeChallenge() {
        timer?.cancel()
        if let challenge = selectedChallenge,
           let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].completed = true
            challengeScore = challenge.reward
        }
        isPlayingChallenge = false
    }
    
    func incrementScore(_ points: Int) {
        challengeScore += points
    }
}
