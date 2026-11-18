/// One entry per direct API payment method a payer can fill in, shown by `Payin.presentPaymentSheet`.
let methodForms: [MethodForm] = [
    MethodForm("ABSA_PAY", "synqt_absa_pay", [
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("passportNumber", "synqt_passport_number", .text, required: false, hint: "synqt_a_letter_followed_by_numbers", minLength: 8, maxLength: 9, pattern: #"^[a-zA-Z][0-9]+$"#, invalid: "synqt_enter_a_letter_followed_by_7_or_8_numbers"),
        FormField("said", "synqt_south_african_id_number", .number, required: false, hint: "synqt_13_digits", minLength: 13, maxLength: 13, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_13_digits"),
        FormField("account.accountNumber", "synqt_account_number", .text, required: false),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ], oneOfs: [OneOf("synqt_how_do_you_want_to_confirm_it_s_you", [Choice("synqt_bank_account", ["account.accountNumber", "account.accountName"]), Choice("synqt_south_african_id_number", ["said"]), Choice("synqt_passport_number", ["passportNumber"])])]) { values in
        try .absaPay(PaymentMethod.AbsaPay(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress"),
            passportNumber: values.str("passportNumber"),
            said: values.str("said"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.str("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            )
        ))
    },
    MethodForm("CAPITEC_PAY", "synqt_capitec_pay", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: false, placeholder: "synqt_0821234567", maxLength: 12, pattern: #"^0"#, invalid: "synqt_enter_up_to_12_characters_starting_with_0"),
        FormField("said", "synqt_south_african_id_number", .number, required: false, hint: "synqt_13_digits", minLength: 13, maxLength: 13, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_13_digits"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number", .number, required: false, placeholder: "synqt_10_digits", minLength: 10, maxLength: 10, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_10_digits"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ], oneOfs: [OneOf("synqt_how_do_you_want_to_confirm_it_s_you", [Choice("synqt_bank_account", ["account.accountNumber", "account.accountName"]), Choice("synqt_mobile_number", ["phoneNumber"]), Choice("synqt_south_african_id_number", ["said"])])]) { values in
        try .capitecPay(PaymentMethod.CapitecPay(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber"),
            said: values.str("said"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.str("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            ),
            paymentOperatorCode: values.str("paymentOperatorCode")
        ))
    },
    MethodForm("CODE_PAYMENT", "synqt_payment_code", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: true, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("paymentLocation.postalCode", "synqt_postal_code", .text, required: true, section: "synqt_where_you_are_paying"),
        FormField("paymentLocation.city", "synqt_city", .text, required: true, section: "synqt_where_you_are_paying"),
        FormField("paymentLocation.district", "synqt_district", .text, required: true, section: "synqt_where_you_are_paying"),
    ]) { values in
        try .codePayment(PaymentMethod.CodePayment(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.req("emailAddress"),
            phoneNumber: values.req("phoneNumber"),
            paymentLocation: PaymentMethod.PaymentLocation(
                postalCode: values.req("paymentLocation.postalCode"),
                city: values.req("paymentLocation.city"),
                district: values.req("paymentLocation.district")
            ),
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            )
        ))
    },
    MethodForm("CRYPTO_OFFLINE", "synqt_crypto", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
    ]) { values in
        try .cryptoOffline(PaymentMethod.CryptoOffline(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("DUITNOW", "synqt_duitnow", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account"),
    ]) { values in
        try .duitNow(PaymentMethod.DuitNow(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName"),
                accountNumber: values.str("account.accountNumber")
            ),
            paymentOperatorCode: values.str("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("EWALLET", "synqt_e_wallet", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .eWallet(PaymentMethod.EWallet(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName")
                )
            },
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber")
        ))
    },
    MethodForm("FNB_DIRECT_EFT", "synqt_fnb_pay", [
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("passportNumber", "synqt_passport_number", .text, required: false, hint: "synqt_a_letter_followed_by_numbers", minLength: 8, maxLength: 9, pattern: #"^[a-zA-Z][0-9]+$"#, invalid: "synqt_enter_a_letter_followed_by_7_or_8_numbers"),
        FormField("said", "synqt_south_african_id_number", .number, required: false, hint: "synqt_13_digits", minLength: 13, maxLength: 13, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_13_digits"),
        FormField("customerName.firstName", "synqt_first_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("account.accountNumber", "synqt_account_number", .text, required: true, section: "synqt_bank_account"),
    ], oneOfs: [OneOf("synqt_how_do_you_want_to_confirm_it_s_you", [Choice("synqt_south_african_id_number", ["said"]), Choice("synqt_passport_number", ["passportNumber"])])]) { values in
        try .fnbDirectEFT(PaymentMethod.FnbDirectEFT(
            customerName: PaymentMethod.PersonName(
                firstName: values.req("customerName.firstName"),
                lastName: values.req("customerName.lastName")
            ),
            emailAddress: values.req("emailAddress"),
            account: PaymentMethod.Account(
                accountNumber: values.req("account.accountNumber")
            ),
            passportNumber: values.str("passportNumber"),
            said: values.str("said")
        ))
    },
    MethodForm("FPX", "synqt_fpx_online_banking", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountType", "synqt_account_type", .choice, required: true, section: "synqt_bank_account", options: [("savings", "synqt_savings"), ("current", "synqt_current"), ("corporate", "synqt_corporate")]),
    ]) { values in
        try .fpx(PaymentMethod.Fpx(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName"),
                accountType: values.req("account.accountType")
            ),
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("IMPS", "synqt_imps_bank_transfer", [
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account"),
    ]) { values in
        try .imps(PaymentMethod.IMPS(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName"),
                accountNumber: values.str("account.accountNumber")
            ),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("MOBILE_MONEY", "synqt_mobile_money", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: true, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .mobileMoney(PaymentMethod.MobileMoney(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            ),
            phoneNumber: values.req("phoneNumber"),
            paymentOperatorCode: values.str("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("MOMOPAY", "synqt_momopay", [
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
    ]) { values in
        .momoPay(PaymentMethod.MomoPay(
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("NEDBANK_DIRECT_EFT", "synqt_nedbank_pay", [
        FormField("said", "synqt_south_african_id_number", .number, required: true, hint: "synqt_13_digits", minLength: 13, maxLength: 13, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_13_digits"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ]) { values in
        try .nedbankDirectEFT(PaymentMethod.NedbankDirectEFT(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            ),
            said: values.req("said"),
            emailAddress: values.str("emailAddress"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.str("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            )
        ))
    },
    MethodForm("NETBANKING", "synqt_net_banking", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
    ]) { values in
        .netBanking(PaymentMethod.NetBanking(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber"),
            paymentOperatorCode: values.str("paymentOperatorCode")
        ))
    },
    MethodForm("OFFLINE", "synqt_pay_offline", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("productId", "synqt_product_reference_optional", .text, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#),
        FormField("taxId", "synqt_tax_number_optional", .text, required: false, hint: "synqt_8_to_18_characters", minLength: 8, maxLength: 18, invalid: "synqt_enter_8_to_18_characters"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ]) { values in
        try .offline(PaymentMethod.Offline(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber"),
            productId: values.str("productId"),
            taxId: values.str("taxId"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.req("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            )
        ))
    },
    MethodForm("ONLINE", "synqt_online_banking", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number", .text, required: true, section: "synqt_bank_account"),
        FormField("account.accountType", "synqt_account_type", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .online(PaymentMethod.Online(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName"),
                accountNumber: values.req("account.accountNumber"),
                accountType: values.req("account.accountType")
            ),
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.req("emailAddress")
        ))
    },
    MethodForm("OTT_VOUCHER", "synqt_ott_voucher", [
        FormField("voucherPin", "synqt_voucher_pin", .text, required: true, hint: "synqt_the_12_digit_pin_on_your_voucher"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: true, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ]) { values in
        try .ottVoucher(PaymentMethod.OttVoucher(
            voucherPin: values.req("voucherPin"),
            phoneNumber: values.req("phoneNumber"),
            emailAddress: values.req("emailAddress"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.req("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            )
        ))
    },
    MethodForm("P2A_V2", "synqt_bank_transfer", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
    ]) { values in
        try .p2AV2(PaymentMethod.P2AV2(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("PAYSHAP", "synqt_payshap", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: false, placeholder: "synqt_0821234567", maxLength: 12, pattern: #"^0"#, invalid: "synqt_enter_up_to_12_characters_starting_with_0"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("passportNumber", "synqt_passport_number_optional", .text, required: false, hint: "synqt_a_letter_followed_by_numbers", minLength: 8, maxLength: 9, pattern: #"^[a-zA-Z][0-9]+$"#, invalid: "synqt_enter_a_letter_followed_by_7_or_8_numbers"),
        FormField("said", "synqt_south_african_id_number_optional", .number, required: false, hint: "synqt_13_digits", minLength: 13, maxLength: 13, pattern: #"^[0-9]*$"#, invalid: "synqt_enter_13_digits"),
        FormField("externalProviderCode", "synqt_provider", .provider, required: false),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: false, maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number", .number, required: false, hint: "synqt_numbers_only", pattern: #"^[0-9]*$"#, invalid: "synqt_use_numbers_only"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ], oneOfs: [OneOf("synqt_how_do_you_want_to_pay", [Choice("synqt_bank_account", ["account.accountNumber", "account.accountName"], required: ["account.accountNumber", "account.accountName"]), Choice("synqt_mobile_number", ["phoneNumber", "externalProviderCode"], required: ["phoneNumber", "externalProviderCode"])]), OneOf("synqt_which_id_do_you_want_to_give", [Choice("synqt_south_african_id_number", ["said"], required: []), Choice("synqt_passport_number", ["passportNumber"], required: [])])]) { values in
        try .payShap(PaymentMethod.PayShap(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            phoneNumber: values.str("phoneNumber"),
            emailAddress: values.str("emailAddress"),
            passportNumber: values.str("passportNumber"),
            said: values.str("said"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.str("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            ),
            externalProviderCode: values.str("externalProviderCode")
        ))
    },
    MethodForm("PAY_ME", "synqt_payme", [
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account"),
    ]) { values in
        try .payMe(PaymentMethod.PayMe(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName"),
                accountNumber: values.str("account.accountNumber")
            ),
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber")
        ))
    },
    MethodForm("PIXQR", "synqt_pix", [
        FormField("taxId", "synqt_cpf_or_cnpj", .text, required: true, hint: "synqt_14_characters", minLength: 14, maxLength: 14, invalid: "synqt_enter_your_14_character_cpf_or_cnpj"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .pixQR(PaymentMethod.PixQR(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            ),
            taxId: values.req("taxId")
        ))
    },
    MethodForm("PROMPTPAY", "synqt_promptpay", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number", .text, required: true, section: "synqt_bank_account"),
    ]) { values in
        try .promptPay(PaymentMethod.PromptPay(
            account: PaymentMethod.Account(
                accountName: values.str("account.accountName"),
                accountNumber: values.req("account.accountNumber")
            ),
            paymentOperatorCode: values.str("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("PSE", "synqt_pse", [
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: true, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .pse(PaymentMethod.Pse(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            ),
            emailAddress: values.req("emailAddress"),
            phoneNumber: values.req("phoneNumber")
        ))
    },
    MethodForm("QRISPAY", "synqt_qris", [
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
    ]) { values in
        .qrisPay(PaymentMethod.QrisPay(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("QRPH", "synqt_qr_ph", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
    ]) { values in
        .qrPh(PaymentMethod.QrPh(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            emailAddress: values.str("emailAddress"),
            paymentOperatorCode: values.str("paymentOperatorCode"),
            phoneNumber: values.str("phoneNumber")
        ))
    },
    MethodForm("SNAPSCAN_QR", "synqt_snapscan", [
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("customerName.titleBefore", "synqt_title_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.firstName", "synqt_first_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.middleName", "synqt_middle_name_optional", .text, required: false, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.titleAfter", "synqt_name_suffix_optional", .text, required: false, section: "synqt_your_name"),
    ]) { values in
        try .snapScanQr(PaymentMethod.SnapScanQr(
            emailAddress: values.req("emailAddress"),
            customerName: PaymentMethod.PersonName(
                titleBefore: values.str("customerName.titleBefore"),
                firstName: values.req("customerName.firstName"),
                middleName: values.str("customerName.middleName"),
                lastName: values.req("customerName.lastName"),
                titleAfter: values.str("customerName.titleAfter")
            )
        ))
    },
    MethodForm("UPICOLLECT", "synqt_upi", [
        FormField("upiId", "synqt_upi_id", .text, required: true, placeholder: "synqt_name_bank", maxLength: 100, pattern: #"[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+"#, invalid: "synqt_enter_a_upi_id_like_name_bank"),
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number", .phone, required: true, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name", .text, required: true, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        try .upiCollect(PaymentMethod.UpiCollect(
            account: PaymentMethod.Account(
                accountName: values.req("account.accountName")
            ),
            upiId: values.req("upiId"),
            emailAddress: values.req("emailAddress"),
            phoneNumber: values.req("phoneNumber")
        ))
    },
    MethodForm("UPIID", "synqt_upi_id", [
        FormField("upiId", "synqt_upi_id", .text, required: true, placeholder: "synqt_name_bank", maxLength: 100, pattern: #"[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+"#, invalid: "synqt_enter_a_upi_id_like_name_bank"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
    ]) { values in
        try .upiId(PaymentMethod.UpiId(
            upiId: values.req("upiId"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("UPIQR", "synqt_upi_qr", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("upiId", "synqt_upi_id_optional", .text, required: false, placeholder: "synqt_name_bank", maxLength: 100, pattern: #"[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\.]+"#, invalid: "synqt_enter_a_upi_id_like_name_bank"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
    ]) { values in
        .upiQR(PaymentMethod.UpiQR(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName")
                )
            },
            upiId: values.str("upiId"),
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber"),
            paymentOperatorCode: values.str("paymentOperatorCode")
        ))
    },
    MethodForm("VAPAY", "synqt_virtual_account", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider_optional", .operator, required: false, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("phoneNumber", "synqt_mobile_number_optional", .phone, required: false, placeholder: "synqt_27821234567", minLength: 7, maxLength: 16, pattern: #"^\+?[0-9]+$"#, invalid: "synqt_enter_the_number_with_your_country_code_and_no_s"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account_optional", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number_optional", .text, required: false, section: "synqt_bank_account_optional"),
        FormField("paymentLocation.postalCode", "synqt_postal_code", .text, required: true, section: "synqt_where_you_are_paying"),
        FormField("paymentLocation.city", "synqt_city", .text, required: true, section: "synqt_where_you_are_paying"),
        FormField("paymentLocation.district", "synqt_district", .text, required: true, section: "synqt_where_you_are_paying"),
    ]) { values in
        try .vaPay(PaymentMethod.VaPay(
            account: values.group("account") {
                PaymentMethod.Account(
                    accountName: values.str("account.accountName"),
                    accountNumber: values.str("account.accountNumber")
                )
            },
            paymentOperatorCode: values.str("paymentOperatorCode"),
            emailAddress: values.str("emailAddress"),
            phoneNumber: values.str("phoneNumber"),
            paymentLocation: PaymentMethod.PaymentLocation(
                postalCode: values.req("paymentLocation.postalCode"),
                city: values.req("paymentLocation.city"),
                district: values.req("paymentLocation.district")
            )
        ))
    },
    MethodForm("VAPAY_VERIF", "synqt_verified_virtual_account", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
        FormField("account.accountName", "synqt_account_holder_name_optional", .text, required: false, section: "synqt_bank_account", maxLength: 64, pattern: #"^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$"#, invalid: "synqt_use_letters_numbers_spaces_and_common_punctuatio"),
        FormField("account.accountNumber", "synqt_account_number", .number, required: true, hint: "synqt_numbers_only", section: "synqt_bank_account", pattern: #"^[0-9-]*$"#, invalid: "synqt_use_numbers_only"),
    ]) { values in
        try .vaPayVerif(PaymentMethod.VaPayVerif(
            account: PaymentMethod.Account(
                accountName: values.str("account.accountName"),
                accountNumber: values.req("account.accountNumber")
            ),
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("VIETQR", "synqt_vietqr", [
        FormField("paymentOperatorCode", "synqt_bank_or_provider", .operator, required: true, maxLength: 30, pattern: #"^[A-Za-z0-9_-]+$"#, invalid: "synqt_use_letters_numbers_and_only"),
        FormField("emailAddress", "synqt_email_address_optional", .email, required: false, invalid: "synqt_enter_a_valid_email_address"),
    ]) { values in
        try .vietQR(PaymentMethod.VietQR(
            paymentOperatorCode: values.req("paymentOperatorCode"),
            emailAddress: values.str("emailAddress")
        ))
    },
    MethodForm("ZAPPER_QR", "synqt_zapper", [
        FormField("emailAddress", "synqt_email_address", .email, required: true, invalid: "synqt_enter_a_valid_email_address"),
        FormField("customerName.firstName", "synqt_first_name", .text, required: true, section: "synqt_your_name"),
        FormField("customerName.lastName", "synqt_last_name", .text, required: true, section: "synqt_your_name"),
    ]) { values in
        try .zapperQr(PaymentMethod.ZapperQr(
            emailAddress: values.req("emailAddress"),
            customerName: PaymentMethod.PersonName(
                firstName: values.req("customerName.firstName"),
                lastName: values.req("customerName.lastName")
            )
        ))
    },
]

/// Payer-facing text (a string key) for each of SYNQT's failure reason codes, whose own descriptions are written for the merchant.
let failureMessages: [String: String] = [
    "SYSTEM": "synqt_failure_payment_process_error",
    "PAYMENT_PROCESS_ERROR": "synqt_failure_payment_process_error",
    "PAYMENT_METHOD_ERROR": "synqt_failure_payment_process_error",
    "ENTITY_EXPIRED": "synqt_failure_expired",
    "CUSTOMER_VERIFICATION_INACTIVITY": "synqt_failure_expired",
    "DIFFERENT_AMOUNT_CONFIRMED": "synqt_failure_amount_mismatch",
    "INCORRECT_CURRENCY": "synqt_failure_amount_mismatch",
    "CURRENCY_NOT_SUPPORTED": "synqt_failure_method_unavailable",
    "CURRENCY_PRECISION_EXCEEDED": "synqt_failure_method_unavailable",
    "PAYMENT_METHOD_NOT_FOUND": "synqt_failure_method_unavailable",
    "PAYMENT_CHANNEL_NO_ACTIVE_FOUND": "synqt_failure_method_unavailable",
    "PAYMENT_CHANNEL_NO_OPENED_FOUND": "synqt_failure_method_unavailable",
    "PAYMENT_CHANNEL_NO_SEGMENT_FOUND": "synqt_failure_method_unavailable",
    "PAYMENT_CHANNEL_AMOUNT_LIMITS": "synqt_failure_method_unavailable",
    "PAYMENT_CHANNEL_DAILY_LIMITS": "synqt_failure_method_unavailable",
    "PAYMENT_OPERATOR_NOT_FOUND": "synqt_failure_bank_unavailable",
    "PAYMENT_OPERATOR_INVALID": "synqt_failure_bank_unavailable",
    "PAYMENT_OPERATOR_UNAVAILABLE": "synqt_failure_bank_unavailable",
    "IP_DENIED": "synqt_failure_security",
    "SECURITY_CHECK_FAILED": "synqt_failure_security",
    "BALANCE_INSUFFICIENT": "synqt_failure_balance",
    "INVALID_ACCOUNT_NUMBER": "synqt_failure_account_number",
    "INVALID_ACCOUNT_NAME": "synqt_failure_account_name",
    "NAME_SIMILARITY_CHECK_FAILED": "synqt_failure_account_name",
    "INVALID_PHONE_NUMBER": "synqt_failure_phone_number",
    "INVALID_ID_NUMBER": "synqt_failure_id_number",
    "INVALID_IFSC": "synqt_failure_ifsc",
    "CUSTOMER_VERIFICATION_REJECTED": "synqt_failure_declined",
    "CUSTOMER_VERIFICATION_FAILED": "synqt_failure_not_verified",
    "ACCOUNT_TYPE_INELIGIBLE": "synqt_failure_account_ineligible",
    "FEATURE_UNAVAILABLE": "synqt_failure_feature_unavailable",
    "CUSTOMER_ACCOUNT_LIMIT_EXCEEDED": "synqt_failure_account_limit",
    "CUSTOMER_NOT_REGISTERED": "synqt_failure_not_registered",
    "VOUCHER_INELIGIBLE": "synqt_failure_voucher",
]
