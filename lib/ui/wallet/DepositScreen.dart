import 'package:flexx_bet/ui/wallet/widget/payment_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../constants/images.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  int _selectedOption = 0;
  double nairaRate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Deposit',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(48),
        child: Column(
          children: [
            _buildOption(
              icon: ImageConstant.flutterWave,
              title: 'Flutterwave',
              subtitle: 'Naira (NGN) ₦',
              isSelected: _selectedOption == 0,
              index: 0,
            ),
            _buildOption(
              icon: ImageConstant.coinbase,
              title: 'Coinbase',
              subtitle: 'Select a token',
              isSelected: _selectedOption == 1,
              index: 1,
            ),
            _buildOption(
              icon: ImageConstant.payStack,
              title: 'Paystack',
              subtitle: 'Coming soon',
              isSelected: _selectedOption == 2,
              index: 2,
              isSelectable: false,
            ),
            _buildOption(
              icon: ImageConstant.mastercard,
              title: 'Card',
              subtitle: 'Coming soon',
              isSelected: _selectedOption == 3,
              index: 3,
              isSelectable: false,
            ),
            SizedBox(height: 40,),
            ElevatedButton(

              onPressed: () async {
                if(_selectedOption==0 || _selectedOption==1){
                  await paymentBottomSheet(_selectedOption);
                }
                else{
                  print("Coming Soon");
                }

              },

              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40), backgroundColor: Color(0xFF7643FF),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),

              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required int index,
    bool isSelectable = true, // New flag to control if the option is selectable
  }) {
    return GestureDetector(
      onTap: () {
        if (isSelectable) { // Only allow selection if the option is selectable
          setState(() {
            _selectedOption = index;
          });
        }
      },
      child: Container(
        width: 327,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected && isSelectable ? Border.all(color: Colors.purple, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(icon, height: 40, width: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected && isSelectable ? Colors.purple : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected && isSelectable ? Colors.purple : Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            // Conditionally display the selection icon only if the option is selectable
            if (isSelectable)
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Color(0xFF7643FF) : Colors.grey,
              )
            else
              SizedBox(width: 24), // Placeholder to maintain alignment
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DepositScreen(),
  ));
}
