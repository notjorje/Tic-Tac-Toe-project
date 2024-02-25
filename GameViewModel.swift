//
//  GameViewModel.swift
//  tic tac toe
//
//  Created by Lupu George on 23.03.2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    @AppStorage("scoreCountHuman")  var scoreCountHuman = 0
    @AppStorage("scoreCountComputer") var scoreCountComputer = 0
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            scoreCountHuman += 1
            return
        }
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let computerPosition = self.determineComputerMovePosition(in: moves)
            self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                scoreCountComputer += 1
                return
            }
        }
        isGameBoardDisabled = true
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        // If AI can win, then win
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block or win, take the middle square
        let centerPiece = 4
        if !isSquareOccupied(in: moves, forIndex: centerPiece) {
            return centerPiece
        }
        
        // If AI can't take middle square, take random available square
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
              movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    func resetGame () {
        moves = Array(repeating: nil, count: 9)
    }
    
}
