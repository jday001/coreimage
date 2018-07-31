import UIKit

public extension CIImage {
    public func uiImage() -> UIImage {
        let context = CIContext()
        let cgImage = context.createCGImage(self, from: self.extent)!
        let newImage = UIImage(cgImage: cgImage)
        return newImage
    }
}
