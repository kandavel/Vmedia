//
//  UIImageExtension.swift
//  Walmart-WaIE
//
//  Created by kandavel on 02/03/23.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(_ height: CGFloat, aspectRatio: CGFloat, opaque: Bool) -> UIImage {
        var width: CGFloat
        var newImage: UIImage
        
        if aspectRatio > 1 {
            width = height * aspectRatio
        } else {
            width = height / aspectRatio
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = opaque
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format)
        newImage = renderer.image {
            (context) in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        return newImage
    }
}
