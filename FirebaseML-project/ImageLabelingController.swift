//
//  ImageLabelingController.swift
//  FirebaseML-project
//
//  Created by Lasse Silkoset on 26/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import Firebase

class ImageLabelingController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainHeight(constant: 350)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    
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
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let selectedImage = self.imageView.image else { return }
        
        let vision = Vision.vision()
        let labelDetector = vision.onDeviceImageLabeler()
        let visionImage = VisionImage(image: selectedImage)
        
        labelDetector.process(visionImage) { [weak self] (labels, err) in
            guard err == nil, let labels = labels, !labels.isEmpty else {
                print("Error with labeling image")
                return
            }
            
            for label in labels {
                
                let confidence = label.confidence as! Double
                
                self?.textLabel.text = (self?.textLabel.text)! + "\n" + "\(label.text) - \(confidence * 100.0)%"
            }
        }
    }
    
}
