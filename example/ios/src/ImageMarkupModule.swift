//
//  ImageMarkupModule.swift
//  example
//
//  Created by Lane Lu on 2023/4/20.
//

import Foundation
import UIKit
import AVFoundation
import CoreServices
import TOCropViewController
import QuickLook

@objc(ImageMarkupModule)
class ImageMarkupModule : RCTEventEmitter {
  private var resolve: RCTPromiseResolveBlock!
  private var reject: RCTPromiseRejectBlock!
  private var imageURL: String = ""
  
  @objc func requiresMainQueueSetup() -> Bool {
    false
  }
  
  override func supportedEvents() -> [String]! {
    return []
  }
  
  @objc
  func editImage(_ url: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    self.resolve = resolve
    self.reject = reject
    setImageURL(url)
    print("Open edit screen: \(imageURL)")

    DispatchQueue.main.async {
      let preview = QLPreviewController()
      preview.modalPresentationStyle = .fullScreen
      preview.dataSource = self
      preview.delegate = self
      
      let controller = RCTPresentedViewController();
      controller?.present(preview, animated: true, completion: nil)
    }
  }
  
  @objc
  func cropImage(_ url: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    self.resolve = resolve
    self.reject = reject
    setImageURL(url)
    print("Open crop screen: \(imageURL)")
    
    let path: String = getImageURL()
    let data: Data = FileManager.default.contents(atPath: path)!
    let image = UIImage(data: data)
    DispatchQueue.main.async {
      let corpController = TOCropViewController(image: image!)
      corpController.modalPresentationStyle = .fullScreen
      corpController.delegate = self
      corpController.toolbarPosition = .top

      let controller = RCTPresentedViewController();
      controller?.present(corpController, animated: true, completion: nil)
    }
  }
  
  func setImageURL(_ url: String) -> Void {
    var s: String = url
    if !s.hasPrefix("file://") {
      s = "file://\(s)"
    }
    self.imageURL = s
  }
  
  func getImageURL() -> String {
    if imageURL.hasPrefix("file://") {
      return String(imageURL.dropFirst("file://".count))
    } else {
      return imageURL
    }
  }
  
  func onSuccess() -> Void {
    resolve(imageURL)
  }

  func getExtension(_ name: String) -> String {
      let filename: NSString = NSString(string: name)
      return filename.pathExtension
  }
  
  func getTempFile(_ ext: String) -> String {
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let distPath = "\(documentDirectory[0])/\(Date().timeIntervalSinceReferenceDate).\(ext)"
    if fileManager.fileExists(atPath: distPath) {
      do {
        try fileManager.removeItem(atPath: distPath)
      } catch {
        print("\(error)")
      }
    }
    return distPath
  }
}

extension ImageMarkupModule : TOCropViewControllerDelegate {
  func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
    print("Corp picture")
    
    //setup file name
    let distPath: String = getTempFile("jpeg")
    
    //write file
    let data = image.jpegData(compressionQuality: 1.0)
    FileManager.default.createFile(atPath: distPath, contents: data, attributes: [:])

    //set var
    setImageURL(distPath)

    //return promise
    onSuccess()
    
    //close screen
    cropViewController.dismiss(animated: true, completion: nil)
  }
}

extension ImageMarkupModule : QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    1
  }
  
  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    let url: NSURL = NSURL(string: imageURL)!
    return url as QLPreviewItem
  }
}

extension ImageMarkupModule : QLPreviewControllerDelegate {
  func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
    .createCopy
  }
    
  func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
    let path: String = modifiedContentsURL.path
    
    //read file
    let fileManager = FileManager.default
    let data: Data = fileManager.contents(atPath: path)!
    
    //write file
    let ext = getExtension(path)
    let distPath = getTempFile(ext)
    fileManager.createFile(atPath: distPath, contents: data, attributes: [:])
    
    //member var
    setImageURL(distPath)
    print("complete editImage: \(imageURL)")
    
    onSuccess()
    controller.dismiss(animated: true, completion: nil)
  }
}
