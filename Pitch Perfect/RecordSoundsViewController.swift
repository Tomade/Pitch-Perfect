//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Danilo Fiorenzano on 22/7/2015.
//  Copyright (c) 2015 Danilo Fiorenzano. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var filePath : NSURL!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as! String
        filePath = NSURL.fileURLWithPathComponents([dirPath, "my_audio.wav"])
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        recording.text = "Tap to Record"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        stopButton.enabled = true
        if audioRecorder.recording {
            audioRecorder.pause()
            recording.text = "Recording paused - tap again to resume"
        }
        else {
            audioRecorder.record()
            recording.text = "Recording - tap to pause"
        }
    }
    
    
    @IBAction func stopRecording() {
        stopButton.hidden = true
        stopButton.enabled = false
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
}

// EOF