//
//  QuestionTableViewCell.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 10.04.2022.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var otherTextfield: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.setImage(selected ? UIImage(named: "iconRadioButtonSelect") : UIImage(named: "iconRadioButtonEmpty"), for: .normal)
        // Configure the view for the selected state
    }
    
    func configure(text: String) {
        questionLabel.text = text
    }
    
    func showTextfield() {
        otherTextfield.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

