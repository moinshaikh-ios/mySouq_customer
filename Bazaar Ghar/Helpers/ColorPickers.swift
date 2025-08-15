//
//  ColorPickers.swift
//  RGB
//
//  Created by Usama on 04/11/2021.
//

import ImageIO
import UIKit
//MARK:- Color picker
@IBDesignable open class ColorPicker: UIView {
    
    fileprivate var pickerImage1:PickerImage?
    fileprivate var pickerImage2:PickerImage?
    fileprivate var image:UIImage?
    fileprivate var data1Shown = false
    fileprivate lazy var opQueue:OperationQueue = { return OperationQueue() }()
    fileprivate var lock:NSLock = NSLock()
    fileprivate var rerender = false
    open var onColorChange:((_ color:UIColor, _ finished:Bool)->Void)? = nil
    
    
    open var a:CGFloat = 1 {
        didSet {
            if a < 0 || a > 1 {
                a = max(0, min(1, a))
            }
        }
    }
    
    open var h:CGFloat = 0 { // // [0,1]
        didSet {
            if h > 1 || h < 0 {
                h = max(0, min(1, h))
            }
            renderBitmap()
            setNeedsDisplay()
        }
        
    }
    
    fileprivate var currentPoint:CGPoint = CGPoint.zero
    
    
    open func saturationFromCurrentPoint() -> CGFloat {
        return currentPoint.x
    }
    
    open func brigthnessFromCurrentPoint() -> CGFloat {
        return currentPoint.y
    }
    
    open var color:UIColor  {
        set(value) {
            var hue:CGFloat = 1
            var saturation:CGFloat = 1
            var brightness:CGFloat = 1
            var alpha:CGFloat = 1
            value.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            a = alpha
            if hue != h || pickerImage1 == nil {
                self.h = hue
            }
            currentPoint = CGPoint(x: saturation, y: brightness)
            self.setNeedsDisplay()
        }
        get {
            return UIColor(hue: h, saturation: saturationFromCurrentPoint(), brightness: brigthnessFromCurrentPoint(), alpha: a)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = true
        clipsToBounds = true
        layer.cornerRadius  = 6
        self.addObserver(self, forKeyPath: "bounds",
                         options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial],
                         context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "bounds")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            if(bounds.isEmpty) {
                return
            }
            if var pImage1 = pickerImage1 {
                pImage1.changeSize(width: Int(self.bounds.width), height: Int(self.bounds.height))
            }
            if var pImage2 = pickerImage2 {
                pImage2.changeSize(width: Int(self.bounds.width), height: Int(self.bounds.height))
            }
            renderBitmap()
            self.setNeedsDisplay()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        handleTouche(touch, ended: false)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        handleTouche(touch, ended: false)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        handleTouche(touch, ended: true)
    }
    
    fileprivate func handleColorChange(_ color:UIColor, finished:Bool) {
        if color !== self.color {
            if let handler = onColorChange {
                handler(color, finished)
            }
            setNeedsDisplay()
        }
    }
    
    fileprivate func handleTouche(_ touch:UITouch, ended:Bool) {
        // set current point
        let point = touch.location(in: self)
        let x:CGFloat = min(bounds.width, max(0, point.x)) / bounds.width
        let y:CGFloat = min(bounds.height, max(0, point.y)) / bounds.height
        currentPoint = CGPoint(x: x, y: y)
        handleColorChange(pointToColor(currentPoint), finished: ended)
    }
    
    fileprivate func pointToColor(_ point:CGPoint) ->UIColor {
        let s:CGFloat = min(1, max(0, point.x))
        let b:CGFloat = min(1, max(0, point.y))
        return UIColor(hue: h, saturation: s, brightness: b, alpha:a)
    }
    
