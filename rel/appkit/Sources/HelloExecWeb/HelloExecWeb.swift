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
    var statusBarItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 隐藏应用图标（作为启动器运行）
        NSApp.setActivationPolicy(.accessory)

        // 创建状态栏图标
        setupStatusBar()

                // 设置正确的工作目录到项目根目录
        let bundlePath = Bundle.main.bundlePath
        print("[AppKit] Bundle path: \(bundlePath)")

        // 从应用程序包路径推导项目根目录
        let projectRoot = bundlePath
            .replacingOccurrences(of: "/Contents/Resources/rel", with: "")
            .replacingOccurrences(of: "/.build/HelloExecWeb.app", with: "")
            .replacingOccurrences(of: "/rel/appkit", with: "")

        print("[AppKit] Calculated project root: \(projectRoot)")

        // 验证目录是否存在
        if FileManager.default.fileExists(atPath: projectRoot) {
            FileManager.default.changeCurrentDirectoryPath(projectRoot)
            print("[AppKit] Successfully set working directory to: \(projectRoot)")
        } else {
            print("[AppKit] ERROR: Project root directory does not exist: \(projectRoot)")
            // 尝试使用当前工作目录
            let currentDir = FileManager.default.currentDirectoryPath
            print("[AppKit] Using current directory instead: \(currentDir)")
        }

        // 设置必要的环境变量
        setenv("SECRET_KEY_BASE", "+qH+DSBivm6UUWHs88dhlf48SE9sUcrOltkSrdFzZHqNsTvb2vWVjEGOoVFgmbqd", 1)
        setenv("PHX_SERVER", "true", 1)
        setenv("PHX_ENV", "prod", 1)
        setenv("MIX_ENV", "prod", 1)
        setenv("PORT", "4000", 1)
        print("[AppKit] Set environment variables: SECRET_KEY_BASE, PHX_SERVER, PHX_ENV, MIX_ENV, PORT")

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

    // 设置状态栏图标和菜单
    private func setupStatusBar() {
        // 创建状态栏项目
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // 设置图标（使用字母 E 作为 logo）
        if let button = statusBarItem?.button {
            // 创建字母 E 的图标
            let image = NSImage(size: NSSize(width: 18, height: 18))
            image.lockFocus()

            // 设置字体和颜色
            let font = NSFont.systemFont(ofSize: 14, weight: .bold)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: NSColor.labelColor
            ]

            // 绘制字母 E
            let text = "E"
            let textSize = text.size(withAttributes: attributes)
            let textRect = NSRect(
                x: (18 - textSize.width) / 2,
                y: (18 - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)

            image.unlockFocus()
            button.image = image
            button.toolTip = "Hello Exec Web"
        }

        // 创建菜单
        let menu = NSMenu()

        // 添加打开浏览器菜单项
        let openBrowserItem = NSMenuItem(title: "打开浏览器", action: #selector(openBrowserMenu), keyEquivalent: "")
        openBrowserItem.target = self
        menu.addItem(openBrowserItem)

        // 添加分隔线
        menu.addItem(NSMenuItem.separator())

        // 添加退出菜单项
        let quitItem = NSMenuItem(title: "退出", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        // 设置菜单
        statusBarItem?.menu = menu
    }

    // 打开浏览器菜单项的处理方法
    @objc private func openBrowserMenu() {
        openBrowser("http://localhost:4000")
    }

    // 退出应用的处理方法
    @objc private func quitApp() {
        // 停止 ElixirKit
        ElixirKit.API.stop()

        // 退出应用程序
        NSApp.terminate(nil)
    }
}
