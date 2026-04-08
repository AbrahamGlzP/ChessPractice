//
//  ChessViewModel.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import Combine
import ChessNetworking

@MainActor
final class ChessViewModel: ObservableObject {
    // MARK: Published (UI Observes this)
    @Published private(set) var moves: [ChessMove] = []
    @Published private(set) var isConnected: Bool = false
    
    // MARK: Depednencies
    private let service: ChessWebSocketServiceProtocol
    private let board: ChessBoardActor
    
    // MARK: Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    init(
        service: ChessWebSocketServiceProtocol,
        board: ChessBoardActor
    ) {
        self.service = service
        self.board = board
        setupPipeline()
    }
    
    static func makeDefault() -> ChessViewModel {
        #if DEBUG
        ChessViewModel(
            service: ChessWebSocketService(),
            board: ChessBoardActor()
        )
        #else
        ChessViewModel(service: ChessWebSocketService(), board: ChessBoardActor())
        #endif
    }
}

// MARK: Public interface
extension ChessViewModel {
    
    func connect() {
        service.connect()
    }
    
    func disconnect() {
        service.disconnect()
    }
    
    func sendMove(_ notation: String) {
        service.send(notation)
    }
}

// MARK: Combine Pipeline
extension ChessViewModel {
    
    private func setupPipeline() {
        service.messageSubject
            .filter { !$0.isEmpty }
            .compactMap { ChessMove.parse(from: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chessMove in
                print("📥 ViewModel: movimiento recibido → \(chessMove.notation)")
                guard let self else { return }
                Task {
                    await self.board.append(chessMove)
                    self.moves = await self.board.allMoves()
                }
            }
            .store(in: &cancellables)
        
        // Connection status pipeline
        service.connectionStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                print("🔌 ViewModel: isConnected → \(connected)")
                self?.isConnected = connected
            }
            .store(in: &cancellables)
    }
}
