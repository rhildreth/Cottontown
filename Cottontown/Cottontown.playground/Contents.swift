import Foundation


func testRetainCycle() {
    class Dog {
        var cat:Cat?
        deinit {
            print("farewell from Dog")
        }
    }
    
    class Cat {
        var dog:Dog?
        deinit {
            print("farewell from Cat")
        }
    }
    
    let d = Dog()
    let c = Cat()
    d.cat = c
    c.dog = d
}

testRetainCycle()

// OptionSetType

struct Features: OptionSetType {
    let rawValue: Int
    static let AlarmSystem = Features(rawValue: 1 << 1)
    static let CDStereo = Features(rawValue: 1 << 2)
    static let ChromeWheels = Features(rawValue: 1 << 3)
    static let PinStripes = Features(rawValue: 1 << 4)
    static let LeatherInterior = Features(rawValue: 1 << 5)
    static let Undercoating = Features(rawValue: 1 << 6)
    static let WindowTint = Features(rawValue: 1 << 7)
}

var options: Features = [.AlarmSystem, .Undercoating, .WindowTint]
print(options)
options.contains(.LeatherInterior)
options.contains(.AlarmSystem)

let a:Set = [1,2,3,1,2,3]
print(a)
a.contains(5)

// last N values the same

var last3Values = [0,0,0]
last3Values.insert(1, atIndex: 0)
last3Values.removeLast()
let near = [1,1,1]
last3Values == near
last3Values = [1,1,1]
last3Values == near


var evens = Array(1...10).filter { number in
    print (number)
    return number % 2 == 0
}
print(evens)
var b = [Int]?()
let d = [1,2,3]
b = nil
print(b)
let e = d + (b ?? [])



