import Foundation

/// The `paymentMethod` object of POST /payins/{idPayin}. Field rules differ per method and sometimes per currency.
public enum PaymentMethod: Encodable, Equatable, Sendable {
    /// Absa Pay offers a simple, quick and secure way to make payments without needing to input banking login details. Customers can select their preferred account for payment and securely authorize the transaction through the banking app.
    case absaPay(AbsaPay)
    /// Capitec Pay is an easy, fast and safe way to pay without having to enter the bank card details or share banking login information. The customer can choose the account he wants to pay from and authenticate the payment safely in the banking app.
    case capitecPay(CapitecPay)
    /// Card payment method.
    case card(Card)
    /// Convenience Store Payments. Payment method which requires customer to copy Payment Code from the Payment application right after the payment is submitted into kiosk in convenience store during the payment on the cashier.
    case codePayment(CodePayment)
    /// Crypto Offline is a payment method that allows customers to pay by crypto currency from they crypto wallet to an address that they are provided.
    case cryptoOffline(CryptoOffline)
    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case duitNow(DuitNow)
    /// E-Wallet is a payment option on Indonesian market that allows customers to use major Indonesian wallets for payments. Customer is either automatically redirected to a chosen wallet with all payment details pre-populated to finalize the payment or directly receives push notification to authorize the payment in case of OVO wallet.
    case eWallet(EWallet)
    /// FNB Direct EFT is a digital payment method that enables customers to make secure payments directly through their FNB app. Rather than manually entering bank details, customers can approve the payment on their phone, creating a faster, safer, and more seamless checkout experience.
    case fnbDirectEFT(FnbDirectEFT)
    /// FPX (Financial Process Exchange) is a real-time online payment system in Malaysia that enables secure, instant payments by redirecting users to their selected FPX-participating banks.
    case fpx(Fpx)
    /// It is India market version of the Offline Bank Transfer which differs in the data which need to be collected and used during a Payment process.
    case imps(IMPS)
    /// Mobile Money is a payment method which allows customers to simply complete a payment from their mobile money wallet.
    case mobileMoney(MobileMoney)
    /// MoMo is a mobile payment method that allows users to complete transactions via the MoMo app. Payments are initiated through QR codes, where users authorize the transaction within the app.
    case momoPay(MomoPay)
    /// Nedbank Direct EFT is a digital payment method that allows customers to pay quickly and securely using their Nedbank app. Instead of entering bank details, customers simply approve the payment on their phone, making the checkout process faster, safer, and more convenient.
    case nedbankDirectEFT(NedbankDirectEFT)
    /// Netbanking, also known as online banking or Net Banking is a payment option offered by banks and financial institutions on Indian market that allow customers to use banking services over the internet. In our case, we take advantage of the Netbanking services to offer your customer UPI Payment method to pay funds directly from your customer Net Banking account.
    case netBanking(NetBanking)
    /// Offline Bank Transfer. Payment method which requires customer to copy Payment instruction from the Payment application right after the incoming payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking or wallet.
    case offline(Offline)
    /// Online Bank Transfer. Payment method where Customer is redirected to his own preferred Payment service application right after the payment is submitted and create the Payment transfer with pre-filled Payment instruction.
    case online(Online)
    /// OTT Voucher is a cash-to-digital payment method that enables customers to make secure online payments using prepaid vouchers. Rather than relying on a credit card or bank account, customers simply enter a unique 12-digit PIN at checkout, creating an accessible, safe, and seamless payment experience.
    case ottVoucher(OttVoucher)
    /// Phone to Account. Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case p2AV2(P2AV2)
    /// PayShap offers a quick, easy, and secure way to send money without having to input banking login details. Customers can make payments using just a phone number or account number, with transactions processed instantly.
    case payShap(PayShap)
    /// Pay Me is payment method intended for South Africa market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    case payMe(PayMe)
    /// Pix is a Brazilian payment method which allows customers to send payments using their preferred banking app by either scanning QR code or copy-pasting Pix EMV code.
    case pixQR(PixQR)
    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case promptPay(PromptPay)
    /// PSE (Pagos Seguros en L?nea) is a real-time online payment system in Colombia that enables secure, instant bank transfer payments - customers simply log in into their internet banking and authorize pre-populated payment details.
    case pse(Pse)
    /// QRIS is payment method intended for the Indonesian market which allows users to pay using scanning QR codes by theirs Payment application.
    case qrisPay(QrisPay)
    /// QR Ph is payment method intended for Philippine market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    case qrPh(QrPh)
    /// SnapScan is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the SnapScan app or by clicking on the payment deep link.
    case snapScanQr(SnapScanQr)
    /// UPI Collect is a method of fund transfers in India. This payment method allows users to simply authorize payments through their registered UPI app after receiving a payment collection request.
    case upiCollect(UpiCollect)
    /// UPI (Unified Payments Interface) is a method of fund transfers in India. The mechanism allows two parties to exchange funds using a UPI ID without having to share the banking information with the other party.
    case upiId(UpiId)
    /// UPI QR is payment method intended for the Indian market. This payment method requires customers to scan QR code by Customer's Payment service application compatible with UPI payment schema.
    case upiQR(UpiQR)
    /// Virtual Accounts. Payment method which requires customer to copy Payment instruction with generated Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    case vaPay(VaPay)
    /// Virtual Accounts With Verified Bank Account. Payment method which requires customer to copy Payment instruction with assigned Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    case vaPayVerif(VaPayVerif)
    /// Viet QR is a payment method intended for the Vietnamese market which allows users to pay using scanning QR codes by theirs payment application or internet banking.
    case vietQR(VietQR)
    /// Zapper is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the Zapper app or by clicking on the payment deep link.
    case zapperQr(ZapperQr)

