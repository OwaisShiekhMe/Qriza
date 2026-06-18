import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final FormFieldValidator<String>? validator;
  const CustomInput({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.horizontalMarginFactor = 0.05,
    this.verticalMarginFactor = 0.01,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * widget.verticalMarginFactor,
        left: screenWidth * widget.horizontalMarginFactor,
        right: screenWidth * widget.horizontalMarginFactor,
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText ? _obscureText : false,
        enableSuggestions: !widget.obscureText,
        validator: widget.validator,
        autocorrect: !widget.obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus ? Colors.black : Colors.grey,
          ),
          hintText: widget.hint,
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                    widget.prefixIcon,
                    color: _focusNode.hasFocus ? Colors.black : Colors.grey,
                  )
                  : null,
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _focusNode.hasFocus ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : (widget.suffixIcon != null
                      ? Icon(
                        widget.suffixIcon,
                        color: _focusNode.hasFocus ? Colors.black : Colors.grey,
                      )
                      : null),
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
          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
        ),
      ),
    );
  }
}
