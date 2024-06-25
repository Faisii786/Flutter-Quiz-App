import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class GettingResultsSplash extends StatefulWidget {
  final int correctAnswers;
  final int currentQuestionIndex;
  final String selectedAnswer;
  final VoidCallback resetQuiz;
  const GettingResultsSplash(
      {super.key,
      required this.correctAnswers,
      required this.currentQuestionIndex,
      required this.selectedAnswer,
      required this.resetQuiz});

  @override
  State<GettingResultsSplash> createState() => _GettingResultsSplashState();
}

class _GettingResultsSplashState extends State<GettingResultsSplash> {
  String? message;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        if (widget.correctAnswers >= 15) {
          message = 'Congratulations! You passed the test.';
        } else {
          message = 'Oops! Better luck next time!';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Calculating Results",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              if (message == null)
                const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 40,
                )
              else if (message != null)
                Text(
                  '${message!}.\nYour total score is ${widget.correctAnswers}.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              SizedBox(
                height: height * .1,
              ),
              if (message != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.resetQuiz();
                      },
                      child: Text(
                        "Try Again",
                        style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 233, 227, 227),
                            fontSize: 16),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
