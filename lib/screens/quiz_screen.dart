import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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


  bool isAnswered = false ;
  bool isCorrectAnswer =false;
  String selectedAnswer="";



  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuizBloc>(context).add(FetchQuizQuestions(
        difficulty: widget.selectedDifficulty,
        amount: widget.selectedAmount,
        category: widget.selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(image: DecorationImage(
            image: AssetImage('assets/peakkx.jpg'),
            fit: BoxFit.cover,
          )
        ),




        child: Center(
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              if (state is QuizLoading) {
                return CircularProgressIndicator();
              } else if (state is QuizSuccess) {

                final quizModel = state.quizModel;
                final currentQuestionIndex = state.currentQuestionIndex; // Bu indeksi Bloc'dan almalısınız.
                final totalQuestions = quizModel.results.length;
                final progress = (currentQuestionIndex + 1) / totalQuestions;

                List<String> answers = List.from(quizModel.results[currentQuestionIndex].incorrectAnswers);
                answers.add(quizModel.results[currentQuestionIndex].correctAnswer);
                answers.shuffle(Random());

                return  Column(
                  children: [

                  // İlerleme Çubuğu

                    SizedBox(height: 16), // Boşluk

                    Padding(
                      padding: const EdgeInsets.only(top: 25.0,left: 15,right: 15,bottom: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple.withOpacity(0.4),),
                        padding: EdgeInsets.all(16),

                        child: Text(
                          'Question ${currentQuestionIndex + 1} of $totalQuestions',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 10),
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
                          borderRadius: BorderRadius.circular(24)
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text('${state.quizModel.results[currentQuestionIndex].question}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,),),
                              SizedBox(height: 10),

                              Container(
                                height: 250,
                                child: ListView.builder(
                                  itemCount: answers.length,
                                    itemBuilder: (context,index){

                                      final answer = answers[index];
                                      final isSelected = answer == selectedAnswer;
                                      final isCorrect = answer == quizModel.results[currentQuestionIndex].correctAnswer;


                                      return  Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side:BorderSide(color: Colors.white.withOpacity(0.7),),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),),

                                              backgroundColor: isSelected
                                                  ? (isCorrect ? Colors.green : Colors.red).withOpacity(0.8)
                                                  : Colors.transparent,

                                            ),
                                            onPressed: isAnswered
                                                ? null
                                                : () {
                                              setState(() {
                                                isAnswered = true;
                                                selectedAnswer = answer;
                                                isCorrectAnswer = isCorrect;
                                              });

                                              Future.delayed(Duration(seconds: 4), () {
                                                if (isCorrect) {
                                                  BlocProvider.of<QuizBloc>(context).add(NextQuestionEvent());
                                                } else {
                                                  setState(() {}); // Rebuild the widget to reflect the selected answer
                                                  BlocProvider.of<QuizBloc>(context).add(NextQuestionEvent());
                                                }
                                              });

                                            },
                                            child: Text(answers[index],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 17),)),


                                    );


                                    }

                                ),
                              )



                            ],
                          ),
                        ),
                      ),


                    ),
                  ],
                );

              }





              else if (state is QuizError) {
                return Text(state.message);
              } else {
                return Text("Press the button to fetch quiz questions.");
              }
            },
          ),
        ),
      ),
    );
  }
}
