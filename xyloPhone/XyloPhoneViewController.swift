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
    var 🎹 = 60
    var notesArray = [MIDINoteNumber]()
    var noteLetters = ["C", "D", "E", "F", "G", "A", "B", "C"]
    let noteColors = [UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red, UIColor.purple, UIColor.white, UIColor.blue]
    
    @IBOutlet var backgroundLabel: UIView!
    
    @IBOutlet weak var noteTextLabel: UILabel!
    
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBAction func buttonPressedDown(_ sender: UIButton) {
        🏦.play(noteNumber: 60, velocity: 80)
    }
    @IBAction func releasedButton(_ sender: UIButton) {
        🏦.stop(noteNumber: 60)
    }
    
    
    let 🏦 = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.01, decayDuration: 0.05, sustainLevel: 0.08, releaseDuration: 0.2)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextLabel.layer.zPosition = 1
        AudioKit.output = 🏦
        AudioKit.start()
        let min = CGFloat(-1500)
        let max = CGFloat(1500)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        imageViewLabel.addMotionEffect(xMotion)
        
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
            
            if 📒!.attitude.roll >= Double.pi/2.0{
                note = 0
            }else if 📒!.attitude.roll <= -Double.pi/2.0{
                note = 7
            }else{
                note = self.notesArray.count - Int(ceil((((📒!.attitude.roll - -Double.pi/2) * 8.0) / Double.pi)))
            }
            DispatchQueue.main.async {
                self.backgroundLabel.backgroundColor = self.noteColors[note]
                self.noteTextLabel.text = self.noteLetters[note]
            }
            
            print(📒!.attitude.roll,self.notesArray.count - Int(ceil((((📒!.attitude.roll - -Double.pi/2) * 8.0) / Double.pi))))
            
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
