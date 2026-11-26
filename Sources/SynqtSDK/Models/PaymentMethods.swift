import Foundation

/// The `paymentMethod` of a `Payin` request (POST /payins/{idPayin}). Field rules differ per method and sometimes per currency.
public enum PaymentMethodPayin: Encodable, Equatable, Sendable {
    /// Absa Pay offers a simple, quick and secure way to make payments without needing to input banking login details. Customers can select their preferred account for payment and securely authorize the transaction through the banking app.
    case absaPay(AbsaPayMethod)
    /// Capitec Pay is an easy, fast and safe way to pay without having to enter the bank card details or share banking login information. The customer can choose the account he wants to pay from and authenticate the payment safely in the banking app.
    case capitecPay(CapitecPayMethod)
    /// Card payment method.
    case card(CardMethod)
    /// Convenience Store Payments. Payment method which requires customer to copy Payment Code from the Payment application right after the payment is submitted into kiosk in convenience store during the payment on the cashier.
    case codePayment(CodePaymentMethod)
    /// Crypto Offline is a payment method that allows customers to pay by crypto currency from they crypto wallet to an address that they are provided.
    case cryptoOffline(CryptoOfflineMethod)
    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case duitNow(DuitNowMethod)
    /// E-Wallet is a payment option on Indonesian market that allows customers to use major Indonesian wallets for payments. Customer is either automatically redirected to a chosen wallet with all payment details pre-populated to finalize the payment or directly receives push notification to authorize the payment in case of OVO wallet.
    case eWallet(EWalletMethod)
    /// FNB Direct EFT is a digital payment method that enables customers to make secure payments directly through their FNB app. Rather than manually entering bank details, customers can approve the payment on their phone, creating a faster, safer, and more seamless checkout experience.
    case fnbDirectEFT(FnbDirectEFTMethod)
    /// FPX (Financial Process Exchange) is a real-time online payment system in Malaysia that enables secure, instant payments by redirecting users to their selected FPX-participating banks.
    case fpx(FpxMethod)
    /// It is India market version of the Offline Bank Transfer which differs in the data which need to be collected and used during a Payment process.
    case imps(IMPSMethod)
    /// Mobile Money is a payment method which allows customers to simply complete a payment from their mobile money wallet.
    case mobileMoney(MobileMoneyMethod)
    /// MoMo is a mobile payment method that allows users to complete transactions via the MoMo app. Payments are initiated through QR codes, where users authorize the transaction within the app.
    case momoPay(MomoPayMethod)
    /// Nedbank Direct EFT is a digital payment method that allows customers to pay quickly and securely using their Nedbank app. Instead of entering bank details, customers simply approve the payment on their phone, making the checkout process faster, safer, and more convenient.
    case nedbankDirectEFT(NedbankDirectEFTMethod)
    /// Netbanking, also known as online banking or Net Banking is a payment option offered by banks and financial institutions on Indian market that allow customers to use banking services over the internet. In our case, we take advantage of the Netbanking services to offer your customer UPI Payment method to pay funds directly from your customer Net Banking account.
    case netBanking(NetBankingMethod)
    /// Offline Bank Transfer. Payment method which requires customer to copy Payment instruction from the Payment application right after the incoming payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking or wallet.
    case offline(OfflineMethod)
    /// Online Bank Transfer. Payment method where Customer is redirected to his own preferred Payment service application right after the payment is submitted and create the Payment transfer with pre-filled Payment instruction.
    case online(OnlineMethod)
    /// OTT Voucher is a cash-to-digital payment method that enables customers to make secure online payments using prepaid vouchers. Rather than relying on a credit card or bank account, customers simply enter a unique 12-digit PIN at checkout, creating an accessible, safe, and seamless payment experience.
    case ottVoucher(OttVoucherMethod)
    /// Phone to Account. Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case p2AV2(P2AV2Method)
    /// PayShap offers a quick, easy, and secure way to send money without having to input banking login details. Customers can make payments using just a phone number or account number, with transactions processed instantly.
    case payShap(PayShapMethod)
    /// Pay Me is payment method intended for South Africa market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    case payMe(PayMeMethod)
    /// Pix is a Brazilian payment method which allows customers to send payments using their preferred banking app by either scanning QR code or copy-pasting Pix EMV code.
    case pixQR(PixQRMethod)
    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    case promptPay(PromptPayMethod)
    /// PSE (Pagos Seguros en L?nea) is a real-time online payment system in Colombia that enables secure, instant bank transfer payments - customers simply log in into their internet banking and authorize pre-populated payment details.
    case pse(PseMethod)
    /// QRIS is payment method intended for the Indonesian market which allows users to pay using scanning QR codes by theirs Payment application.
    case qrisPay(QrisPayMethod)
    /// QR Ph is payment method intended for Philippine market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    case qrPh(QrPhMethod)
    /// SnapScan is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the SnapScan app or by clicking on the payment deep link.
    case snapScanQr(SnapScanQrMethod)
    /// UPI Collect is a method of fund transfers in India. This payment method allows users to simply authorize payments through their registered UPI app after receiving a payment collection request.
    case upiCollect(UpiCollectMethod)
    /// UPI (Unified Payments Interface) is a method of fund transfers in India. The mechanism allows two parties to exchange funds using a UPI ID without having to share the banking information with the other party.
    case upiId(UpiIdMethod)
    /// UPI QR is payment method intended for the Indian market. This payment method requires customers to scan QR code by Customer's Payment service application compatible with UPI payment schema.
    case upiQR(UpiQRMethod)
    /// Virtual Accounts. Payment method which requires customer to copy Payment instruction with generated Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    case vaPay(VaPayMethod)
    /// Virtual Accounts With Verified Bank Account. Payment method which requires customer to copy Payment instruction with assigned Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    case vaPayVerif(VaPayVerifMethod)
    /// Viet QR is a payment method intended for the Vietnamese market which allows users to pay using scanning QR codes by theirs payment application or internet banking.
    case vietQR(VietQRMethod)
    /// Zapper is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the Zapper app or by clicking on the payment deep link.
    case zapperQr(ZapperQrMethod)
    /// A method an add-on builds as JSON, such as CARD from SYNQT's card add-on. Apps can't create one.
    case addon(Addon)

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
        case .addon(let method): return method.paymentMethodCode
        }
    }

    public func encode(to encoder: Encoder) throws {
        if case .addon(let method) = self { return try method.json.encode(to: encoder) } // it has its own code
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
        default: break
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

    /// An add-on's method: its code and the whole `paymentMethod` object, which it built and checked itself.
    public struct Addon: Equatable, Sendable {
        public let paymentMethodCode: String
        let json: JSON

        @_spi(SynqtAddon)
        public init(paymentMethodCode: String, json: JSON) {
            self.paymentMethodCode = paymentMethodCode
            self.json = json
        }
    }

    /// Absa Pay offers a simple, quick and secure way to make payments without needing to input banking login details. Customers can select their preferred account for payment and securely authorize the transaction through the banking app.
    public struct AbsaPayMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName?

        public init(account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil, passportNumber: String? = nil, said: String? = nil, customerName: PaymentMethodPayin.PersonName? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.passportNumber = passportNumber
            self.said = said
            self.customerName = customerName
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.AbsaPayMethod does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethodPayin.AbsaPayMethod needs customerName.lastName")
        }
    }

    /// Capitec Pay is an easy, fast and safe way to pay without having to enter the bank card details or share banking login information. The customer can choose the account he wants to pay from and authenticate the payment safely in the banking app.
    public struct CapitecPayMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, said: String? = nil, customerName: PaymentMethodPayin.PersonName? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.said = said
            self.customerName = customerName
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.CapitecPayMethod does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethodPayin.CapitecPayMethod needs customerName.lastName")
        }
    }

    /// Card payment method.
    public struct CardMethod: Encodable, Equatable, Sendable {
        public let card: PaymentMethodPayin.CardMethod.CardData
        public let paymentContacts: PaymentMethodPayin.CardMethod.CardPaymentContacts?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        public let saveCardForFutureUse: Bool?
        public let recurring: PaymentMethodPayin.CardMethod.RecurringPayment?

        public init(card: PaymentMethodPayin.CardMethod.CardData, paymentContacts: PaymentMethodPayin.CardMethod.CardPaymentContacts? = nil, paymentOperatorCode: String? = nil, saveCardForFutureUse: Bool? = nil, recurring: PaymentMethodPayin.CardMethod.RecurringPayment? = nil) {
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
            public let cardDataVault: PaymentMethodPayin.CardMethod.CardDataVault?

            public init(cardDataVault: PaymentMethodPayin.CardMethod.CardDataVault? = nil) {
                self.cardDataVault = cardDataVault
            }
        }

        public struct CardDataVault: Encodable, Equatable, Sendable {
            /// min 1.
            public let vaultToken: String
            public let securityCode: PaymentMethodPayin.CardMethod.EnvelopeEncryption?

            public init(vaultToken: String, securityCode: PaymentMethodPayin.CardMethod.EnvelopeEncryption? = nil) {
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
            public let personName: PaymentMethodPayin.PersonName?
            /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
            public let emailAddress: String?
            /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
            public let phoneNumber: String?

            public init(addressLines: [String]? = nil, administrativeArea: String? = nil, country: String? = nil, countryCode: String? = nil, locality: String? = nil, postalCode: String? = nil, personName: PaymentMethodPayin.PersonName? = nil, emailAddress: String? = nil, phoneNumber: String? = nil) {
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
                try check(personName == nil || personName?.lastName != nil, "PaymentMethodPayin.CardMethod.CardPaymentContact needs personName.lastName")
            }
        }

        public struct CardPaymentContacts: Encodable, Equatable, Sendable {
            public let billingContact: PaymentMethodPayin.CardMethod.CardPaymentContact?
            public let shippingContact: PaymentMethodPayin.CardMethod.CardPaymentContact?

            public init(billingContact: PaymentMethodPayin.CardMethod.CardPaymentContact? = nil, shippingContact: PaymentMethodPayin.CardMethod.CardPaymentContact? = nil) {
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
    public struct CodePaymentMethod: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocation: PaymentMethodPayin.PaymentLocation
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?

        public init(paymentOperatorCode: String, emailAddress: String, phoneNumber: String, paymentLocation: PaymentMethodPayin.PaymentLocation, account: PaymentMethodPayin.Account? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentLocation = paymentLocation
            self.account = account
        }

        func validate() throws {
            try check(account == nil || account?.accountName != nil, "PaymentMethodPayin.CodePaymentMethod needs account.accountName")
            try check(account == nil || account?.accountNumber == nil, "PaymentMethodPayin.CodePaymentMethod does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.CodePaymentMethod does not take account.accountType")
        }
    }

    /// Crypto Offline is a payment method that allows customers to pay by crypto currency from they crypto wallet to an address that they are provided.
    public struct CryptoOfflineMethod: Encodable, Equatable, Sendable {
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
    public struct DuitNowMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.DuitNowMethod needs account.accountName")
            try check(account.accountType == nil, "PaymentMethodPayin.DuitNowMethod does not take account.accountType")
        }
    }

    /// E-Wallet is a payment option on Indonesian market that allows customers to use major Indonesian wallets for payments. Customer is either automatically redirected to a chosen wallet with all payment details pre-populated to finalize the payment or directly receives push notification to authorize the payment in case of OVO wallet.
    public struct EWalletMethod: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(paymentOperatorCode: String, account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber == nil, "PaymentMethodPayin.EWalletMethod does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.EWalletMethod does not take account.accountType")
        }
    }

    /// FNB Direct EFT is a digital payment method that enables customers to make secure payments directly through their FNB app. Rather than manually entering bank details, customers can approve the payment on their phone, creating a faster, safer, and more seamless checkout experience.
    public struct FnbDirectEFTMethod: Encodable, Equatable, Sendable {
        /// Customer's first and last name.
        public let customerName: PaymentMethodPayin.PersonName
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?

        public init(customerName: PaymentMethodPayin.PersonName, emailAddress: String, account: PaymentMethodPayin.Account, passportNumber: String? = nil, said: String? = nil) {
            self.customerName = customerName
            self.emailAddress = emailAddress
            self.account = account
            self.passportNumber = passportNumber
            self.said = said
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethodPayin.FnbDirectEFTMethod needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethodPayin.FnbDirectEFTMethod needs customerName.lastName")
            try check(customerName.titleBefore == nil, "PaymentMethodPayin.FnbDirectEFTMethod does not take customerName.titleBefore")
            try check(customerName.middleName == nil, "PaymentMethodPayin.FnbDirectEFTMethod does not take customerName.middleName")
            try check(customerName.titleAfter == nil, "PaymentMethodPayin.FnbDirectEFTMethod does not take customerName.titleAfter")
            try check(account.accountNumber != nil, "PaymentMethodPayin.FnbDirectEFTMethod needs account.accountNumber")
            try check(account.accountName == nil, "PaymentMethodPayin.FnbDirectEFTMethod does not take account.accountName")
            try check(account.accountType == nil, "PaymentMethodPayin.FnbDirectEFTMethod does not take account.accountType")
        }
    }

    /// FPX (Financial Process Exchange) is a real-time online payment system in Malaysia that enables secure, instant payments by redirecting users to their selected FPX-participating banks.
    public struct FpxMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account, paymentOperatorCode: String, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.FpxMethod needs account.accountName")
            try check(account.accountType != nil, "PaymentMethodPayin.FpxMethod needs account.accountType")
            try check(account.accountNumber == nil, "PaymentMethodPayin.FpxMethod does not take account.accountNumber")
        }
    }

    /// It is India market version of the Offline Bank Transfer which differs in the data which need to be collected and used during a Payment process.
    public struct IMPSMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account, emailAddress: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.IMPSMethod needs account.accountName")
            try check(account.accountType == nil, "PaymentMethodPayin.IMPSMethod does not take account.accountType")
        }
    }

    /// Mobile Money is a payment method which allows customers to simply complete a payment from their mobile money wallet.
    public struct MobileMoneyMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account, phoneNumber: String, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.MobileMoneyMethod needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethodPayin.MobileMoneyMethod does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.MobileMoneyMethod does not take account.accountType")
        }
    }

    /// MoMo is a mobile payment method that allows users to complete transactions via the MoMo app. Payments are initiated through QR codes, where users authorize the transaction within the app.
    public struct MomoPayMethod: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(emailAddress: String? = nil) {
            self.emailAddress = emailAddress
        }
    }

    /// Nedbank Direct EFT is a digital payment method that allows customers to pay quickly and securely using their Nedbank app. Instead of entering bank details, customers simply approve the payment on their phone, making the checkout process faster, safer, and more convenient.
    public struct NedbankDirectEFTMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName?

        public init(account: PaymentMethodPayin.Account, said: String, emailAddress: String? = nil, customerName: PaymentMethodPayin.PersonName? = nil) {
            self.account = account
            self.said = said
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.NedbankDirectEFTMethod needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethodPayin.NedbankDirectEFTMethod does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.NedbankDirectEFTMethod does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethodPayin.NedbankDirectEFTMethod needs customerName.lastName")
        }
    }

    /// Netbanking, also known as online banking or Net Banking is a payment option offered by banks and financial institutions on Indian market that allow customers to use banking services over the internet. In our case, we take advantage of the Netbanking services to offer your customer UPI Payment method to pay funds directly from your customer Net Banking account.
    public struct NetBankingMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.NetBankingMethod does not take account.accountType")
        }
    }

    /// Offline Bank Transfer. Payment method which requires customer to copy Payment instruction from the Payment application right after the incoming payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking or wallet.
    public struct OfflineMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
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
        public let customerName: PaymentMethodPayin.PersonName?

        public init(account: PaymentMethodPayin.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, productId: String? = nil, taxId: String? = nil, customerName: PaymentMethodPayin.PersonName? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.productId = productId
            self.taxId = taxId
            self.customerName = customerName
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.OfflineMethod does not take account.accountType")
            try check(customerName == nil || customerName?.firstName != nil, "PaymentMethodPayin.OfflineMethod needs customerName.firstName")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethodPayin.OfflineMethod needs customerName.lastName")
        }
    }

    /// Online Bank Transfer. Payment method where Customer is redirected to his own preferred Payment service application right after the payment is submitted and create the Payment transfer with pre-filled Payment instruction.
    public struct OnlineMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }
    }

    /// OTT Voucher is a cash-to-digital payment method that enables customers to make secure online payments using prepaid vouchers. Rather than relying on a credit card or bank account, customers simply enter a unique 12-digit PIN at checkout, creating an accessible, safe, and seamless payment experience.
    public struct OttVoucherMethod: Encodable, Equatable, Sendable {
        /// OTT voucher PIN. min 1.
        public let voucherPin: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Person's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName

        public init(voucherPin: String, phoneNumber: String, emailAddress: String, customerName: PaymentMethodPayin.PersonName) {
            self.voucherPin = voucherPin
            self.phoneNumber = phoneNumber
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethodPayin.OttVoucherMethod needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethodPayin.OttVoucherMethod needs customerName.lastName")
        }
    }

    /// Phone to Account. Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    public struct P2AV2Method: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(paymentOperatorCode: String, account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil) {
            self.paymentOperatorCode = paymentOperatorCode
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.P2AV2Method does not take account.accountType")
        }
    }

    /// PayShap offers a quick, easy, and secure way to send money without having to input banking login details. Customers can make payments using just a phone number or account number, with transactions processed instantly.
    public struct PayShapMethod: Encodable, Equatable, Sendable {
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Customer's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName?
        /// min 1.
        public let externalProviderCode: String?

        public init(paymentOperatorCode: String, account: PaymentMethodPayin.Account? = nil, phoneNumber: String? = nil, emailAddress: String? = nil, passportNumber: String? = nil, said: String? = nil, customerName: PaymentMethodPayin.PersonName? = nil, externalProviderCode: String? = nil) {
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
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.PayShapMethod does not take account.accountType")
            try check(customerName == nil || customerName?.lastName != nil, "PaymentMethodPayin.PayShapMethod needs customerName.lastName")
        }
    }

    /// Pay Me is payment method intended for South Africa market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    public struct PayMeMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(account: PaymentMethodPayin.Account, emailAddress: String? = nil, phoneNumber: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.PayMeMethod needs account.accountName")
            try check(account.accountType == nil, "PaymentMethodPayin.PayMeMethod does not take account.accountType")
        }
    }

    /// Pix is a Brazilian payment method which allows customers to send payments using their preferred banking app by either scanning QR code or copy-pasting Pix EMV code.
    public struct PixQRMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Brazilian tax payer identification number - CPF for individuals / CNPJ for businesses. min 14, max 14.
        public let taxId: String

        public init(account: PaymentMethodPayin.Account, taxId: String) {
            self.account = account
            self.taxId = taxId
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.PixQRMethod needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethodPayin.PixQRMethod does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.PixQRMethod does not take account.accountType")
        }
    }

    /// Payment method which requires customer to scan QR code from the Payment application by Customer's Payment service application right after the payment is submitted.
    public struct PromptPayMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber != nil, "PaymentMethodPayin.PromptPayMethod needs account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.PromptPayMethod does not take account.accountType")
        }
    }

    /// PSE (Pagos Seguros en L?nea) is a real-time online payment system in Colombia that enables secure, instant bank transfer payments - customers simply log in into their internet banking and authorize pre-populated payment details.
    public struct PseMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String

        public init(account: PaymentMethodPayin.Account, emailAddress: String, phoneNumber: String) {
            self.account = account
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.PseMethod needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethodPayin.PseMethod does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.PseMethod does not take account.accountType")
        }
    }

    /// QRIS is payment method intended for the Indonesian market which allows users to pay using scanning QR codes by theirs Payment application.
    public struct QrisPayMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.QrisPayMethod does not take account.accountType")
        }
    }

    /// QR Ph is payment method intended for Philippine market which allows customers to send payments by scanning QR codes from supported banks and e-wallets.
    public struct QrPhMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?

        public init(account: PaymentMethodPayin.Account? = nil, emailAddress: String? = nil, paymentOperatorCode: String? = nil, phoneNumber: String? = nil) {
            self.account = account
            self.emailAddress = emailAddress
            self.paymentOperatorCode = paymentOperatorCode
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.QrPhMethod does not take account.accountType")
        }
    }

    /// SnapScan is a QR-based payment method that allows customers to make fast and secure payments by scanning a QR code using the SnapScan app or by clicking on the payment deep link.
    public struct SnapScanQrMethod: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Person's first, middle and last name.
        public let customerName: PaymentMethodPayin.PersonName

        public init(emailAddress: String, customerName: PaymentMethodPayin.PersonName) {
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethodPayin.SnapScanQrMethod needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethodPayin.SnapScanQrMethod needs customerName.lastName")
        }
    }

    /// UPI Collect is a method of fund transfers in India. This payment method allows users to simply authorize payments through their registered UPI app after receiving a payment collection request.
    public struct UpiCollectMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String

        public init(account: PaymentMethodPayin.Account, upiId: String, emailAddress: String, phoneNumber: String) {
            self.account = account
            self.upiId = upiId
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
        }

        func validate() throws {
            try check(account.accountName != nil, "PaymentMethodPayin.UpiCollectMethod needs account.accountName")
            try check(account.accountNumber == nil, "PaymentMethodPayin.UpiCollectMethod does not take account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.UpiCollectMethod does not take account.accountType")
        }
    }

    /// UPI (Unified Payments Interface) is a method of fund transfers in India. The mechanism allows two parties to exchange funds using a UPI ID without having to share the banking information with the other party.
    public struct UpiIdMethod: Encodable, Equatable, Sendable {
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
    public struct UpiQRMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// Virtual payment address of the customer on UPI provided by the merchant or obtained during the processing on our platform. max 100, pattern `[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+`.
        public let upiId: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?

        public init(account: PaymentMethodPayin.Account? = nil, upiId: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentOperatorCode: String? = nil) {
            self.account = account
            self.upiId = upiId
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentOperatorCode = paymentOperatorCode
        }

        func validate() throws {
            try check(account == nil || account?.accountNumber == nil, "PaymentMethodPayin.UpiQRMethod does not take account.accountNumber")
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.UpiQRMethod does not take account.accountType")
        }
    }

    /// Virtual Accounts. Payment method which requires customer to copy Payment instruction with generated Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    public struct VaPayMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocation: PaymentMethodPayin.PaymentLocation?

        public init(account: PaymentMethodPayin.Account? = nil, paymentOperatorCode: String? = nil, emailAddress: String? = nil, phoneNumber: String? = nil, paymentLocation: PaymentMethodPayin.PaymentLocation? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
            self.phoneNumber = phoneNumber
            self.paymentLocation = paymentLocation
        }

        func validate() throws {
            try check(account == nil || account?.accountType == nil, "PaymentMethodPayin.VaPayMethod does not take account.accountType")
        }
    }

    /// Virtual Accounts With Verified Bank Account. Payment method which requires customer to copy Payment instruction with assigned Virtual Account from the Payment application right after the payment is submitted and create the Payment transfer using the instructions within customer's own payment service such as Internet or mobile banking, wallet or ATM.
    public struct VaPayVerifMethod: Encodable, Equatable, Sendable {
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let account: PaymentMethodPayin.Account
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`.
        public let paymentOperatorCode: String
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?

        public init(account: PaymentMethodPayin.Account, paymentOperatorCode: String, emailAddress: String? = nil) {
            self.account = account
            self.paymentOperatorCode = paymentOperatorCode
            self.emailAddress = emailAddress
        }

        func validate() throws {
            try check(account.accountNumber != nil, "PaymentMethodPayin.VaPayVerifMethod needs account.accountNumber")
            try check(account.accountType == nil, "PaymentMethodPayin.VaPayVerifMethod does not take account.accountType")
        }
    }

    /// Viet QR is a payment method intended for the Vietnamese market which allows users to pay using scanning QR codes by theirs payment application or internet banking.
    public struct VietQRMethod: Encodable, Equatable, Sendable {
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
    public struct ZapperQrMethod: Encodable, Equatable, Sendable {
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String
        /// Customer's first and last name.
        public let customerName: PaymentMethodPayin.PersonName

        public init(emailAddress: String, customerName: PaymentMethodPayin.PersonName) {
            self.emailAddress = emailAddress
            self.customerName = customerName
        }

        func validate() throws {
            try check(customerName.firstName != nil, "PaymentMethodPayin.ZapperQrMethod needs customerName.firstName")
            try check(customerName.lastName != nil, "PaymentMethodPayin.ZapperQrMethod needs customerName.lastName")
            try check(customerName.titleBefore == nil, "PaymentMethodPayin.ZapperQrMethod does not take customerName.titleBefore")
            try check(customerName.middleName == nil, "PaymentMethodPayin.ZapperQrMethod does not take customerName.middleName")
            try check(customerName.titleAfter == nil, "PaymentMethodPayin.ZapperQrMethod does not take customerName.titleAfter")
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
public enum PaymentMethodResponsePayin: Decodable, Equatable, Sendable {
    case absaPay(AbsaPayMethodResponse)
    case capitecPay(CapitecPayMethodResponse)
    case card(CardMethodResponse)
    case codePayment(CodePaymentMethodResponse)
    case cryptoOffline(CryptoOfflineMethodResponse)
    case duitNow(DuitNowPayMethodResponse)
    case eWallet(EWalletMethodResponse)
    case fnbDirectEFT(FnbDirectEFTMethodResponse)
    case fpx(FpxMethodResponse)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case imps(IMPSMethodResponse)
    case mobileMoney(MobileMoneyMethodResponse)
    case momoPay(MomoPayMethodResponse)
    case nedbankDirectEFT(NedbankDirectEFTMethodResponse)
    case netBanking(NetBankingMethodResponse)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case offline(OfflineMethodResponse)
    case online(OnlineMethodResponse)
    case ottVoucher(OttVoucherMethodResponse)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case p2AV2(P2AV2MethodResponse)
    case payShap(PayShapMethodResponse)
    case payMe(PayMeMethodResponse)
    case pixQR(PixQRMethodResponse)
    case promptPay(PromptPayMethodResponse)
    case pse(PseMethodResponse)
    case qrisPay(QrisPayMethodResponse)
    case qrPh(QrPhMethodResponse)
    case snapScanQr(SnapScanQrMethodResponse)
    case upiCollect(UpiCollectMethodResponse)
    case upiId(UpiIdMethodResponse)
    case upiQR(UpiQRMethodResponse)
    /// The account parameters for this payment method are used to show payment instructions to the customer.
    case vaPay(VaPayMethodResponse)
    case vaPayVerif(VaPayVerifMethodResponse)
    case vietQR(VietQRMethodResponse)
    case zapperQr(ZapperQrMethodResponse)
    /// A `paymentMethodCode` this SDK version does not know yet, with its JSON (UTF-8); new values are non-breaking API changes.
    case unknown(paymentMethodCode: String, json: Data)

    /// A known paymentMethodCode whose fields don't fit its model also reads as `.unknown`, so a response never fails on them.
    public init(from decoder: Decoder) throws {
        let code = (try? decoder.container(keyedBy: Discriminator.self).decodeIfPresent(String.self, forKey: .paymentMethodCode)) ?? ""
        do {
            switch code {
            case "ABSA_PAY": self = .absaPay(try AbsaPayMethodResponse(from: decoder))
            case "CAPITEC_PAY": self = .capitecPay(try CapitecPayMethodResponse(from: decoder))
            case "CARD": self = .card(try CardMethodResponse(from: decoder))
            case "CODE_PAYMENT": self = .codePayment(try CodePaymentMethodResponse(from: decoder))
            case "CRYPTO_OFFLINE": self = .cryptoOffline(try CryptoOfflineMethodResponse(from: decoder))
            case "DUITNOW": self = .duitNow(try DuitNowPayMethodResponse(from: decoder))
            case "EWALLET": self = .eWallet(try EWalletMethodResponse(from: decoder))
            case "FNB_DIRECT_EFT": self = .fnbDirectEFT(try FnbDirectEFTMethodResponse(from: decoder))
            case "FPX": self = .fpx(try FpxMethodResponse(from: decoder))
            case "IMPS": self = .imps(try IMPSMethodResponse(from: decoder))
            case "MOBILE_MONEY": self = .mobileMoney(try MobileMoneyMethodResponse(from: decoder))
            case "MOMOPAY": self = .momoPay(try MomoPayMethodResponse(from: decoder))
            case "NEDBANK_DIRECT_EFT": self = .nedbankDirectEFT(try NedbankDirectEFTMethodResponse(from: decoder))
            case "NETBANKING": self = .netBanking(try NetBankingMethodResponse(from: decoder))
            case "OFFLINE": self = .offline(try OfflineMethodResponse(from: decoder))
            case "ONLINE": self = .online(try OnlineMethodResponse(from: decoder))
            case "OTT_VOUCHER": self = .ottVoucher(try OttVoucherMethodResponse(from: decoder))
            case "P2A_V2": self = .p2AV2(try P2AV2MethodResponse(from: decoder))
            case "PAYSHAP": self = .payShap(try PayShapMethodResponse(from: decoder))
            case "PAY_ME": self = .payMe(try PayMeMethodResponse(from: decoder))
            case "PIXQR": self = .pixQR(try PixQRMethodResponse(from: decoder))
            case "PROMPTPAY": self = .promptPay(try PromptPayMethodResponse(from: decoder))
            case "PSE": self = .pse(try PseMethodResponse(from: decoder))
            case "QRISPAY": self = .qrisPay(try QrisPayMethodResponse(from: decoder))
            case "QRPH": self = .qrPh(try QrPhMethodResponse(from: decoder))
            case "SNAPSCAN_QR": self = .snapScanQr(try SnapScanQrMethodResponse(from: decoder))
            case "UPICOLLECT": self = .upiCollect(try UpiCollectMethodResponse(from: decoder))
            case "UPIID": self = .upiId(try UpiIdMethodResponse(from: decoder))
            case "UPIQR": self = .upiQR(try UpiQRMethodResponse(from: decoder))
            case "VAPAY": self = .vaPay(try VaPayMethodResponse(from: decoder))
            case "VAPAY_VERIF": self = .vaPayVerif(try VaPayVerifMethodResponse(from: decoder))
            case "VIETQR": self = .vietQR(try VietQRMethodResponse(from: decoder))
            case "ZAPPER_QR": self = .zapperQr(try ZapperQrMethodResponse(from: decoder))
            default: self = .unknown(paymentMethodCode: code, json: try rawJSON(decoder))
            }
        } catch {
            self = .unknown(paymentMethodCode: code, json: try rawJSON(decoder))
        }
    }

    /// What the payer does next: the QR code, app link, amount, reference and expiry this method returned.
    public func nextStep() -> NextStep {
        switch self {
        case .absaPay(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .capitecPay(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .card(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .codePayment(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .cryptoOffline(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .duitNow(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .eWallet(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .fnbDirectEFT(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .fpx(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .imps(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .mobileMoney(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .momoPay(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, qrCodeData: method.qrRawData.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .nedbankDirectEFT(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .netBanking(let method): return NextStep(appLink: method.deepLink.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .offline(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty, payInto: method.account)
        case .online(let method): return NextStep(amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .ottVoucher(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .p2AV2(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .payShap(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .payMe(let method): return NextStep(appLink: method.payMeDeepLink.nonEmpty, qrCodeImageURL: method.qrCode.nonEmpty, amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .pixQR(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, qrCodeData: method.qrRawData.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .promptPay(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .pse(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .qrisPay(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, qrCodeData: method.qrRawData.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .qrPh(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, amountToPay: method.moneyRequired, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .snapScanQr(let method): return NextStep(appLink: method.snapscanQrDeepLink.nonEmpty, qrCodeImageURL: method.qrCode.nonEmpty, qrCodeData: method.qrRawData.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .upiCollect(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .upiId(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .upiQR(let method): return NextStep(appLink: method.upiQrDeepLink.nonEmpty, qrCodeImageURL: method.qrCode.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .vaPay(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .vaPayVerif(let method): return NextStep(reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .vietQR(let method): return NextStep(qrCodeImageURL: method.qrCode.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .zapperQr(let method): return NextStep(appLink: method.zapperQrDeepLink.nonEmpty, qrCodeImageURL: method.qrCode.nonEmpty, qrCodeData: method.qrRawData.nonEmpty, reference: method.reference.nonEmpty, expiresAt: method.expireAt.nonEmpty)
        case .unknown(_, let json): return parseNextStep(json)
        }
    }

    private enum Discriminator: String, CodingKey { case paymentMethodCode }

    public struct AbsaPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        public let accounts: [PaymentMethodResponsePayin.Account]?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponsePayin.Account?
        /// min 8, max 9, pattern `^[a-zA-Z][0-9]+$`.
        public let passportNumber: String?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct CapitecPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponsePayin.Account?
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

    public struct CardMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
        /// TODO:
        public let userInteraction: UserInteraction?
    }

    public struct CodePaymentMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a Convenience Store Payment that your customer use to send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Specifies location where a customer is making the payment (e.g. Always present per spec.
        public let paymentLocationCustomer: PaymentMethodPayin.PaymentLocation?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct CryptoOfflineMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a crypto wallet where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct DuitNowPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct EWalletMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct FnbDirectEFTMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
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

    public struct FpxMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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
    public struct IMPSMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct MobileMoneyMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct MomoPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct NedbankDirectEFTMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct NetBankingMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    /// The account parameters for this payment method are used to show payment instructions to the customer.
    public struct OfflineMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
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

    public struct OnlineMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct OttVoucherMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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
    public struct P2AV2MethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Specifies the payment address (e.g. Always present per spec.
        public let paymentAddress: PaymentMethodResponsePayin.P2AV2MethodResponse.PaymentAddress?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// External payment / transaction reference is a unique identifier assigned to a financial transaction.
        public let externalReference: PaymentMethodResponsePayin.ExternalReference?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
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

    public struct PayShapMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Your customer's mobile phone number, starting with 0. min 12, max 12.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// TODO:
        public let externalProvider: ExternalProvider?
        /// min 13, max 13, pattern `^[0-9]*$`.
        public let said: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct PayMeMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct PixQRMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// The raw string / payload encoded within the QR code to be used for the Copy and Paste functionality or rendered as a QR code. Always present per spec.
        public let qrRawData: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
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

    public struct PromptPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
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

    public struct PseMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins. Always present per spec.
        public let emailAddress: String?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`. Always present per spec.
        public let phoneNumber: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct QrisPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct QrPhMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let moneyRequired: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct SnapScanQrMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct UpiCollectMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct UpiIdMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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

    public struct UpiQRMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Contains information about the account used by the customer.
        public let accountCustomerUsedForPayment: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// External payment / transaction reference is a unique identifier assigned to a financial transaction.
        public let externalReference: PaymentMethodResponsePayin.ExternalReference?
        /// The external processor of the payment. one of POC, PAYSTAGE, MTPX, TPAY, LCSX, PRL.
        public let processor: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// It can be used as deep link button target (what is typically known as an intent trigger) or to generate a QR code that can be scanned with any UPI enabled app.
        public let upiQrDeepLink: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
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
    public struct VaPayMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The external processor of the payment. one of POC, PAYSTAGE, MTPX, TPAY, LCSX, PRL.
        public let processor: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// One of following can serve as Payment Operator:
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Your customer's mobile phone number in full international telephone number format, including country code. min 7, max 16, pattern `^\+?[0-9]+$`.
        public let phoneNumber: String?
        /// Your customer's e-mail address in RFC 5322 format that is used for identification of the customer's payins.
        public let emailAddress: String?
        /// Specifies location where a customer is making the payment (e.g.
        public let paymentLocationCustomer: PaymentMethodPayin.PaymentLocation?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
        public let paymentInstructionList: [PaymentMethodResponsePayin.VaPayMethodResponse.PaymentInstruction]?

        /// If not empty then it specifies special instructions for different banking services your customers has to follow when entering payment in their banking service.
        public struct PaymentInstruction: Decodable, Equatable, Sendable {
            /// It specifies your customer banking service to which companyCode belongs. Always present per spec.
            public let bankingService: String?
            /// It informs your customers that companyCode has to be used in their banking service together with Virtual Account Number from accountNumber parameter e.g. Always present per spec.
            public let companyCode: String?
        }
    }

    public struct VaPayVerifMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Parameters of a bank account where we expect that your customer send funds to make a payment. Always present per spec.
        public let account: PaymentMethodResponsePayin.Account?
        /// Parameters of your customer's bank or wallet account which your customer sends funds from. Always present per spec.
        public let accountCustomer: PaymentMethodResponsePayin.Account?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on). Always present per spec.
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct VietQRMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
        /// Always present per spec.
        public let merchantName: String?
        /// Reference number of transaction. Always present per spec.
        public let reference: String?
        /// The name of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrName: String?
        /// The URL of the QR code image to be scanned by a wallet or payment service compatible with this payment method. Always present per spec.
        public let qrCode: String?
        /// PaymentOperator is a financial institution that manages transactions in your customer's account (such as banks, card payment processors, mobile wallets and so on).
        public let paymentOperator: PaymentMethodResponsePayin.SelectedPaymentOperatorIncoming?
        /// This is the URL where the customers will be redirected after completing a payment. max 1000. Always present per spec.
        public let returnUrl: String?
        /// Date and time when payment was accepted. date-time. Always present per spec.
        public let acceptedAt: String?
        /// Date and time of payment expiration. date-time. Always present per spec.
        public let expireAt: String?
    }

    public struct ZapperQrMethodResponse: Decodable, Equatable, Sendable {
        /// Unique Merchant Order ID provided by merchant. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayin: String?
        /// The Unique reference ID of the Order generated by platform. max 250, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let idPayment: String?
        /// Always present per spec.
        public let money: PaymentMethodResponsePayin.Money?
        public let vat: PaymentMethodResponsePayin.Money?
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
    /// A `type` this SDK version does not know yet, with its JSON (UTF-8); new values are non-breaking API changes.
    case unknown(type: String, json: Data)

    /// A known type whose fields don't fit its model also reads as `.unknown`, so a response never fails on them.
    public init(from decoder: Decoder) throws {
        let code = (try? decoder.container(keyedBy: Discriminator.self).decodeIfPresent(String.self, forKey: .type)) ?? ""
        do {
            switch code {
            case "CONTENT": self = .content(try Content(from: decoder))
            case "FORM": self = .form(try Form(from: decoder))
            case "OTP_REQUIRED": self = .otpRequired
            case "REDIRECT": self = .redirect(try Redirect(from: decoder))
            default: self = .unknown(type: code, json: try rawJSON(decoder))
            }
        } catch {
            self = .unknown(type: code, json: try rawJSON(decoder))
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

/// How a payin's money was settled to the merchant. Unknown methods parse to `.unknown`.
public enum SettlementMethod: Decodable, Equatable, Sendable {
    /// Payment method for sending funds from your crypto wallet to external crypto wallet. It requires customer to provide a receiving crypto wallet details in format related to chosen blockchain protocol.
    case cryptoTransfer(SettlementCryptoTransferMethod)
    /// A `paymentMethodCode` this SDK version does not know yet, with its JSON (UTF-8); new values are non-breaking API changes.
    case unknown(paymentMethodCode: String, json: Data)

    /// A known paymentMethodCode whose fields don't fit its model also reads as `.unknown`, so a response never fails on them.
    public init(from decoder: Decoder) throws {
        let code = (try? decoder.container(keyedBy: Discriminator.self).decodeIfPresent(String.self, forKey: .paymentMethodCode)) ?? ""
        do {
            switch code {
            case "CRYPTO_TRANSFER": self = .cryptoTransfer(try SettlementCryptoTransferMethod(from: decoder))
            default: self = .unknown(paymentMethodCode: code, json: try rawJSON(decoder))
            }
        } catch {
            self = .unknown(paymentMethodCode: code, json: try rawJSON(decoder))
        }
    }

    private enum Discriminator: String, CodingKey { case paymentMethodCode }

    /// Payment method for sending funds from your crypto wallet to external crypto wallet. It requires customer to provide a receiving crypto wallet details in format related to chosen blockchain protocol.
    public struct SettlementCryptoTransferMethod: Decodable, Equatable, Sendable {
        /// Parameters of a customer's crypto wallet information where your customer would like his funds to be transferred. Always present per spec.
        public let account: SettlementMethod.Account?
        /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
        public let paymentOperatorCode: String?
        /// Reference number of transaction.
        public let transactionReference: String?
    }

    /// The account a settlement is sent to.
    public struct Account: Decodable, Equatable, Sendable {
        /// Address of a customer's crypto wallet where your customer would like his funds to be transferred. min 1, max 62, pattern `^[a-zA-Z0-9]*$`.
        public let accountNumber: String?
    }
}

/// The object being decoded, as JSON text with sorted keys, for `.unknown`.
private func rawJSON(_ decoder: Decoder) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    return try encoder.encode(JSON(from: decoder))
}

private extension Optional where Wrapped == String {
    var nonEmpty: String? { self?.isEmpty == false ? self : nil }
}

private func check(_ ok: Bool, _ message: String) throws {
    if !ok { throw SynqtArgumentError(message) }
}
