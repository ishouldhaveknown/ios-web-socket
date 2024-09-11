//
//  ChatViewModel.swift
//  SwiftWebSocket
//
//  Created by Tomi on 11.09.24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {

    @Published var messages: [String] = []
    @Published var inputMessage: String = ""

    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()

    init() {
        connectWebSocket()
    }

    deinit {
        disconnect()
    }

    func connectWebSocket() {
        let url = URL(string: "wss://echo.websocket.org")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func sendMessage() {
        guard !inputMessage.isEmpty else {
            return
        }

        let message = URLSessionWebSocketTask.Message.string(inputMessage)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
        inputMessage = ""
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.messages.append("Arrived back: \(text)")
                    }
                default:
                    print("Received unexpected message format")
                }
                self?.receiveMessage()
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