    fileprivate func renderBitmap() {
        if self.bounds.isEmpty {
            return
        }
        if !lock.try() {
            rerender = true
            return
        }
        rerender = false
        
        if pickerImage1 == nil {
            self.pickerImage1 = PickerImage(width: Int(bounds.width), height: Int(bounds.height))
            self.pickerImage2 = PickerImage(width: Int(bounds.width), height: Int(bounds.height))
        }
        #if !TARGET_INTERFACE_BUILDER
        opQueue.addOperation { () -> Void in
            // Write colors to data array
            if self.data1Shown { self.pickerImage2!.writeColorData(hue: self.h, alpha:self.a) } else { self.pickerImage1!.writeColorData(hue: self.h, alpha:self.a) }
            
            
            // flip images
            self.image = self.data1Shown ? self.pickerImage2!.getImage()! : self.pickerImage1!.getImage()!
            self.data1Shown = !self.data1Shown
            
            // make changes visible
            OperationQueue.main.addOperation({ () -> Void in
                self.setNeedsDisplay()
                self.lock.unlock()
                if self.rerender {
                    self.renderBitmap()
                }
            })
            
        }
        #else
        self.pickerImage1!.writeColorData(hue: self.h, alpha:self.a)
        self.image = self.pickerImage1!.getImage()!
        #endif
    }
    
    open override func draw(_ rect: CGRect) {
        #if TARGET_INTERFACE_BUILDER
        if pickerImage1 == nil {
            commonInit()
        }
        #endif
        if let img = image {
            img.draw(in: rect)
        }
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: currentPoint.x * bounds.width - 5,
                                                   y: currentPoint.y * bounds.height - 5,
                                                   width: 10,
                                                   height: 10))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: currentPoint.x * bounds.width - 4,
                                                    y: currentPoint.y * bounds.height - 4,
                                                    width: 8,
                                                    height: 8))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 1
        oval2Path.stroke()
    }
    
}

//MARK:-Color picker controller
open class ColorPickerController: NSObject {
    
    open var onColorChange:((_ color:UIColor, _ finished:Bool)->Void)? = nil
    
    // Hue Picker
    open var huePicker:HuePicker
    
    // Color Well
//    open var colorWell:ColorWell {
//        didSet {
//            huePicker.setHueFromColor(colorWell.color)
//            colorPicker.color =  colorWell.color
//        }
//    }
    
    
    // Color Picker
    open var colorPicker:ColorPicker
    
    open var color:UIColor? {
        set(value) {
            colorPicker.color = value!
            //colorWell.color = value!
            huePicker.setHueFromColor(value!)
        }
        get {
            return colorPicker.color
        }
    }
    
    public init(svPickerView:ColorPicker, huePickerView:HuePicker) {
        self.huePicker = huePickerView
        self.colorPicker = svPickerView
        //self.colorWell = colorWell
        //self.colorWell.color = colorPicker.color
        self.huePicker.setHueFromColor(colorPicker.color)
        super.init()
        self.colorPicker.onColorChange = {(color, finished) -> Void in
            self.huePicker.setHueFromColor(color)
            //self.colorWell.previewColor = (finished) ? nil : color
            //if(finished) {self.colorWell.color = color}
            self.onColorChange?(color, finished)
        }
        self.huePicker.onHueChange = {(hue, finished) -> Void in
            self.colorPicker.h = CGFloat(hue)
            let color = self.colorPicker.color
            //self.colorWell.previewColor = (finished) ? nil : color
           // if(finished) {self.colorWell.color = color}
            self.onColorChange?(color, finished)
        }
    }
    
}

//MARK:- Hue picker
@IBDesignable open class HuePicker: UIView {
    
    var _h:CGFloat = 0.1111
    open var h:CGFloat { // [0,1]
        set(value) {
            _h = min(1, max(0, value))
            currentPoint = CGPoint(x: CGFloat(_h), y: 0)
            setNeedsDisplay()
        }
        get {
            return _h
        }
    }
    var image:UIImage?
    fileprivate var data:[UInt8]?
    fileprivate var currentPoint = CGPoint.zero
    open var handleColor:UIColor = UIColor.black
    
    open var onHueChange:((_ hue:CGFloat, _ finished:Bool) -> Void)?
    
