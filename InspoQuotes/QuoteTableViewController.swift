//
//  File.swift
//  InspoQuotes
//
//  Created by Radhi Mighri on 21/07/2020.
//  Copyright © 2020 Radhi Mighri. All rights reserved.
//


import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    
    let productID = "tn.radhimighri.InspoQuotes.PremiumQuotes"// the same as the ID that we've put it into AppStore Connect under 'Features , In-App Purchases'
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self) // set this 'QuoteTableViewController' class as the observer (delegate) : so now whenever any changes happens to the payment tansaction it's going to contact our 'QuoteTableViewController' and its going to try and find the delegate method 'paymentQueue()' to trigger an update
        if isPurchased() == true {
            showPremiumQuotes()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return  quotesToShow.count
        }else{
            return  quotesToShow.count + 1 // 1 is for the in-purchase section
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if indexPath.row < quotesToShow.count{ //  before purchasing : < 6 : < 7 elements (because we start counting from 0)
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 //show all the text in multiple lines as it needs to in order to display
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }else {
            cell.textLabel?.text = "Get more Quotes" // this is going to be our main 'buy' button
            cell.textLabel?.textColor = #colorLiteral(red: 0.1568627451, green: 0.6, blue: 0.9960784314, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count { // indexPath.row = 6 thats means the 7th line because we start with 0 (0123456)
            //print("Buy Quotes clicked")
            buyPremiumQuotes()
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) { // in case when u change ur phone, reset it and wipe its data the you will lose your UsersDefault stored data so to prove via the apple servers that ur already purchased this app previously you have to use this statement :
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - In-App Purchase Methods
    
    func buyPremiumQuotes() {
        if  SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }else{
            print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successful
                print("Transaction successful!")
                
                showPremiumQuotes()
                
                // Terminate the current transaction
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }else if transaction.transactionState == .failed {
                //Payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed! due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("Transaction restored")
                
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }
        }
    }
    
    func showPremiumQuotes(){
        // save the In-App Parchase state
        UserDefaults.standard.set(true, forKey: productID)
        
        quotesToShow.append(contentsOf: premiumQuotes) // append the hole premiumQuotes table to the quotestoShow one
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus == true {  
            print("Previously purchased")
            return true
        }else{
            print("Never purchased")
            return false
        }
    }
    
}
