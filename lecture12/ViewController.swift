import UIKit

enum Operations {
    case byDefault
    case division
    case multiplication
    case subtraction
    case addition
    case compare
    case percent
}

class ViewController: UIViewController {
    
    private var operation = Operations.byDefault
    private var operationCount = 0
    private var result = ""
    
    private var firstDigit = 0.0
    private var secondDigit = 0.0
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        view.layoutIfNeeded()
        buttons.forEach{
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func calculate() {
        switch operation {
        case .division:
            result = "\(firstDigit / secondDigit)"
        case .multiplication:
            result = "\(firstDigit * secondDigit)"
        case .subtraction:
            result = "\(firstDigit - secondDigit)"
        case .addition:
            result = "\(firstDigit + secondDigit)"
        case .percent:
            result = "\(firstDigit * secondDigit / 100)"
        default:
            result = ""
        }
        if Double(result)?.truncatingRemainder(dividingBy: 1) == 0 {
            result = "\(Int(Double(result) ?? 0.0) )"
        }
        lblResult.text = result
        operation = .byDefault
        operationCount = 0
    }
    
    private func clear() {
        lblResult.text = ""
        result = ""
        firstDigit = 0.0
        secondDigit = 0.0
        operation = .byDefault
        operationCount = 0
    }
    
    private func changeSign() {
        if result.contains("-"){
            result = String(result.removeFirst())
            lblResult.text = result
        } else {
            result = "-\(lblResult.text ?? "")"
            lblResult.text = result
        }
    }
    
    private func addZero(_ value: inout String) -> String{
        if value.last == "," {
            value.append("0")
        }
        return value
    }
    
    @IBAction func setBaseOperation(_ sender: UIButton) {
        let tag = sender.tag
        
        if operationCount == 0 && operation == .byDefault{
            operationCount = 1
            firstDigit = Double(addZero(&result)) ?? 0.0
            result = ""
        } else if operation != .byDefault{
            operationCount = 0
            secondDigit = Double(addZero(&result)) ?? 0.0
        }
        
        switch tag % 10 {
        case 0:
            operation = .division
        case 1:
            operation = .multiplication
        case 2:
            operation = .subtraction
        case 3:
            operation = .addition
        case 4:
            calculate()
        case 5:
            clear()
        case 6:
            operation = .percent
        default:
            operation = .byDefault
        }
    }
    
    @IBAction func addDigit(_ sender: UIButton) {
        result = result + (sender.titleLabel?.text ?? "")
        lblResult.text = result
    }
    
    @IBAction func changeSign(_ sender: UIButton) {
        changeSign()
    }
}

