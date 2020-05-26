//
//  BarcodeDetectionController.swift
//  FirebaseML-project
//
//  Created by Lasse Silkoset on 26/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import Firebase

class BarcodeDetectionController: UIViewController {
    
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
        
        detectBarcode()
    }
    
    fileprivate func detectBarcode() {
        
        guard let selectedImage = self.imageView.image else { return }
        
        let options = VisionBarcodeDetectorOptions(formats: VisionBarcodeFormat.all)
        let vision = Vision.vision()
        
        let barcodeDetector = vision.barcodeDetector(options: options)
        let image = VisionImage(image: selectedImage)
        barcodeDetector.detect(in: image) { [weak self] (barcodes, err) in
            guard err == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                print("Error with barcodes")
                return
            }
            
            for barcode in barcodes {
                let rawValue = barcode.rawValue!
                self?.textLabel.text = (self?.textLabel.text)! + " " + rawValue
            }
        }
    }
}
