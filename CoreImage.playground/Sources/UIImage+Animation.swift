import UIKit


extension UIImage {
    public func pixellated(percent: CGFloat) -> UIImage {
        let ciImage = CIImage(image: self)!
        let dimension = ciImage.extent.width / 20
        let inputCenter = CIVector(x: ciImage.extent.width / 2, y: ciImage.extent.height / 2)
        let params: [String: Any] = [
            "inputImage": ciImage,
            "inputCenter": inputCenter,
            "inputScale": dimension * percent
        ]
        
        let frame = ciImage.applyingFilter("CIPixellate", parameters: params)
        
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(frame, from: ciImage.extent)!
        return UIImage(cgImage: imageRef)
    }
    
    public func bumpDistortion(percent: CGFloat) -> UIImage {
        let ciImage = CIImage(image: self)!
        let context = CIContext(options: nil)
        
        let inputCenter = CIVector(x: ciImage.extent.width / 2,
                                   y: ciImage.extent.height / 2)
        let inputRadius = ciImage.extent.width / 2
        
        let params: [String: Any] = [
            "inputImage": ciImage,
            "inputCenter": inputCenter,
            "inputRadius": inputRadius,
            "inputScale": percent
        ]
        
        let frame = ciImage.applyingFilter("CIBumpDistortion", parameters: params)
        
        let imageRef = context.createCGImage(frame, from: ciImage.extent)!
        return UIImage(cgImage: imageRef)
    }
}
