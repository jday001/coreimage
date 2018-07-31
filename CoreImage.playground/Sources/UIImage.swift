import UIKit


class Math {
    static func radians(from degrees: Double) -> CGFloat {
        let radians = Measurement(value: degrees, unit: UnitAngle.degrees)
            .converted(to: UnitAngle.radians).value
        
        return CGFloat(radians)
    }
}

public extension UIImage {
    
    public func rotated(by degrees: Double, clockwise: Bool) -> UIImage {
        let ciImage = CIImage(image: self)!
        
        var finalExtent: CGRect = .zero
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        if ciImage.extent.width > ciImage.extent.height {
            finalExtent.size.width = ciImage.extent.width
            finalExtent.size.height = ciImage.extent.width
            offsetY = (ciImage.extent.width - ciImage.extent.height) / 2
        } else {
            finalExtent.size.width = ciImage.extent.height
            finalExtent.size.height = ciImage.extent.height
            offsetX = (ciImage.extent.height - ciImage.extent.width) / 2
        }
        
        var rotationAngle = Math.radians(from: degrees)
        if clockwise {
            rotationAngle = rotationAngle * -1
        }
        
        let centerX = ciImage.extent.width / 2
        let centerY = ciImage.extent.height / 2
        var transform = CGAffineTransform(translationX: centerX, y: centerY)
        transform = transform.rotated(by: rotationAngle)
        transform = transform.translatedBy(x: -centerX, y: -centerY)
        
        let rotatedImage = ciImage.transformed(by: transform)
        let translation = CGAffineTransform(translationX: offsetX, y: offsetY)
        let finalImage = rotatedImage.transformed(by: translation)
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(finalImage, from: finalExtent)!
        let image = UIImage(cgImage: imageRef)
        
        return image
    }
    
    public func scaled(by factor: CGFloat) -> UIImage {
        let ciImage = CIImage(image: self)!
        let translationX: CGFloat = ciImage.extent.width / 2
        let translationY: CGFloat = ciImage.extent.height / 2
        
        var transform = CGAffineTransform(translationX: translationX, y: translationY)
        transform = transform.scaledBy(x: factor, y: factor)
        transform = transform.translatedBy(x: -translationX, y: -translationY)
        
        let frame = ciImage.transformed(by: transform)
        let context = CIContext(options: nil)
        
        let imageRef = context.createCGImage(frame, from: ciImage.extent)!
        return UIImage(cgImage: imageRef)
    }
    
    public func translatedX(by distance: CGFloat) -> UIImage {
        var translation: CGFloat = 0
        let ciImage = CIImage(image: self)!
        
        if distance > 0 {
            if distance >= ciImage.extent.width {
                translation = ciImage.extent.width - 1
            } else {
                translation = distance
            }
        } else {
            if distance <= -ciImage.extent.width {
                translation = -ciImage.extent.width + 1
            } else {
                translation = distance
            }
        }
        
        let transform = CGAffineTransform(translationX: translation, y: 0)
        let frame = ciImage.transformed(by: transform)
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(frame, from: ciImage.extent)!
        return UIImage(cgImage: imageRef)
    }
    
    public func translatedY(by distance: CGFloat) -> UIImage {
        var translation: CGFloat = 0
        let ciImage = CIImage(image: self)!
        
        if distance > 0 {
            if distance >= ciImage.extent.width {
                translation = ciImage.extent.width - 1
            } else {
                translation = distance
            }
        } else {
            if distance <= -ciImage.extent.width {
                translation = -ciImage.extent.width + 1
            } else {
                translation = distance
            }
        }
        
        let transform = CGAffineTransform(translationX: 0, y: translation)
        let frame = ciImage.transformed(by: transform)
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(frame, from: ciImage.extent)!
        return UIImage(cgImage: imageRef)
    }
    
    public func scaledToFit(rect: CGRect) -> UIImage {
        
        // compute scale factor for imageView
        let widthScaleFactor = rect.size.width / self.size.width
        let heightScaleFactor = rect.size.height / self.size.height
        
        // applying an adjustment to the y origin to not get the very top of the image
        let imageViewOriginX: CGFloat = 0
        let imageViewOriginY: CGFloat = 0
        var imageViewWidth: CGFloat = 0
        var imageViewHeight: CGFloat = 0
        
        // if image is narrow and tall, scale to width and align vertically to the top
        if widthScaleFactor > heightScaleFactor {
            imageViewWidth = self.size.width * widthScaleFactor
            imageViewHeight = self.size.height * widthScaleFactor
        } else {
            
            // if image is wide and short, scale to height and align horizontally centered
            imageViewWidth = self.size.width * heightScaleFactor
            imageViewHeight = self.size.height * heightScaleFactor
        }
        
        let finalRect  = CGRect(x: imageViewOriginX,
                                y: imageViewOriginY,
                                width: imageViewWidth,
                                height: imageViewHeight)
        return scaled(to: finalRect)
    }
    
    private func scaled(to rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
