
import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    // for cell content
    override func awakeFromNib() {
        super.awakeFromNib()
        //btnCall.layer.borderWidth = 1
        //btnCall.layer.cornerRadius = btnCall.bounds.height/4
//        btnCall.backgroundColor = #colorLiteral(red: 0.7149018514, green: 1, blue: 0.9679634731, alpha: 1)
//        backgroundColor = #colorLiteral(red: 0.9734258585, green: 0.8711321319, blue: 1, alpha: 1)
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderWidth = 0.4
        viewMain.layer.borderColor = UIColor.white.cgColor
    }
    
    // for padding between cell
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.size.height -= 2 * 5
            super.frame = frame
        }
      }

    // when cell is got selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