    /// The method's code in the API, such as CAPITEC_PAY.
    public var paymentMethodCode: String {
        switch self {
        case .absaPay: return "ABSA_PAY"
        case .capitecPay: return "CAPITEC_PAY"
        case .card: return "CARD"
        case .codePayment: return "CODE_PAYMENT"
        case .cryptoOffline: return "CRYPTO_OFFLINE"
        case .duitNow: return "DUITNOW"
        case .eWallet: return "EWALLET"
        case .fnbDirectEFT: return "FNB_DIRECT_EFT"
        case .fpx: return "FPX"
        case .imps: return "IMPS"
        case .mobileMoney: return "MOBILE_MONEY"
        case .momoPay: return "MOMOPAY"
        case .nedbankDirectEFT: return "NEDBANK_DIRECT_EFT"
        case .netBanking: return "NETBANKING"
        case .offline: return "OFFLINE"
        case .online: return "ONLINE"
        case .ottVoucher: return "OTT_VOUCHER"
        case .p2AV2: return "P2A_V2"
        case .payShap: return "PAYSHAP"
        case .payMe: return "PAY_ME"
        case .pixQR: return "PIXQR"
        case .promptPay: return "PROMPTPAY"
        case .pse: return "PSE"
        case .qrisPay: return "QRISPAY"
        case .qrPh: return "QRPH"
        case .snapScanQr: return "SNAPSCAN_QR"
        case .upiCollect: return "UPICOLLECT"
        case .upiId: return "UPIID"
        case .upiQR: return "UPIQR"
        case .vaPay: return "VAPAY"
        case .vaPayVerif: return "VAPAY_VERIF"
        case .vietQR: return "VIETQR"
        case .zapperQr: return "ZAPPER_QR"
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Discriminator.self)
        try container.encode(paymentMethodCode, forKey: .paymentMethodCode)
        switch self {
        case .absaPay(let method): try method.encode(to: encoder)
        case .capitecPay(let method): try method.encode(to: encoder)
        case .card(let method): try method.encode(to: encoder)
        case .codePayment(let method): try method.encode(to: encoder)
        case .cryptoOffline(let method): try method.encode(to: encoder)
        case .duitNow(let method): try method.encode(to: encoder)
        case .eWallet(let method): try method.encode(to: encoder)
        case .fnbDirectEFT(let method): try method.encode(to: encoder)
        case .fpx(let method): try method.encode(to: encoder)
        case .imps(let method): try method.encode(to: encoder)
        case .mobileMoney(let method): try method.encode(to: encoder)
        case .momoPay(let method): try method.encode(to: encoder)
        case .nedbankDirectEFT(let method): try method.encode(to: encoder)
        case .netBanking(let method): try method.encode(to: encoder)
        case .offline(let method): try method.encode(to: encoder)
        case .online(let method): try method.encode(to: encoder)
        case .ottVoucher(let method): try method.encode(to: encoder)
        case .p2AV2(let method): try method.encode(to: encoder)
        case .payShap(let method): try method.encode(to: encoder)
        case .payMe(let method): try method.encode(to: encoder)
        case .pixQR(let method): try method.encode(to: encoder)
        case .promptPay(let method): try method.encode(to: encoder)
        case .pse(let method): try method.encode(to: encoder)
        case .qrisPay(let method): try method.encode(to: encoder)
        case .qrPh(let method): try method.encode(to: encoder)
        case .snapScanQr(let method): try method.encode(to: encoder)
        case .upiCollect(let method): try method.encode(to: encoder)
        case .upiId(let method): try method.encode(to: encoder)
        case .upiQR(let method): try method.encode(to: encoder)
        case .vaPay(let method): try method.encode(to: encoder)
        case .vaPayVerif(let method): try method.encode(to: encoder)
        case .vietQR(let method): try method.encode(to: encoder)
        case .zapperQr(let method): try method.encode(to: encoder)
        }
    }

    /// Throws SynqtArgumentError when a shared type such as Account lacks a field this method needs, or has one it does not take.
    func validate() throws {
        switch self {
        case .absaPay(let method): try method.validate()
        case .capitecPay(let method): try method.validate()
        case .card(let method): try method.validate()
        case .codePayment(let method): try method.validate()
        case .duitNow(let method): try method.validate()
        case .eWallet(let method): try method.validate()
        case .fnbDirectEFT(let method): try method.validate()
        case .fpx(let method): try method.validate()
        case .imps(let method): try method.validate()
        case .mobileMoney(let method): try method.validate()
        case .nedbankDirectEFT(let method): try method.validate()
        case .netBanking(let method): try method.validate()
        case .offline(let method): try method.validate()
        case .ottVoucher(let method): try method.validate()
        case .p2AV2(let method): try method.validate()
        case .payShap(let method): try method.validate()
        case .payMe(let method): try method.validate()
        case .pixQR(let method): try method.validate()
        case .promptPay(let method): try method.validate()
        case .pse(let method): try method.validate()
        case .qrisPay(let method): try method.validate()
        case .qrPh(let method): try method.validate()
        case .snapScanQr(let method): try method.validate()
        case .upiCollect(let method): try method.validate()
        case .upiQR(let method): try method.validate()
        case .vaPay(let method): try method.validate()
        case .vaPayVerif(let method): try method.validate()
        case .zapperQr(let method): try method.validate()
        default: break
        }
    }

    private enum Discriminator: String, CodingKey { case paymentMethodCode }

    /// Absa Pay offers a simple, quick and secure way to make payments without needing to input banking login details. Customers can select their preferred account for payment and securely authorize the transaction through the banking app.
    public struct AbsaPay: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethod.PersonName?

