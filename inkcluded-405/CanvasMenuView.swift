//
//  CanvasMenuView.swift
//  inkcluded-405
//
//  Created by Francis Yuen on 2/12/17.
//  Copyright © 2017 Boba. All rights reserved.
//

import UIKit

enum CanvasMenuItem: String {
    case INSERT_IMAGE = "IM"
    case INSERT_TEXT  = "TXT"
    case UNDO         = "UNDO"
}

struct CanvasMenuButton {
    static public let BUTTON_WIDTH: CGFloat = 45.0

    private(set) var button: UIButton
    private(set) var type: CanvasMenuItem
    private(set) var image: UIImage
    
    init(type: CanvasMenuItem, image: UIImage) {
        self.type = type
        self.image = image
        self.button = UIButton(type: .custom)
        self.button.frame = CGRect(
            origin: CGPoint(x:10, y:0),
            size: CGSize(width: CanvasMenuButton.BUTTON_WIDTH, height: CanvasMenuButton.BUTTON_WIDTH)
        )
        self.button.backgroundColor = UIColor.clear
        self.button.setTitle(type.rawValue, for: .normal)
        self.button.titleLabel?.removeFromSuperview()
        self.button.setImage(image, for: .normal)
        self.button.contentMode = .center
    }
}

public class CanvasMenuView: UIView {

    static let MENU_HEIGHT: CGFloat = 90.0
    static let MENU_WIDTH_RATIO: CGFloat = 0.8
    
    private var itemList: [CanvasMenuButton]?

    private var delegate: CanvasMenuDelegate!

    init(size: CGSize, delegate: CanvasMenuDelegate) {
        let origin = CGPoint(x: 0, y: size.height - CanvasMenuView.MENU_HEIGHT)
        let frameSize = CGSize(width: size.width, height: CanvasMenuView.MENU_HEIGHT)
        
        super.init(frame: CGRect(origin: origin, size: frameSize))
        
        self.delegate = delegate
        
        self.itemList = [CanvasMenuButton(type: CanvasMenuItem.INSERT_IMAGE, image: UIImage(named: "image")!),
                         CanvasMenuButton(type: CanvasMenuItem.INSERT_TEXT, image: UIImage(named: "text")!),
                         CanvasMenuButton(type: CanvasMenuItem.UNDO, image: UIImage(named: "undo")!)]
        addMenuButtonToView(items: self.itemList!)
        
        self.layer.cornerRadius = 2.5
        let greyColor: Float = 200.0 / 255
        self.backgroundColor = UIColor(colorLiteralRed: greyColor, green: greyColor, blue: greyColor, alpha: 1.0)
    }
    
    func addMenuButtonToView(items: [CanvasMenuButton]) {
        let padding: CGFloat = 30.0
        let buttonViewWidth = CGFloat(items.count) * CanvasMenuButton.BUTTON_WIDTH + (CGFloat(items.count) - 1) * padding
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: buttonViewWidth, height: self.frame.height))
        
        buttonView.center.x = self.center.x
        
        var xPos: CGFloat = 0.0
        for item in items {
            item.button.frame.origin.y = CanvasMenuButton.BUTTON_WIDTH / 4
            item.button.frame.origin.x = xPos
            xPos += CanvasMenuButton.BUTTON_WIDTH + padding
            
            item.button.addTarget(self, action: #selector(didClickOnMenuButton), for: .touchUpInside)
            
            item.button.isEnabled = self.delegate.shouldEnableMenuItem(item: item.type)
            
            buttonView.addSubview(item.button)
        }
        
        self.addSubview(buttonView)
    }
    
    func refreshView() {
        self.itemList?.forEach({ (menuButton) in
            menuButton.button.isEnabled = self.delegate.shouldEnableMenuItem(item: menuButton.type)
        })
    }
    
    func didClickOnMenuButton(sender: UIButton!) {
        let buttonText = sender.titleLabel?.text
        self.delegate.didClickOnMenuItem(item: CanvasMenuItem(rawValue: buttonText!)!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
