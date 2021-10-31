//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Tiago Silva on 23/09/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    @IBAction func recordAudio(_ sender: Any) {
        NSLog("Record Button was pressed!!!")
        //print("Record Button was pressed!!!")
        
        self.configureUI(isEnabled: false, label: "Recording in Progress")
        
//        recordingLabel.text = "Recording in Progress"
//        recordButton.isEnabled = false
//        stopRecordingButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                          .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        NSLog("Stop recording button pressed")
        //print("Stop recording button pressed!")
        
        self.configureUI(isEnabled: true, label: "Tap to Record")
//        recordButton.isEnabled = true
//        stopRecordingButton.isEnabled = false
//        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            NSLog("Error when recording the audio!")
            //print("Error when recording the audio!")
        }
    }
    
    private func configureUI(isEnabled: Bool, label: String) {
        recordingLabel.text = "Tap to Record"
        recordButton.isEnabled = isEnabled
        stopRecordingButton.isEnabled = !isEnabled
    }
}

