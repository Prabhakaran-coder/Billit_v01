import 'dart:math';
import 'dart:ui';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/main.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillitAuthPage extends StatefulWidget {
  const BillitAuthPage({super.key});

  @override
  State<BillitAuthPage> createState() => _BillitAuthPageState();
}

class _BillitAuthPageState extends State<BillitAuthPage>
    with TickerProviderStateMixin {
  late AnimationController _bgController; // floating circles
  late AnimationController _billController; // bill printing
  bool isLogin = true;
  bool showPassword = false;

late Future<AdminSignUp?> _Admin;
  late ProductDatabaseHelper _databaseHelper;

  
  // Form controllers
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  final _nameCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

     void _addAdmin() async {
    final String adminNameController = _nameCtr.text;
    final String emailidController = _emailCtr.text ;
    final String passwordController = _passCtr.text;
   

    if (adminNameController.isNotEmpty && emailidController.isNotEmpty&& passwordController.isNotEmpty) {
      final newAdmin = AdminSignUp(username: adminNameController, emailid: emailidController,
      password: passwordController);
      var result = await ProductDatabaseHelper.insertAdmin(newAdmin);
      // _products=<product>[];
      setState(() {
        _Admin = ProductDatabaseHelper.getAdminByEmail(emailidController) ;
      });
      print(result);
      _nameCtr.clear();
      _emailCtr.clear();
      _passCtr.clear();     
    }
  }
Future<bool> validateAdminLogin(String email, String password) async {
  final admin = await ProductDatabaseHelper.getAdminByEmail(email);
  
  if (admin != null) {
    if (admin.password== password) {
      print("Login successful for ${admin.username}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      return true;
    } else {
      print("Incorrect password");
      return false;
    }
  } else {
    print("Admin not found");
    return false;
  }
}

  @override
  void initState() {
   
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 25))
          ..repeat();

    _billController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: false);

    _billController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 600));
        _billController.reset();
        _billController.forward();
      }
    });

    _billController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _billController.dispose();
    _emailCtr.dispose();
    _passCtr.dispose();
    _nameCtr.dispose();
    super.dispose();
  }

  Widget _animatedCircle(double size, Color color, double phase, double dy) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        final t = _bgController.value * 2 * pi;
        final x = sin(t + phase) * 40;
        final y = cos(t + phase * 1.5) * dy;
        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.42),
                  color.withOpacity(0.12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w < 700 ? w * 0.92 : 440.0;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F8FD), Color.fromARGB(255, 250, 250, 250)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating circles
          Positioned(top: 40, left: 20, child: _animatedCircle(160, Colors.purpleAccent, 0.4, 20)),
          Positioned(bottom: 80, right: 20, child: _animatedCircle(200, Colors.lightGreenAccent, 1.1, 18)),
          Positioned(top: 220, right: 60, child: _animatedCircle(110, Colors.purpleAccent, 2.0, 12)),
          Positioned(left: 60, bottom: 220, child: _animatedCircle(90, Colors.lightGreenAccent, 3.0, 10)),

          // Billing machine
          Positioned(
            left: 30,
            top: 300,
            child: IgnorePointer(
              child: SizedBox(
                width: 220,
                height: 220,
                child: BillingMachine(animation: _billController),
              ),
            ),
          ),

          // Glassmorphic auth card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color.fromARGB(255, 200, 161, 161).withOpacity(0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 238, 237, 237).withOpacity(0.12),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // subtle moving highlight
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _bgController,
                            builder: (_, __) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.08 * _bgController.value),
                                      Colors.white.withOpacity(0.02),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              );
                            },
                          ),
                        ),
                        _buildAuthContent(cardWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthContent(double width) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isLogin ? 'Welcome Back' : 'Create an account',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLogin ? 'Login to access your billing dashboard' : 'Sign up to start billing smoothly',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.deepPurple.shade700.withOpacity(0.78),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Tabs Toggle
          _buildToggleRow(),

          const SizedBox(height: 18),

          AnimatedSize(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            child: Column(
              children: [
                if (!isLogin) _styledTextField(_nameCtr, 'Full name', Icons.person, validator: (v) {
                  if (v == null || v.trim().length < 2) return 'Enter a valid name';
                  return null;
                }),
                if (!isLogin) const SizedBox(height: 12),
                _styledTextField(_emailCtr, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) {
                  if (v == null || !v.contains('@')) return 'Enter a valid email';
                  return null;
                }),
                const SizedBox(height: 12),
                _styledTextField(_passCtr, 'Password', Icons.lock_outline, isPassword: true, validator: (v) {
                  if (v == null || v.length < 6) return 'Password must be 6+ chars';
                  return null;
                }),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Primary Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _onPrimaryPressed,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade200.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    isLogin ? 'Login' : 'Sign up',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Switch mode
          GestureDetector(
            onTap: () => setState(() => isLogin = !isLogin),
            child: Text(
              isLogin ? "Don't have an account? Sign up" : "Already have an account? Login",
              style: GoogleFonts.poppins(
                color: Colors.deepPurple.shade700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isLogin = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isLogin ? const Color.fromARGB(255, 104, 72, 234) : const Color.fromARGB(0, 253, 253, 253),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Login', style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: isLogin? Colors.white: Colors.black))),
            ),
          ),
        ),
        const SizedBox(width: 8,),
         SizedBox(width: 1.5,child: Container(width: 0.5,height: 25,color: Colors.blue,)),
          const SizedBox(width: 8,),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isLogin = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !isLogin ? const Color.fromARGB(255, 104, 72, 234) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Sign up', style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: isLogin? Colors.black: Colors.white))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _styledTextField(
    TextEditingController ctr,
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return StatefulBuilder(builder: (context, setStateInside) {
      return TextFormField(
        controller: ctr,
        keyboardType: keyboardType,
        obscureText: isPassword && !showPassword,
        validator: validator,
        style: GoogleFonts.poppins(color: Colors.deepPurple.shade900),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0),borderSide: BorderSide(color: const Color.fromARGB(88, 26, 77, 246),width: .5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          prefixIcon: Icon(icon, color: Colors.deepPurple.shade800.withOpacity(0.8)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.deepPurple.shade700),
                  onPressed: () => setState(() => showPassword = !showPassword),
                )
              : null,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.deepPurple.shade700.withOpacity(0.6)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      );
    });
  }

void _loginAdmin() async {
  final email = _emailCtr.text.trim();
  final password = _passCtr.text.trim();

  if (email.isNotEmpty && password.isNotEmpty) {
    bool isValid = await validateAdminLogin(email, password);
    if (isValid) {
      // Navigate to admin dashboard
      print("Navigate to admin dashboard");
    } else {
      // Show error message
      print("Login failed");
    }
  } else {
    print("Please fill all fields");
  }
}

  void _onPrimaryPressed() {
    if (_formKey.currentState?.validate() ?? false) {
     if(!isLogin){
      _addAdmin();
     }
     else{
      _loginAdmin();
     }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isLogin ? 'Logging in...' : 'Signing up...')),
      );
    }
  }
}

