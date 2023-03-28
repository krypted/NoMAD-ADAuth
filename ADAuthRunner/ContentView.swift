//
//  ContentView.swift
//  ADAuthRunner
//
//  Created by Joel Rennich on 12/28/20.
//  Copyright © 2020 Orchard & Grove Inc. All rights reserved.
//

import SwiftUI
import NoMAD_ADAuth

struct ContentView: View {
    @State var user: String = ""
    @State var password: String = ""
    
    let myWorkQueue = DispatchQueue(label: "menu.nomad.kerberos", qos: .userInteractive, attributes:[], autoreleaseFrequency: .never, target: nil)

    @ObservedObject var sessionManager = SessionManager()
    
    var body: some View {
        VStack {
            Text(sessionManager.status)
            .padding()
        HStack {
            Text("User:")
            TextField("user name", text: $user)
        }
        .padding([.leading, .trailing])
        HStack {
            Text("Password:")
            SecureField("user name", text: $password)
        }
        .padding([.leading, .trailing])
            HStack {
            Button(action: {
            signIn()
            }, label: {
                Text("Do It!")
                    .bold()
            })
            }
        }
        .frame(width: 400, height: 200
               , alignment: .center)
        
    }
    
    private func signIn() {
        self.sessionManager.setup(userName: user, password: password)
        myWorkQueue.async {
            self.sessionManager.auth()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
