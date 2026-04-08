//
//  ChessMoveTests.swift
//  ChessPracticeTests
//
//  Created by Abraham Gonzalez Puga on 06/04/26.
//

import XCTest
@testable import ChessPractice

extension String {
    static func testLocalized(_ key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: key, table: "Localizable")
    }
    
    
    final class ChessMoveTests: XCTestCase {
        
        // MARK: - parse(from:)
        func test_parse_validPawnMove_returnsMove() {
            let move = ChessMove.parse(from: "e4")
            XCTAssertNotNil(move)
            XCTAssertEqual(move?.notation, "e4")
        }
        
        func test_parse_emptyString_returnsNil() {
            let move = ChessMove.parse(from: "")
            XCTAssertNil(move)
        }
        
        func test_parse_tooLongString_returnsNil() {
            XCTAssertNil(ChessMove.parse(from: "thisisaninvalidchessmove"))
        }
        
        func test_parse_withespaceOnly_returnsNil() {
            XCTAssertNil(ChessMove.parse(from: " "))
        }
        
        func test_parse_stripsWhiteSpace() {
            let move = ChessMove.parse(from: "   e4   ")
            XCTAssertNotNil(move)
            XCTAssert(((move?.notation) != nil), "e4")
        }
        
        // MARK: - Icon
        func test_icon_pawn() {
            XCTAssertEqual(ChessMove(notation: "e4").icon, "♟")
        }
        
        func test_icon_knight() {
            XCTAssertEqual(ChessMove(notation: "Nf3").icon, "♞")
        }
        
        func test_icon_bishop() {
            XCTAssertEqual(ChessMove(notation: "Bc4").icon, "♝")
        }
        
        func test_icon_rook() {
            XCTAssertEqual(ChessMove(notation: "Re1").icon, "♜")
        }
        
        func test_icon_queen() {
            XCTAssertEqual(ChessMove(notation: "Qh5").icon, "♛")
        }
        
        func test_icon_king() {
            XCTAssertEqual(ChessMove(notation: "Ke2").icon, "♚")
        }
        
        func test_icon_kingsideCastle() {
            XCTAssertEqual(ChessMove(notation: "O-O").icon, "♚")
        }
        
        func test_icon_queensideCastle() {
            XCTAssertEqual(ChessMove(notation: "O-O-O").icon, "♚")
        }
        // MARK: - accessibilityPieceName
        
        func test_a11y_pieceName_pawn_isNotEmpty() {
            XCTAssertFalse(ChessMove(notation: "e4").accessibilityPieceName.isEmpty)
        }
        
        func test_a11y_pieceName_castle_differFromPieces() {
            let pawn = ChessMove(notation: "e4").accessibilityPieceName
            let castle = ChessMove(notation: "O-O").accessibilityPieceName
            XCTAssertNotEqual(pawn, castle)  // son conceptos distintos
        }
        
        func test_a11y_pieceName_allPiecesAreDifferent() {
            let notations = ["e4", "Nf3", "Bc4", "Re1", "Qh5", "Ke2"]
            let names = notations.map { ChessMove(notation: $0).accessibilityPieceName }
            let unique = Set(names)
            XCTAssertEqual(unique.count, notations.count)  // cada pieza tiene nombre único
        }
        
        // MARK: - accessibilityPositions
        
        func test_a11y_positions_kingsideCastle_isEmpty() {
            XCTAssertEqual(ChessMove(notation: "O-O").accessibilityPositions, "")
        }
        
        func test_a11y_positions_queensideCastle_isEmpty() {
            XCTAssertEqual(ChessMove(notation: "O-O-O").accessibilityPositions, "")
        }
        
        func test_a11y_positions_knightWithOrigin_endsWithDestination() {
            let positions = ChessMove(notation: "Ng1-f3").accessibilityPositions
            XCTAssertTrue(positions.hasSuffix("f3"))
        }
        
        func test_a11y_positions_pawn_endsWithSquare() {
            let positions = ChessMove(notation: "e4").accessibilityPositions
            XCTAssertTrue(positions.hasSuffix("e4"))
        }
        
        func test_a11y_positions_bishop_endsWithDestination() {
            let positions = ChessMove(notation: "Bc4").accessibilityPositions
            XCTAssertTrue(positions.hasSuffix("c4"))
        }
    }
}