        public init(account: PaymentMethod.Account? = nil, emailAddress: String? = nil, passportNumber: String? = nil, said: String? = nil, customerName: PaymentMethod.PersonName? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.passportNumber = passportNumber
            self.said = said
            self.customerName = customerName
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.AbsaPay does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethod.AbsaPay needs customerName.lastName")
        }
    }

    /// Capitec Pay is an easy, fast and safe way to pay without having to enter the bank card details or share banking login information. The customer can choose the account he wants to pay from and authenticate the payment safely in the banking app.
    public struct CapitecPay: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethod.PersonName?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethod.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, said: String? = nil, customerName: PaymentMethod.PersonName? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.said = said
            self.customerName = customerName
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.CapitecPay does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethod.CapitecPay needs customerName.lastName")
        }
    }

    /// Card payment method.
    public struct Card: Encodable, Equatable, Sendable {
        public let card: PaymentMethod.Card.CardData
        public let paymentContacts: PaymentMethod.Card.CardPaymentContacts?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        public let saveCardForFutureUse: Bool?
        public let recurring: PaymentMethod.Card.RecurringPayment?

        public init(card: PaymentMethod.Card.CardData, paymentContacts: PaymentMethod.Card.CardPaymentContacts? = nil, paymentOperatorCode: String? = nil, saveCardForFutureUse: Bool? = nil, recurring: PaymentMethod.Card.RecurringPayment? = nil) {
            self.card = card
            self.paymentContacts = paymentContacts
            self.paymentOperatorCode = paymentOperatorCode
            self.saveCardForFutureUse = saveCardForFutureUse
            self.recurring = recurring
        }

        func validate() throws {
            try paymentContacts?.validate()
        }

        public struct CardData: Encodable, Equatable, Sendable {
            public let cardDataVault: PaymentMethod.Card.CardDataVault?

            public init(cardDataVault: PaymentMethod.Card.CardDataVault? = nil) {
                self.cardDataVault = cardDataVault
            }
        }

        public struct CardDataVault: Encodable, Equatable, Sendable {
            /// min 1.
            public let vaultToken: String
            public let securityCode: PaymentMethod.Card.EnvelopeEncryption?

            public init(vaultToken: String, securityCode: PaymentMethod.Card.EnvelopeEncryption? = nil) {
                self.vaultToken = vaultToken
                self.securityCode = securityCode
            }
        }

        public struct CardPaymentContact: Encodable, Equatable, Sendable {
            public let addressLines: [String]?
            /// min 1.
            public let administrativeArea: String?
            /// min 1.
            public let country: String?
            /// min 1.
            public let countryCode: String?
            /// min 1.
            public let locality: String?
            /// min 1.
            public let postalCode: String?
            /// Person's first, middle and last name.
            public let personName: PaymentMethod.PersonName?
            /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
            public let emailAddress: String?
            /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
            public let phoneNumber: String?

            public init(addressLines: [String]? = nil, administrativeArea: String? = nil, country: String? = nil, countryCode: String? = nil, locality: String? = nil, postalCode: String? = nil, personName: PaymentMethod.PersonName? = nil, emailAddress: String? = nil, phoneNumber: String? = nil) {
                self.addressLines = addressLines
                self.administrativeArea = administrativeArea
                self.country = country
                self.countryCode = countryCode
                self.locality = locality
                self.postalCode = postalCode
                self.personName = personName
                self.emailAddress = emailAddress
                self.phoneNumber = phoneNumber
            }

            func validate() throws {
                try check(personName == nil || personName?.lastName != nil, "PaymentMethod.Card.CardPaymentContact needs personName.lastName")
            }
        }

        public struct CardPaymentContacts: Encodable, Equatable, Sendable {
            public let billingContact: PaymentMethod.Card.CardPaymentContact?
            public let shippingContact: PaymentMethod.Card.CardPaymentContact?

            public init(billingContact: PaymentMethod.Card.CardPaymentContact? = nil, shippingContact: PaymentMethod.Card.CardPaymentContact? = nil) {
                self.billingContact = billingContact
                self.shippingContact = shippingContact
            }

            func validate() throws {
                try billingContact?.validate()
                try shippingContact?.validate()
            }
        }

        public struct EnvelopeEncryption: Encodable, Equatable, Sendable {
            /// min 1.
            public let cipherText: String
            /// min 1.
            public let wrappedDEK: String
            /// min 1.
            public let initializationVector: String
            /// min 1.
            public let kekId: String

            public init(cipherText: String, wrappedDEK: String, initializationVector: String, kekId: String) {
                self.cipherText = cipherText
                self.wrappedDEK = wrappedDEK
                self.initializationVector = initializationVector
                self.kekId = kekId
            }
        }

        public struct RecurringPayment: Encodable, Equatable, Sendable {
            public let isFixedAmount: Bool
            public let isFixedPeriod: Bool
            public let idOfInitialTransaction: String?

            public init(isFixedAmount: Bool, isFixedPeriod: Bool, idOfInitialTransaction: String? = nil) {
                self.isFixedAmount = isFixedAmount
                self.isFixedPeriod = isFixedPeriod
                self.idOfInitialTransaction = idOfInitialTransaction
            }
        }
    }

    /// Convenience Store Payments. Payment method which requires customer to copy Payment Code from the Payment application right after the payment is submitted into kiosk in convenience store during the payment on the cashier.
    public struct CodePayment: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocation: PaymentMethod.PaymentLocation
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?

        public init(paymentOperatorCode: String, emailAddress: String, phoneNumber: String, paymentLocation: PaymentMethod.PaymentLocation, account: PaymentMethod.Account? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentLocation = paymentLocation
            self.account = account
        }

        func validate() throws {
            try check(account == nil || account?.accountName != nil, "PaymentMethod.CodePayment needs account.accountName")
            try check(account == nil || account?.accountNumber == nil, "PaymentMethod.CodePayment does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethod.CodePayment does not take account.accountType")
        }
    }

    /// Crypto Offline is a payment method that allows customers to pay by crypto currency from they crypto wallet to an address that they are provided.
    public struct CryptoOffline: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(paymentOperatorCode: String, emailAddress: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }
    }

    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    public struct DuitNow: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.DuitNow needs account.accountName")
            try check(account.accountType == nil, "PaymentMethod.DuitNow does not take account.accountType")
        }
    }

    /// E-Wallet is a payment option on Indonesian market that allows customers to use major Indonesian wallets for payments. Customer is either automatically redirected to a chosen wallet with all payment details pre-populated to finalize the payment or directly receives push notification to authorize the payment in case of OVO wallet.
    public struct EWallet: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(paymentOperatorCode: String, account: PaymentMethod.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber == nil, "PaymentMethod.EWallet does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethod.EWallet does not take account.accountType")
        }
    }

    /// FNB Direct EFT is a digital payment method that enables customers to make secure payments directly through their FNB app. Rather than manually entering bank details, customers can approve the payment on their phone, creating a faster, safer, and more seamless checkout experience.
    public struct FnbDirectEFT: Encodable, Equatable, Sendable {
        /// Customer's first and last name.
        public let customerName: PaymentMethod.PersonName
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?

        public init(customerName: PaymentMethod.PersonName, emailAddress: String, account: PaymentMethod.Account, passportNumber: String? = nil, said: String? = nil) {
            self.customerName = customerName
            self.emailAddress = emailAddress
            self.account = account
            self.passportNumber = passportNumber
            self.said = said
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethod.FnbDirectEFT needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethod.FnbDirectEFT needs customerName.lastName")
            try check(customerName.titleBefore == nil, "PaymentMethod.FnbDirectEFT does not take customerName.titleBefore")
            try check(customerName.middleName == nil, "PaymentMethod.FnbDirectEFT does not take customerName.middleName")
            try check(customerName.titleAfter == nil, "PaymentMethod.FnbDirectEFT does not take customerName.titleAfter")
            try check(account.accountNumber != nil, "PaymentMethod.FnbDirectEFT needs account.accountNumber")
            try check(account.accountName == nil, "PaymentMethod.FnbDirectEFT does not take account.accountName")
            try check(account.accountType == nil, "PaymentMethod.FnbDirectEFT does not take account.accountType")
        }
    }

    /// FPX (Financial Process Exchange) is a real-time online payment system in Malaysia that enables secure, instant payments by redirecting users to their selected FPX-participating banks.
    public struct Fpx: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account, paymentOperatorCode: String, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.Fpx needs account.accountName")
            try check(account.accountType != nil, "PaymentMethod.Fpx needs account.accountType")
            try check(account.accountNumber == nil, "PaymentMethod.Fpx does not take account.accountNumber")
        }
    }

    /// It is India market version of the Offline Bank Transfer which differs in the data which need to be collected and used during a Payment process.
    public struct IMPS: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account, emailAddress: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.IMPS needs account.accountName")
            try check(account.accountType == nil, "PaymentMethod.IMPS does not take account.accountType")
        }
    }

    /// Mobile Money is a payment method which allows customers to simply complete a payment from their mobile money wallet.
    public struct MobileMoney: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account, phoneNumber: String, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.MobileMoney needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethod.MobileMoney does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.MobileMoney does not take account.accountType")
        }
    }

    /// MoMo is a mobile payment method that allows users to complete transactions via the MoMo app. Payments are initiated through QR codes, where users authorize the transaction within the app.
    public struct MomoPay: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(emailAddress: String? = nil) {
            self.emailAddress = emailAddress
        }
    }

    /// Nedbank Direct EFT is a digital payment method that allows customers to pay quickly and securely using their Nedbank app. Instead of entering bank details, customers simply approve the payment on their phone, making the checkout process faster, safer, and more convenient.
    public struct NedbankDirectEFT: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethod.PersonName?

        public init(account: PaymentMethod.Account, said: String, emailAddress: String? = nil, customerName: PaymentMethod.PersonName? = nil) {
            self.account = account
            self.said = said
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.NedbankDirectEFT needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethod.NedbankDirectEFT does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.NedbankDirectEFT does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethod.NedbankDirectEFT needs customerName.lastName")
        }
    }

    /// Netbanking, also known as online banking or Net Banking is a payment option offered by banks and financial institutions on Indian market that allow customers to use banking services over the internet. In our case, we take advantage of the Netbanking services to offer your customer UPI Payment method to pay funds directly from your customer Net Banking account.
    public struct NetBanking: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethod.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.NetBanking does not take account.accountType")
        }
    }

    /// Offline Bank Transfer. Payment method which requires customer to copy Payment instruction from the Payment application right after the incoming payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking or wallet.
    public struct Offline: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Identification of a product related to a payment order. max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let productId: String?
        /// Tax payer identification number of a customer. min 8, max 18.
        public let taxId: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethod.PersonName?

        public init(account: PaymentMethod.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, productId: String? = nil, taxId: String? = nil, customerName: PaymentMethod.PersonName? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.productId = productId
            self.taxId = taxId
            self.customerName = customerName
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.Offline does not take account.accountType")
            try check(customerName == nil || customerName?.firstName != nil, "PaymentMethod.Offline needs customerName.firstName")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethod.Offline needs customerName.lastName")
        }
    }

    /// Online Bank Transfer. Payment method where Customer is redirected to his own preferred Payment service application right after the payment is submitted and create the Payment transfer with pre-filled Payment instruction.
    public struct Online: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }
    }

    /// OTT Voucher is a cash-to-digital payment method that enables customers to make secure online payments using prepaid vouchers. Rather than relying on a credit card or bank account, customers simply enter a unique 12-digit PIN at checkout, creating an accessible, safe, and seamless payment experience.
    public struct OttVoucher: Encodable, Equatable, Sendable {
        /// OTT voucher PIN. min 1.
        public let voucherPin: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Person's first, middle and last name.
        public let customerName: PaymentMethod.PersonName

        public init(voucherPin: String, phoneNumber: String, emailAddress: String, customerName: PaymentMethod.PersonName) {
            self.voucherPin = voucherPin
            self.phoneNumber = phoneNumber
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethod.OttVoucher needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethod.OttVoucher needs customerName.lastName")
        }
    }

    /// Phone to Account. Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    public struct P2AV2: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(paymentOperatorCode: String, account: PaymentMethod.Account? = nil, emailAddress: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.P2AV2 does not take account.accountType")
        }
    }

    /// PayShap offers a quick, easy, and secure way to send money without having to input banking login details. Customers can make payments using just a phone number or account number, with transactions processed instantly.
    public struct PayShap: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethod.PersonName?
        /// min 1.
        public let externalProviderCode: String?

        public init(paymentOperatorCode: String, account: PaymentMethod.Account? = nil, phoneNumber: String? = nil, emailAddress: String? = nil, passportNumber: String? = nil, said: String? = nil, customerName: PaymentMethod.PersonName? = nil, externalProviderCode: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.account = account
            self.phoneNumber = phoneNumber
            self.emailAddress = emailAddress
            self.passportNumber = passportNumber
            self.said = said
            self.customerName = customerName
            self.externalProviderCode = externalProviderCode
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.PayShap does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethod.PayShap needs customerName.lastName")
        }
    }

    /// Pay Me is payment method intended for South Africa market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    public struct PayMe: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(account: PaymentMethod.Account, emailAddress: String? = nil, phoneNumber: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.PayMe needs account.accountName")
            try check(account.accountType == nil, "PaymentMethod.PayMe does not take account.accountType")
        }
    }

    /// Pix is a Brazilian payment method which allows customers to send payments using their preferred banking app by either scanning QR code or copy-pasting Pix EMV code.
    public struct PixQR: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Brazilian tax payer identification number - CPF for individuals / CNPJ for businesses. min 14, max 14.
        public let taxId: String

        public init(account: PaymentMethod.Account, taxId: String) {
            self.account = account
            self.taxId = taxId
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.PixQR needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethod.PixQR does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.PixQR does not take account.accountType")
        }
    }

    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    public struct PromptPay: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber != nil, "PaymentMethod.PromptPay needs account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethod.PromptPay does not take account.accountType")
        }
    }

    /// PSE (Pagos Seguros en L?nea) is a real-time online payment system in Colombia that enables secure, instant bank transfer payments - customers simply log in into their internet banking and authorize pre-populated payment details.
    public struct Pse: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String

        public init(account: PaymentMethod.Account, emailAddress: String, phoneNumber: String) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.Pse needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethod.Pse does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.Pse does not take account.accountType")
        }
    }

    /// QRIS is payment method intended for the Indonesian market which allows users to pay using scanning QR codes by theirs Payment application.
    public struct QrisPay: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account? = nil, emailAddress: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.QrisPay does not take account.accountType")
        }
    }

    /// QR Ph is payment method intended for Philippine market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    public struct QrPh: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(account: PaymentMethod.Account? = nil, emailAddress: String? = nil, paymentOperatorCode: String? = nil, phoneNumber: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.paymentOperatorCode = paymentOperatorCode
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.QrPh does not take account.accountType")
        }
    }

    /// SnapScan is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the SnapScan app or by clicking on the payment deep link.
    public struct SnapScanQr: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Person's first, middle and last name.
        public let customerName: PaymentMethod.PersonName

        public init(emailAddress: String, customerName: PaymentMethod.PersonName) {
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethod.SnapScanQr needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethod.SnapScanQr needs customerName.lastName")
        }
    }

    /// UPI Collect is a method of fund transfers in India. This payment method allows users to simply authorize payments through their registered UPI app after receiving a payment collection request.
    public struct UpiCollect: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String

        public init(account: PaymentMethod.Account, upiId: String, emailAddress: String, phoneNumber: String) {
            self.account = account
            self.upiId = upiId
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethod.UpiCollect needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethod.UpiCollect does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.UpiCollect does not take account.accountType")
        }
    }

    /// UPI (Unified Payments Interface) is a method of fund transfers in India. The mechanism allows two parties to exchange funds using a UPI ID without having to share the banking information with the other party.
    public struct UpiId: Encodable, Equatable, Sendable {
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(upiId: String, emailAddress: String? = nil) {
            self.upiId = upiId
            self.emailAddress = emailAddress
        }
    }

    /// UPI QR is payment method intended for the Indian market. This payment method requires customers to scan QR code by Customer's Payment service application compatible with UPI payment schema.
    public struct UpiQR: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethod.Account? = nil, upiId: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.upiId = upiId
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber == nil, "PaymentMethod.UpiQR does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethod.UpiQR does not take account.accountType")
        }
    }

    /// Virtual Accounts. Payment method which requires customer to copy Payment instruction with generated Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    public struct VaPay: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocation: PaymentMethod.PaymentLocation?

        public init(account: PaymentMethod.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentLocation: PaymentMethod.PaymentLocation? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentLocation = paymentLocation
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethod.VaPay does not take account.accountType")
        }
    }

    /// Virtual Accounts With Verified Bank Account. Payment method which requires customer to copy Payment instruction with assigned Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    public struct VaPayVerif: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethod.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethod.Account, paymentOperatorCode: String, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountNumber != nil, "PaymentMethod.VaPayVerif needs account.accountNumber")
            try check(account.accountType == nil, "PaymentMethod.VaPayVerif does not take account.accountType")
        }
    }

    /// Viet QR is a payment method intended for the Vietnamese market which allows users to pay using scanning QR codes by theirs payment application or internet banking.
    public struct VietQR: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(paymentOperatorCode: String, emailAddress: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }
    }

    /// Zapper is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the Zapper app or by clicking on the payment deep link.
    public struct ZapperQr: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Customer's first and last name.
        public let customerName: PaymentMethod.PersonName

        public init(emailAddress: String, customerName: PaymentMethod.PersonName) {
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethod.ZapperQr needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethod.ZapperQr needs customerName.lastName")
            try check(customerName.titleBefore == nil, "PaymentMethod.ZapperQr does not take customerName.titleBefore")
            try check(customerName.middleName == nil, "PaymentMethod.ZapperQr does not take customerName.middleName")
            try check(customerName.titleAfter == nil, "PaymentMethod.ZapperQr does not take customerName.titleAfter")
        }
    }

    /// The payer's bank or wallet account. Each method needs different fields and checks them when it is sent.
    public struct Account: Encodable, Equatable, Sendable {
        /// Account Name is the name of the person who holds the bank or wallet account which your customer sends funds from to make his payment. Rules differ per payment method.
        public let accountName: String?
        /// Account Number is the number of your customer's bank account which your customer sends funds from to make his payment. Rules differ per payment method.
        public let accountNumber: String?
        /// The customer's account type. Rules differ per payment method.
        public let accountType: String?

        public init(accountName: String? = nil, accountNumber: String? = nil, accountType: String? = nil) {
            self.accountName = accountName
            self.accountNumber = accountNumber
            self.accountType = accountType
        }
    }

    public struct PaymentLocation: Encodable, Decodable, Equatable, Sendable {
        /// Postal code where customer is paying at (e.g. min 1.
        public let postalCode: String
        /// City which customer is paying in (e.g. min 1.
        public let city: String
        /// Disctrict which customer is paying in (e.g. min 1.
        public let district: String

        public init(postalCode: String, city: String, district: String) {
            self.postalCode = postalCode
            self.city = city
            self.district = district
        }
    }

    /// A person's name. Each method needs different parts and checks them when it is sent.
    public struct PersonName: Encodable, Equatable, Sendable {
        /// A title before the name. min 1.
        public let titleBefore: String?
        /// A first name. min 1.
        public let firstName: String?
        /// A middle name. min 1.
        public let middleName: String?
        /// A last name. min 1.
        public let lastName: String?
        /// A title after the name. min 1.
        public let titleAfter: String?

        public init(titleBefore: String? = nil, firstName: String? = nil, middleName: String? = nil, lastName: String? = nil, titleAfter: String? = nil) {
            self.titleBefore = titleBefore
            self.firstName = firstName
            self.middleName = middleName
            self.lastName = lastName
            self.titleAfter = titleAfter
        }
    }
}

