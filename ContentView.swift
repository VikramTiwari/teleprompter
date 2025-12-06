import SwiftUI

struct ContentView: View {
    @StateObject var vm = TeleprompterViewModel()
    @StateObject var hotkeyManager = HotkeyManager()
    @State private var window: NSWindow?
    @State private var hovered = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .opacity(vm.isGhostMode ? 0.1 : vm.opacity)
                .edgesIgnoringSafeArea(.all)
                .background(WindowAccessor(window: $window))
            
            // Text Content with Auto-Scroll
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    Text(vm.text)
                        .font(.system(size: vm.fontSize))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40) // Margins
                        .padding(.top, geometry.size.height / 2) // Start text in middle
                        .padding(.bottom, geometry.size.height / 2)
                        // Use offset for auto-scrolling
                        .offset(y: -vm.scrollOffset)
                }
                .disabled(vm.isScrolling) // Disable manual scroll when auto-scrolling
            }
            .allowsHitTesting(!vm.isGhostMode) // Pass clicks through if ghost mode
            
            // Controls Overlay (Visible when hovered or not in ghost mode)
            VStack {
                Spacer()
                if hovered && !vm.isGhostMode {
                    ControlPanel(vm: vm)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onHover { isHovering in
            withAnimation {
                self.hovered = isHovering
            }
        }
        .onChange(of: vm.isGhostMode) { newValue in
            window?.setClickThrough(newValue)
            window?.setAlwaysOnTop(vm.isAlwaysOnTop)
            if newValue {
                window?.backgroundColor = .clear
            }
        }
        .onChange(of: vm.isAlwaysOnTop) { newValue in
            window?.setAlwaysOnTop(newValue)
        }
        .onAppear {
            // Bind hotkeys
            hotkeyManager.onToggleScroll = {
                vm.toggleScroll()
            }
            hotkeyManager.onToggleGhost = {
                vm.isGhostMode.toggle()
            }
            // Initial Window Setup
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                window?.setAlwaysOnTop(vm.isAlwaysOnTop)
                window?.standardWindowButton(.closeButton)?.isHidden = true
                window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window?.standardWindowButton(.zoomButton)?.isHidden = true
                window?.titleVisibility = .hidden
                window?.titlebarAppearsTransparent = true
                window?.styleMask.insert(.fullSizeContentView)
                window?.isOpaque = false
                window?.backgroundColor = .clear
            }
        }
    }
}

struct ControlPanel: View {
    @ObservedObject var vm: TeleprompterViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Playback Controls
            HStack {
                Button(action: { vm.toggleScroll() }) {
                    Image(systemName: vm.isScrolling ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                }
                .buttonStyle(.plain)
                
                Button("Reset") { vm.resetScroll() }
            }
            
            Divider()
            
            // Sliders
            HStack {
                Text("Speed").frame(width: 50)
                Slider(value: $vm.scrollSpeed, in: 10...300)
            }
            HStack {
                Text("Size").frame(width: 50)
                Slider(value: $vm.fontSize, in: 12...100)
            }
            HStack {
                Text("Opacity").frame(width: 50)
                Slider(value: $vm.opacity, in: 0.1...1.0)
            }
            
            Divider()
            
            // Toggles
            HStack {
                Toggle("Ghost Mode", isOn: $vm.isGhostMode)
                Toggle("On Top", isOn: $vm.isAlwaysOnTop)
            }
            
            // Edit Text Area (Quick Edit)
            // Ideally we'd prefer a separate window or a modal for editing large text,
            // but for now a simple TextEditor toggle could work.
            // Let's keep it simple: Paste button
            Button("Paste from Clipboard") {
                if let content = NSPasteboard.general.string(forType: .string) {
                    vm.text = content
                    vm.resetScroll()
                }
            }
        }
        .padding()
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow).cornerRadius(12))
        .frame(maxWidth: 400)
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
