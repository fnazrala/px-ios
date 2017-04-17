//
//  CheckoutViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDK

class CheckoutViewControllerTest: BaseTest {
    
    var checkoutViewController : MockCheckoutViewController?
    var preference : CheckoutPreference?
    var selectedPaymentMethod : PaymentMethod?
    var selectedPayerCost : PayerCost?
    var selectedIssuer : Issuer?
    var createdToken : Token?
    
    override func setUp() {
        
    }
}

class CheckoutViewModelTest : BaseTest {
    
    var instance : CheckoutViewModel?
    
    let mockPaymentMethodSearchItem = MockBuilder.buildPaymentMethodSearchItem("paymentMethodId")
    
    override func setUp() {
        self.instance = CheckoutViewModel(checkoutPreference: CheckoutPreference(), paymentData: PaymentData(), paymentOptionSelected: mockPaymentMethodSearchItem as! PaymentMethodOption)
    }
    
    func testIsPaymentMethodSelectedCard(){
        
        XCTAssertFalse(self.instance!.isPaymentMethodSelectedCard())
        
        self.instance!.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("rapipago", name: "rapipago", paymentTypeId: PaymentTypeId.TICKET.rawValue)
        XCTAssertFalse(self.instance!.isPaymentMethodSelectedCard())
        
        self.instance!.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "visa", paymentTypeId: PaymentTypeId.CREDIT_CARD.rawValue)
        XCTAssertTrue(self.instance!.isPaymentMethodSelectedCard())
        
        self.instance!.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("debmaster", name: "master", paymentTypeId: PaymentTypeId.DEBIT_CARD.rawValue)
        XCTAssertTrue(self.instance!.isPaymentMethodSelectedCard())
    }
    
    func testNumberOfSections(){
        
        let preference = MockBuilder.buildCheckoutPreference()
        self.instance!.preference = preference
        
        XCTAssertEqual(6, self.instance!.numberOfSections())
        
    }
    
    func testIsPaymentMethodSelected(){
        
        self.instance!.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("rapipago", name: "rapipago", paymentTypeId: PaymentTypeId.TICKET.rawValue)
        
        XCTAssertTrue(self.instance!.isPaymentMethodSelected())
        
        self.instance!.paymentData.paymentMethod = nil
        
        XCTAssertFalse(self.instance!.isPaymentMethodSelected())
        
    }
    
    func testNumberOfRowsInMainSectionWithOfflinePaymentMethod(){
        let paymentMethodOff = MockBuilder.buildPaymentMethod("redlink", name: "redlink", paymentTypeId: PaymentTypeId.ATM.rawValue)
        self.instance!.paymentData.paymentMethod = paymentMethodOff
        
        let result = self.instance!.numberOfRowsInMainSection()
        XCTAssertEqual(2, result)
    }
    
    func testNumberOfRowsInMainSectionWithCreditCardPaymentMethod() {
        let paymentMethodCreditCard = MockBuilder.buildPaymentMethod("master", name: "master", paymentTypeId: PaymentTypeId.CREDIT_CARD.rawValue)
        self.instance!.paymentData.paymentMethod = paymentMethodCreditCard
        
        let result = self.instance!.numberOfRowsInMainSection()
        XCTAssertEqual(3, result)
    }
    
    func testIsPreferenceLoaded(){
        XCTAssertTrue(self.instance!.isPreferenceLoaded())
        
        let preference = MockBuilder.buildCheckoutPreference()
        self.instance!.preference = preference
        XCTAssertTrue(self.instance!.isPreferenceLoaded())
    }
    
    func testGetTotalAmount() {
        let paymentMethodCreditCard = MockBuilder.buildPaymentMethod("master", name: "master", paymentTypeId: PaymentTypeId.CREDIT_CARD.rawValue)
        self.instance!.paymentData.paymentMethod = paymentMethodCreditCard
        self.instance!.paymentData.payerCost = MockBuilder.buildPayerCost()
        self.instance!.paymentData.payerCost!.totalAmount = 10
        var totalAmount = self.instance!.getTotalAmount()
        XCTAssertEqual(totalAmount, self.instance!.paymentData.payerCost!.totalAmount)
        
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        self.instance!.preference = checkoutPreference
        self.instance!.paymentData.payerCost = nil
        totalAmount = self.instance!.getTotalAmount()
        XCTAssertEqual(totalAmount, checkoutPreference.getAmount())
    }
    
    func testShouldDisplayNoRate(){
        
        // No payerCost loaded
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        
        // PayerCost with installmentRate
        let payerCost = MockBuilder.buildPayerCost()
        payerCost.installmentRate = 10.0
        self.instance!.paymentData.payerCost = payerCost
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        
        // PayerCost with no installmentRate but one installment
        let payerCostOneInstallment = MockBuilder.buildPayerCost()
        payerCostOneInstallment.installmentRate = 0.0
        payerCostOneInstallment.installments = 1
        self.instance!.paymentData.payerCost = payerCostOneInstallment
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        
        // PayerCost with no installmentRate and few installments
        let payerCostWithNoRate = MockBuilder.buildPayerCost()
        payerCostWithNoRate.installmentRate = 0.0
        payerCostWithNoRate.installments = 6
        self.instance!.paymentData.payerCost = payerCostWithNoRate
        XCTAssertTrue(self.instance!.shouldDisplayNoRate())
    }
    
    func testAccountMoney() {
        
        /// SUMARY:
        ///
        /// Productos --- $30
        /// Confirmar
        
        self.instance?.paymentOptionSelected = MockBuilder.buildPaymentMethodSearchItem("account_money", type: PaymentMethodSearchItemType.PAYMENT_METHOD)
        
        XCTAssertEqual(self.instance!.numberOfRowsInMainSection(), 2) // Productos + Confirm Button
        XCTAssertTrue(self.instance!.isProductlCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertTrue(self.instance!.isConfirmButtonCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(self.instance!.shouldShowInstallmentSummary())
        XCTAssertFalse(self.instance!.shouldShowTotal())
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        XCTAssertFalse(self.instance!.hasPayerCostAddionalInfo())
    }
    
    func testPaymentMethodOff() {
        
        /// SUMARY:
        ///
        /// Productos --- $30
        /// Confirmar
        self.instance?.paymentOptionSelected = MockBuilder.buildPaymentMethodSearchItem("rapipago", type: PaymentMethodSearchItemType.PAYMENT_METHOD)
        
        XCTAssertEqual(self.instance!.numberOfRowsInMainSection(), 2) // Productos + Confirm Button
        XCTAssertTrue(self.instance!.isProductlCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertTrue(self.instance!.isConfirmButtonCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(self.instance!.shouldShowInstallmentSummary())
        XCTAssertFalse(self.instance!.shouldShowTotal())
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        XCTAssertFalse(self.instance!.hasPayerCostAddionalInfo())
    }
    
    func testPaymentMethodOn() {
        
        /// SUMARY:
        ///
        /// Productos --- $30
        /// Confirmar
        self.instance?.paymentOptionSelected = MockBuilder.buildPaymentMethodSearchItem("visa", type: PaymentMethodSearchItemType.PAYMENT_METHOD)
        
        XCTAssertEqual(self.instance!.numberOfRowsInMainSection(), 2) // Productos + Confirm Button
        XCTAssertTrue(self.instance!.isProductlCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertTrue(self.instance!.isConfirmButtonCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(self.instance!.shouldShowInstallmentSummary())
        XCTAssertFalse(self.instance!.shouldShowTotal())
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())
        XCTAssertFalse(self.instance!.hasPayerCostAddionalInfo())
    }
}
