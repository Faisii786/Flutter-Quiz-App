import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerAnswersContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  const CustomerAnswersContainer(
      {super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width * .9,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        border: Border.all(
            width: 1.5, color: const Color.fromARGB(255, 85, 83, 202)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
