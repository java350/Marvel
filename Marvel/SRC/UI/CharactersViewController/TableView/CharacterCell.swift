
import UIKit
//import SDWebImage

class CharacterCell: UITableViewCell {


    // MARK:  Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    // MARK: Override methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.indicatorView.hidesWhenStopped = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.fill(with: .none)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarImageView.map {
            $0.layer.cornerRadius = $0.frame.size.width / 2
            $0.clipsToBounds = true
        }
    }
    
    
    // MARK:  Public method
    
    func fill(with character: Character?) {
        if let character = character {
            labelTitle?.text = character.name
            avatarImageView.setImage(with: character.thumbnail.fullImageUrl)
            hideShowElements(show: true)
        } else {
            hideShowElements()
        }
    }
    
    
    // MARK: - Private methods
    
   private func hideShowElements(show: Bool = false) {
        labelTitle.alpha = show.float
        avatarImageView.alpha = show.float
        show ? indicatorView.stopAnimating() : indicatorView.startAnimating()
    }
    
}