    open func setHueFromColor(_ color:UIColor) {
        var h:CGFloat = 0
        color.getHue(&h, saturation: nil, brightness: nil, alpha: nil)
        self.h = h
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true;
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
    }
    
    
    func renderBitmap() {
        if bounds.isEmpty {
            return
        }
        
        let width = UInt(bounds.width)
        let height = UInt(bounds.height)
        
        if  data == nil {
            data = [UInt8](repeating: UInt8(255), count: Int(width * height) * 4)
        }

        var p = 0.0
        var q = 0.0
        var t = 0.0

        var i = 0
        //_ = 255
        var double_v:Double = 0
        var double_s:Double = 0
        let widthRatio:Double = 360 / Double(bounds.width)
        var d = data!
        for hi in 0..<Int(bounds.width) {
            let double_h:Double = widthRatio * Double(hi) / 60
            let sector:Int = Int(floor(double_h))
            let f:Double = double_h - Double(sector)
            let f1:Double = 1.0 - f
            double_v = Double(1)
            double_s = Double(1)
            p = double_v * (1.0 - double_s) * 255
            q = double_v * (1.0 - double_s * f) * 255
            t = double_v * ( 1.0 - double_s  * f1) * 255
            let v255 = double_v * 255
            i = hi * 4
            switch(sector) {
            case 0:
                d[i+1] = UInt8(v255)
                d[i+2] = UInt8(t)
                d[i+3] = UInt8(p)
            case 1:
                d[i+1] = UInt8(q)
                d[i+2] = UInt8(v255)
                d[i+3] = UInt8(p)
            case 2:
                d[i+1] = UInt8(p)
                d[i+2] = UInt8(v255)
                d[i+3] = UInt8(t)
            case 3:
                d[i+1] = UInt8(p)
                d[i+2] = UInt8(q)
                d[i+3] = UInt8(v255)
            case 4:
                d[i+1] = UInt8(t)
                d[i+2] = UInt8(p)
                d[i+3] = UInt8(v255)
            default:
                d[i+1] = UInt8(v255)
                d[i+2] = UInt8(p)
                d[i+3] = UInt8(q)
            }
        }
        var sourcei = 0
        for v in 1..<Int(bounds.height) {
            for s in 0..<Int(bounds.width) {
                sourcei = s * 4
                i = (v * Int(width) * 4) + sourcei
                d[i+1] = d[sourcei+1]
                d[i+2] = d[sourcei+2]
                d[i+3] = d[sourcei+3]
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        let provider = CGDataProvider(data: Data(bytes: d, count: d.count * MemoryLayout<UInt8>.size) as CFData)
        let cgimg = CGImage(width: Int(width), height: Int(height), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(width) * Int(MemoryLayout<UInt8>.size * 4),
            space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        
        
        image = UIImage(cgImage: cgimg!)
        
    }
    
    fileprivate func handleTouch(_ touch:UITouch, finished:Bool) {
        let point = touch.location(in: self)
        
        currentPoint = CGPoint(x: max(0, min(bounds.width, point.x)) / bounds.width , y: 0)
        _h = currentPoint.x
        onHueChange?(h, finished)
        setNeedsDisplay()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches.first! as UITouch, finished: false)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches.first! as UITouch, finished: false)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches.first! as UITouch, finished: true)
    }
    
    
    override open func draw(_ rect: CGRect) {
        if image == nil {
            renderBitmap()
        }
        if let img = image {
            img.draw(in: rect)
        }

        let handleRect = CGRect(x: bounds.width * currentPoint.x, y: 0, width: 35, height: bounds.height)
        drawHueDragHandler(frame: handleRect)
    }
    
    func drawHueDragHandler(frame: CGRect) {
        
        /*
        // Polygon Drawing
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: frame.minX + 4, y: frame.maxY - 6))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 7.46, y: frame.maxY))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.54, y: frame.maxY))
        polygonPath.close()
        UIColor.black.setFill()
        polygonPath.fill()
        
        //// Polygon 2 Drawing
        let polygon2Path = UIBezierPath()
        polygon2Path.move(to: CGPoint(x: frame.minX + 4, y: frame.minY + 6))
        polygon2Path.addLine(to: CGPoint(x: frame.minX + 7.46, y: frame.minY))
        polygon2Path.addLine(to: CGPoint(x: frame.minX + 0.54, y: frame.minY))
        polygon2Path.close()
        UIColor.white.setFill()
        polygon2Path.fill()*/

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: currentPoint.x * bounds.width,
                                                   y: currentPoint.y * bounds.height,
                                                   width: 15,
                                                   height: 15))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()


