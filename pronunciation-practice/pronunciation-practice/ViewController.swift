//
//  ViewController.swift
//  pronunciation-practice
//
//  Created by Jason Faas on 12/8/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    private let uiTextView: UITextView = {
        let uiTextView = UITextView()
        
        uiTextView.text = "What\nWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHOWHO"
        
        return uiTextView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .white
        
        button.setTitle("Random Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemGray
        
        view.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: 300,
            height: 300
        )
        imageView.center = view.center
        
        view.addSubview(button)
        
        getRandomPhoto()
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubview(uiTextView)
        
    }
    
    override func viewDidLayoutSubviews() {
        button.frame = CGRect(
            x: 30,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
        
        uiTextView.frame = CGRect(x: 30, y: view.safeAreaInsets.top, width: 300, height: 100)
    }
    
    @objc func didTapButton() {
        button.setTitle("\(button.currentTitle ?? "") A", for: .normal)
        
        getRandomPhoto()
    }
    
    
    func getRandomPhoto() {
        let urlString = "https://source.unsplash.com/random/600x600"
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
        
    }


}

