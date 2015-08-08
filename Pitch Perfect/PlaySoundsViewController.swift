//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Danilo Fiorenzano on 4/8/2015.
//  Copyright (c) 2015 Danilo Fiorenzano. All rights reserved.
//

/*
This module sets up an AVAudioEngine unit chain as such:
 AVAudioPlayerNode -> AVAudioUnitTimePitch -> AVAudioUnitReverb -> AVAudioUnitDistortion
It then connects the end of the chain to the engine's output node.

The time pitch unit is used to control playback rate and pitch, implementing the effects
corresponding to the four primary picture buttons.
The "special effects" units are used for additional filtering, and they are controlled by a
series of toggle buttons below the four picture buttons.  If one of these units is not used,
its bypass property is set to true.  Depending on the particular effect selected, they are
made active and configured appropriately.

*/

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var player: AVAudioPlayerNode!
    var timePitchUnit: AVAudioUnitTimePitch!
    var reverbUnit: AVAudioUnitReverb!
    var distortionUnit: AVAudioUnitDistortion!
    
    var error: NSError?


    @IBOutlet var reverbButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        timePitchUnit = AVAudioUnitTimePitch()
        reverbUnit = AVAudioUnitReverb()
        reverbUnit.loadFactoryPreset(.Cathedral)
        reverbUnit.wetDryMix = 0
        reverbUnit.bypass = false

        distortionUnit = AVAudioUnitDistortion()
        distortionUnit.loadFactoryPreset(.SpeechRadioTower)
        distortionUnit.wetDryMix = 20
        distortionUnit.bypass = true
        
        audioEngine.attachNode(player)
        audioEngine.attachNode(timePitchUnit)
        audioEngine.attachNode(reverbUnit)
        audioEngine.attachNode(distortionUnit)
        
        audioEngine.connect(player, to: timePitchUnit, format: nil)
        audioEngine.connect(timePitchUnit, to: reverbUnit, format: nil)
        audioEngine.connect(reverbUnit, to: distortionUnit, format: nil)
        audioEngine.connect(distortionUnit, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(&error)

        if let error = error {
            println("Error while starting engine: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: user IBActions and support functions
    
    @IBAction func PlaySlow() {
        playAudioWithVariablePitchAndRate(rate: 0.5)
    }
    
    @IBAction func PlayFast() {
        playAudioWithVariablePitchAndRate(rate: 1.5)
    }
    
    @IBAction func playChipmunkAudio() {
        playAudioWithVariablePitchAndRate(pitch: 1000.0)
    }
    
    @IBAction func playDarthVaderAudio() {
        playAudioWithVariablePitchAndRate(pitch: -1000.0)
    }
    
    @IBAction func StopPlay() {
        player.stop()
    }

    func playAudioWithVariablePitchAndRate(pitch: Float = 1.0, rate: Float = 1.0) {
        StopPlay()
        timePitchUnit.pitch = pitch
        timePitchUnit.rate = rate
        player.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        player.play()
    }
    
    @IBAction func toggleReverb(sender: UIButton) {
        let isSelected = !sender.selected
        if isSelected {
            var preset: AVAudioUnitReverbPreset!
            for button in reverbButtons {
                button.selected = false
            }
            switch sender.titleLabel!.text! {
            case "Small Room":
                preset = AVAudioUnitReverbPreset.SmallRoom
            case "Medium Room":
                preset = AVAudioUnitReverbPreset.MediumRoom
            case "Large Room":
                preset = AVAudioUnitReverbPreset.LargeRoom
            default:
                preset = AVAudioUnitReverbPreset.MediumRoom
            }
            reverbUnit.loadFactoryPreset(preset)
            reverbUnit.wetDryMix = 50
            sender.selected = true
        }
        else {
            reverbUnit.wetDryMix = 0
            sender.selected = false
        }
    }

    
}
