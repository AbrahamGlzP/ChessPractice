//
//  ContentView.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ChessViewModel.makeDefault()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                controlsBar
                Divider()
                MovesListView(moves: viewModel.moves)
            }
            .navigationTitle(Localizables.appTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    connectionIndicator
                }
            }
        }
    }
    
    private var connectionIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(viewModel.isConnected ? .green : .red)
                .frame(width: 8, height: 8)
            
            Text(viewModel.isConnected ? Localizables.statusLive : Localizables.statusOffline)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(viewModel.isConnected ? .green : .secondary)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isConnected)
    }
    
    private var controlsBar: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.connect()
            } label: {
                Label(Localizables.btnConnect, systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isConnected)
            
            Button {
                viewModel.disconnect()
            } label: {
                Label(Localizables.btnDisconnect, systemImage: "stop.fill")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isConnected)
            
            Button {
                viewModel.sendMove(randomMove())
            } label: {
                Label(Localizables.btnSendMove, systemImage: "paperplane.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isConnected)
        }
        .padding()
    }
    
    private func randomMove() -> String {
        let moves = ["e2-e4", "d7-d5", "Ng1-f3", "Bc4", "O-O", "Qd1-h5"]
        return moves.randomElement()!
    }
}

extension ContentView {
    struct Localizables {
        static let appTitle: String = String(localized: "app_title")
        static let btnConnect: String = String(localized: "btn_connect")
        static let btnDisconnect: String = String(localized: "btn_disconnect")
        static let btnSendMove: String = String(localized: "btn_send_move")
        
        static let statusLive = String(localized: "status_live")
        static let statusOffline = String(localized: "status_offline")
    }
}

#Preview {
    ContentView()
}
