import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_time/screens/quiz_result_screen.dart';
import '../bloc/quiz_bloc.dart';
import '../utils/utils.dart';

class QuizScreen extends StatefulWidget {
  var selectedDifficulty;
  var selectedAmount;
  var selectedCategory;

  QuizScreen({
    required this.selectedDifficulty,
    required this.selectedAmount,
    required this.selectedCategory,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isAnswered = false;
  bool isCorrectAnswer = false;
  String selectedAnswer = "";
  int seconds = 15;
  int _correctAnswers = 0;


  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        _nextQuestion();
      }
    });
  }



  void resetTimer() {
    setState(() {
      seconds = 15;
    });
    timer?.cancel();
    startTimer();
  }


  void _nextQuestion() {
    if (mounted) {
      setState(() {
        isAnswered = false;
        selectedAnswer = "";
      });
      BlocProvider.of<QuizBloc>(context).add(NextQuestionEvent());
      resetTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuizBloc>(context).add(FetchQuizQuestions(
      difficulty: widget.selectedDifficulty,
      amount: widget.selectedAmount,
      category: widget.selectedCategory,
    ));
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/peakkx.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizLoading) {
                  return CircularProgressIndicator();
                } else if (state is QuizSuccess) {
                  final quizModel = state.quizModel;
                  final currentQuestionIndex = state.currentQuestionIndex;
                  final totalQuestions = quizModel.results.length;
                  final progress = (currentQuestionIndex + 1) / totalQuestions;

                  final answers = List.from(quizModel.results[currentQuestionIndex].incorrectAnswers);

                  return Column(
                    children: [
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 15, right: 15, bottom: 5),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(0.4),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
                            children: [
                              Expanded(
                                child: Text(
                                  'Question ${currentQuestionIndex + 1} of $totalQuestions',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.volume_up, color: Colors.white), // Set icon color to match the text
                                onPressed: () {
                                  BlocProvider.of<QuizBloc>(context).add(SpeakText(state.quizModel.results[currentQuestionIndex].question));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(

                        child: Card(
                          color: Colors.white.withOpacity(0.35),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  decodeHtml(state.quizModel.results[currentQuestionIndex].question),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Container(
                                  height: 280,
                                  child: ListView.builder(
                                    itemCount: answers.length,
                                    itemBuilder: (context, index) {
                                      final answer = answers[index];
                                      final isSelected = answer == selectedAnswer;
                                      final isCorrect = answer == quizModel.results[currentQuestionIndex].correctAnswer;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: Colors.white.withOpacity(0.8)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            backgroundColor: isSelected
                                                ? (isCorrect ? Color(0xff00ff00) : Color(0xffff0000)).withOpacity(0.8)
                                                : (isAnswered && isCorrect)
                                                ? Color(0xff00ff00).withOpacity(0.8)
                                                : Colors.transparent,
                                          ),
                                          onPressed: isAnswered
                                              ? null
                                              : () {
                                            setState(() {
                                              isAnswered = true;
                                              selectedAnswer = answer;
                                              isCorrectAnswer = isCorrect;
                                              if (isCorrect) {
                                                _correctAnswers++;  // Increment the correct answers counter
                                              }
                                            });
                                            timer?.cancel();
                                          },
                                          child: Text(
                                            answers[index],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Text(
                                              '$seconds',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(
                                                value: seconds / 15,
                                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(), // This creates flexible space between the two children
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0, left: 5, right: 5, bottom: 10),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child:ElevatedButton(
                                          onPressed: isAnswered
                                              ? (currentQuestionIndex == totalQuestions - 1
                                              ? () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizResultScreen(correctAnswers: _correctAnswers,totalQuestions: totalQuestions,),
                                              ),
                                            );
                                          }
                                              : _nextQuestion)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple.withOpacity(0.27),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          ),
                                          child: Text(
                                            currentQuestionIndex == totalQuestions - 1 ? "Finish  ➤" : "Next  ➤",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is QuizError) {
                  return Text(state.message);
                } else {
                  return Text("Error");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
