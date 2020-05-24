//
//  ImagePickerViewController.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/05/22.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickUpButton:UIButton = UIButton()
    var picker: UIImagePickerController! = UIImagePickerController()
    var selectedImage: UIImage?
    var delegate: MessageSendProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

//        //押されるとUIImagePickerControllerが開くボタンを作成する
//        imagePickUpButton.frame = self.view.bounds
//        imagePickUpButton.addTarget(self, action: #selector(imagePickUpButtonClicked(sender:)), for: .touchUpInside)
//        imagePickUpButton.backgroundColor = UIColor.gray
//        imagePickUpButton.setTitle("Toupe Me!!", for: UIControl.State.normal)
//        self.view.addSubview(imagePickUpButton)
        showImagePicker()
    }
    
    deinit {
        delegate = nil
    }
    
    //basicボタンが押されたら呼ばれます
    @objc func imagePickUpButtonClicked(sender: UIButton){
        
    }
    
    func showImagePicker() {

        //PhotoLibraryから画像を選択
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //デリゲートを設定する
        picker.delegate = self
        
        //現れるピッカーNavigationBarの文字色を設定する
        picker.navigationBar.tintColor = UIColor.white
        
        //現れるピッカーNavigationBarの背景色を設定する
        picker.navigationBar.barTintColor = UIColor.gray
        
        //ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    //UIImagePickerControllerのデリゲートメソッド
    
    //画像が選択された時に呼ばれる.
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            
            print("Error")
            return
        }
        selectedImage = image
        //ボタンの背景に選択した画像を設定
        //imagePickUpButton.setBackgroundImage(image, for: UIControl.State.normal)
        
        delegate?.sendImageMessage(image: selectedImage)
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
     //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
