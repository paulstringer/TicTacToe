import UIKit

typealias ButtonPositions = [UIButton]

class ViewController: UIViewController {

    var buttons: ButtonPositions!
    @IBOutlet var topLeftButton: UIButton!
    @IBOutlet var topMiddleButton: UIButton!
    @IBOutlet var topRightButton: UIButton!
    @IBOutlet var middleLeftButton: UIButton!
    @IBOutlet var middleButton: UIButton!
    @IBOutlet var middleRightButton: UIButton!
    @IBOutlet var bottomLeftButton: UIButton!
    @IBOutlet var bottomMiddleButton: UIButton!
    @IBOutlet var bottomRightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

