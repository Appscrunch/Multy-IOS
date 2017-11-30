//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class BricksView: UIView {
    var currentCheckedWordCounter : Int = 3;
    var segmentsCountUp : Int  = 7
    var segmentsCountDown : Int  = 8
    
    let upperSizes : [CGFloat] = [0, 35, 79, 107, 151, 183, 218, 253]
    let downSizes : [CGFloat] = [0, 23, 40, 53, 81, 136, 153, 197, 249]
    
    init(with rect : CGRect, and currentWordCounter: Int) {
        super.init(frame: rect)
        backgroundColor = UIColor(red: 249.0/255.0, green: 250.0/255.0, blue: 1.0, alpha: 1.0)
        currentCheckedWordCounter = currentWordCounter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        for index in 0..<segmentsCountUp + segmentsCountDown {
            let widthUp = CGFloat((rect.size.width - 6 * 2) / 253.0)
            let widthDown = CGFloat((rect.size.width - 7 * 2) / 249.0)
            
            let xCoord = index < segmentsCountUp ?
                upperSizes[index] * widthUp + CGFloat(index * 2) : downSizes[index - segmentsCountUp] * widthDown + CGFloat((index - segmentsCountUp) * 2)
            
            let yCoord = CGFloat(index < segmentsCountUp ? 0 : 22)
            
            let width = index < segmentsCountUp ? (upperSizes[index + 1] - upperSizes[index]) * widthUp : (downSizes[index + 1 - segmentsCountUp] - downSizes[index - segmentsCountUp]) * widthDown
            
            let newRect = UIView(frame: CGRect(x: xCoord, y: yCoord, width: width, height: 20))
            
            newRect.backgroundColor = UIColor.green
            newRect.setRounded(radius: 5)
            self.addSubview(newRect)
        }
    }
}
