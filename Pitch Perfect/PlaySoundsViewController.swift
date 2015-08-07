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
    

    @IBOutlet weak var testButton: UIButton!
    
    @IBAction func toggle(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        timePitchUnit = AVAudioUnitTimePitch()
        reverbUnit = AVAudioUnitReverb()
        reverbUnit.bypass = true
        distortionUnit = AVAudioUnitDistortion()
        distortionUnit.bypass = true
        
        audioEngine.attachNode(player)
        audioEngine.attachNode(timePitchUnit)
//        audioEngine.attachNode(reverbUnit)
//        audioEngine.attachNode(distortionUnit)
        
        audioEngine.connect(player, to: timePitchUnit, format: nil)
//        audioEngine.connect(timePitchUnit, to: reverbUnit, format: nil)
//        audioEngine.connect(reverbUnit, to: distortionUnit, format: nil)
//        audioEngine.connect(distortionUnit, to: audioEngine.outputNode, format: nil)
        audioEngine.connect(timePitchUnit, to: audioEngine.outputNode, format: nil)
    }

    
    override func viewWillAppear(animated: Bool) {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        audioEngine.stop()
//        audioEngine.reset()
    }

    func playAudioWithVariablePitchAndRate(pitch: Float = 1.0, rate: Float = 1.0) {
        StopPlay()
//        player.stop()
        timePitchUnit.pitch = pitch
        timePitchUnit.rate = rate
        // Check effects
        
        // play with distortion
//        let dist = AVAudioUnitDistortion()
//        dist.loadFactoryPreset(.SpeechWaves)
//        audioEngine.attachNode(dist)
//        
//        dist.bypass = !testButton.selected
//        
        audioEngine.startAndReturnError(nil)
        player.play()
        player.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    }
    
    // TODO: Add an additional effect or more, such as reverb or echo
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
