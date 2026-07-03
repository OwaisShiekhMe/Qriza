import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qriza/reusable_component/app_scaffold.dart';
import 'package:qriza/reusable_component/custom_input.dart';
import 'package:qriza/reusable_component/drop_down_field.dart';
import 'package:qriza/reusable_component/custom_button.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late double screenWidth;
  late double screenHeight;
  late TextScaler textScaler;
  String selectedPaymentMethod = "bank";
  String selectedBank = "Bank Al Habib";
  TextEditingController bankAccountTitleController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController miniWalletController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    textScaler = MediaQuery.of(context).textScaler;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Image.asset(
          'images/logo.png',
          width: screenWidth * 0.3,
          height: screenHeight * 0.1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            stepCount(),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Payment Setup',
              style: TextStyle(
                fontSize: textScaler.scale(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: Text(
                'Choose how you want to receive your payments.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontSize: textScaler.scale(16),
                    color: Color(0xff424656),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              height: screenHeight * 0.18,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  paymentOption("bank", "Bank Account", Icons.account_balance),
                  SizedBox(width: screenWidth * 0.05),
                  paymentOption(
                    "easypaisa",
                    "EasyPaisa",
                    Icons.account_balance_wallet,
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  paymentOption("jazzcash", "JazzCash", Icons.money),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            paymentForm(),
            SizedBox(height: screenHeight * 0.05),
            infoCard(),
            SizedBox(height: screenHeight * 0.05),
            CustomButton(label: 'Create Account', onTap: () {}),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget infoCard() {
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffF2F4F6),
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xff424656),
            size: screenHeight * 0.04,
          ),
          SizedBox(width: screenWidth * 0.02),
          SizedBox(
            width: screenWidth * 0.7,
            height: screenHeight * 0.08,
            child: Text(
              'Your payment details can be updated anytime. Your QR code will continue to work even after updating your information.',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontSize: textScaler.scale(12),
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stepCount() {
    return Container(
      height: screenHeight * 0.05,
      width: screenWidth * 0.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.08),
        color: Color(0xff60F8CB),
      ),
      child: Text(
        "Step 2 of 2",
        style: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(
            fontSize: textScaler.scale(14),
            color: Color(0xff007057),
          ),
        ),
      ),
    );
  }

  Widget paymentOption(String label, String title, IconData iconName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = label;
        });
      },
      child: Container(
        height: screenHeight * 0.18,
        width: screenWidth * 0.5,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color:
              selectedPaymentMethod == label
                  ? Color(0xff0066FF).withAlpha(13)
                  : Colors.white,
          border: Border.all(
            color:
                selectedPaymentMethod == label
                    ? Color(0xff0066FF)
                    : Color(0xffC2C6D8),
            width: selectedPaymentMethod == label ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              height: screenHeight * 0.06,
              width: screenHeight * 0.06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    selectedPaymentMethod == label
                        ? Color(0xff0050CB).withAlpha(26)
                        : Color(0xffECEEF0),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Icon(
                iconName,
                size: screenHeight * 0.04,
                color:
                    selectedPaymentMethod == label
                        ? Color(0xff0050CB)
                        : Color(0xff424656),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontSize: textScaler.scale(16),
                  fontWeight: FontWeight.bold,
                  color:
                      selectedPaymentMethod == label
                          ? Color(0xff0050CB)
                          : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentForm() {
    if (selectedPaymentMethod == "bank") {
      return Form(
        key: formkey,
        child: Column(
          children: [
            Dropdownfield(
              label: "Select Bank",
              options: [
                "Bank Al Habib",
                "Habib Metropolitan Bank",
                "MCB Bank",
                "United Bank Limited",
                "Allied Bank",
                "Bank of Punjab",
                "Bank Alfalah",
                "Meezan Bank",
                "Faysal Bank",
              ],
              prefixIcon: Icons.account_balance,
              onChanged: (value) {
                setState(() {
                  selectedBank = value!;
                });
              },
              initialValue: selectedBank,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomInput(
              label: "Bank Account Title",
              controller: bankAccountTitleController,
              hint: "Enter your bank account title",
              prefixIcon: Icons.person,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomInput(
              label: "Bank Account Number",
              controller: bankAccountNumberController,
              hint: "Enter your bank account number",
              prefixIcon: Icons.onetwothree_outlined,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomInput(
              label: "IBAN (Optional)",
              controller: ibanController,
              hint: "PK00 HABB 0123...",
              prefixIcon: Icons.public,
            ),
          ],
        ),
      );
    } else {
      return CustomInput(
        label:
            selectedPaymentMethod == "easypaisa"
                ? "EasyPaisa Number"
                : "JazzCash Number",
        controller: miniWalletController,
        hint:
            selectedPaymentMethod == "easypaisa"
                ? "Enter your EasyPaisa number"
                : "Enter your JazzCash number",
      );
    }
  }
}
