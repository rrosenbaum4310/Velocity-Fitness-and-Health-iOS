import UIKit

public class BadgeBarButtonItem: UIBarButtonItem
{
    @IBInspectable
    public var badgeNumber: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let label: UILabel
    
    init(image: UIImage?, style: UIBarButtonItem.Style, target: Any?, action: Selector?) {
        let label = UILabel()
        label.backgroundColor = .red
        label.alpha = 0.9
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 10)
        label.layer.zPosition = 1
        self.label = label
        super.init()
        self.image = image
        self.style = style
        self.target = target as AnyObject
        self.action = action
        
        //super.init(image: image, style: style, target: target, action: action)
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationCounter(notification:)), name: Notification.Name("NotificationCounterNotify"), object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        let label = UILabel()
        label.backgroundColor = .red
        label.alpha = 0.9
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.layer.zPosition = 1
        self.label = label
        
        super.init(coder: aDecoder)
        
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationCounter(notification:)), name: Notification.Name("NotificationCounterNotify"), object: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.updateBadge()
    }
    
    private func updateBadge()
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        self.label.text = "\(badgeNumber)"
        
        if self.badgeNumber > 0 && self.label.superview == nil
        {
            view.addSubview(self.label)
            
            self.label.widthAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
            self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        }
        else if self.badgeNumber == 0 && self.label.superview != nil
        {
            self.label.removeFromSuperview()
        }
    }
    
    @objc func updateNotificationCounter(notification: Notification){
        if let data = notification.userInfo as? [String: Any] {
            if let count = data["count"] as? Int {
                DispatchQueue.main.async(execute: {
                    self.badgeNumber = count
                    UIView.animate(withDuration: 0.6,
                                   animations: {
                                    self.label.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.6) {
                                        self.label.transform = CGAffineTransform.identity
                                    }
                    })
                })
                
            }
        }
    }
    
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
