//
//  SocketView.swift
//  SeSACWebSocket
//
//  Created by 서승우 on 2023/12/26.
//

import SwiftUI

struct SocketView: View {

    @StateObject
    private var viewModel = SocketViewModel()

    var body: some View {
        VStack {
            ForEach(viewModel.askOrderBook, id: \.id) { item in
                Text("\(item.price)")
            }
        }
        .padding()
    }
}

struct SocketView_Previews: PreviewProvider {
    static var previews: some View {
        SocketView()
    }
}
