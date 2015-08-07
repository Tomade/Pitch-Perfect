//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Danilo Fiorenzano on 4/8/2015.
//  Copyright (c) 2015 Danilo Fiorenzano. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
    }

    
    override func viewWillAppear(animated: Bool) {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: nil)
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
    
    
    func playAudioWithVariablePitchAndRate(pitch: Float? = nil, rate: Float? = nil) {
        StopPlay()
        let pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        
        let timePitch = AVAudioUnitTimePitch()
        if let pitch = pitch {
            timePitch.pitch = pitch
        }
        if let rate = rate {
            timePitch.rate = rate
        }
        audioEngine.attachNode(timePitch)

        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        pitchPlayer.play()
    }
    
    @IBAction func StopPlay() {
        audioEngine.stop()
        audioEngine.reset()
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
