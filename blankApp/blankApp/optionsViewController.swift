//
//  optionsViewController.swift
//  blankApp
//
//  Created by User on 2018-05-05.
//  Copyright © 2018 User. All rights reserved.
//

import Cocoa

class optionsViewController: NSViewController {
    @IBOutlet weak var lowCheckBox: NSButton!
    @IBOutlet weak var midCheckBox: NSButton!
    @IBOutlet weak var highCheckBox: NSButton!
    @IBOutlet weak var lowFlatCheckBox: NSButton!
    @IBOutlet weak var midFlatCheckBox: NSButton!
    @IBOutlet weak var highFlatCheckBox: NSButton!
    
    
    override func viewWillAppear() {
        if lowKeysEnabled {
            lowCheckBox.state = .on
        }
        if midKeysEnabled {
            midCheckBox.state = .on
        }
        if highKeysEnabled {
            highCheckBox.state = .on
        }
        if flatLowKeysEnabled {
            lowFlatCheckBox.state = .on
        }
        if flatMidKeysEnabled {
            midFlatCheckBox.state = .on
        }
        if flatHighKeysEnabled {
            highFlatCheckBox.state = .on
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        pianoPlayer.allNotes.removeAll()
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if lowCheckBox.state == .on || midCheckBox.state == .on || highCheckBox.state == .on || lowFlatCheckBox.state == .on || midFlatCheckBox.state == .on || highFlatCheckBox.state == .on {
            
        if lowCheckBox.state == .on {
            lowKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoLowNotes
        } else {
            lowKeysEnabled = false
            }
        if midCheckBox.state == .on {
            midKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoMidNotes
        } else {
            midKeysEnabled = false
            }
        if highCheckBox.state == .on {
            highKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoHighNotes
        } else {
            highKeysEnabled = false
            }
        if lowFlatCheckBox.state == .on {
            flatLowKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoFlatLowNotes
        } else {
            flatLowKeysEnabled = false
            }
        if midFlatCheckBox.state == .on {
            flatMidKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoFlatMidNotes
        } else {
            flatMidKeysEnabled = false
            }
        if highFlatCheckBox.state == .on {
            flatHighKeysEnabled = true
            pianoPlayer.allNotes += pianoPlayer.pianoFlatHighNotes
        } else {
            flatHighKeysEnabled = false
            }
            print(pianoPlayer.allNotes)
            self.dismissViewController(self)
        } else {
            let alert = NSAlert()
            alert.messageText = "You must select at least one set of keys!"
            alert.informativeText = "Don't be silly"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        
        
    }
}
