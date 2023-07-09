
import 'package:flutter_test/flutter_test.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';

void main(){
  group('Date Parser', (){
    test("Date should be returned", () {
      String? datetime = "2021-10-10T10:10:10.000Z";
      String output = parseDate(datetime);
      String expectedOutput = "10 OCT, 2021";
      expect(output, expectedOutput);
    });

    test("Null Date should be handled", () {
      String? datetime = null;
      String output = parseDate(datetime);
      String expectedOutput = "Dates to be declared";
      expect(output, expectedOutput);
    });
  });

}