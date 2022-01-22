//
//  Netguru iOS code review task
//

class paymentViewController: UIViewController {
    
    // MARK:- Varaibles
    internal let viewModel: PaymentViewModel
    weak var  delegate: PaymentViewControllerDelegate?
    let paymentView = PaymentView()
    let payment: Payment?
    
    // MARK:- MESTHODS LIFE CYCLE
    func viewDidLoad() {
        fetchPayment()
        initUi()
    }
    
    func initUi() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        self.prePaymentView()
    }
    
    func prePaymentView() {
        paymentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        paymentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        view.addSubview(paymentView)
        callbacks()
    }
    
    func callbacks() {
        paymentView.didTapButton = { [weak self] in
            if let payment = self.payment {
                self.delegate.didFinishFlow(amount: payment.amount,
                                            currency: payment.currency)
            }
        }
    }
    
    // MARK:- FEATCHING DATA
    func fetchPayment() {
        paymentView.statusText = "Fetching data"
        ApiClient.sharedInstance().fetchPayment { [weak self] payment in
            self.payment = payment
            self.paymentView.isEuro = viewModel.isEuroOrNot(payment:payment)
            if let paymentModel = payment {
                if paymentModel.amount != 0 {
                    self.paymentView.label.text = "\(paymentModel.amount)"
                    return
                }
            }
        }
    }
}

class PaymentViewModel {
    func isEuroOrNot( payment: Payment?) -> Bool {
        if let paymentModel = payment {
            if payment.currency == "EUR" {
                return true
            }else{
                false
            }
        }
        return false
    }
}