/// `paymentMethodResponse` of a created payin. Unknown methods parse to `.unknown`.
public enum PaymentMethodResponse: Decodable, Equatable, Sendable {
    case absaPay(AbsaPay)
    case capitecPay(CapitecPay)
    case card(Card)
    case codePayment(CodePayment)
    case cryptoOffline(CryptoOffline)
    case duitNow(DuitNow)
    case eWallet(EWallet)
    case fnbDirectEFT(FnbDirectEFT)
    case fpx(Fpx)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case imps(IMPS)
    case mobileMoney(MobileMoney)
    case momoPay(MomoPay)
    case nedbankDirectEFT(NedbankDirectEFT)
    case netBanking(NetBanking)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case offline(Offline)
    case online(Online)
    case ottVoucher(OttVoucher)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case p2AV2(P2AV2)
    case payShap(PayShap)
    case payMe(PayMe)
    case pixQR(PixQR)
    case promptPay(PromptPay)
    case pse(Pse)
    case qrisPay(QrisPay)
    case qrPh(QrPh)
    case snapScanQr(SnapScanQr)
    case upiCollect(UpiCollect)
    case upiId(UpiId)
    case upiQR(UpiQR)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case vaPay(VaPay)
    case vaPayVerif(VaPayVerif)
    case vietQR(VietQR)
    case zapperQr(ZapperQr)
    /// A `paymentMethodCode` this SDK version does not know yet; new values are non-breaking API changes.
    case unknown(paymentMethodCode: String)

