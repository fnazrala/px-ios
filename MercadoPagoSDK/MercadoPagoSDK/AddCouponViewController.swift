//
//  AddCouponViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 12/30/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class AddCouponViewController: MercadoPagoUIViewController , UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textBox: HoshiTextField!
    
    
    var toolbar : UIToolbar?
    var errorLabel : MPLabel?
    var amount : Double!
    
    var callback : ((_ coupon: DiscountCoupon) -> Void)?
    var coupon : DiscountCoupon?
    
    override open var screenName : String { get { return "DISCOUNT_INPUT_CODE" } }
    
    
    
    init(amount : Double, callback : @escaping ((_ coupon: DiscountCoupon) -> Void), callbackCancel : ((Void) -> Void)? = nil) {
        super.init(nibName: "AddCouponViewController", bundle: MercadoPago.getBundle())
        self.callbackCancel = callbackCancel
        self.callback = callback
        self.amount = amount
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textBox.placeholder = "Código de descuento".localized
        textBox.becomeFirstResponder()
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = MercadoPagoContext.getPrimaryColor()
        textBox.autocorrectionType = UITextAutocorrectionType.no
        setupInputAccessoryView()
        textBox.delegate = self
        textBox.addTarget(self, action: #selector(CardFormViewController.editingChanged(_:)), for: UIControlEvents.editingChanged)
        view.setNeedsUpdateConstraints()
    }

    var buttonNext : UIBarButtonItem!
    var buttonPrev : UIBarButtonItem!
    
    func setupInputAccessoryView() {
        let frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        let toolbar = UIToolbar(frame: frame)
        
        toolbar.barStyle = UIBarStyle.default;
        toolbar.backgroundColor = UIColor(netHex: 0xEEEEEE);
        toolbar.alpha = 1;
        toolbar.isUserInteractionEnabled = true
        
        buttonNext = UIBarButtonItem(title: "Canejar".localized, style: .done, target: self, action: #selector(AddCouponViewController.rightArrowKeyTapped))
        buttonPrev = UIBarButtonItem(title: "Cancelar".localized, style: .plain, target: self, action: #selector(AddCouponViewController.leftArrowKeyTapped))
        
        
        let font = UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 14) ?? UIFont.systemFont(ofSize: 14)
        buttonNext.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        buttonPrev.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        
        buttonNext.setTitlePositionAdjustment(UIOffset(horizontal: UIScreen.main.bounds.size.width / 8, vertical: 0), for: UIBarMetrics.default)
        buttonPrev.setTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.size.width / 8, vertical: 0), for: UIBarMetrics.default)
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        toolbar.items = [flexibleSpace, buttonPrev, flexibleSpace, buttonNext, flexibleSpace]
        
        textBox.delegate = self
        self.toolbar = toolbar
        textBox.inputAccessoryView = toolbar
        buttonNext.isEnabled = false
        
    }
    
    
    
    func leftArrowKeyTapped(){
        self.exit()
    }
    
    
    func rightArrowKeyTapped(){
        let disco = DiscountService()
        self.showLoading()
        self.textBox.resignFirstResponder()
        disco.getDiscount(amount: self.amount, code: self.textBox.text!, success: { (coupon) in
            self.hideLoading()
            if let coupon = coupon{
                self.coupon = coupon
                let couponDetailVC =  CouponDetailViewController(coupon: coupon, amount: self.amount, callbackCancel: { () in
                    self.callbackAndExit()
                })
                self.present(couponDetailVC, animated: false, completion: {})
            }
        }) { (error) in
            if (error.localizedDescription == "campaign-code-doesnt-match"){
                self.showErrorMessage("Código inválido".localized)
            }else {
                 self.showErrorMessage("Hubo un error".localized)
            }
            self.textBox.becomeFirstResponder()
            self.hideLoading()
        }
    }
    
    @IBAction func exit(){
        self.textBox.resignFirstResponder()
        guard let callbackCancel = self.callbackCancel else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.dismiss(animated: false) {
            callbackCancel()
        }
        

    }
    
    func callbackAndExit() {
        self.textBox.resignFirstResponder()
        if let callback = self.callback {
            if let coupon = self.coupon {
                callback(coupon)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    func showErrorMessage(_ errorMessage:String){
        
        errorLabel = MPLabel(frame: toolbar!.frame)
        self.errorLabel!.backgroundColor = UIColor(netHex: 0xEEEEEE)
        self.errorLabel!.textColor = UIColor(netHex: 0xf04449)
        self.errorLabel!.text = errorMessage
        self.errorLabel!.textAlignment = .center
        self.errorLabel!.font = self.errorLabel!.font.withSize(12)
        textBox.borderInactiveColor = UIColor.red
        textBox.borderActiveColor = UIColor.red
        textBox.inputAccessoryView = errorLabel
        textBox.setNeedsDisplay()
        textBox.resignFirstResponder()
        textBox.becomeFirstResponder()
    }
    
    
    open func editingChanged(_ textField:UITextField){
        if ((textBox.text?.characters.count)! > 0){
            buttonNext.isEnabled = true
        }else{
            buttonNext.isEnabled = false
        }
        hideErrorMessage()
    
    }
    
    func hideErrorMessage(){
        self.textBox.borderInactiveColor = UIColor(netHex: 0x3F9FDA)
        self.textBox.borderActiveColor = UIColor(netHex: 0x3F9FDA)
        self.textBox.inputAccessoryView = self.toolbar
        self.textBox.setNeedsDisplay()
        self.textBox.resignFirstResponder()
        self.textBox.becomeFirstResponder()
    }
    
}