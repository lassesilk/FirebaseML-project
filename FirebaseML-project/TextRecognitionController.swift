//
//  TextRecognitionController.swift
//  FirebaseML-project
//
//  Created by Lasse Silkoset on 26/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import Firebase

class TextRecognitionController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainHeight(constant: 350)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var vision = Vision.vision()
    var textDetector: VisionTextRecognizer?
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [imageView, textLabel])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.fillSuperview(padding: .init(top: 24, left: 16, bottom: 24, right: 16))
        
        textDetector = vision.onDeviceTextRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let selectedImage = imageView.image else { return }
        
        let image = VisionImage(image: selectedImage)
        
        textDetector?.process(image, completion: { (features, err) in
            guard err == nil, let features = features, !features.blocks.isEmpty else {
                print("Error recognizing text in image")
                return
            }
            
            print("Detected text has \(features.blocks.count) blocks")
            
            for feature in features.blocks {
                let text = feature.text
                self.textLabel.text = self.textLabel.text! + " " + text
            }
        })
    }
}
