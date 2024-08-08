import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_time/bloc/quiz_bloc.dart';
import 'package:quiz_time/screens/quiz_screen.dart';

import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //url parametrelerini belirlemek için
  Difficulty _selectedDifficulty = Difficulty.easy;
  QuestionAmount _selectedAmount = QuestionAmount.five;
  var _selectedCategory = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuizBloc>(context).add(FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff302b63), Color(0xff24243e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),




        //Categories
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0, left: 15.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  if (state is CategorySuccess) {
                    return GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 4 sütun
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                      ),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final isSelected = _selectedCategory == category.id.toString();

                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedCategory = category.id.toString();


                            });
                          },
                          child: Container(
                            width: 250,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                colors: [Colors.green, Colors.greenAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : const LinearGradient(
                                colors: [Color(0xffad5389), Color(0xff1d2671)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CategoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CategoryError) {
                    return Center(child: Text("An Error occured!!"));
                  } else {
                    return Center(child: Text("An Error occured!!"));
                  }
                },
              ),
            ),










            //Difficulties
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 2.0),
              child: Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            const Divider(
              color: Colors.grey, // Gri renk
              thickness: 0.52, // Çizgi kalınlığı
              indent: 10, // Sol tarafta boşluk
              endIndent: 20, // Sağ tarafta boşluk
            ),

            Row(
              children: [
                Flexible(
                  child: RadioListTile<Difficulty>(
                    title: const Text(
                      'Easy',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    value: Difficulty.easy,
                    groupValue: _selectedDifficulty,
                    onChanged: (Difficulty? value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                    activeColor: Colors.green,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 5), // Boşluğu azaltmak için eklendi
                  ),
                ),
                Flexible(
                  child: RadioListTile<Difficulty>(
                    title: const Text(
                      'Medium',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    value: Difficulty.medium,
                    groupValue: _selectedDifficulty,
                    onChanged: (Difficulty? value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                    activeColor: Colors.orange,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 5), // Boşluğu azaltmak için eklendi
                  ),
                ),
                Flexible(
                  child: RadioListTile<Difficulty>(
                    title: const Text(
                      'Hard',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    value: Difficulty.hard,
                    groupValue: _selectedDifficulty,
                    onChanged: (Difficulty? value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                    activeColor: Colors.red,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10), // Boşluğu azaltmak için eklendi
                  ),
                ),
              ],
            ),







            // Question Amount

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 5.0),
              child: Text(
                'Question Amount',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            const Divider(
              color: Colors.grey, // Gri renk
              thickness: 0.52, // Çizgi kalınlığı
              indent: 10, // Sol tarafta boşluk
              endIndent: 20, // Sağ tarafta boşluk
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Radio<QuestionAmount>(
                        value: QuestionAmount.five,
                        groupValue: _selectedAmount,
                        onChanged: (value) {
                          setState(() {
                            _selectedAmount = value!;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text('5',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Radio<QuestionAmount>(
                        value: QuestionAmount.ten,
                        groupValue: _selectedAmount,
                        onChanged: (QuestionAmount? value) {
                          setState(() {
                            _selectedAmount = value!;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text('10',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Radio<QuestionAmount>(
                        value: QuestionAmount.fifteen,
                        groupValue: _selectedAmount,
                        onChanged: (QuestionAmount? value) {
                          setState(() {
                            _selectedAmount = value!;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text('15',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Radio<QuestionAmount>(
                        value: QuestionAmount.twenty,
                        groupValue: _selectedAmount,
                        onChanged: (QuestionAmount? value) {
                          setState(() {
                            _selectedAmount = value!;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text('20',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ],
            ),





            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(


                  onPressed: () {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          selectedDifficulty: _selectedDifficulty,
                          selectedAmount: _selectedAmount,
                          selectedCategory: _selectedCategory,
                        ),
                      ),
                    );


                  },


                  child: Text("Start Now",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                      fixedSize: const Size(250,30),
                      elevation: 7,
                      shadowColor: Color(0xffEF8011),
                      backgroundColor: Color(0xffF4640D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                ),
              ),
            )





          ],
        ),
      ),
    );
  }
}