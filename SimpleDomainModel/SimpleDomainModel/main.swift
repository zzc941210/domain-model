//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Double
    public var currency : currencyType
    
    public enum currencyType {
        case USD
        case GBP
        case EUR
        case CAN
    }

    public func convert(_ to: currencyType) -> Money {
        switch to {
        case .USD:
            return Money(amount: toUSD(), currency: to)
        case .GBP:
            return Money(amount: toUSD() * 0.5, currency: to)
        case .EUR:
            return Money(amount: toUSD() * 1.5, currency: to)
        case .CAN:
            return Money(amount: toUSD() * 1.25, currency: to)
        }
    }

    public func add(_ to: Money) -> Money {
        let target = convert(to.currency)
        return Money(amount: target.amount + to.amount, currency: to.currency)
        
    }
    public func subtract(_ from: Money) -> Money {
        let target = convert(from.currency)
        return Money(amount: from.amount - target.amount, currency: from.currency)
    }
    
    private func toUSD() -> Double {
        switch currency {
        case .GBP:
            return amount / 0.5
        case .EUR:
            return amount / 1.5
        case .CAN:
            return amount / 1.25
        case .USD:
            return amount
        }
    }
}



////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let numH):
        return Int(numH * Double(hours))
    case .Salary(let numS) :
        return numS
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let numH):
        self.type = .Hourly(numH + amt)
        //self.type = .Hourly(numH * (1.0 + 0.01 * amt))
    case .Salary(let numS) :
        self.type = .Salary(numS + Int(amt))
    }
  }
}


////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job}
    set(value) {
        if (self.age >= 16) {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse}
    set(value) {
        if (self.age >= 18) {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
  }
}


////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.age >= 21 || spouse2.age >= 21) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    child.age = 0
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var total = 0
    for eachPerson in members {
        if let eachJob = eachPerson.job {
            total += eachJob.calculateIncome(2000)
        }
    }
    return total
  }
}
