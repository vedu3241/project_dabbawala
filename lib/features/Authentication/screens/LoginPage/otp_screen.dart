import 'package:dabbawala/features/authentication/controllers/login_api_service.dart';
import 'package:dabbawala/features/dab_nav_screen.dart';
import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key, required this.mobileNo});

  String mobileNo;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final LoginApiService _loginApiService = LoginApiService();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitOtp() async {
    if (_formKey.currentState!.validate()) {
      String otp = '';
      for (var controller in _otpControllers) {
        otp += controller.text;
      }

      if (otp.isEmpty) {
        THelperFunctions.showSnackBar("Please Enter OTP");
        return; // Exit the method if either field is empty
      }

      bool isSuccess = await _loginApiService.verifyOtp(otp);

      if (isSuccess) {
        // Navigate to the OTP screen!
        Get.to(DabAnimatedNavBar());
        THelperFunctions.showSnackBar("Login successful");
      } else {
        // Show error message if login failed
        THelperFunctions.showSnackBar("Login failed");
      }

      // Handle OTP verification here
      print('Submitted OTP: $otp');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verifying OTP: $otp')),
      );
    }
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'We just sent an SMS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the security code we sent to ${widget.mobileNo}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle resend OTP logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resending OTP')),
                    );
                  },
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
