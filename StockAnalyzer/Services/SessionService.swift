import Foundation
import FirebaseAuth

class SessionService: ObservableObject {
    static let entity = SessionService()
    
    @Published var session: FirebaseAuth.User?
    var handle: AuthStateDidChangeListenerHandle?
    
    private init() {
        self.listen()
    }
    
    func listen() {
       handle = Auth.auth().addStateDidChangeListener { (auth, user) in
           if let user = user {
               self.session = user
           } else {
               self.session = nil
           }
       }
    }
}
