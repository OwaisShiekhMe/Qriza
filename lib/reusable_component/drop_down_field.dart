import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dropdownfield extends StatefulWidget {
  final String label;
  final List<String> options;
  final Function(String?)? onChanged;
  final String initialValue;
  final IconData? prefixIcon;
  const Dropdownfield({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    required this.initialValue,
    this.prefixIcon,
  });

  @override
  State<Dropdownfield> createState() => _DropdownfieldState();
}

class _DropdownfieldState extends State<Dropdownfield> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final textScaler = MediaQuery.of(context).textScaler;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.label,
          labelStyle: GoogleFonts.manrope(
            color: Colors.black,
            fontSize: textScaler.scale(16),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
        initialValue: widget.initialValue,
        items:
            widget.options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
        onChanged: (value) {
          widget.onChanged!(value);
        },
      ),
    );
  }
}
