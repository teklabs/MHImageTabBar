import UIKit

typealias Palette = UIColor
extension Palette {
    class func mainColor() -> UIColor {
        return UIColor(red:0.22, green:0.49, blue:0.81, alpha:1)
    }

    class func confirmColor() -> UIColor {
        return UIColor(red:0.6, green:0.8, blue:0.37, alpha:1)
    }

    class func destructiveColor() -> UIColor {
        return UIColor(red:0.75, green:0.22, blue:0.17, alpha:1)
    }

    class func lightGray() -> UIColor {
        return UIColor(red:0.91, green:0.91, blue:0.92, alpha:1)
    }
    
    class func tabBarBackgroundColor()  -> UIColor {
        return UIColor(red: 0.92, green: 0.96, blue: 0.95, alpha: 1)
    }
    
    class func tabBarSeparatorColor() -> UIColor {
        return UIColor(red: 0.45, green: 0.77, blue: 0.72, alpha: 1)
    }
    
    class func tabBarSelectedItemColor() -> UIColor {
        return UIColor(red: 0.38, green: 0.73, blue: 0.69, alpha: 1)
    }
    
    class func tabBarUnselectedItemColor() -> UIColor {
        return UIColor(red: 0.65, green: 0.74, blue: 0.71, alpha: 1)
    }

}
