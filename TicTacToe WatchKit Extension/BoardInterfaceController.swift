import WatchKit
import Foundation


class BoardInterfaceController: WKInterfaceController {

    @IBOutlet var board: WKInterfaceGroup!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - Board Button Action
    
    @IBAction func topLeftAction() {
        
        print("Board Action \(0)")
    }
    
    @IBAction func topMiddleAction() {
        
        print("Board Action \(1)")
    }
    
    @IBAction func topRightAction() {
        
        print("Board Action \(2)")
        
    }
    
    
    
    @IBAction func middleLeftAction() {
        
        print("Board Action \(3)")
    }
    
    @IBAction func middleAction() {
        
        print("Board Action \(4)")
    }
    
    @IBAction func middleRightAction() {
        print("Board Action \(5)")
    }
    
    
    
    
    @IBAction func bottomLeftAction() {
        print("Board Action \(6)")
    }
    
    @IBAction func bottomMiddleAction() {
        print("Board Action \(7)")
    }
    
    @IBAction func bottomRightAction() {
        print("Board Action \(8)")
    }
    
    



}
