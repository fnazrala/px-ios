//
//  PaymentMethodSearchService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentMethodSearchService: MercadoPagoService {
    
    public let MP_SEARCH_BASE_URL = "http://private-9376e-paymentmethodsmla.apiary-mock.com"
    
    //public let MP_SEARCH_BASE_URL = "https://api.mercadopago.com"
        public let MP_SEARCH_PAYMENTS_URI = "/beta/checkout/payment_methods/search/options"
    
    public init(){
        super.init(baseURL: MP_SEARCH_BASE_URL)
    }
    
    public func getPaymentMethods(excludedPaymentTypesIds : Set<PaymentTypeId>?, excludedPaymentMethods : Set<String>?, success: (paymentMethodSearch: PaymentMethodSearch) -> Void, failure: ((error: NSError) -> Void)?) {
        var params = "public_key=" + MercadoPagoContext.publicKey()
        if excludedPaymentTypesIds != nil {
            let excludedPaymentTypesParams = excludedPaymentTypesIds!.map({$0.rawValue}).joinWithSeparator(",")
            params = params + "&excluded_payment_types=" + String(excludedPaymentTypesParams).trimSpaces()
        }
        if excludedPaymentMethods != nil {
            let excludedPaymentMethodsParams = excludedPaymentMethods!.joinWithSeparator(",")
            params = params + "&excluded_payment_methods=" + excludedPaymentMethodsParams.trimSpaces()
        }
        self.request(MP_SEARCH_PAYMENTS_URI, params: params, body: nil, method: "GET", success: { (jsonResult) -> Void in
            success(paymentMethodSearch : PaymentMethodSearch.fromJSON(jsonResult as! NSDictionary))
            },  failure: { (error) -> Void in
                //TODO
        })
    }
    

}
