import Foundation
import ElixirKit
import AppKit

@main
public struct HelloExecWeb {
    public static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 隐藏应用图标（作为启动器运行）
        NSApp.setActivationPolicy(.accessory)

        ElixirKit.API.start(
            name: "hello_exec_web",
            readyHandler: {
                print("[AppKit] Phoenix server ready, opening browser...")
                self.openBrowser("http://localhost:4000")
            },
            terminationHandler: { _ in
                print("[AppKit] Phoenix server terminated")
                NSApp.terminate(nil)
            }
        )

        // 监听来自 Phoenix 的消息
        ElixirKit.API.addObserver(queue: .main) { (name, data) in
            print("[AppKit] Received event: \(name) - \(data)")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ElixirKit.API.stop()
    }

    private func openBrowser(_ url: String) {
        guard let nsUrl = URL(string: url) else { return }
        NSWorkspace.shared.open(nsUrl)
    }
}