/// Billing Machine Widget
class BillingMachine extends StatelessWidget {
  final Animation<double> animation;
  const BillingMachine({required this.animation, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final ease = Curves.easeOut.transform(animation.value);
        final paperOffset = 80.0 * ease;
        final wobble = sin(animation.value * pi * 6) * 2.5;

        return Transform.translate(
          offset: Offset(wobble, -paperOffset + 18),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // machine base
              Positioned(
                bottom: 0,
                child: Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                ),
              ),

              // printer head
              Positioned(
                top: 74,
                child: Container(
                  width: 150,
                  height: 28,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), borderRadius: BorderRadius.circular(6)),
                ),
              ),

              // paper
              Positioned(
                top: 18 - paperOffset,
                child: Opacity(
                  opacity: 0.98,
                  child: Container(
                    width: 120,
                    height: 200,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3))],
                    ),
                    child: CustomPaint(painter: _BillPainter(animation.value)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Paints the bill content safely (no overlap)
class _BillPainter extends CustomPainter {
  final double progress;
  _BillPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final maxPrintedHeight = size.height * (0.12 + 0.45 * progress);
    final skeletonPaint = Paint()..color = Colors.grey.shade300;
    final headerPaint = Paint()..color = Colors.deepPurple.shade50;

    // Header with "Billit" text
    final headerHeight = min(34, maxPrintedHeight);
    if (headerHeight > 6) {
      final headerRect = Rect.fromLTWH(8, 8, size.width - 16, headerHeight - 6);
      canvas.drawRect(headerRect, headerPaint);
      _textPainter('Billit', 14, Colors.deepPurple.shade700)
          .paint(canvas, const Offset(12, 10));
    }

    // Skeleton lines for bill items (simulating text rows)
    final startY = 44.0;
    final lineHeight = 10.0;
    final spacing = 8.0;
    final availableHeight = maxPrintedHeight - startY;
    final maxLines = (availableHeight ~/ (lineHeight + spacing)).clamp(0, 8);

    for (int i = 0; i < maxLines; i++) {
      final y = startY + i * (lineHeight + spacing);
      // Short grey rectangles to simulate text lines
      final widthFactor = (0.5 + (i % 2) * 0.4); // alternating line lengths
      final lineWidth = size.width * widthFactor - 20;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(12, y, lineWidth, lineHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, skeletonPaint);
    }

    // Totals section placeholder skeletons
    if (progress > 0.7 && availableHeight > 60) {
      final yBase = size.height - 60;

      // subtotal placeholder
      final rect1 = RRect.fromRectAndRadius(
        Rect.fromLTWH(12, yBase, size.width - 24, 10),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect1, skeletonPaint);

      // total placeholder
      final rect2 = RRect.fromRectAndRadius(
        Rect.fromLTWH(12, yBase + 24, size.width - 24, 12),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect2, skeletonPaint);
    }

    // Perforation line at bottom
    final clipY = (8 + maxPrintedHeight.clamp(0, size.height - 8)).toDouble();
    final perforationPaint = Paint()..color = Colors.grey.shade300;
    for (double x = 6; x < size.width - 6; x += 8) {
      canvas.drawCircle(Offset(x, clipY), 2, perforationPaint);
    }
  }

  TextPainter _textPainter(String text, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: size, color: color, fontFamily: 'Poppins'),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 500);
    return tp;
  }

  @override
  bool shouldRepaint(covariant _BillPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
