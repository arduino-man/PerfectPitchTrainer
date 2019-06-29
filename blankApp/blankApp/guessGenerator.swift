//
//  guessGenerator.swift
//  blankApp
//
//  Created by User on 2018-05-04.
//  Copyright © 2018 User. All rights reserved.
//

import Cocoa

class guessGenerator: NSObject {
    
    var toPlay: String = "Z"
    var toGuess: String = "Z"
    var guessTuple: (String, String) = ("Z","Z")
    var guessingHasStarted: Bool = false
    var generatedQuestions = 0.0
    
    func createGuess(myList: [(note: String, soundURL: String)], myObject: PianoPlayer){
        let index: Int = Int(arc4random_uniform(UInt32(myList.count)))
        //var value = Array(myList.values)[index]
        self.guessTuple = myList[index]
        self.toGuess = guessTuple.0
        self.toPlay = guessTuple.1
        //print("##########################")
        myObject.playSound(myURL: self.guessTuple.1)
        self.generatedQuestions += 1.0
    }

}
