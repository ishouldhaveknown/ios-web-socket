//
//  ContentView.swift
//  SwiftWebSocket
//
//  Created by Tomi on 11.09.24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            List(viewModel.messages, id: \.self) { message in
                Text(message)
            }

            HStack {
                TextField("Send message", text: $viewModel.inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
        }
    }
}
