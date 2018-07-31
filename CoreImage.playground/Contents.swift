  
import UIKit
import PlaygroundSupport

  typealias FramesCompletion = ((_ frames: [UIImage]) -> Void)

enum Animation {
    case pixellate
    case bumpDistortion
    
    func frames(from image: UIImage, completion: @escaping FramesCompletion) {
        switch self {
        case .pixellate:
            pixellatedFrames(from: image, completion: completion)
            
        case .bumpDistortion:
            return bumpDistortionFrames(from: image, completion: completion)
        }
    }
    
    private func pixellatedFrames(from image: UIImage, completion: @escaping FramesCompletion) {
        var images = [UIImage]()
        for i in 1..<10 {
            images.append(image.pixellated(percent: CGFloat(i) / 10))
        }
        
        for i in (2..<9).reversed() {
            images.append(image.pixellated(percent: CGFloat(i) / 10))
        }
        
        completion(images)
    }
    
    private func bumpDistortionFrames(from image: UIImage, completion: @escaping FramesCompletion) {
        var images = [UIImage]()
        let sequence = stride(from: 1, to: 10, by: 2)
        
        for i in sequence {
            images.append(image.bumpDistortion(percent: CGFloat(i) / 10))
        }
        
        for i in sequence.reversed() {
            images.append(image.bumpDistortion(percent: CGFloat(i) / 10))
        }
        
        for i in sequence {
            images.append(image.bumpDistortion(percent: CGFloat(-i) / 10))
        }
        
        for i in sequence.reversed() {
            images.append(image.bumpDistortion(percent: CGFloat(-i) / 10))
        }
        
        completion(images)
    }
}


class MyViewController : UIViewController {
    private let chipImage = UIImage(named: "Chip_cropped.jpg")!
    
    private lazy var imageView: UIImageView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let frame = CGRect(x: 0,
                           y: 30,
                           width: screenWidth * 0.5,
                           height: screenWidth * 0.5)
        
        let imageView = UIImageView(frame: frame)
        imageView.image = chipImage
        imageView.backgroundColor = .gray
        imageView.animationDuration = 2.0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var filterControl: UISegmentedControl = {
        let segFrame = CGRect(x: 80, y: 450, width: 200, height: 21)
        let segControl = UISegmentedControl(frame: segFrame)
        segControl.insertSegment(withTitle: "Plain", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Sepia", at: 1, animated: false)
        segControl.insertSegment(withTitle: "Vintage", at: 2, animated: false)
        segControl.addTarget(self, action: #selector(filterSegmentChanged(_:)), for: .valueChanged)
        segControl.selectedSegmentIndex = 0
        return segControl
    }()
    
    private lazy var animationControl: UISegmentedControl = {
        let segFrame = CGRect(x: 80, y: 500, width: 200, height: 21)
        let segControl = UISegmentedControl(frame: segFrame)
        segControl.insertSegment(withTitle: "None", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Pixellate", at: 1, animated: false)
        segControl.insertSegment(withTitle: "Bump", at: 2, animated: false)
        segControl.addTarget(self, action: #selector(animationSegmentChanged(_:)),
                             for: .valueChanged)
        segControl.selectedSegmentIndex = 0
        return segControl
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(filterControl)
        view.addSubview(animationControl)
        self.view = view
    }
    
    @objc
    private func filterSegmentChanged(_ sender: Any) {
        guard let segControl = sender as? UISegmentedControl else {
            return
        }
        
        switch segControl.selectedSegmentIndex {
        case 0:
            imageView.image = chipImage
            animateIfNeeded()
            
        case 1:
            imageView.image = chipImage.withSepiaFilter()
            animateIfNeeded()
            
        case 2:
            imageView.image = chipImage.withVintageFilter()
            animateIfNeeded()
            
        default:
            break
        }
    }
    
    @objc
    private func animationSegmentChanged(_ sender: Any) {
        imageView.stopAnimating()
        animateIfNeeded()
    }
    
    private func animateIfNeeded() {
        switch animationControl.selectedSegmentIndex {
        case 0:
            imageView.animationImages = nil
            imageView.stopAnimating()
            
        case 1:
            if let currentImage = imageView.image {
                DispatchQueue.global().async {
                    Animation.pixellate.frames(from: currentImage) { frames in
                        DispatchQueue.main.async {
                            self.imageView.animationImages = frames
                            self.imageView.startAnimating()
                        }
                    }
                }
            }
            
        case 2:
            if let currentImage = imageView.image {
                DispatchQueue.global().async {
                    Animation.bumpDistortion.frames(from: currentImage) { frames in
                        DispatchQueue.main.async {
                            self.imageView.animationImages = frames
                            self.imageView.startAnimating()
                        }
                    }
                }
            }
            
        default:
            break
        }
    }
}

PlaygroundPage.current.liveView = MyViewController()
