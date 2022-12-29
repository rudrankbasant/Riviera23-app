import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/info/contacts/contacts_cubit.dart';
import '../../utils/app_colors.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactsCubit(),
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
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsSuccess) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.contactsList.length,
                          itemBuilder: (context, position) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBgColor,
                              ),
                              child: ExpansionTile(
                                  backgroundColor: AppColors.cardBgColor,
                                  title: Text(
                                    "Q. ${state.contactsList[position].question}",
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
                                        state.contactsList[position].answer,
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

                    return Text("Loading Contacts", style: TextStyle(color: AppColors.secondaryColor),);
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
