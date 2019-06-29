//
//  ViewController.swift
//  blankApp
//
//  Created by User on 2018-04-30.
//  Copyright © 2018 User. All rights reserved.
//

import Cocoa
import AppKit
import AVFoundation

var pianoPlayer = PianoPlayer()



class ViewController: NSViewController, NSSpeechRecognizerDelegate, NSSpeechSynthesizerDelegate{
    

    @IBOutlet weak var lowCheckBox: NSButton!
    @IBOutlet weak var midCheckBox: NSButton!
    @IBOutlet weak var highCheckBox: NSButton!
    
    @IBOutlet weak var noteLabel: NSTextField!
    
    @IBOutlet weak var youSaidLabel: NSTextField!
    @IBOutlet weak var percentageCorrectLabel: NSTextField!
    
    var speechRecognizer = NSSpeechRecognizer()
    
    var speechSynthesizer = NSSpeechSynthesizer()
    
    @IBOutlet var mainView: NSView!
    

    var myGuesser = guessGenerator()
    
    var firstNotePlayed = false
    
    //Float to take how many correct guesses
    var guessedCorrectly = 0.0
    //Start value is 100% correct
    var percentageCorrect = 100.0
    
    
  
    override func viewWillAppear() {
        speechRecognizer?.startListening()
        //mainView.window?.backgroundColor = .darkGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pianoPlayer.setVars()
        
        speechRecognizer?.delegate = self
        speechRecognizer?.commands = ["C", "D", "E", "F", "G", "A", "B", "D flat" , "E flat", "G flat", "A flat", "B flat", "Again", "Stop", "Start", "Show me", "Tell me"]
        speechRecognizer?.listensInForegroundOnly = false
        
        
        speechSynthesizer.delegate = self
        speechSynthesizer.volume = 0.2
        
        
        
        
        //myGuesser.createGuess(myList: self.pianoPlayer.pianoNotes, myObject: self.pianoPlayer)
        youSaidLabel.stringValue = "Say or click \"start\""
        

    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
   
  
    
    
    
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {

        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        }
        else if command == "Again" && myGuesser.guessingHasStarted == true{
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You said: \(command)")
            pianoPlayer.playCurrentNote(myTuple: myGuesser.guessTuple)
        }
        else if command == "Stop" && myGuesser.guessingHasStarted == true{
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You said: \(command)")
            pianoPlayer.actualPlayer.stop()
        }
        else if command == "Start" && myGuesser.guessingHasStarted == false{
            myGuesser.guessingHasStarted = true
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You said: \(command)")
            myGuesser.createGuess(myList: pianoPlayer.allNotes, myObject: pianoPlayer)
        }
        else if command == "Tell me" && myGuesser.guessingHasStarted == true{
            speechSynthesizer.startSpeaking("\(myGuesser.guessTuple.0)")
            pianoPlayer.playCurrentNote(myTuple: myGuesser.guessTuple)
            fadeOutLabelAndUpdate(myLabel: noteLabel, messageForLabel: "The note is \(myGuesser.guessTuple.0)")
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You said: \(command)")
        }
        else if command == "Show me" && myGuesser.guessingHasStarted == true{
            pianoPlayer.playCurrentNote(myTuple: myGuesser.guessTuple)
            fadeOutLabelAndUpdate(myLabel: noteLabel, messageForLabel: "The note is \(myGuesser.guessTuple.0)")
        }
        
        else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
        //fadeInLabel(myLabel: noteLabel)
    }
    
    func fadeInLabels(myLabel: NSTextField, myOtherLabel: NSTextField){
        myLabel.alphaValue = 0.0
        myOtherLabel.alphaValue = 0.0
        NSAnimationContext.runAnimationGroup({_ in
            //Indicate the duration of the animation
            NSAnimationContext.current.duration = 0.5
            //What is being animated? In this example I’m making a view transparent
            myLabel.animator().alphaValue = 1.0
            myOtherLabel.animator().alphaValue = 1.0
        }, completionHandler:{
            //In here we add the code that should be triggered after the animation completes.
            print("Two labels faded in completed")
        })
    }
    
    
    
    func fadeOutLabelsAndUpdate(myLabel: NSTextField, myOtherLabel: NSTextField, messageForNoteLabel: String, messageForYouSaidLabel: String, status: String){
        myLabel.alphaValue = 1.0
        myOtherLabel.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup({_ in
            //Indicate the duration of the animation
            NSAnimationContext.current.duration = 0.6
            //What is being animated? In this example I’m making a view transparent
            myLabel.animator().alphaValue = 0.0
            myOtherLabel.animator().alphaValue = 0.0
        }, completionHandler:{
            //In here we add the code that should be triggered after the animation completes.
            print("Two labels fadedout")
            if status == "correct"{
                myLabel.textColor = NSColor.black
                
            } else{
                myLabel.textColor = NSColor.systemRed
            }
            myLabel.stringValue = messageForNoteLabel
            myOtherLabel.stringValue = messageForYouSaidLabel
            self.fadeInLabels(myLabel: myLabel, myOtherLabel: myOtherLabel)
        })
    }
    
