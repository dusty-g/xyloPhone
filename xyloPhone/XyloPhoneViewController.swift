//
//  XyloPhoneViewController.swift
//  xyloPhone
//
//  Created by Dustin Galindo on 6/1/17.
//  Copyright © 2017 Dustin Galindo. All rights reserved.
//

import UIKit
import CoreMotion
import AudioKit



class XyliPhoneViewController: UIViewController {
    let 🤵 = CMMotionManager()
    let 🚦 = OperationQueue()
    
    @IBOutlet weak var imageView: UIImageView!
    var 🎹 = 60
    var notesArray = [MIDINoteNumber]()
    var noteLetters = ["C", "D", "E", "F", "G", "A", "B", "C"]
    let noteColors = [UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red, UIColor.purple, UIColor.white, UIColor.blue]
    
    @IBOutlet var backgroundLabel: UIView!
    
    @IBOutlet weak var noteTextLabel: UILabel!
    
    @IBAction func buttonPressedDown(_ sender: UIButton) {
        🏦.play(noteNumber: 60, velocity: 80)
    }
    @IBAction func releasedButton(_ sender: UIButton) {
        🏦.stop(noteNumber: 60)
    }
    
    
    let 🏦 = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.01, decayDuration: 0.05, sustainLevel: 0.08, releaseDuration: 0.2)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioKit.output = 🏦
        AudioKit.start()
        
        for index in 0..<8{
            switch index {
            case 0:
                notesArray.append(MIDINoteNumber(🎹))
            case 3,
                 7:
                notesArray.append(MIDINoteNumber(notesArray[index-1]+1))
            default:
                notesArray.append(MIDINoteNumber(notesArray[index-1]+2))
            }
            
        }
        print(notesArray)
        🤵.startDeviceMotionUpdates(to: 🚦) { (📒, 🚨) in
            if 📒 == nil{
                return
            }
            var note = 0
            
            if 📒!.attitude.roll >= 7*Double.pi/16{
                note = 0
            }else if 📒!.attitude.roll <= -7*Double.pi/16{
                note = 7
            }else{
                //scale -pi/2, pi/2 to -2239, 2239
                let newCenter = (((📒!.attitude.roll - -7*Double.pi/16) * 4478)/(7*Double.pi/8)) + -2239
                
                
                DispatchQueue.main.async {
                    self.imageView.center.x = CGFloat(newCenter)
                }
                note = 8 - Int(ceil((((📒!.attitude.roll - -Double.pi/2) * 8.0) / Double.pi)))
            }
            DispatchQueue.main.async {
                
                self.noteTextLabel.text = self.noteLetters[note]
            }
            
//            print(📒!.attitude.roll,self.notesArray.count - Int(ceil((((📒!.attitude.roll - -Double.pi/2) * 8.0) / Double.pi))))
            
            if 📒!.userAcceleration.z < -1.2 {
                
                
                
                
                self.🏦.play(noteNumber: self.notesArray[note], velocity: 85)
            }else{
                for i in 0..<8{
                    self.🏦.stop(noteNumber: self.notesArray[i])
                }
                
            }
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
