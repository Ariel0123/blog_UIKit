//
//  Media.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/17/21.
//

import Foundation
import UIKit

struct Media {
    var key: String = ""
    var filename: String = ""
    var data: Data = Data()
    var mimeType: String = ""
    
    init?(withImage image: UIImage, forKey key: String, filename: String, mimeType: String) {
        
        
        self.key = key
        if mimeType == "jpeg" || mimeType == "jpg"{
            self.mimeType = "image/jpeg"
            self.filename = filename+".jpeg"
            guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
            self.data = data
            
        }else if mimeType == "png"{
            self.mimeType = "image/png"
            self.filename = filename+".png"
            guard let data = image.pngData() else { return nil }
            self.data = data
          
        }
    }
    
}
