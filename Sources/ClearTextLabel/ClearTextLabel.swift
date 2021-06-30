import UIKit

class ClearTextLabel: UILabel {
    
    var maskColor : UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    func customInit() {
        maskColor = self.backgroundColor
        self.textColor = UIColor.white
        backgroundColor = UIColor.clear
        self.isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        super.draw(rect)

        context.concatenate(__CGAffineTransformMake(1, 0, 0, -1, 0, rect.height))

        let image: CGImage = context.makeImage()!
        let mask: CGImage = CGImage(maskWidth: image.width, height: image.height, bitsPerComponent: image.bitsPerComponent, bitsPerPixel: image.bitsPerPixel, bytesPerRow: image.bytesPerRow, provider: image.dataProvider!, decode: image.decode, shouldInterpolate: image.shouldInterpolate)!

        context.clear(rect)
        
        context.saveGState()
        context.clip(to: rect, mask: mask)
        
        if (self.layer.cornerRadius != 0.0) {
            context.addPath(CGPath(roundedRect: rect, cornerWidth: self.layer.cornerRadius, cornerHeight: self.layer.cornerRadius, transform: nil))
            context.clip()
        }

        drawBackgroundInRect(rect: rect)
        context.restoreGState()
    }

    func drawBackgroundInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        if let _ = maskColor {
            maskColor!.set()
        }

        context!.fill(rect)
    }
}
