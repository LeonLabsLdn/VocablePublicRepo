import StoreKit

class PurchaseModel:ObservableObject{
    
    var isPro           :Bool?
    var products        :[Product]?
    var restore         :Bool?
    var count           :Int?
    var proCount        = 0
    let productNames    = ["london.leonlabs.vocable.monthly","london.leonlabs.vocable.quarterly","london.leonlabs.vocable.yearly"]
    static let shared   = PurchaseModel()
    
    func fetchProducts(){
        Task.init{
            do{
                products = try await Product.products(for:productNames)
               if PurchaseModel.shared.products?.count != 0{
                   for products in PurchaseModel.shared.products!{
                       switch products.id{
                       case "london.leonlabs.vocable.monthly":UserDefaults.standard.setValue("\(products.displayPrice)/month", forKey: "monthPrice")
                       case "london.leonlabs.vocable.quarterly":UserDefaults.standard.setValue("\(products.displayPrice)/3 months", forKey: "3monthPrice")
                       default:break
                       }
                   }
                    Protocols.homeDelegate?.setPrice()
                    DispatchQueue.main.async { [] in
                        if UserData.productsReturned != true{
                            UserData.productsReturned = true
                            Protocols.purchaseDelegate?.reloadTableView()
                        }
                    }
                }
            }catch{
                DispatchQueue.main.async { [error] in
                    print(error)
                    if UserData.productsReturned != true{
                        Protocols.purchaseDelegate?.reloadTableView()
                    }
                }
            }
        }
    }
    
    func restoreFetch(){
        Task.init{
            do{
                products = try await Product.products(for:productNames)
                restoreCheck()
            }catch{
                print("error")
            }
        }
    }
    
    func restoreCheck(){
        self.count = 0
        for p in products!{
            Task.init{
                let state = await p.currentEntitlement
                switch state{
                case .verified(let safe):
                    print("verified")
                    restore = true
                    UserDefaults.standard.set("\(safe.expirationDate!.formatted())",forKey: "expiryString")
                    UserDefaults.standard.set(safe.expirationDate! as Date,forKey: "expiry")
                    isPro = true
                    DispatchQueue.main.async {
                        Protocols.translateDelegate?.popToRoot()
                        Protocols.phraseDelegate?.popToRoot()
                    }
                case .unverified:
                    print("unverified")
                case .none:
                    print("none")
                }
                if self.count == 2{
                    DispatchQueue.main.async{
                        if UserData.restoreCheck == true{
                            UserData.restoreCheck = false
                            Protocols.settingsDelegate?.removeRestoreLoading(state: self.restore ?? false)
                        }else if UserData.restoreCheck1 == true{
                            UserData.restoreCheck1 = false
                            Protocols.purchaseDescriptionDelegate?.restoreCheck(state: self.restore ?? false)
                        }else if UserData.restoreCheck2 == true{
                            
                            UserData.restoreCheck2 = false
                            Protocols.purchaseDelegate?.restoreCheck(state: self.restore ?? false)
                        }
                    }
                }else{
                    self.count! += 1
                }
            }
        }
    }
    
    func purchaseState(product:Product){
        proCount += 1
        Task.init{
            let state = await product.currentEntitlement
            DispatchQueue.main.async { [self] in
                switch state{
                case .verified(let safe):
                    UserDefaults.standard.set("\(safe.expirationDate!.formatted())",forKey: "expiryString")
                    UserDefaults.standard.set(safe.expirationDate! as Date,forKey: "expiry")
                    isPro = true
                    DispatchQueue.main.async { [] in
                        Protocols.translateDelegate?.popToRoot()
                        Protocols.phraseDelegate?.popToRoot()
                        Protocols.homeDelegate?.proState()
                    }
                case .unverified:
                    if proCount == 3{isPro = false}
                    DispatchQueue.main.async { [] in
                        Protocols.homeDelegate?.proState()
                    }
                case .none:
                    if proCount == 3{isPro = false}
                    DispatchQueue.main.async { [] in
                        Protocols.homeDelegate?.proState()
                    }
                }
            }
        }
    }
    
    func purchase(_ product: Product){
        UserData.isPurchasing = true
        Task.init{
            updateListenerTask = listenForTransactions()
            let result = try await product.purchase()
            print("this is result\(result)")
            switch result {
            case .pending:
                throw PurchaseError.pending
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    DispatchQueue.main.async { [] in
                        UserDefaults.standard.set(transaction.expirationDate! as Date,forKey: "expiry")
                        if transaction.expirationDate?.isInThePast == false{
                            self.isPro = true
                            UserData.isPurchasing = false
                            DispatchQueue.main.async {
                                Protocols.translateDelegate?.popToRoot()
                                Protocols.phraseDelegate?.popToRoot()
                                Protocols.purchaseDelegate?.dismissSelf()
                            }
                        }else{
                            self.purchase(product)
                        }
                    }
                case .unverified:
                    DispatchQueue.main.async { [] in
                        UserData.isPurchasing = false
                        Protocols.purchaseDelegate?.removeLoading()
                    }
                    throw PurchaseError.failed
                }
            case .userCancelled:
                DispatchQueue.main.async { [] in
                    UserData.isPurchasing = false
                    Protocols.purchaseDelegate?.removeLoading()
                }
                throw PurchaseError.cancelled
            @unknown default:
                DispatchQueue.main.async { [] in
                    UserData.isPurchasing = false
                    Protocols.purchaseDelegate?.removeLoading()
                }
                assertionFailure("Unexpected result")
                throw PurchaseError.failed
            }
        }
    }
    
    enum PurchaseError: Error {case pending, failed, cancelled}
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    deinit {updateListenerTask?.cancel()}
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do{
                    switch result {
                    case .unverified:
                        throw PurchaseError.failed
                    case .verified(let safe):
                        print("PRINTED SAFE FROM LISTENER \(safe)")
                    }
                }catch{
                }
            }
        }
    }
}


