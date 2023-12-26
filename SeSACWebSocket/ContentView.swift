//
//  ContentView.swift
//  SeSACWebSocket
//
//  Created by 서승우 on 2023/12/26.
//

import SwiftUI

struct ContentView: View {

    @State
    private var showNextPage = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("이동하기") {
                showNextPage = true
            }
        }
        .padding()
        .sheet(isPresented: $showNextPage) {
            SocketView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
