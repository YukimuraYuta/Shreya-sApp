import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'dart:async'; // For simulation timers

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _currentStep = 0;

  // Controllers
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  // OTP State
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isLoading = false;

  // Documents State (0=None, 1=Verifying, 2=Verified)
  int _aadharStatus = 0;
  int _panStatus = 0;
  int _dlStatus = 0;

  // Face Scan State
  bool _isFaceScanned = false;
  bool _isScanning = false;
  String _faceScanStatusText = "Tap to Open Camera";

  // --- NAVIGATION LOGIC ---
  void _nextStep() {
    if (_currentStep == 0 && !_isOtpVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please verify OTP first.")));
      return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      if (!_isFaceScanned) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete face registration.")),
        );
        return;
      }

      // ============================================================
      // TODO: BACKEND INTEGRATION - FINAL REGISTRATION
      // Call your Create User API here with all collected data.
      // await AuthService.registerDriver(userData);
      // ============================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful! Welcome to RideFlow."),
          backgroundColor: Color(0xFFFFC107),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  // --- LOGIC: OTP (BACKEND READY) ---

  Future<void> _sendOtp() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // ============================================================
    // TODO: BACKEND INTEGRATION - SEND OTP
    // await AuthService.sendOtp(_phoneController.text);
    // ============================================================

    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP Sent successfully")));
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter full OTP")));
      return;
    }

    setState(() => _isLoading = true);

    // ============================================================
    // TODO: BACKEND INTEGRATION - VERIFY OTP
    // bool isValid = await AuthService.verifyOtp(_otpController.text);
    // if (!isValid) return; // Handle error
    // ============================================================

    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone Verified Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // --- LOGIC: DOC UPLOAD (BACKEND READY) ---

  void _showUploadOptions(String docType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true, // Added to allow dynamic sizing
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          // Add padding for bottom safe area
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            // REMOVED fixed height: 320 to fix overflow
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wraps content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload $docType",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildUploadOption(
                  icon: Icons.folder_open,
                  text: "File Manager",
                  subtext: "Upload PDF or JPEG",
                  onTap: () {
                    Navigator.pop(context);
                    _processDocument(docType, "File");
                  },
                ),
                const SizedBox(height: 16),
                _buildUploadOption(
                  icon: Icons.cloud_download_outlined,
                  text: "DigiLocker",
                  subtext: "Import verified document",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _processDocument(docType, "DigiLocker");
                  },
                ),
                const SizedBox(height: 16),
                _buildUploadOption(
                  icon: Icons.camera_alt_outlined,
                  text: "Camera",
                  subtext: "Take a photo now",
                  onTap: () {
                    Navigator.pop(context);
                    _processDocument(docType, "Camera");
                  },
                ),
                const SizedBox(height: 16), // Extra padding at bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processDocument(String type, String source) async {
    setState(() {
      if (type == 'Aadhar Card') _aadharStatus = 1;
      if (type == 'PAN Card') _panStatus = 1;
      if (type == 'Driving License') _dlStatus = 1;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Processing via $source...")));

    // ============================================================
    // TODO: BACKEND INTEGRATION - DOCUMENT UPLOAD
    // 1. Pick File
    // 2. Upload to Server
    // 3. Verify
    // ============================================================

    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    if (mounted) {
      setState(() {
        if (type == 'Aadhar Card') _aadharStatus = 2;
        if (type == 'PAN Card') _panStatus = 2;
        if (type == 'Driving License') _dlStatus = 2;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$type verification successfully done"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // --- LOGIC: FACE SCAN (BACKEND READY) ---

  Future<void> _openCameraForFace() async {
    setState(() {
      _isScanning = true;
      _faceScanStatusText = "Opening Camera...";
    });

    // ============================================================
    // TODO: BACKEND INTEGRATION - FACE VERIFICATION
    // 1. Capture Face
    // 2. Liveness Check
    // 3. Save Face ID
    // ============================================================

    // Simulating camera initializing
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _faceScanStatusText = "Detecting Face...");

    // Simulating scanning
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isScanning = false;
        _isFaceScanned = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Face ID Registered Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _prevStep,
        ),
        title: Text(
          "Step ${_currentStep + 1} of 3",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                _getStepName(),
                style: const TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildStepContent(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2 ? "Finish" : "Next",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepName() {
    switch (_currentStep) {
      case 0:
        return "Contact";
      case 1:
        return "Documents";
      case 2:
        return "Face ID";
      default:
        return "";
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Contact();
      case 1:
        return _buildStep2Docs();
      case 2:
        return _buildStep3Verify();
      default:
        return const SizedBox();
    }
  }

  // --- STEP 1: CONTACT ---
  Widget _buildStep1Contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Let's start with basics",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your phone number to receive a real-time OTP.",
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 32),

        // PHONE FIELD
        _buildLabel("Phone Number"),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _phoneController,
                hint: "98765 43210",
                icon: Icons.phone_android,
                inputType: TextInputType.phone,
                enabled: !_isOtpVerified,
                prefixText: "+91 ",
              ),
            ),
            const SizedBox(width: 12),
            if (!_isOtpVerified)
              ElevatedButton(
                onPressed: (_isOtpSent || _isLoading) ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Color(0xFFFFC107)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFFC107),
                        ),
                      )
                    : Text(
                        _isOtpSent ? "Resend" : "Get OTP",
                        style: const TextStyle(color: Color(0xFFFFC107)),
                      ),
              )
            else
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
          ],
        ),

        // OTP FIELD
        if (_isOtpSent && !_isOtpVerified) ...[
          const SizedBox(height: 24),
          _buildLabel("Enter OTP Code"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _otpController,
                  hint: "0 0 0 0",
                  icon: Icons.lock_clock,
                  isCenter: true,
                  inputType: TextInputType.number,
                  maxLength: 6,
                  letterSpacing: 8.0,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Verify",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Enter the code sent to your mobile number",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],

        const SizedBox(height: 20),
        const Divider(color: Colors.grey),
        const SizedBox(height: 20),

        _buildLabel("Email Address"),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hint: "driver@rideflow.com",
          icon: Icons.email_outlined,
          inputType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  // --- STEP 2: DOCS ---
  Widget _buildStep2Docs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Document Verification",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select an option to upload your documents.",
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 32),
        _buildDocUploadCard(
          "Aadhar Card",
          _aadharStatus,
          () => _showUploadOptions('Aadhar Card'),
        ),
        const SizedBox(height: 16),
        _buildDocUploadCard(
          "PAN Card",
          _panStatus,
          () => _showUploadOptions('PAN Card'),
        ),
        const SizedBox(height: 16),
        _buildDocUploadCard(
          "Driving License",
          _dlStatus,
          () => _showUploadOptions('Driving License'),
        ),
      ],
    );
  }

  // --- STEP 3: FACE ID ---
  Widget _buildStep3Verify() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Face Registration",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We need to scan your face for identity verification.",
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 60),
        Center(
          child: GestureDetector(
            onTap: _openCameraForFace,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isFaceScanned
                      ? Colors.green
                      : const Color(0xFFFFC107),
                  width: 4,
                ),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    // UPDATED: withOpacity replaced by withValues
                    color: const Color(0xFFFFC107).withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: _isScanning
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _faceScanStatusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : _isFaceScanned
                  ? const Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _faceScanStatusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isCenter = false,
    bool enabled = true,
    TextInputType inputType = TextInputType.text,
    String? prefixText,
    int? maxLength,
    double letterSpacing = 0.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF1E1E1E) : Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        maxLength: maxLength,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.grey,
          letterSpacing: letterSpacing,
          fontSize: letterSpacing > 0 ? 18 : 14,
        ),
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
        cursorColor: const Color(0xFFFFC107),
        inputFormatters:
            inputType == TextInputType.number ||
                inputType == TextInputType.phone
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          prefixText: prefixText,
          prefixStyle: const TextStyle(color: Colors.white, fontSize: 16),
          hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 0),
          prefixIcon: isCenter
              ? null
              : Icon(
                  icon,
                  color: enabled ? Colors.grey[500] : Colors.grey[800],
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDocUploadCard(String title, int status, VoidCallback onTap) {
    Color borderColor = status == 2
        ? Colors.green
        : (status == 1 ? const Color(0xFFFFC107) : Colors.grey[800]!);
    IconData statusIcon = status == 2 ? Icons.check_circle : Icons.upload_file;
    Color iconColor = status == 2 ? Colors.green : Colors.grey;
    String statusText = status == 2
        ? "Verification successfully done"
        : (status == 1 ? "Verifying..." : "Tap to upload");

    return InkWell(
      onTap: status == 1 || status == 2 ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description, color: Colors.grey[400]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: status == 2
                          ? Colors.green
                          : (status == 1
                                ? const Color(0xFFFFC107)
                                : Colors.grey),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (status == 1)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFFC107),
                ),
              )
            else
              Icon(statusIcon, color: iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String text,
    required String subtext,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(12),
          // UPDATED: withOpacity replaced by withValues
          color: Colors.black.withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFFFFC107)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtext,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
