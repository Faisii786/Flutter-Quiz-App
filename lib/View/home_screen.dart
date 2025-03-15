import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Controller/api_response.dart';
import 'package:quiz_app/View/getting_results.dart';
import 'package:quiz_app/components/custom_ans_container.dart';
import 'package:quiz_app/components/custom_que_container.dart';
import 'package:quiz_app/helper/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  ApiClass apiClass = ApiClass();
  int currentQuestionIndex = 0;
  List? questions;
  bool isLoading = true;
  String errorMessage = '';
  String? selectedAnswer;
  int correctAnswers = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    fetchQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await apiClass.fetchData();
      setState(() {
        questions = response.results;
        isLoading = false;
      });
      _controller.forward();
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network Issue';
      });
    }
  }

  void nextQuestion() {
    if (selectedAnswer == null) {
      ShowSnackBar()
          .snackBarTop('Error', 'Please select an answer to continue');
      return;
    }

    if (selectedAnswer == questions![currentQuestionIndex].correctAnswer) {
      correctAnswers++;
    }

    setState(() {
      if (currentQuestionIndex < questions!.length - 1) {
        _controller.reverse().then((_) {
          setState(() {
            currentQuestionIndex++;
            selectedAnswer = null;
          });
          _controller.forward();
        });
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    Get.to(
      () => GettingResultsSplash(
        correctAnswers: correctAnswers.toInt(),
        currentQuestionIndex: currentQuestionIndex.toInt(),
        selectedAnswer: selectedAnswer.toString(),
        resetQuiz: resetQuiz,
      ),
      transition: Transition.fadeIn,
    );
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      correctAnswers = 0;
      selectedAnswer = null;
      isLoading = true;
    });
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    int currentQuestionNumber = currentQuestionIndex + 1;
    int totalQuestions = questions?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/quiz.png',
              height: 32,
            ),
            const SizedBox(width: 12),
            Text(
              "Question $currentQuestionNumber/$totalQuestions",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPulse(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50.0,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Questions...',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = '';
                          });
                          fetchQuestions();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 16),
                        child: FadeTransition(
                          opacity: _animation,
                          child: Column(
                            children: [
                              CustomerQuestionsContainer(
                                text: questions![currentQuestionIndex]
                                    .question
                                    .toString(),
                              ),
                              const SizedBox(height: 24),
                              ...questions![currentQuestionIndex]
                                  .incorrectAnswers!
                                  .map((answer) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = answer.toString();
                                    });
                                  },
                                  child: CustomerAnswersContainer(
                                    text: answer.toString(),
                                    isSelected: selectedAnswer == answer,
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswer =
                                        questions![currentQuestionIndex]
                                            .correctAnswer
                                            .toString();
                                  });
                                },
                                child: CustomerAnswersContainer(
                                  text: questions![currentQuestionIndex]
                                      .correctAnswer
                                      .toString(),
                                  isSelected: selectedAnswer ==
                                      questions![currentQuestionIndex]
                                          .correctAnswer,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            currentQuestionIndex < questions!.length - 1
                                ? "Next Question"
                                : "Finish Quiz",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
