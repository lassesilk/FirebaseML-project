//
//  FaceDetectionController.swift
//  FirebaseML-project
//
//  Created by Lasse Silkoset on 26/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import Firebase

class FaceDetectionController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainHeight(constant: 500)
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
        detectFaces()
    }
    
    fileprivate func detectFaces() {
        
        guard let image = self.imageView.image else { return }
        
        let vision = Vision.vision()
        let options = VisionFaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
        options.minFaceSize = CGFloat(0.01)
        options.isTrackingEnabled = true
        
        let faceDetector = vision.faceDetector(options: options)
        let visionImage = VisionImage(image: image)
        faceDetector.process(visionImage) { [weak self] (faces, err) in
            if err != nil {
                print("Unable to detect face")
                return
            }
            
            guard let faces = faces else { return }
            var image = self?.imageView.image
            
            var count = 1
            var message = ""
            
            faces.forEach { [weak self] (face) in
                image = self?.drawRectOnImage(image: image!, cgRect: face.frame)
                
                
                
                if face.hasLeftEyeOpenProbability {
                    if face.leftEyeOpenProbability > 0.4 {
                        message += "Person \(count)`s left eye is open. \n"
                    } else {
                        message += "Person \(count)`s left eye is closed. \n"
                    }
                }
                if face.hasRightEyeOpenProbability {
                    if face.rightEyeOpenProbability > 0.4 {
                        message += "Person \(count)`s right eye is open. \n"
                    } else {
                        message += "Person \(count)`s right eye is closed. \n"
                    }
                }
                
                if face.hasSmilingProbability {
                    if face.smilingProbability > 0.5 {
                        message += "Person \(count) is smiling. \n"
                    } else {
                        message += "Person \(count) is not smiling. \n"
                    }
                }
                count += 1
            }
            
            print("This is the message: ", message)
            
            self?.imageView.image = image
            self?.textLabel.text = message
        }
    }
    
    fileprivate func drawRectOnImage(image: UIImage, cgRect: CGRect) -> UIImage {
        let imageSize = image.size
        let scale:CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero)
        context?.saveGState()
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.setLineWidth(2.0)
        context?.addRect(cgRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
