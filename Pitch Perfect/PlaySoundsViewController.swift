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

    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioFile : AVAudioFile!
    var audioEngine : AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let bundle = NSBundle.mainBundle()
//        let path = bundle.pathForResource("movie_quote", ofType: "mp3")
//        let url = NSURL(fileURLWithPath: path!)
//        audioPlayer = AVAudioPlayer(contentsOfURL: url, fileTypeHint: AVFileTypeMPEGLayer3, error: nil)
//        audioPlayer.enableRate = true
//        audioPlayer.prepareToPlay()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    
    override func viewWillAppear(animated: Bool) {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: AVFileTypeMPEGLayer3, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func PlaySlow() {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    
    @IBAction func PlayFast() {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    
    @IBAction func playChipmunkAudio() {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthVaderAudio() {
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch : Float) {
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        pitchPlayer.play()
    }
    
    @IBAction func StopPlay() {
        audioPlayer.stop()
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
