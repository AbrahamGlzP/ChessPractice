//
//  MockChessWebSocketService.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import Combine

@MainActor
final public class MockChessWebSocketService {
    public let messageSubject = PassthroughSubject<String, Never>()
    public let connectionStateSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: Private
    private var timerTask: Task<Void, Never>?
    private var moveIndex: Int = .zero
    
    // Simulated game — Kasparov's Immortal vs Topalov, Wijk aan Zee 1999
    private let simulatedMoves = [
        "e2-e4", "d7-d6", "d2-d4", "Ng8-f6", "Nb1-c3", "g7-g6",
        "Bc1-e3", "Bf8-g7", "Qd1-d2", "c7-c6", "f2-f3", "b7-b5",
        "Ng1-e2", "Nb8-d7", "Be3-h6", "Bg7-h6", "Qd2-h6", "Rb8-b8",
        "a2-a3", "e7-e5", "O-O-O", "Qd8-e7", "Kb1-b1", "a7-a6",
        "Ne2-c1", "O-O", "Nc1-b3", "e5-d4"
    ]
    
    public init() {}

    deinit {
        timerTask?.cancel()
        timerTask = nil
    }
}

@MainActor
// MARK: Simulation of service
extension MockChessWebSocketService {
    private func startTimer() {
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                emitNextMove()
            }
        }
    }
    
    func emitNextMove() {
        guard moveIndex < simulatedMoves.count else {
            stopTimer()
            return
        }
        
        let move = simulatedMoves[moveIndex]
        print("♟ MockService: emitiendo movimiento → \(move)")
        messageSubject.send(move)
        moveIndex += 1
    }
    
    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
}

@MainActor
// MARK: Protocol Methods implementation
extension MockChessWebSocketService: ChessWebSocketServiceProtocol {
    
    public func connect() {
        print("🟢 MockService: connect() llamado")
        connectionStateSubject.send(true)
        startTimer()
    }
    
    public func disconnect() {
        stopTimer()
        connectionStateSubject.send(false)
        moveIndex = .zero
    }
    
    public func send(_ text: String) {
        // In the mock, we do a manual echo — simulates that the server confirmed your move
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            self?.messageSubject.send(text)
        }
    }
}
