import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension NSWindow {
    func setClickThrough(_ enabled: Bool) {
        self.ignoresMouseEvents = enabled
    }
    
    func setAlwaysOnTop(_ enabled: Bool) {
        self.level = enabled ? .floating : .normal
    }
}
