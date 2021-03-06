//
//  ConfirmAdditionalInfoTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/2/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class ConfirmAdditionalInfoTableViewCell: UITableViewCell {
    static let ROW_HEIGHT = CGFloat(45)
    @IBOutlet weak var TEALabel: UILabel!
    @IBOutlet weak var CFT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func fillCell(payerCost: PayerCost?){
        if let payerCost = payerCost {
            
            CFT.font = Utils.getLightFont(size: CFT.font.pointSize)
            CFT.textColor = UIColor.px_grayDark()
            TEALabel.font = Utils.getLightFont(size: TEALabel.font.pointSize)
            TEALabel.textColor = UIColor.px_grayDark()
            
            if let CFTValue = payerCost.getCFTValue() {
                CFT.text = "CFT " + CFTValue
            } else {
                CFT.text = ""
            }
            if let TEAValue = payerCost.getTEAValue() {
                TEALabel.text = "TEA " + TEAValue
            } else {
                TEALabel.text = ""
            }
        }
    }
    
}
