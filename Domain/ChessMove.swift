//
//  ChessMove.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation

struct ChessMove: Identifiable, Equatable {
    let id: UUID
    let notation: String
    let timestamp: Date
    
    init(notation: String) {
        self.id = UUID()
        self.notation = notation
        self.timestamp = Date()
    }
}

// MARK: Parsing

extension ChessMove {
    /// Tries to create a ChessMove from a raw String
    /// Returns nil if the string is not a valid chess move
    static func parse(from raw: String) -> ChessMove? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.count >= 2, trimmed.count <= 10 else {
            return nil
        }
        return ChessMove(notation: trimmed)
    }
    
    
    var icon: String {
        if notation.hasPrefix("O-O") { return "♚" }
        
        switch notation.first {
        case "N": return "♞"  // kNight - Caballo
        case "B": return "♝"  // Bishop - Alfil
        case "R": return "♜"  // Rook   - Torre
        case "Q": return "♛"  // Queen  - Reina
        case "K": return "♚"  // King   - Rey
        default:  return "♟"  // Peón (minúscula o coordenada directa e.g. "e2-e4")
        }
    }
    
    /// Formated timestamp to show in the list of moves
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: timestamp)
    }
}

// MARK: Accessibility a11y
extension ChessMove {
    var accessibilityDescription: String {
        let piece = accessibilityPieceName
        let positions = accessibilityPositions
        let time = formattedTime
        return "\(piece) \(positions), \(String(localized: "a11y_received_at")) \(time)"
    }
    
    var accessibilityPieceName: String {
        if notation.hasPrefix("O-O-O") { return a11yLocalizables.Move.queenSideCastle }
        if notation.hasPrefix("O-O") { return a11yLocalizables.Move.kingSideCastle }
        
        switch notation.first {
        case "N": return a11yLocalizables.Piece.knight
        case "B": return a11yLocalizables.Piece.bishop
        case "R": return a11yLocalizables.Piece.rook
        case "Q": return a11yLocalizables.Piece.queen
        case "K": return a11yLocalizables.Piece.king
        default:  return a11yLocalizables.Piece.pawn
        }
    }
    
    var accessibilityPositions: String {
        if notation.hasPrefix("O-O") { return "" }
        
        let withoutPiece = notation.first?.isUppercase == true ? String(notation.dropFirst()) : notation
        
        if let dashIndex = withoutPiece.firstIndex(of: "-") {
            let destination = String(withoutPiece[withoutPiece.index(after: dashIndex)...])
            return "\(String(localized: "a11y_to")) \(destination)"
        }
        return "\(String(localized: "a11y_to")) \(withoutPiece)"
    }
}

// MARK: Localizables
private extension ChessMove {
    struct a11yLocalizables {
        struct Piece {
            static let knight = String(localized: "a11y_piece_knight")
            static let bishop =  String(localized: "a11y_piece_bishop")
            static let rook =  String(localized: "a11y_piece_rook")
            static let queen =  String(localized: "a11y_piece_queen")
            static let king =  String(localized: "a11y_piece_king")
            static let pawn =  String(localized: "a11y_piece_pawn")
        }
        
        struct Move {
            static let queenSideCastle = String(localized: "a11y_piece_queenside_castle")
            static let kingSideCastle = String(localized: "a11y_piece_kingside_castle")
        }
    }
}
