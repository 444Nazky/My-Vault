import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _pin = ['', '', '', '', '', ''];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo & Title
              _buildHeader(),
              
              const SizedBox(height: 48),
              
              // PIN Display
              _buildPinDisplay(),
              
              const SizedBox(height: 32),
              
              // Error message
              if (_error != null) _buildError(),
              
              const SizedBox(height: 24),
              
              // Number Pad
              _buildNumberPad(),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(AppConstants.primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.local_shipping,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appDescription,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = _pin[index].isNotEmpty;
        final isCurrent = index == _currentIndex;
        
        return Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isCurrent
                  ? Color(AppConstants.primaryColor)
                  : isFilled
                      ? Color(AppConstants.successColor)
                      : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isFilled
                ? const Icon(
                    Icons.circle,
                    size: 24,
                    color: Colors.black87,
                  )
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(AppConstants.errorColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(AppConstants.errorColor),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                color: Color(AppConstants.errorColor),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 4: empty, 0, backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            _buildNumberButton('0'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 80,
      height: 64,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _onNumberTap(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return SizedBox(
      width: 80,
      height: 64,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onBackspace,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Icon(
          Icons.backspace_outlined,
          size: 24,
        ),
      ),
    );
  }

  void _onNumberTap(String number) {
    if (_currentIndex >= 6) return;

    setState(() {
      _pin[_currentIndex] = number;
      _currentIndex++;
      _error = null;
    });

    // Jika PIN sudah lengkap
    if (_currentIndex == 6) {
      _onPinComplete();
    }
  }

  void _onBackspace() {
    if (_currentIndex == 0) return;

    setState(() {
      _currentIndex--;
      _pin[_currentIndex] = '';
      _error = null;
    });
  }

  Future<void> _onPinComplete() async {
    final pin = _pin.join();
    
    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(pin);

    if (success) {
      // Navigasi ke home screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _isLoading = false;
        _error = authProvider.error ?? 'Login gagal';
        _pin.fillRange(0, 6, '');
        _currentIndex = 0;
      });
    }
  }
}