import UIKit

public extension UIView {
    var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }
    var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }
    var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }
    var right: CGFloat {
        get { frame.origin.x + frame.size.width }
        set { frame.origin.x = newValue - frame.size.width }
    }
    var bottom: CGFloat {
        get { frame.origin.y + frame.size.height }
        set { frame.origin.y = newValue - frame.size.height }
    }
}
