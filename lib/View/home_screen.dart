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

class _HomeScreenState extends State<HomeScreen> {
  ApiClass apiClass = ApiClass();
  int currentQuestionIndex = 0;
  List? questions;
  bool isLoading = true;
  String errorMessage = '';
  String? selectedAnswer;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await apiClass.fetchData();
      setState(() {
        questions = response.results;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network Issue';
      });
    }
  }

  void nextQuestion() {
    if (selectedAnswer == null) {
      ShowSnackBar().snackBarTop('Error404', 'Please select an option first');

      return;
    }

    if (selectedAnswer == questions![currentQuestionIndex].correctAnswer) {
      correctAnswers++;
    }

    setState(() {
      if (currentQuestionIndex < questions!.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    Get.to(() => GettingResultsSplash(
          correctAnswers: correctAnswers.toInt(),
          currentQuestionIndex: currentQuestionIndex.toInt(),
          selectedAnswer: selectedAnswer.toString(),
          resetQuiz: resetQuiz,
        ));
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      correctAnswers = 0;
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    int currentQuestionNumber = currentQuestionIndex + 1;
    int totalQuestions = questions?.length ?? 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('images/quiz.png'),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Question $currentQuestionNumber out of $totalQuestions",
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        body: isLoading
            ? const Center(
                child: SpinKitFadingCircle(
                size: 40,
                color: Colors.white,
              ))
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListView(
                      children: [
                        SizedBox(height: height * 0.01),
                        CustomerQuestionsContainer(
                          text: questions![currentQuestionIndex]
                              .question
                              .toString(),
                        ),
                        const SizedBox(height: 10),
                        ...questions![currentQuestionIndex]
                            .incorrectAnswers!
                            .map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAnswer = answer.toString();
                                });
                              },
                              child: CustomerAnswersContainer(
                                text: answer.toString(),
                                isSelected: selectedAnswer == answer,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAnswer = questions![currentQuestionIndex]
                                  .correctAnswer
                                  .toString();
                            });
                          },
                          child: CustomerAnswersContainer(
                            text: questions![currentQuestionIndex]
                                .correctAnswer
                                .toString(),
                            isSelected: selectedAnswer ==
                                questions![currentQuestionIndex].correctAnswer,
                          ),
                        ),
                      ],
                    ),
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: nextQuestion,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.deepPurple]),
              ),
              width: width * 9,
              height: height * 0.075,
              child: Center(
                child: Text(
                  "N e x t",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
