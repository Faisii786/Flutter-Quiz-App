import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerQuestionsContainer extends StatelessWidget {
  final String text;

  const CustomerQuestionsContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width * .9,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        border: Border.all(
            width: 1.5, color: const Color.fromARGB(255, 85, 83, 202)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            'Q : $text',
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