    func fadeInLabel(myLabel: NSTextField){
        myLabel.alphaValue = 0.0
        NSAnimationContext.runAnimationGroup({_ in
            //Indicate the duration of the animation
            NSAnimationContext.current.duration = 0.5
            //What is being animated? In this example I’m making a view transparent
            myLabel.animator().alphaValue = 1.0
            
        }, completionHandler:{
            //In here we add the code that should be triggered after the animation completes.
            print("One label faded in completed")
        })
    }
    
    
    
    func fadeOutLabelAndUpdate(myLabel: NSTextField, messageForLabel: String){
        myLabel.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup({_ in
            //Indicate the duration of the animation
            NSAnimationContext.current.duration = 0.6
            //What is being animated? In this example I’m making a view transparent
            myLabel.animator().alphaValue = 0.0
        }, completionHandler:{
            //In here we add the code that should be triggered after the animation completes.
            print("One label faded out completed")
            myLabel.stringValue = messageForLabel
            self.fadeInLabel(myLabel: myLabel)
        })
    }
    
    @IBAction func guessC(_ sender: Any) {
        let command = "C"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
        
        
        
    }
    
    @IBAction func guessD(_ sender: Any) {
        let command = "D"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessE(_ sender: Any) {
        let command = "E"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        }else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessF(_ sender: Any) {
        let command = "F"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessG(_ sender: Any) {
        let command = "G"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessA(_ sender: Any) {
        let command = "A"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessB(_ sender: Any) {
        let command = "B"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    } 
    
    @IBAction func guessStart(_ sender: Any) {
        //Clicking this button starts the guessing game
        let command = "Start"
        if command == "Start" && myGuesser.guessingHasStarted == false{
            myGuesser.guessingHasStarted = true
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You clicked: \(command)")
            myGuesser.createGuess(myList: pianoPlayer.allNotes, myObject: pianoPlayer)
        }
    }
    
    @IBAction func guessAgain(_ sender: Any) {
        //Clicking this button gets the system to repeat the note that needs to be guessed
        let command = "Again"
        if command == "Again" && myGuesser.guessingHasStarted == true{
            fadeOutLabelAndUpdate(myLabel: youSaidLabel, messageForLabel: "You clicked: \(command)")
            pianoPlayer.playCurrentNote(myTuple: myGuesser.guessTuple)
        }
        
    }
    
    func correctDude(command: String){
        fadeOutLabelsAndUpdate(myLabel:  self.noteLabel, myOtherLabel: self.youSaidLabel, messageForNoteLabel: "Correct", messageForYouSaidLabel: "You said: \(command)", status: "correct")
        guessedCorrectly += 1
        pianoPlayer.actualPlayer.stop()
        myGuesser.createGuess(myList: pianoPlayer.allNotes, myObject: pianoPlayer)
        percentageCorrect = (guessedCorrectly/(myGuesser.generatedQuestions - 1)) * 100
        print("\(guessedCorrectly) out of \(myGuesser.generatedQuestions)")
        print("\(percentageCorrect)% correct")
        percentageCorrectLabel.stringValue = String(format: "%.1f", percentageCorrect) + "%"
    }
    
    
    func wrongDude(command: String){
            fadeOutLabelsAndUpdate(myLabel: noteLabel, myOtherLabel: youSaidLabel, messageForNoteLabel: "Wrong", messageForYouSaidLabel: "You said: \(command)", status: "wrong")
                myGuesser.generatedQuestions += 1
        
        percentageCorrect = (guessedCorrectly/(myGuesser.generatedQuestions - 1)) * 100
        print("\(guessedCorrectly) out of \(myGuesser.generatedQuestions)")
        print("\(percentageCorrect)% correct")
        percentageCorrectLabel.stringValue = String(format: "%.1f", percentageCorrect) + "%"
    }
    
    @IBAction func zeroCorrectScore(_ sender: Any) {
        myGuesser.generatedQuestions = 1
        guessedCorrectly = 0
        percentageCorrect = 100
        percentageCorrectLabel.stringValue = String(format: "%.1f", percentageCorrect) + "%"
    }
    
    @IBAction func guessDFlat(_ sender: Any) {
        let command = "D flat"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessEFlat(_ sender: Any) {
        let command = "E flat"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessGFlat(_ sender: Any) {
        let command = "G flat"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessAFlat(_ sender: Any) {
        let command = "A flat"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
    
    @IBAction func guessBFlat(_ sender: Any) {
        let command = "B flat"
        if command == myGuesser.toGuess && myGuesser.guessingHasStarted == true{
            correctDude(command: command)
        } else {
            if myGuesser.guessingHasStarted == true && command != "Start"{
                wrongDude(command: command)
            }
        }
    }
   
    @IBAction func showHelp(_ sender: Any) {
        
    }
    
    
}


