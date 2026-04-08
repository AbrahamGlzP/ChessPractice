//
//  ChessBoardActor.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import OrderedCollections

actor ChessBoardActor {
    
    //MARK: - State
    private(set) var movesMap: OrderedDictionary<UUID, ChessMove> = [:]
    
    //MARK: - Mutations
    func append(_ move: ChessMove) {
        movesMap[move.id] = move
    }
    
    func reset() {
        movesMap = [:]
    }
    
    func allMoves() -> [ChessMove] {
        Array(movesMap.values)
    }
    
    func move(for id: UUID) -> ChessMove? {
        movesMap[id]
    }
}
