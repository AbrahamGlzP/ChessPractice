//
//  ChessWebSocketService.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import Combine

@MainActor
final public class ChessWebSocketService {
    public let messageSubject = PassthroughSubject<String, Never>()
    public let connectionStateSubject = PassthroughSubject<Bool, Never>()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var receiveTask: Task<Void, Never>?
    private let url = URL(string: "ws://localhost:8080")!
    
    public init () {}
}

extension ChessWebSocketService: ChessWebSocketServiceProtocol {
    public func connect() {
        // Avoids double connection
        guard webSocketTask == nil else { return }
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        connectionStateSubject.send(true)
        startReceiveLoop()
    }
    
    public func disconnect() {
        receiveTask?.cancel()
        receiveTask = nil
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        
        connectionStateSubject.send(false)
    }
    
    public func send(_ text: String) {
        
        // Make sure there is a connection
        guard let webSocketTask else {
            print("⚠️ WebSocket: intento de send sin conexión activa")
            return
        }
        
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask.send(message) { error in
            if let error {
                print("⚠️ WebSocket send error: \(error.localizedDescription)")
            }
        }
    }
}

@MainActor
private extension ChessWebSocketService {
    func startReceiveLoop() {
        receiveTask = Task { [weak self] in
            guard let self else { return }
            
            while !Task.isCancelled {
                do {
                    guard let task = webSocketTask else { break }
                    let message = try await task.receive()
                    
                    switch message {
                    case .string(let text):
                        print("📨 WebSocket recibió: \(text)")
                        messageSubject.send(text)
                        
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            print("📨 WebSocket recibió data: \(text)")
                            messageSubject.send(text)
                        }
                    @unknown default:
                        break
                    }
                } catch {
                    print("⚠️ WebSocket error: \(error.localizedDescription)")
                    connectionStateSubject.send(false)
                    break
                }
            }
        }
    }
}