//        Oval 2 Drawing
//        let oval2Path = UIBezierPath(ovalIn: CGRect(x: currentPoint.x * bounds.width - 4,
//                                                    y: currentPoint.y * bounds.height - 4,
//                                                    width: frame.height/4,
//                                                    height: frame.height/2))
//        UIColor.white.setStroke()
//        oval2Path.lineWidth = 1
//        oval2Path.stroke()
    }




}

//MARK:- PickerImage
public struct PickerImage {

    var width: Int
    var height: Int
    var hue: CGFloat = 0
    var alpha: CGFloat = 1.0

    let lockQueue = DispatchQueue(label: "PickerImage")
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

    // MARK: Pixel Data struct

    public struct PixelData {
        var a:UInt8 = 255
        var r:UInt8
        var g:UInt8
        var b:UInt8
    }

    var pixelData: [PixelData]

    // MARK: Image generation

    public func getImage() -> UIImage? {
        return self.imageFromARGB32Bitmap(pixels: self.pixelData, width: UInt(self.width), height: UInt(self.height))
    }

    private func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt) -> UIImage? {

        let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32

        assert(pixels.count == Int(width * height))

        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)
            ) else {
                return nil
        }

        guard let cgim = CGImage(width: Int(width),
                                 height: Int(height),
                                 bitsPerComponent: Int(bitsPerComponent),
                                 bitsPerPixel: Int(bitsPerPixel),
                                 bytesPerRow: Int(width) * MemoryLayout<PixelData>.size,
                                 space: rgbColorSpace,
                                 bitmapInfo: bitmapInfo,
                                 provider: providerRef,
                                 decode: nil,
                                 shouldInterpolate: true,
                                 intent: .defaultIntent) else {
                                    return nil
        }

        let image = UIImage(cgImage: cgim)
        return image
    }

    // MARK: Size changes

    mutating func changeSize(width: Int, height: Int) {
        lockQueue.sync() {
            self.width = width
            self.height = height

            let whitePixel = PixelData(a: 255, r: 255, g: 255, b: 255)
            self.pixelData = Array<PixelData>(repeating: whitePixel, count: Int(width * height))

            self.writeColorData(hue: self.hue, alpha: self.alpha)
        }
    }

    // MARK: Lifecycle

    init(width:Int, height:Int) {
        self.width = width
        self.height = height

        let whitePixel = PixelData(a: 255, r: 255, g: 255, b: 255)
        self.pixelData = Array<PixelData>(repeating: whitePixel, count: Int(width * height))

        self.writeColorData(hue: self.hue, alpha: self.alpha)
    }

    // MARK: Generating raw image data

    public mutating func writeColorData(hue: CGFloat, alpha: CGFloat) {
        lockQueue.sync() {
            self.hue = hue
            self.alpha = alpha

            let saturationSteps = self.width
            let brightnessSteps = self.height

            let saturationStepSize: CGFloat = 1.0 / CGFloat(saturationSteps)
            let brightnessStepSize: CGFloat = 1.0 / CGFloat(brightnessSteps)

            var currentBrightnessIndex = 0
            while currentBrightnessIndex < brightnessSteps {

                var currentSaturationIndex = 0
                while currentSaturationIndex < saturationSteps {


                    let currentSaturation = CGFloat(currentSaturationIndex) * saturationStepSize
                    let currentBrightness = CGFloat(currentBrightnessIndex) * brightnessStepSize
                    let color = UIColor(hue: hue,
                                        saturation: currentSaturation,
                                        brightness: currentBrightness,
                                        alpha: alpha)

                    var red: CGFloat = 0
                    var green: CGFloat = 0
                    var blue: CGFloat = 0
                    var alpha: CGFloat = 0
                    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                    
                    let index = currentBrightnessIndex * width + currentSaturationIndex
                    self.pixelData[index] = PixelData(a: UInt8(alpha*255.0), r: UInt8(red*255.0), g: UInt8(green*255.0), b: UInt8(blue*255.0))

                    currentSaturationIndex += 1
                }

                currentBrightnessIndex += 1
            }
        }
    }

    
}

