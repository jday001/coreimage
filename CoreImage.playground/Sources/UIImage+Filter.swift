import UIKit


public extension UIImage {
    public func withSepiaFilter() -> UIImage {
        let ciImage = CIImage(image: self)!
        let params: [String: Any] = [
            "inputImage": ciImage,
            "inputIntensity": 1
        ]
        
        let sepia = ciImage.applyingFilter("CISepiaTone", parameters: params)
        return sepia.uiImage()
    }
    
    public func withVintageFilter() -> UIImage {
        let ciImage = CIImage(image: self)!
        let params: [String: Any] = ["inputImage": ciImage]
        let vintage = ciImage.applyingFilter("CIPhotoEffectTransfer", parameters: params)
        return vintage.uiImage()
    }
}