    public init(from decoder: Decoder) throws {
        let code = try decoder.container(keyedBy: Discriminator.self).decodeIfPresent(String.self, forKey: .paymentMethodCode) ?? ""
        switch code {
        case "ABSA_PAY": self = .absaPay(try AbsaPay(from: decoder))
        case "CAPITEC_PAY": self = .capitecPay(try CapitecPay(from: decoder))
        case "CARD": self = .card(try Card(from: decoder))
        case "CODE_PAYMENT": self = .codePayment(try CodePayment(from: decoder))
        case "CRYPTO_OFFLINE": self = .cryptoOffline(try CryptoOffline(from: decoder))
        case "DUITNOW": self = .duitNow(try DuitNow(from: decoder))
        case "EWALLET": self = .eWallet(try EWallet(from: decoder))
        case "FNB_DIRECT_EFT": self = .fnbDirectEFT(try FnbDirectEFT(from: decoder))
        case "FPX": self = .fpx(try Fpx(from: decoder))
        case "IMPS": self = .imps(try IMPS(from: decoder))
        case "MOBILE_MONEY": self = .mobileMoney(try MobileMoney(from: decoder))
        case "MOMOPAY": self = .momoPay(try MomoPay(from: decoder))
        case "NEDBANK_DIRECT_EFT": self = .nedbankDirectEFT(try NedbankDirectEFT(from: decoder))
        case "NETBANKING": self = .netBanking(try NetBanking(from: decoder))
        case "OFFLINE": self = .offline(try Offline(from: decoder))
        case "ONLINE": self = .online(try Online(from: decoder))
        case "OTT_VOUCHER": self = .ottVoucher(try OttVoucher(from: decoder))
        case "P2A_V2": self = .p2AV2(try P2AV2(from: decoder))
        case "PAYSHAP": self = .payShap(try PayShap(from: decoder))
        case "PAY_ME": self = .payMe(try PayMe(from: decoder))
        case "PIXQR": self = .pixQR(try PixQR(from: decoder))
        case "PROMPTPAY": self = .promptPay(try PromptPay(from: decoder))
        case "PSE": self = .pse(try Pse(from: decoder))
        case "QRISPAY": self = .qrisPay(try QrisPay(from: decoder))
        case "QRPH": self = .qrPh(try QrPh(from: decoder))
        case "SNAPSCAN_QR": self = .snapScanQr(try SnapScanQr(from: decoder))
        case "UPICOLLECT": self = .upiCollect(try UpiCollect(from: decoder))
        case "UPIID": self = .upiId(try UpiId(from: decoder))
        case "UPIQR": self = .upiQR(try UpiQR(from: decoder))
        case "VAPAY": self = .vaPay(try VaPay(from: decoder))
        case "VAPAY_VERIF": self = .vaPayVerif(try VaPayVerif(from: decoder))
        case "VIETQR": self = .vietQR(try VietQR(from: decoder))
        case "ZAPPER_QR": self = .zapperQr(try ZapperQr(from: decoder))
        default: self = .unknown(paymentMethodCode: code)
        }
    }

