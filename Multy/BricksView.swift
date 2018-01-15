//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BricksView: UIView {
    var currentCheckedWordCounter : Int = 3;
    
    init(with rect : CGRect, and currentWordCounter: Int) {
        super.init(frame: rect)
        backgroundColor = UIColor(red: 249.0/255.0, green: 250.0/255.0, blue: 1.0, alpha: 1.0)
        currentCheckedWordCounter = currentWordCounter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // here we draw green and red bricks depending the current state (segmentsCountUp and segmentsCountDown)
    override func draw(_ rect: CGRect) {
        
        for index in 0..<segmentsCountUp + segmentsCountDown {
            let widthUp = CGFloat((rect.size.width - 6 * 2) / 253.0)
            let widthDown = CGFloat((rect.size.width - 7 * 2) / 249.0)
            
            let xCoord = index < segmentsCountUp ?
                upperSizes[index] * widthUp + CGFloat(index * 2) :
                downSizes[index - segmentsCountUp] * widthDown + CGFloat((index - segmentsCountUp) * 2)
            
            let yCoord = CGFloat(index < segmentsCountUp ? 0 : 22)
            
            let width = index < segmentsCountUp ?
                (upperSizes[index + 1] - upperSizes[index]) * widthUp :
                (downSizes[index + 1 - segmentsCountUp] - downSizes[index - segmentsCountUp]) * widthDown
            
            let newRect = UIView(frame: CGRect(x: xCoord, y: yCoord, width: width, height: 20))
            
            newRect.backgroundColor = index < currentCheckedWordCounter ?
                UIColor(redInt: 95, greenInt: 204, blueInt: 125, alpha: 1.0) :
                UIColor(redInt: 239, greenInt: 239, blueInt: 244, alpha: 1.0)
            
            if index == currentCheckedWordCounter {
                newRect.layer.borderColor = UIColor(redInt: 95, greenInt: 204, blueInt: 125, alpha: 1.0).cgColor
                newRect.layer.borderWidth = 1.0;
            }
            newRect.setRounded(radius: 5)
            self.addSubview(newRect)
        }
    }
}
