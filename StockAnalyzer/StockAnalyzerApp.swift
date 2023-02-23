import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser != nil {
                print("signed in")
            } else {
                print("signed out")
            }
        }
      return true
    }
    
  }

@main
struct StockAnalyzerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
