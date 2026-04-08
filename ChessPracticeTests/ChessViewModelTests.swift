//
//  ChessViewModelTests.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 07/04/26.
//

import XCTest
import Combine
import ChessNetworking

@testable import ChessPractice

final class ChessViewModelTests: XCTestCase {
    
    var sut: ChessViewModel!
    var mockService: MockChessWebSocketService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() async throws {
        try await super.setUp()
        mockService = await MockChessWebSocketService()
        sut = await ChessViewModel(service: mockService, board: ChessBoardActor())
        cancellables = []
    }
    
    override func tearDown() async throws {
        mockService = nil
        sut = nil
        cancellables = nil
        try await super.tearDown()
    }
    
    func test_initialState_isNotConnected() async {
        let isConnected = await sut.isConnected
        XCTAssertFalse(isConnected)
    }
    
    func test_initialState_movesAreEmpty() async {
        let initialMoves = await sut.moves
        XCTAssertTrue(initialMoves.isEmpty)
    }
    
    // MARK: Connection tests
    func test_connect_setsIsConnectedTrue() async {
        await sut.connect()
        let isConnected = await sut.isConnected
        XCTAssertTrue(isConnected)
    }
    
    func test_disconnect_setsIsConnectedFalse() async {
        await sut.connect()
        await sut.disconnect()
        let isConnected = await sut.isConnected
        XCTAssertFalse(isConnected)
    }
    
    // MARK: Moves pipeline
    func test_validMove_appearsInMovesList() async {
        await sut.connect()
        
        // Expectation To await for the async combines result
        let expectation = expectation(description: "Move appears in the list")
        
        await MainActor.run {
            sut.$moves
                .dropFirst()
                .sink { moves in
                    if moves.contains(where: { $0.notation == "e4" }) {
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)
        }
        
        // Simulate that the servers returns a move
        await mockService.messageSubject.send("e4")
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        let moves = await sut.moves
        let notations = await MainActor.run {
            moves.map { $0.notation }
        }
        XCTAssertTrue(notations.contains("e4"))
    }
    
    func test_emptyMessage_doesNotAppearInMovesList() async {
        await sut.connect()
        
        await mockService.messageSubject.send("thisisinvalid_andlong")
        
        try? await Task.sleep(for: .milliseconds(300))
        
        let moves = await sut.moves
        XCTAssertTrue(moves.isEmpty)
    }
    
    func test_multipleValidMoves_allAppearInList() async throws {
        await sut.connect()

        await mockService.messageSubject.send("e4")
        await mockService.messageSubject.send("Nf3")
        await mockService.messageSubject.send("Bc4")

        // Damos tiempo al pipeline de Combine para procesar
        try await Task.sleep(for: .milliseconds(500))

        let moves = await sut.moves
        XCTAssertEqual(moves.count, 3)
    }
}
