//
//  Global.swift
//  InterviewTask
//
//  Created by Balachandar M on 09/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class Global: NSObject {

    func saveImagesToFileManager(imageReceived : UIImage, name : String) -> String {
          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
          let fileName = name + ".jpg"
          let fileURL = documentsDirectory.appendingPathComponent(fileName)
          if let data = imageReceived.jpegData(compressionQuality:  1.0),
              !FileManager.default.fileExists(atPath: fileURL.path) {
              do {
                  try data.write(to: fileURL)
                  print("file saved")
                  return fileURL.absoluteString
              } catch {
                  print("error saving file:", error)
              }
          }
          return ""
      }
    
}
