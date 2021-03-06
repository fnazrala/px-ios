//
//  PaymentMethodCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class OfflinePaymentMethodCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(313)
    
    @IBOutlet weak var iconCash: UIImageView!
    @IBOutlet weak var paymentMethodDescription: MPLabel!
   
    @IBOutlet weak var acreditationTimeLabel: MPLabel!

    @IBOutlet weak var changePaymentButton: MPButton!
    
    @IBOutlet weak var accreditationTimeIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var image = MercadoPago.getImage("time")
        image = image?.withRenderingMode(.alwaysTemplate)
        self.accreditationTimeIcon.tintColor = UIColor.px_grayLight()
        self.accreditationTimeIcon.image = image
        
        self.contentView.backgroundColor = UIColor.px_grayBackgroundColor()
        
        let separatorLine = ViewUtils.getTableCellSeparatorLineView(0, y: OfflinePaymentMethodCell.ROW_HEIGHT - 1, width: UIScreen.main.bounds.width, height: 1)
        self.addSubview(separatorLine)

        self.iconCash.image = MercadoPago.getImage("MPSDK_review_iconoDineroEnEfectivo")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillCell(_ paymentMethodOption : PaymentMethodOption, amount : Double, paymentMethod : PaymentMethod, currency : Currency, reviewScreenPreference: ReviewScreenPreference = ReviewScreenPreference()) {
        
        let attributedAmount = Utils.getAttributedAmount(amount, currency: currency, color : UIColor.black)
        var attributedTitle = NSMutableAttributedString(string : "Pagáras ".localized, attributes: [NSFontAttributeName: Utils.getFont(size: 20), NSForegroundColorAttributeName: UIColor.px_grayBaseText()])
        attributedTitle.append(attributedAmount)
        
        if paymentMethodOption.getId() == PaymentTypeId.ACCOUNT_MONEY.rawValue {
            attributedTitle = NSMutableAttributedString(string : "Con dinero en cuenta".localized, attributes: [NSFontAttributeName: Utils.getFont(size: 20), NSForegroundColorAttributeName: UIColor.px_grayBaseText()])
            self.iconCash.image = MercadoPago.getImage("MPSDK_review_dineroEnCuenta")
            self.acreditationTimeLabel.isHidden = true
            self.accreditationTimeIcon.isHidden = true
        } else {
            var currentTitle = ""
            let titleI18N = "ryc_title_" + paymentMethodOption.getId()
            if (titleI18N.existsLocalized()) {
                currentTitle = titleI18N.localized
            } else {
                currentTitle = "ryc_title_default".localized
            }
            
            attributedTitle.append(NSAttributedString(string : currentTitle, attributes: [NSFontAttributeName: Utils.getFont(size: 20), NSForegroundColorAttributeName: UIColor.px_grayBaseText()]))
            
            let complementaryTitle = "ryc_complementary_" + paymentMethodOption.getId()
            if complementaryTitle.existsLocalized() {
                attributedTitle.append(NSAttributedString(string : complementaryTitle.localized, attributes: [NSFontAttributeName: Utils.getFont(size: 20), NSForegroundColorAttributeName: UIColor.px_grayBaseText()]))
            }
            attributedTitle.append(NSAttributedString(string : paymentMethodOption.getDescription(), attributes: [NSFontAttributeName: Utils.getFont(size: 20), NSForegroundColorAttributeName: UIColor.px_grayBaseText()]))
            
            self.acreditationTimeLabel.attributedText = NSMutableAttributedString(string: paymentMethodOption.getComment(), attributes: [NSFontAttributeName: Utils.getFont(size: 12)])
        }

        self.paymentMethodDescription.attributedText = attributedTitle
		
		if reviewScreenPreference.isChangeMethodOptionEnabled() {
   			self.changePaymentButton.setTitleColor(UIColor.primaryColor(), for: UIControlState.normal)			
			self.changePaymentButton.titleLabel?.font = Utils.getFont(size: 18)
			self.changePaymentButton.setTitle("Cambiar medio de pago".localized, for: .normal)
		} else {
			self.changePaymentButton.isHidden = true;
		}
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }
    
	
    
  }
