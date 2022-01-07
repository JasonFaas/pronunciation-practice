//
//  GuiElements.swift
//  pronunciation-practice
//
//  Created by Jason Faas on 1/6/22.
//

import Foundation
import Speech
import UIKit


class SpeechProcessing: SFSpeechRecognizer, SFSpeechRecognizerDelegate {
    
    
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-us"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    
    
    
    @objc func locButtonClicked(_ sender: Any, _ recordButton: UIButton, _ uiTextView: UITextView) {
           if audioEngine.isRunning {
               audioEngine.stop()
               recognitionRequest?.endAudio()
               recordButton.isEnabled = false
               recordButton.setTitle("Record", for: .normal)
               uiTextView.text = "\(uiTextView.text ?? "") \nSTOPPED"
           } else {
//               startRecording(recordButton, uiTextView)
               startSpeechRecognization(recordButton, uiTextView)
               recordButton.setTitle("Stop", for: .normal)
           }
       }
    

    
    func isSpeechRecognitionAllowed(_ recordButton: UIButton) {
        speechRecognizer?.delegate = self
                SFSpeechRecognizer.requestAuthorization {
                    status in
                    var buttonState = false
                    switch status {
                    case .authorized:
                        buttonState = true
                        print("Permission received")
                    case .denied:
                        buttonState = false
                        print("User did not give permission to use speech recognition")
                    case .notDetermined:
                        buttonState = false
                        print("Speech recognition not allowed by user")
                    case .restricted:
                        buttonState = false
                        print("Speech recognition not supported on this device")
                    @unknown default:
                        print("TODO: Fix this")
                    }
                    DispatchQueue.main.async {
                        // TODO: enable button for recording
                        recordButton.isEnabled = buttonState
                    }
                }
        
    }
 
    func startSpeechRecognization(_ recordButton: UIButton, _ uiTextView: UITextView){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
//            alertView(message: "Error comes here for starting the audio listner =\(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
//            self.alertView(message: "Recognization is not allow on your local")
            return
        }
        
        if !myRecognization.isAvailable {
//            self.alertView(message: "Recognization is free right now, Please try again after some time.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() //read from buffer
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil {
//                    self.alertView(message: error.debugDescription)
                }else {
//                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            print("Message : \(message)")
            uiTextView.text = message
            
            
            var lastString: String = ""
            for segment in response.bestTranscription.segments {
                let indexTo = message.index(message.startIndex, offsetBy: segment.substringRange.location)
                lastString = String(message[indexTo...])
            }
            
//            if lastString == "red" {
//                self.view_color.backgroundColor = .systemRed
//            } else if lastString.elementsEqual("green") {
//                self.view_color.backgroundColor = .systemGreen
//            } else if lastString.elementsEqual("pink") {
//                self.view_color.backgroundColor = .systemPink
//            } else if lastString.elementsEqual("blue") {
//                self.view_color.backgroundColor = .systemBlue
//            } else if lastString.elementsEqual("black") {
//                self.view_color.backgroundColor = .black
//            }
            
            
        })
    }
    
    func startRecording(_ recordButton: UIButton, _ uiTextView: UITextView) {
        if recognitionTask != nil { //used to track progress of a transcription or cancel it
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue:
                convertFromAVAudioSessionCategory(AVAudioSession.Category.record)), mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to setup audio session")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() //read from buffer
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Could not create request instance")
        }
        
        recognitionRequest.shouldReportPartialResults = true
                recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
                    res, err in
                    var isLast = false
                    if res != nil { //res contains transcription of a chunk of audio, corresponding to a single word usually
                        isLast = (res?.isFinal)!
                    }
                    if err != nil || isLast {
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        
                        self.recognitionRequest = nil
                        self.recognitionTask = nil
                        
                        // TODO: Reenable
                        recordButton.isEnabled = true
                        let bestStr = res?.bestTranscription.formattedString
                        
                        uiTextView.text = bestStr
//                        var inDict = self.locDict.contains { $0.key == bestStr}
                        
//                        if inDict {
//                            self.placeLbl.text = bestStr
//                            self.userInputLoc = self.locDict[bestStr!]!
//                        }
//                        else {
//                            self.placeLbl.text = "can't find it in the dictionary"
//                            self.userInputLoc = FlyoverAwesomePlace.centralParkNY
//                        }
//                        self.mapSetUp()
                    }
                }
        
    }
    
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
            return input.rawValue
    }
}
