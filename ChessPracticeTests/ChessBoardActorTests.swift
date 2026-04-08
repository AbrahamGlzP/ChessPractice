//
//  ChessBoardActorTests.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 07/04/26.
//

import XCTest
@testable import ChessPractice
internal import OrderedCollections

@MainActor
final class ChessBoardActorTests: XCTestCase {

    var sut: ChessBoardActor!

    override func setUp() async throws {
        sut = ChessBoardActor()
    }

    override func tearDown() async throws {
        sut = nil
    }

    // MARK: - append

    func test_append_incrementsMoveCount() async {
        let move = ChessMove(notation: "e4")
        await sut.append(move)
        let count = await sut.movesMap.count
        XCTAssertEqual(count, 1)
    }

    func test_append_multipleMoves_maintainsOrder() async {
        let first = ChessMove(notation: "e4")
        let second = ChessMove(notation: "Nf3")
        let third = ChessMove(notation: "Bc4")

        await sut.append(first)
        await sut.append(second)
        await sut.append(third)

        let moves = await sut.allMoves()
        XCTAssertEqual(moves[0].notation, "e4")
        XCTAssertEqual(moves[1].notation, "Nf3")
        XCTAssertEqual(moves[2].notation, "Bc4")
    }

    func test_append_storesCorrectNotation() async {
        let move = ChessMove(notation: "O-O")
        await sut.append(move)
        let moves = await sut.allMoves()
        XCTAssertEqual(moves.first?.notation, "O-O")
    }

    // MARK: - reset

    func test_reset_clearsAllMoves() async {
        await sut.append(ChessMove(notation: "e4"))
        await sut.append(ChessMove(notation: "Nf3"))
        await sut.reset()
        let moves = await sut.allMoves()
        XCTAssertTrue(moves.isEmpty)
    }

    func test_reset_setsMoveCountToZero() async {
        await sut.append(ChessMove(notation: "e4"))
        await sut.reset()
        let count = await sut.movesMap.count
        XCTAssertEqual(count, 0)
    }

    func test_reset_allowsAppendingAfterReset() async {
        await sut.append(ChessMove(notation: "e4"))
        await sut.reset()
        await sut.append(ChessMove(notation: "d4"))
        let moves = await sut.allMoves()
        XCTAssertEqual(moves.count, 1)
        XCTAssertEqual(moves.first?.notation, "d4")
    }

    // MARK: - allMoves

    func test_allMoves_initiallyEmpty() async {
        let moves = await sut.allMoves()
        XCTAssertTrue(moves.isEmpty)
    }

    func test_allMoves_returnsCorrectCount() async {
        await sut.append(ChessMove(notation: "e4"))
        await sut.append(ChessMove(notation: "d4"))
        let moves = await sut.allMoves()
        XCTAssertEqual(moves.count, 2)
    }

    // MARK: - move(for:)

    func test_moveForID_returnsCorrectMove() async {
        let move = ChessMove(notation: "Nf3")
        await sut.append(move)
        let found = await sut.move(for: move.id)
        XCTAssertEqual(found?.notation, "Nf3")
    }

    func test_moveForID_unknownID_returnsNil() async {
        let move = ChessMove(notation: "e4")
        await sut.append(move)
        let found = await sut.move(for: UUID())
        XCTAssertNil(found)
    }

    func test_moveForID_afterReset_returnsNil() async {
        let move = ChessMove(notation: "e4")
        await sut.append(move)
        await sut.reset()
        let found = await sut.move(for: move.id)
        XCTAssertNil(found)
    }
}
