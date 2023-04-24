//
//  Copyright © Essential Developer. All rights reserved.
//

import UIKit

public final class ErrorView: UIButton {

    public var message: String? {
        get { return isVisible ? title(for: .normal): nil }
        set { setMessageAnimated(newValue)}
    }
    public var onHide:(() -> Void)?
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        backgroundColor = .errorBackgroundColor
        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
        configureLabel()
        hideMessage()
    }
    private func configureLabel(){
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        titleLabel?.adjustsFontForContentSizeCategory = true
        
    }

	private var isVisible: Bool {
		return alpha > 0
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
        configure()
	}

	func setMessageAnimated(_ message: String?) {
        if let messag = message{
            showAnimated(message: messag)
        }else{
            hideMessageAnimated()
        }
	}
    func showAnimated(message: String){
        setTitle(message, for: .normal)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
	@objc func hideMessageAnimated() {
        UIView.animate(
			withDuration: 0.25,
			animations: { self.alpha = 0 },
			completion: { completed in
				if completed {
					//self.button.setTitle(nil, for: .normal)
                    self.hideMessage()
				}
			})
	}
    private func hideMessage(){
        setTitle(nil, for: .normal)
        alpha = 0
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        onHide?()
    }
}
extension UIColor{
    static var errorBackgroundColor : UIColor {
        UIColor(red: 0.9995240433000004, green: 0.4175926148999999, blue: 0.4154433012, alpha: 1)
    }
}
