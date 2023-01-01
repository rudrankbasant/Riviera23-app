import 'package:flutter/cupertino.dart';

class FaqList {
  List<Faq> faqList;

  FaqList({required this.faqList});

  factory FaqList.fromMap(Map<String, dynamic> map) {
    List<Faq> mFaqList = [];
    map['faqs'].forEach((v) {
      debugPrint('Faq less = $v');
      mFaqList.add(Faq.fromMap(v));
    });
    return FaqList(faqList: mFaqList);
  }
}

class Faq {
  final int id;
  final String question;
  final String answer;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Faq.fromMap(Map<String, dynamic> map) {
    return Faq(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}
