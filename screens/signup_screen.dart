import 'package:flutter/material.dart';
import 'success_screen.dart';

// Mock service. Does not call a live AI model.
class SignupTipService {
  bool simulateFailure = false;

  Future<Map<String, String>> getTip(
    Map<String, String> request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (simulateFailure) {
      throw Exception('Mock service unavailable');
    }

    if (request['task'] != 'signup_tip' ||
        request['topic'] != 'password_help') {
      throw Exception('Invalid request');
    }

    return {
      'tip': 'Use a unique password that is easy for you to remember.',
    };
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();

  final _tipService = SignupTipService();

  static const _hotPink = Color(0xFFFF1493);
  static const _deepPurple = Color(0xFF321044);

  bool _isLoadingTip = false;
  String _tip = '';
  String _tipError = '';

  bool _obscurePassword = true;
  bool _submitting = false;
  DateTime? _birthDate;

  Future<void> _getSignupTip() async {
    setState(() {
      _isLoadingTip = true;
      _tip = '';
      _tipError = '';
    });

    try {
      // Only fixed labels are sent, never the form values.
      final request = {
        'task': 'signup_tip',
        'topic': 'password_help',
      };

      final response = await _tipService
          .getTip(request)
          .timeout(const Duration(seconds: 10));

      final result = response['tip']?.trim() ?? '';

      if (result.isEmpty) {
        throw Exception('Empty tip');
      }

      if (!mounted) return;

      setState(() {
        _tip = result.length > 240 ? result.substring(0, 240) : result;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _tipError = 'Could not get a tip. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTip = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userName = _nameController.text.trim();

    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: userName),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.purple),
      filled: true,
      fillColor: const Color(0xFFFFF4FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8B6DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _hotPink, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _deepPurple,
      appBar: AppBar(
        title: const Text('The Pink Haunted Mansion'),
        backgroundColor: _deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _deepPurple,
              Color(0xFF701B78),
              Color(0xFFB52B79),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const Text(
                      '👻 🕯️',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You’ve been invited…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The ghosts saved a room just for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFD5EB),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      color: Colors.white,
                      elevation: 8,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Sign the Cursed Guest Book',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: _deepPurple,
                                ),
                              ),
                              const SizedBox(height: 24),

                              TextFormField(
                                controller: _nameController,
                                decoration: _fieldDecoration(
                                  'Full Name',
                                  Icons.person,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _fieldDecoration(
                                  'Email Address',
                                  Icons.email,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: _fieldDecoration(
                                  'Password',
                                  Icons.lock,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                    color: Colors.purple,
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                            !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _dateController,
                                readOnly: true,
                                decoration: _fieldDecoration(
                                  'Birth Date',
                                  Icons.cake,
                                ),
                                validator: (_) => _birthDate == null
                                    ? 'Pick your birth date'
                                    : null,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _birthDate ?? DateTime(2008),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime.now(),
                                  );

                                  if (!mounted) return;

                                  if (picked != null) {
                                    setState(() {
                                      _birthDate = picked;
                                      _dateController.text =
                                          '${picked.month}/${picked.day}/${picked.year}';
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 24),

                              ElevatedButton(
                                onPressed:
                                    _submitting ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _hotPink,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                                child: _submitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: _deepPurple,
                                        ),
                                      )
                                    : const Text(
                                        'Claim Your Haunted Room',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                              ),
                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 12),

                              const Text(
                                'Ghostly Signup Coach 👻',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: _deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Mock advice — no live AI model is being called.',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),

                              OutlinedButton(
                                onPressed: _isLoadingTip
                                    ? null
                                    : _getSignupTip,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.purple,
                                ),
                                child: Text(
                                  _tipError.isNotEmpty
                                      ? 'Try again'
                                      : 'Get a signup tip',
                                ),
                              ),

                              if (_isLoadingTip) ...[
                                const SizedBox(height: 12),
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: _hotPink,
                                  ),
                                ),
                              ],

                              if (_tip.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Preset demo tip: $_tip',
                                  style: const TextStyle(
                                    color: _deepPurple,
                                  ),
                                ),
                              ],

                              if (_tipError.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _tipError,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Check in… if you dare. The ghosts are waiting.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}