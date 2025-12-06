import SwiftUI
import Combine

class TeleprompterViewModel: ObservableObject {
    @Published var text: String = "Paste your script here...\n\nThis is a sample text to test the teleprompter. You can edit this text, change the font size, and adjust the scroll speed.\n\nEnjoy recording!"
    @Published var fontSize: CGFloat = 32
    @Published var scrollSpeed: Double = 50 // Points per second approx
    @Published var isScrolling: Bool = false
    @Published var scrollOffset: CGFloat = 0
    
    // Window Settings
    @Published var opacity: Double = 0.7
    @Published var isGhostMode: Bool = false // Click-through and more transparent
    @Published var isAlwaysOnTop: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private let timerInterval = 0.05
    
    init() {
        // Initialize anything if needed
    }
    
    func toggleScroll() {
        isScrolling.toggle()
        if isScrolling {
            startScrolling()
        } else {
            stopScrolling()
        }
    }
    
    private func startScrolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // Calculate pixel movement: speed (pts/sec) * interval (sec)
            let delta = self.scrollSpeed * self.timerInterval
            self.scrollOffset += delta
        }
    }
    
    private func stopScrolling() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetScroll() {
        isScrolling = false
        stopScrolling()
        scrollOffset = 0
    }
}
