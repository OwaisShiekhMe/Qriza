import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlineButton;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final double height;
  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.outlineButton = false,
    this.horizontalMarginFactor = 0.05,
    this.verticalMarginFactor = 0.01,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final textScaler = MediaQuery.of(context).textScaler;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: outlineButton ? Border.all(color: Color(0xff003FA4)) : null,
          gradient:
              outlineButton
                  ? null
                  : LinearGradient(
                    colors: [Color(0xff0050CB), Color(0xff00BFA5)],
                  ),
          borderRadius: BorderRadius.circular(
            (screenHeight * 0.1).clamp(10.0, 20.0),
          ),
        ),
        width: double.infinity,
        margin: EdgeInsets.only(
          top: (screenHeight * verticalMarginFactor).clamp(10.0, 20.0),
          left: (screenWidth * horizontalMarginFactor),
          right: (screenWidth * horizontalMarginFactor),
        ),
        height: (screenHeight * height).clamp(40.0, 60.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: outlineButton ? Color(0xff003FA4) : Colors.white,
              fontSize: textScaler.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
