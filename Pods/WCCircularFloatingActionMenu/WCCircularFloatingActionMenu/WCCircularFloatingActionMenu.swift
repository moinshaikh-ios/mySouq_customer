import UIKit

public protocol WCCircularFloatingActionMenuDataSource {
    func floatingActionMenu(menu: WCCircularFloatingActionMenu, buttonForItem item: Int) -> UIButton
    func numberOfItemsForFloatingActionMenu(menu: WCCircularFloatingActionMenu) -> Int
}

public protocol WCCircularFloatingActionMenuDelegate {
    func floatingActionMenu(menu: WCCircularFloatingActionMenu, didSelectItem item: Int)
}

@objc(WCCircularFloatingActionMenu)
public class WCCircularFloatingActionMenu: UIButton {
    
    public var delegate: WCCircularFloatingActionMenuDelegate?
    public var dataSource: WCCircularFloatingActionMenuDataSource?
    
    @IBInspectable public var radius: CGFloat = 100
    @IBInspectable public var animationDuration: TimeInterval = 0.2
    
    @IBInspectable public var blurColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            screenView.backgroundColor = blurColor
        }
    }
    
    @IBInspectable public var startAngleDegrees: CGFloat {
        set { self.startAngle = newValue.normalizeDegrees().toRadians() }
        get { return startAngle.toDegrees() }
    }
    
    @IBInspectable public var endAngleDegrees: CGFloat {
        set { self.endAngle = newValue.normalizeDegrees().toRadians() }
        get { return endAngle.toDegrees() }
    }
    
    @IBInspectable public var rotationStartAngleDegrees: CGFloat {
        set { self.rotationStartAngle = newValue.normalizeDegrees().toRadians() }
        get { return rotationStartAngle.toDegrees() }
    }
    
    @IBInspectable public var rotationEndAngleDegrees: CGFloat {
        set { self.rotationEndAngle = newValue.normalizeDegrees().toRadians() }
        get { return rotationEndAngle.toDegrees() }
    }
    
    private var menuActive = false {
        didSet {
            menuActive ? addButtons() : removeButtons()
        }
    }
    private var rotationStartAngle: CGFloat = CGFloat(Double.pi)
    private var rotationEndAngle: CGFloat = 0
    private var startAngle: CGFloat = 0
    private var endAngle: CGFloat = CGFloat(Double.pi)
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var buttons: [UIButton] = []
    private var screenView: UIView!
    
    private var mainWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(_:)))
        self.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        
        self.screenView = UIView(frame: UIScreen.main.bounds)
        self.screenView.backgroundColor = blurColor
        self.screenView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func toggleMenu() {
        menuActive.toggle()
    }
    
    @objc func didTapScreen(_ tap: UITapGestureRecognizer) {
        menuActive = false
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        if let index = buttons.firstIndex(of: button) {
            delegate?.floatingActionMenu(menu: self, didSelectItem: index)
            menuActive = false
        }
    }
    
    private func addButtons() {
        guard let dataSource = dataSource, let windowCenter = self.superview?.convert(self.center, to: nil), let menuCenter = mainWindow?.convert(windowCenter, to: screenView) else {
            return
        }
        
        buttons = (0..<dataSource.numberOfItemsForFloatingActionMenu(menu: self)).map { dataSource.floatingActionMenu(menu: self, buttonForItem: $0) }
        
        let deltaAngle = abs(startAngle - endAngle) / CGFloat(buttons.count - 1)
        var angle = startAngle
        
        mainWindow?.addSubview(screenView)
        
        for button in buttons {
            button.center = menuCenter
            button.transform = CGAffineTransform(rotationAngle: rotationStartAngle)
        }
        
        UIView.animate(withDuration: animationDuration) {
            for button in self.buttons {
                let x = menuCenter.x + self.radius * cos(angle)
                let y = menuCenter.y + self.radius * sin(angle)
                
                button.center = CGPoint(x: x, y: y)
                button.transform = CGAffineTransform(rotationAngle: self.rotationEndAngle)
                
                button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
                self.screenView.addSubview(button)
                
                angle += deltaAngle
            }
        }
    }
    
    private func removeButtons() {
        guard let windowCenter = self.superview?.convert(self.center, to: nil), let menuCenter = mainWindow?.convert(windowCenter, to: screenView) else {
            return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            for button in self.buttons {
                button.center = menuCenter
                button.transform = CGAffineTransform(rotationAngle: self.rotationStartAngle)
            }
        }) { _ in
            self.screenView.removeFromSuperview()
            self.buttons.removeAll()
        }
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return (self / 180.0) * CGFloat(Double.pi)
    }
    
    func toDegrees() -> CGFloat {
        return (self * 180.0) / CGFloat(Double.pi)
    }
    
    func normalizeDegrees() -> CGFloat {
        return self.truncatingRemainder(dividingBy: 360)
    }
}
