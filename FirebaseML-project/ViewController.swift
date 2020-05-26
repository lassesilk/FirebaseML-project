//
//  ViewController.swift
//  FirebaseML-project
//
//  Created by Lasse Silkoset on 25/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainHeight(constant: 350)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    lazy var chooseImageBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose Image", for: .normal)
        btn.addTarget(self, action: #selector(handleChooseImageTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var textRecognitionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Text Recognition", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.constrainHeight(constant: 100)
        btn.constrainWidth(constant: 140)
        btn.addTarget(self, action: #selector(textRecTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var faceDetectionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Face Detection", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.constrainHeight(constant: 100)
        btn.constrainWidth(constant: 140)
        btn.addTarget(self, action: #selector(handleFaceDetectionTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageLabeling: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Image Labelling", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.constrainHeight(constant: 100)
        btn.constrainWidth(constant: 140)
        btn.addTarget(self, action: #selector(handleImageLabelingTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var barcodeDetection: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Barcode Detection", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.constrainHeight(constant: 100)
        btn.constrainWidth(constant: 140)
        btn.addTarget(self, action: #selector(handleBarcodeDetectionTapped), for: .touchUpInside)
        return btn
    }()
    
     //MARK: - Lifecycle Funcs *******************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()
        imagePicker.delegate = self
    }
    
    //MARK: - Selector Funcs *******************************************************
    
    @objc fileprivate func handleImageLabelingTapped() {
        let imageLabelingController = ImageLabelingController()
        imageLabelingController.imageView.image = self.imageView.image
        navigationController?.pushViewController(imageLabelingController, animated: true)
    }
    
    @objc fileprivate func handleBarcodeDetectionTapped() {
        let barcodeController = BarcodeDetectionController()
        barcodeController.imageView.image = self.imageView.image
        navigationController?.pushViewController(barcodeController, animated: true)
    }
    
    @objc fileprivate func handleFaceDetectionTapped() {
        let faceDetectionController = FaceDetectionController()
        faceDetectionController.imageView.image = self.imageView.image
        navigationController?.pushViewController(faceDetectionController, animated: true)
    }
    
    @objc fileprivate func textRecTapped() {
        let textRecController = TextRecognitionController()
        textRecController.imageView.image = self.imageView.image
        navigationController?.pushViewController(textRecController, animated: true)
    }
    
    @objc fileprivate func handleChooseImageTapped() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - ImagePicker Funcs *******************************************************
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
     //MARK: - Layout Funcs *******************************************************
    
    
    fileprivate func setupLayout() {
        
        title = "ML Kit"
        view.backgroundColor = .white
        
        let bottomTopStack = UIStackView(arrangedSubviews: [textRecognitionBtn, faceDetectionBtn])
        bottomTopStack.axis = .horizontal
        bottomTopStack.distribution = .fillEqually
        
        let bottomBottomStack = UIStackView(arrangedSubviews: [imageLabeling, barcodeDetection])
        bottomBottomStack.axis = .horizontal
        bottomBottomStack.distribution = .fillEqually
        
        let bottomStack = UIStackView(arrangedSubviews: [bottomTopStack, bottomBottomStack])
        bottomStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [imageView, chooseImageBtn, bottomStack])
        stack.axis = .vertical
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

