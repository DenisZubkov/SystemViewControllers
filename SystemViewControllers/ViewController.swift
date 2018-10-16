//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Denis Zubkov on 15/10/2018.
//  Copyright © 2018 Denis Zubkov. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sharedButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Выберете источник изображения", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Камера", style: .default) {
                action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photoLibraryAction = UIAlertAction(title: "Фото", style: .default) {
                action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([])
        mailComposeViewController.setSubject("Получи картинку")
        mailComposeViewController.setMessageBody("Шлю картинку", isHTML: false)
        if let dataImage =  imageView.image?.jpegData(compressionQuality: 1) {
            mailComposeViewController.addAttachmentData(dataImage, mimeType: "image/jpg", fileName: "image.jpg")
        }
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

