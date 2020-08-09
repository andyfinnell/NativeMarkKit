import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

protocol ImageTextAttachmentDelegate: AnyObject {
    func imageTextAttachmentLoadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void)
}

protocol ImageTextAttachmentLayoutDelegate: AnyObject {
    func imageTextAttachmentDidLoadImage(atCharacterIndex characterIndex: Int)
}

final class ImageTextAttachment: NativeTextAttachment {
    private enum Status {
        case idle
        case loading
        case loaded(NativeImage)
    }
    private let imageUrl: String?
    private var status = Status.idle
    private weak var delegate: ImageTextAttachmentDelegate?
    weak var layoutDelegate: ImageTextAttachmentLayoutDelegate?
    
    init(imageUrl: String?, delegate: ImageTextAttachmentDelegate) {
        self.imageUrl = imageUrl
        self.delegate = delegate
        super.init()
    }
    
    override func draw(in rect: CGRect) {
        if let image = loadImage() {
            // On the Mac, the origin is fractional which results in artifacts,
            //  which in turn breaks the render tests as no run is the same.
            let origin = CGPoint(x: rect.minX.rounded(), y: rect.minY.rounded())
            let drawRect = CGRect(origin: origin, size: rect.size)
            image.draw(in: drawRect)
        } else {
            NativeColor.adaptableImagePlaceholderColor.set()
            rect.fill()
        }
    }
    
    override func lineFragment(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect) -> CGRect {
        if let image = loadImage() {
            return CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        } else {
            return CGRect(x: 0, y: 0, width: lineFrag.height, height: lineFrag.height)
        }
    }
}

private extension ImageTextAttachment {
    func loadImage() -> NativeImage? {
        switch status {
        case .idle:
            beginLoading()
            return nil
        case .loading:
            return nil
        case let .loaded(image):
            return image
        }
    }
    
    func beginLoading() {
        guard let urlString = imageUrl else {
            return
        }
        
        status = .loading
        delegate?.imageTextAttachmentLoadImage(urlString) { [weak self] image in
            guard let image = image else { return }
            self?.status = .loaded(image)
            
            if let characterIndex = self?.characterIndex {
                self?.layoutDelegate?.imageTextAttachmentDidLoadImage(atCharacterIndex: characterIndex)
            }
        }
    }
}
