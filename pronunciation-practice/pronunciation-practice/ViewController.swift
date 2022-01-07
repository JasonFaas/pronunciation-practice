//
//  ViewController.swift
//  pronunciation-practice
//
//  Created by Jason Faas on 12/8/21.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    var speechProcessing: SpeechProcessing?
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    
    
    // TODO: Delete above
    
    private let uiTextView: UITextView = {
        let uiTextView = UITextView()
        
        uiTextView.text = "What\nWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHO"
        
        return uiTextView
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func locButtonClicked(_ sender: Any) {
        speechProcessing?.locButtonClicked(sender, recordButton, uiTextView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        speechProcessing = SpeechProcessing()
//        loadSpeechRecognition()
        speechProcessing?.isSpeechRecognitionAllowed(recordButton)
        
        view.backgroundColor = .systemGray
        
        view.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: 300,
            height: 300
        )
        imageView.center = view.center
        
        view.addSubview(recordButton)
        
        recordButton.addTarget(self, action: #selector(locButtonClicked), for: .touchUpInside)
        
        view.addSubview(uiTextView)
        
    }
    
    override func viewDidLayoutSubviews() {
        recordButton.frame = CGRect(
            x: 30,
            y: view.frame.size.height-300-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
        
        uiTextView.frame = CGRect(x: 30, y: view.safeAreaInsets.top, width: 300, height: 100)
    }
    
//    @objc func didTapButton() {
//        button.setTitle("\(button.currentTitle ?? "") AB", for: .normal)
//
//        getRandomPhoto()
//    }
    
    

    
    
    
        
        

}

