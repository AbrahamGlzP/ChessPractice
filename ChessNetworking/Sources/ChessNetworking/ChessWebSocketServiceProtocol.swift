//
//  ChessWebSocketServiceProtocol.swift
//  ChessPractice
//
//  Created by Abraham Gonzalez Puga on 03/04/26.
//

import Foundation
import Combine

@MainActor
public protocol ChessWebSocketServiceProtocol {
    var messageSubject: PassthroughSubject<String, Never> { get }
    var connectionStateSubject: PassthroughSubject<Bool, Never> { get }
    
    func connect()
    func disconnect()
    func send(_ text: String)
}