    private enum Discriminator: String, CodingKey { case paymentMethodCode }

    public struct AbsaPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        public let accounts: [PaymentMethodResponse.Account]?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponse.Account?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct CapitecPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponse.Account?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct Card: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
        /// TODO:
        public let userInteraction: UserInteraction?
    }

    public struct CodePayment: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a Convenience Store Payment that your customer use to send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Specifies location where a customer is making the payment (e.g. Always present per spec.
        public let paymentLocationCustomer: PaymentMethod.PaymentLocation?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct CryptoOffline: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a crypto wallet where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct DuitNow: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct EWallet: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct FnbDirectEFT: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct Fpx: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// The account parameters for this payment method are used to show payment instructions to the customer.
    public struct IMPS: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// Always present per spec.
        public let qrCode: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct MobileMoney: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct MomoPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code to be used for the Copy and Paste functionality or rendered as a QR code. Always present per spec.
        public let qrRawData: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct NedbankDirectEFT: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// min 13, max 13, pattern `^[0-9]*$`. Always present per spec.
        public let said: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct NetBanking: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Virtual payment address where we expect that your customer sends funds to make a payment. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String?
        /// It can be used as deep link button target (what is typically known as an intent trigger) or to generate a QR code that can be scanned with any UPI enabled app.
        public let deepLink: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// The account parameters for this payment method are used to show payment instructions to the customer.
    public struct Offline: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The external processor of the payment. one of POC, PAYSTAGE, MTPX, TPAY, LCSX, PRL.
        public let processor: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method.
        public let qrCode: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Identification of a product related to a payment order. max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let productId: String?
        /// Tax payer identification number of a customer. min 8, max 18.
        public let taxId: String?
        /// Tax payer identification number of a customer. min 8, max 18.
        public let taxIdCustomer: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct Online: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct OttVoucher: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// The account parameters for this payment method are used to show payment instructions to the customer.
    public struct P2AV2: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Specifies the payment address (e.g. Always present per spec.
        public let paymentAddress: PaymentMethodResponse.P2AV2.PaymentAddress?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// External payment / transaction reference is a unique identifier assigned to a financial transaction.
        public let externalReference: PaymentMethodResponse.ExternalReference?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?

        /// Specifies the payment address (e.g. in UPI payment system) where customer can send the payment using theirs wallets or others banking services.
        public struct PaymentAddress: Decodable, Equatable, Sendable {
            /// The name of the payment address ID e.g. Always present per spec.
            public let name: String?
            /// The payment address ID where customer can send the payment. Always present per spec.
            public let idAddress: String?
        }
    }

    public struct PayShap: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// TODO:
        public let externalProvider: PaymentMethodResponse.PayShap.ExternalProvider?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?

        /// TODO: Add description
        public struct ExternalProvider: Decodable, Equatable, Sendable {
            /// min 1, max 128. Always present per spec.
            public let code: String?
            /// min 1. Always present per spec.
            public let name: String?
        }
    }

    public struct PayMe: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// It can be used as deep link button target (what is typically known as an intent trigger) or to generate a QR code that can be scanned with any UPI enabled app.
        public let payMeDeepLink: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct PixQR: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code to be used for the Copy and Paste functionality or rendered as a QR code. Always present per spec.
        public let qrRawData: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Brazilian tax payer identification number - CPF for individuals / CNPJ for businesses. min 14, max 14. Always present per spec.
        public let taxId: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct PromptPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct Pse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct QrisPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code (e.g. Always present per spec.
        public let qrRawData: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct QrPh: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let moneyRequired: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct SnapScanQr: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code to be used for the Copy and Paste functionality or rendered as a QR code. Always present per spec.
        public let qrRawData: String?
        /// Can be used as a deep link target to launch the app directly, or to generate a QR code that can be scanned by SnapScan application. Always present per spec.
        public let snapscanQrDeepLink: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct UpiCollect: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`. Always present per spec.
        public let upiIdCustomer: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct UpiId: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct UpiQR: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// External payment / transaction reference is a unique identifier assigned to a financial transaction.
        public let externalReference: PaymentMethodResponse.ExternalReference?
        /// The external processor of the payment. one of POC, PAYSTAGE, MTPX, TPAY, LCSX, PRL.
        public let processor: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// It can be used as deep link button target (what is typically known as an intent trigger) or to generate a QR code that can be scanned with any UPI enabled app.
        public let upiQrDeepLink: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Virtual payment address where we expect that your customer sends funds to make a payment. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String?
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiIdCustomer: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// The account parameters for this payment method are used to show payment instructions to the customer.
    public struct VaPay: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The external processor of the payment. one of POC, PAYSTAGE, MTPX, TPAY, LCSX, PRL.
        public let processor: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// One of following can serve as Payment Operator:
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocationCustomer: PaymentMethod.PaymentLocation?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
        public let paymentInstructionList: [PaymentMethodResponse.VaPay.PaymentInstruction]?

        /// If not empty then it specifies special instructions for different banking services your customers has to follow when entering payment in their banking service.
        public struct PaymentInstruction: Decodable, Equatable, Sendable {
            /// It specifies your customer banking service to which companyCode belongs. Always present per spec.
            public let bankingService: String?
            /// It informs your customers that companyCode has to be used in their banking service together with Virtual Account Number from accountNumber parameter e.g. Always present per spec.
            public let companyCode: String?
        }
    }

    public struct VaPayVerif: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponse.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponse.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct VietQR: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponse.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct ZapperQr: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponse.Money?
        public let vat: PaymentMethodResponse.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code to be used for the Copy and Paste functionality or rendered as a QR code. Always present per spec.
        public let qrRawData: String?
        /// Can be used as a deep link target to launch the app directly, or to generate a QR code that can be scanned by Zapper application. Always present per spec.
        public let zapperQrDeepLink: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// An account as SYNQT reports it: the payer's, or the one to pay into. Which fields are set depends on the method.
    public struct Account: Decodable, Equatable, Sendable {
        /// Name of the bank account where we expect that your customer sends funds to make a payment. Rules differ per payment method.
        public let accountName: String?
        /// Number of the bank account where we expect that your customer sends funds to make a payment. Rules differ per payment method.
        public let accountNumber: String?
        /// Account type of the receiving bank account e.g. Rules differ per payment method.
        public let accountType: String?
        /// Bank code of the bank where we expect that your customer sends funds to make a payment. Rules differ per payment method.
        public let bankCode: String?
        /// Name of the bank where we expect that your customer sends funds to make a payment. Rules differ per payment method.
        public let bankName: String?
        /// Branch name of the bank where we expect that your customer sends funds to make a payment. Rules differ per payment method.
        public let bankBranch: String?
        /// City of the bank where we expect that your customer sends funds to make a payment. min 1.
        public let bankCity: String?
        /// Province of the bank where we expect that your customer sends funds to make a payment. min 1.
        public let bankProvince: String?
        /// int32.
        public let accountIndex: Int?
    }

    /// External payment / transaction reference is a unique identifier assigned to a financial transaction. Customers can usually find it in their banking service such as mobile wallets, internet banking services or bank slips.
    public struct ExternalReference: Decodable, Equatable, Sendable {
        /// min 1, max 512. Always present per spec.
        public let reference: String?
    }

    /// An amount in major units and its ISO 4217 currency.
    public struct Money: Decodable, Equatable, Sendable {
        /// Actual amount that end-customer should pay if `paymentMethodResponse.moneyRequired.amount` is not returned. Rules differ per payment method.
        public let amount: Decimal?
        /// For supported currencies please refer to `GET /currencies`. min 1.
        public let currencyCode: String?
    }

    public struct SelectedPaymentOperatorIncoming: Decodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let code: String?
        /// min 1, max 1000. Always present per spec.
        public let name: String?
    }
}

/// Extra step a CARD payment needs from the payer (3DS and similar).
public enum UserInteraction: Decodable, Equatable, Sendable {
    case content(Content)
    case form(Form)
    case otpRequired
    case redirect(Redirect)
    /// A `type` this SDK version does not know yet; new values are non-breaking API changes.
    case unknown(type: String)

    public init(from decoder: Decoder) throws {
        let code = try decoder.container(keyedBy: Discriminator.self).decodeIfPresent(String.self, forKey: .type) ?? ""
        switch code {
        case "CONTENT": self = .content(try Content(from: decoder))
        case "FORM": self = .form(try Form(from: decoder))
        case "OTP_REQUIRED": self = .otpRequired
        case "REDIRECT": self = .redirect(try Redirect(from: decoder))
        default: self = .unknown(type: code)
        }
    }

    private enum Discriminator: String, CodingKey { case type }

    public struct Content: Decodable, Equatable, Sendable {
        /// Always present per spec.
        public let content: String?
    }

    public struct Form: Decodable, Equatable, Sendable {
        /// Always present per spec.
        public let content: String?
    }

    public struct Redirect: Decodable, Equatable, Sendable {
        /// Always present per spec.
        public let url: String?
    }
}

private func check(_ ok: Bool, _ message: String) throws {
    if !ok { throw SynqtArgumentError(message) }
}
