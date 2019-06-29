//
//  PianoPlayer.swift
//  blankApp
//
//  Created by User on 2018-05-04.
//  Copyright © 2018 User. All rights reserved.
//

import Cocoa
import AVFoundation

var lowKeysEnabled = false
var midKeysEnabled = true
var highKeysEnabled = false
var flatLowKeysEnabled = false
var flatMidKeysEnabled = false
var flatHighKeysEnabled = false

class PianoPlayer: AVAudioPlayer {
    
    var lastNote: String? = nil
    
    var currentNote: String? = nil
    
    var currentTuple: (String, String)? = nil
    
    var noteList: [String:String] = [:]
    
    var actualPlayer = AVAudioPlayer()
    
    let c4URL = Bundle.main.path(forResource: "PianoC4", ofType: "aiff")
    let d4URL = Bundle.main.path(forResource: "PianoD4", ofType: "aiff")
    let e4URL = Bundle.main.path(forResource: "PianoE4", ofType: "aiff")
    let f4URL = Bundle.main.path(forResource: "PianoF4", ofType: "aiff")
    let g4URL = Bundle.main.path(forResource: "PianoG4", ofType: "aiff")
    let a4URL = Bundle.main.path(forResource: "PianoA4", ofType: "aiff")
    let b4URL = Bundle.main.path(forResource: "PianoB4", ofType: "aiff")
    let c5URL = Bundle.main.path(forResource: "PianoC5", ofType: "aiff")
    let d5URL = Bundle.main.path(forResource: "PianoD5", ofType: "aiff")
    let e5URL = Bundle.main.path(forResource: "PianoE5", ofType: "aiff")
    let f5URL = Bundle.main.path(forResource: "PianoF5", ofType: "aiff")
    let g5URL = Bundle.main.path(forResource: "PianoG5", ofType: "aiff")
    let a5URL = Bundle.main.path(forResource: "PianoA5", ofType: "aiff")
    let b5URL = Bundle.main.path(forResource: "PianoB5", ofType: "aiff")
    let c6URL = Bundle.main.path(forResource: "PianoC6", ofType: "aiff")
    let d6URL = Bundle.main.path(forResource: "PianoD6", ofType: "aiff")
    let e6URL = Bundle.main.path(forResource: "PianoE6", ofType: "aiff")
    let f6URL = Bundle.main.path(forResource: "PianoF6", ofType: "aiff")
    let g6URL = Bundle.main.path(forResource: "PianoG6", ofType: "aiff")
    let a6URL = Bundle.main.path(forResource: "PianoA6", ofType: "aiff")
    let b6URL = Bundle.main.path(forResource: "PianoB6", ofType: "aiff")
    let d4FlatURL = Bundle.main.path(forResource: "PianoDb4", ofType: "aiff")
    let e4FlatURL = Bundle.main.path(forResource: "PianoEb4", ofType: "aiff")
    let g4FlatURL = Bundle.main.path(forResource: "PianoGb4", ofType: "aiff")
    let a4FlatURL = Bundle.main.path(forResource: "PianoAb4", ofType: "aiff")
    let b4FlatURL = Bundle.main.path(forResource: "PianoBb4", ofType: "aiff")
    let d5FlatURL = Bundle.main.path(forResource: "PianoDb5", ofType: "aiff")
    let e5FlatURL = Bundle.main.path(forResource: "PianoEb5", ofType: "aiff")
    let g5FlatURL = Bundle.main.path(forResource: "PianoGb5", ofType: "aiff")
    let a5FlatURL = Bundle.main.path(forResource: "PianoAb5", ofType: "aiff")
    let b5FlatURL = Bundle.main.path(forResource: "PianoBb5", ofType: "aiff")
    let d6FlatURL = Bundle.main.path(forResource: "PianoDb6", ofType: "aiff")
    let e6FlatURL = Bundle.main.path(forResource: "PianoEb6", ofType: "aiff")
    let g6FlatURL = Bundle.main.path(forResource: "PianoGb6", ofType: "aiff")
    let a6FlatURL = Bundle.main.path(forResource: "PianoAb6", ofType: "aiff")
    let b6FlatURL = Bundle.main.path(forResource: "PianoBb6", ofType: "aiff")
    
    var pianoLowNotes:[(note: String, soundURL: String)] = []
    var pianoMidNotes:[(note: String, soundURL: String)] = []
    var pianoHighNotes:[(note: String, soundURL: String)] = []
    
    var pianoFlatLowNotes:[(note: String, soundURL: String)] = []
    var pianoFlatMidNotes:[(note: String, soundURL: String)] = []
    var pianoFlatHighNotes:[(note: String, soundURL: String)] = []
    
    var pianoFlatNotes:[(note: String, soundURL: String)] = []
    
    var allNotes:[(note: String, soundURL: String)] = []
    
    func setVars() {
        
        self.pianoLowNotes = [("C",c4URL),("D",d4URL),("E",e4URL),("F",f4URL),("G",g4URL),("A",a4URL),("B",b4URL)] as! [(note: String, soundURL: String)]
        self.pianoMidNotes = [("C",c5URL),("D",d5URL),("E",e5URL),("F",f5URL),("G",g5URL),("A",a5URL),("B",b5URL)] as! [(note: String, soundURL: String)]
       self.pianoHighNotes = [("C",c6URL),("D",d6URL),("E",e6URL),("F",f6URL),("G",g6URL),("A",a6URL),("B",b6URL)] as! [(note: String, soundURL: String)]
        
        self.pianoFlatLowNotes = [("D flat",d4FlatURL),("E flat",e4FlatURL),("G flat",g4FlatURL),("A flat",a4FlatURL),("B flat",b4FlatURL)] as! [(note: String, soundURL: String)]
        self.pianoFlatMidNotes = [("D flat",d5FlatURL),("E flat",e5FlatURL),("G flat",g5FlatURL),("A flat",a5FlatURL),("B flat",b5FlatURL)] as! [(note: String, soundURL: String)]
       self.pianoFlatHighNotes = [("D flat",d6FlatURL),("E flat",e6FlatURL),("G flat",g6FlatURL),("A flat",a6FlatURL),("B flat",b6FlatURL)] as! [(note: String, soundURL: String)]
        
        if midKeysEnabled {
        self.allNotes = pianoMidNotes
        }
        
    }
    
    
    
    func playSound(myURL: String){
        
        do {
            try self.actualPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: myURL) as URL)
        } catch {
            print("Sound not found")
        }
        self.actualPlayer.play()
        
    }
    
    
    func playCurrentNote(myTuple: (String, String)){
        playSound(myURL: myTuple.1)
    }
    
    func setAvailableNotes(myLow: Bool, myMid: Bool, miHigh: Bool){
        
    }
    
}
