//
//  SwiftViewController.swift
//  SeSACWebSocket
//
//  Created by 서승우 on 2023/12/27.
//

import UIKit

let age = Int.random(in: 1...100)
let status = false

final class SwiftViewController: UIViewController {

    let randomResult = {
        switch age {
        case 1...30: return "학생입니다"
        case 31...60: return "어른입니다"
        case 61...100: return "노인입니다"
        default: return "알 수 없어요"
        }
    }()

    // Swift 5.9부터 지원
//    let newResult = if age < 20 { "학생입니다" }
//                    else if age > 31 && age < 60 { "어른입니다" }
//                    else { "노인입니다" }
//
//    let userStatus = if status { UIColor.black }
//                    else { UIColor.red }

//    let newResultSwitch = switch age {
//                            case 1...30: return "학생입니다"
//                            case 31...60: return "어른입니다"
//                            case 61...100: return "노인입니다"
//                            default: return "알 수 없어요"
//                        }

    let newLabel = SeSACFactory.make(.label)

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func randomAge() -> String {

        switch age {
        case 1...30: return "학생입니다"
        case 31...60: return "어른입니다"
        case 61...100: return "노인입니다"
        default: return "알 수 없어요"
        }
    }

    // Swift 5.9부터
//    @backDeployed(before: iOS 16.4)
    @available(iOS 15.0, *)
    func randomAge2() -> String {

        if age < 30 {
            return "학생입니다"
        } else if age < 31 && age < 60 {
            return "어른입니다"
        } else {
            return "노인입니다"
        }
    }

    func example<T>(a: T...) {
        print(a)
    }

    // Swift 5.9부터
    // repeat each
    // Parameter Pack 이라고 한다
//    func exampleGeneric<each T>(a: repeat (each T)) -> (repeat each T) {
//        return (repeat each a)
//    }

    // Optional Generic
    func example<T, K>(a: T, b: K?) -> String {
        return "\(a), \(b)"
    }

}










enum SeSACComponent {
    case label
    case button
}

protocol SeSACUIComponent {
    var component: SeSACComponent { get }
    var color: UIColor { get set }
    var bgColor: UIColor { get set }
}

final class NewLabel: UILabel, SeSACUIComponent {
    var component: SeSACComponent = .label
    var color: UIColor
    var bgColor: UIColor

    init(color: UIColor, bgColor: UIColor) {
        self.color = color
        self.bgColor = bgColor
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct SeSACFactory {

    static func make(_ component: SeSACComponent) -> SeSACUIComponent {
        switch component {
        case .label:
            return NewLabel(color: .blue, bgColor: .black)
        default:
            return NewLabel(color: .blue, bgColor: .black)
        }
    }

}

final class SeSACLabel: UILabel {

    init(textColor: UIColor, bgColor: UIColor) {
        super.init(frame: .zero)

        self.textColor = textColor
        self.backgroundColor = bgColor
    }

    init(font: UIFont, bgColor: UIColor) {
        super.init(frame: .zero)

        self.font = .systemFont(ofSize: 20)
        self.textColor = .black
        self.numberOfLines = 0
        self.backgroundColor = bgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
