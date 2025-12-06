import Cocoa
import Combine

class HotkeyManager: ObservableObject {
    var onToggleScroll: (() -> Void)?
    var onToggleGhost: (() -> Void)?
    
    private var monitor: Any?
    
    init() {
        // Monitor for Option+Space to toggle scrolling, Option+G for Ghost Mode
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleEvent(event)
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleEvent(event)
            return event
        }
    }
    
    private func handleEvent(_ event: NSEvent) {
        // Cmd + Option + S (S=1)
        if event.modifierFlags.contains([.command, .option]) && event.keyCode == 1 { 
            DispatchQueue.main.async {
                self.onToggleScroll?()
            }
        }
        // Cmd + Option + G (G=5)
        if event.modifierFlags.contains([.command, .option]) && event.keyCode == 5 { 
            DispatchQueue.main.async {
                self.onToggleGhost?()
            }
        }
    }
    
    deinit {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
