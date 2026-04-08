//
//  MovesListView.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import SwiftUI

struct MovesListView: View {
    
    var moves: [ChessMove]
    
    var body: some View {
        List {
            ForEach(moves.reversed()) { move in
                HStack(spacing: 12) {
                    Text(move.icon)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(move.notation)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                        
                        Text(move.formattedTime)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                // a11y
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(move.accessibilityDescription)
            }
        }
        .listStyle(.plain)
        .overlay {
            if moves.isEmpty {
                ContentUnavailableView(
                    Localizables.noMovesTitle,
                    systemImage: "chess.board",
                    description: Text(Localizables.noMovesDescription)
                )
            }
        }
    }
}

private extension MovesListView {
    struct Localizables {
        static let noMovesTitle = String(localized: "no_moves_title")
        static let noMovesDescription = String(localized: "no_moves_description")
    }
}
