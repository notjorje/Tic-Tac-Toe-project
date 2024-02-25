//
//  GameView.swift
//  tic tac toe
//
//  Created by Lupu George on 19.03.2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var vM = GameViewModel()
        
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(gradient:
                            Gradient(colors: [Color.white,
                                              Color.gray]),
                           startPoint: .top,
                           endPoint: .bottom)
                        .edgesIgnoringSafeArea(.vertical)
                        .overlay(
            VStack {
                Spacer()
                Text("Tic Tac Toe")
                    .bold()
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding(.bottom)
                    .font(.system(size: 38))
                LazyVGrid(columns: vM.columns, spacing: 6) {
                    ForEach(0..<9) { i in
                        ZStack() {
                            Circle()
                                .foregroundColor(.gray).opacity(1)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            
                            Image(systemName: vM.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            vM.processPlayerMove(for: i)
                        }
                    }
                }
                
                Text("*score is \(vM.scoreCountHuman) - \(vM.scoreCountComputer)")
                    .foregroundColor(Color.black.opacity(0.4))
                    .frame(width: 340, alignment: .trailing)
                    .padding()
                    .italic()
                    .offset(y: 70)
                Spacer()
            }
            .disabled(vM.isGameBoardDisabled)
            .padding()
            .alert(item: $vM.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle,
                                              action: { vM.resetGame() }))
            })
            )
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
