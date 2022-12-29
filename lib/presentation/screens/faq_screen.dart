import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/info/faq/faq_cubit.dart';


class FAQScreen extends StatefulWidget {
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FaqCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<FaqCubit, FaqState>(
                  builder: (context, state) {
                    if (state is FaqSuccess) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.faqList.length,
                          itemBuilder: (context, position) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBgColor,
                              ),
                              child: ExpansionTile(
                                backgroundColor: AppColors.cardBgColor,
                                  title: Text(
                                    "Q. ${state.faqList[position].question}",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryColor,
                                      ),
                                      child: Text(
                                        state.faqList[position].answer,
                                        style: TextStyle(
                                            color: AppColors.secondaryColor,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    )
                                  ]),
                            );
                          });
                    }

                    return Text("Loading FAQ");
                  },
                ),
                SizedBox(
                  height: 16,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
