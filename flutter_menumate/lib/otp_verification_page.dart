import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userData;

  const OTPVerificationPage({
    super.key, 
    required this.email, 
    required this.userData,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  
  bool isLoading = false;
  bool canResend = false;
  int countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      canResend = false;
      countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        setState(() => canResend = true);
        timer.cancel();
      }
    });
  }

  String getOTPCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP() async {
    final String otpCode = getOTPCode();
    
    if (otpCode.length != 4) {
      _showSnackBar('Please enter the complete 4-digit OTP');
      return;
    }

    setState(() => isLoading = true);

    try {
      // First verify the OTP
      final otpVerified = await _verifyOTPCode(otpCode);
      
      if (otpVerified) {
        // If OTP is verified, now register the user
        final registrationSuccess = await _registerUser();
        
        if (registrationSuccess) {
          _showSnackBar('Registration completed successfully!');
          
          // Wait a moment to show success message, then navigate to login
          await Future.delayed(const Duration(seconds: 1));
          
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
          
          // Show success dialog
          _showSuccessDialog();
        }
      }
    } catch (e) {
      _showSnackBar('Network error. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> _verifyOTPCode(String otpCode) async {
    final Uri url = Uri.parse('http://10.0.2.2:8000/verify_otp/${widget.email}/$otpCode');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Invalid OTP');
        _clearOTP();
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _registerUser() async {
    final Uri url = Uri.parse('http://10.0.2.2:8000/user/register/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.userData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> resendOTP() async {
    setState(() => isLoading = true);

    final Uri url = Uri.parse('http://10.0.2.2:8000/generate_otp/${widget.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _showSnackBar('New OTP sent to your email');
        startCountdown();
        _clearOTP();
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _showSnackBar('Network error. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Complete!'),
          content: const Text('Your email has been verified and account created successfully. You can now login to MenuMate.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget buildOTPField(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade800, width: 2),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next field
            if (index < 3) {
              focusNodes[index + 1].requestFocus();
            } else {
              focusNodes[index].unfocus();
            }
          } else {
            // Move to previous field if current is empty and backspace is pressed
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
        },
        onTap: () {
          // Clear field when tapped
          otpControllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: otpControllers[index].value.text.length,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
        title: const Text(
          'Verify Email',
          style: appBarTextStyle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email_outlined,
                  size: 80,
                  color: Colors.green[800],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Verify Your Email',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  'We sent a 4-digit code to',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => buildOTPField(index)),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify Email',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                if (!canResend)
                  Text(
                    'Resend code in $countdown seconds',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  TextButton(
                    onPressed: isLoading ? null : resendOTP,
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to Registration',
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}