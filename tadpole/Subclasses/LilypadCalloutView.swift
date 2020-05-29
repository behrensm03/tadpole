//
//  LilypadCalloutView.swift
//  tadpole
//
//  Created by Michael Behrens on 1/4/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import Foundation
import Mapbox

class LilypadCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation

    

    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()

    weak var delegate: MGLCalloutViewDelegate?

    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0

    let mainBody: UIButton

    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)

        super.init(frame: .zero)

        backgroundColor = .clear

        mainBody.backgroundColor = .darkGray
        mainBody.tintColor = .white
        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        mainBody.layer.cornerRadius = 4.0

        addSubview(mainBody)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {

        delegate?.calloutViewWillAppear?(self)

        view.addSubview(self)
        mainBody.setTitle(representedObject.title!, for: .normal)
        mainBody.sizeToFit()

        if isCalloutTappable() {
            mainBody.addTarget(self, action: #selector(calloutTapped), for: .touchUpInside)
        } else {
            mainBody.isUserInteractionEnabled = false
        }

        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)

        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.alpha = 1
                strongSelf.delegate?.calloutViewDidAppear?(strongSelf)
            }
        } else {
            delegate?.calloutViewDidAppear?(self)
        }
    }

    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }


    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }

    @objc func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }


    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom.
        let fillColor: UIColor = .darkGray

        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight - 1

        let currentContext = UIGraphicsGetCurrentContext()!

        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()

        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
