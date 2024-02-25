//
//  Alerts.swift
//  tic tac toe
//
//  Created by Lupu George on 21.03.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    static let humanWin = AlertItem(title:Text("You win."),
                             message: Text("You are so smart, you beat your own AI"),
                             buttonTitle: Text("Good job. Rematch?") )
    
    static let computerWin = AlertItem(title: Text("You lose."),
                                message: Text("You created one good AI."),
                                buttonTitle: Text("No worries. Rematch ?"))
    
    static let draw = AlertItem(title: Text("It's a draw."),
                         message: Text("What a battle of wits..."),
                         buttonTitle: Text("Try again ?"))
}
