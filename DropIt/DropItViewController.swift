//
//  DropItViewController.swift
//  DropIt
//
//  Created by iMac21.5 on 4/29/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyCreatedDynamicAnimator.delegate = self
        return lazyCreatedDynamicAnimator
    }()
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    let dropItBehavior = DropItBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropItBehavior)
    }
    
    var dropsPerRow = 10
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        dropItBehavior.addDrop(dropView)
    }
    
    func removeCompletedRow() {
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
            do {
                dropFrame.origin.y -= dropSize.height
                dropFrame.origin.x = 0
                var dropsFound = [UIView]()
                var rowIsComplete = true
                for _ in 0 ..< dropsPerRow {
                    if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil) {
                        if hitView.superview == gameView {
                            dropsFound.append(hitView)
                        } else {
                            rowIsComplete = false
                        }
                    }
                    dropFrame.origin.x += dropSize.width
                }
                if rowIsComplete {
                    dropsToRemove += dropsFound
                }
            } while dropsToRemove.count == 0 && dropFrame.origin.y  > 0
        
        for drop in dropsToRemove {
            dropItBehavior.removeDrop(drop)
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 10 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        case 5: return UIColor.yellowColor()
        case 6: return UIColor.brownColor()
        case 7: return UIColor.darkGrayColor()
        case 8: return UIColor.lightGrayColor()
        case 9: return UIColor.cyanColor()
        default: return UIColor.blackColor()
        }
    }
}