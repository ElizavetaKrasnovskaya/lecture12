import UIKit

class ViewController: UIViewController {
    
    private var operation = Operations.byDefault
    private var operationCount = 0
    private var result = ""
    
    private var firstDigit = 0.0
    private var secondDigit = 0.0
    
    @IBOutlet weak var viewResult: UIView!
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
        addSwipeGesture(to: viewResult, direction: .left)
        addSwipeGesture(to: viewResult, direction: .right)
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
        lblResult.text = roundResult(&result)
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
        value = value.replacingOccurrences(of: ",", with: ".")
        if value.last == "." {
            value.append("0")
        }
        return value
    }
    
    private func roundResult(_ value: inout String) -> String {
        String(value.prefix(8))
    }
    
    private func addSwipeGesture(to view: UIView, direction:UISwipeGestureRecognizer.Direction) {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteDigit))
        swipeGesture.direction = direction
        view.addGestureRecognizer(swipeGesture)
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
    
    @objc
    private func deleteDigit(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .left, .right:
            if !result.isEmpty {
                result.removeLast(1)
            }
            lblResult.text = result
        default:
            return
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
