//
//  SessionManager.swift
//  ADAuthRunner
//
//  Created by Joel Rennich on 12/28/20.
//  Copyright © 2020 Orchard & Grove Inc. All rights reserved.
//

import Foundation
import NoMAD_ADAuth

class SessionManager: ObservableObject {
    
    @Published var status: String = "Ready to test"
    
    var session: NoMADSession?
    
    func setup(userName: String, password: String) {
        let domain = userName.components(separatedBy: "@").last ?? ""
        let user = userName.components(separatedBy: "@").first ?? ""
        self.session = NoMADSession(domain: domain.uppercased(), user: user)
        self.session?.delegate = self
        self.session?.userPass = password
        self.session?.recursiveGroupLookup = true
    }
    
    func auth() {
        updateStatus(status: "Authenticating...")
        session?.authenticate()
    }
    
    private func updateStatus(status: String) {
        RunLoop.main.perform {
            self.status = status
        }
    }
}

extension SessionManager: NoMADUserSessionDelegate {
    
    func NoMADAuthenticationSucceded() {
        updateStatus(status: "Auth success!")
        _ = cliTask("kswitch -p \(self.session?.userPrincipal ?? "")")
        session?.userInfo()
    }
    
    func NoMADAuthenticationFailed(error: NoMADSessionError, description: String) {
        updateStatus(status: "Auth failed :(")
    }
    
    func NoMADUserInformation(user: ADUserRecord) {
        updateStatus(status: "User info received")
        print("User Info: \(user)")
    }
}
