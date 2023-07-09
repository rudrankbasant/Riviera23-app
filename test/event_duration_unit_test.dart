import 'package:flutter_test/flutter_test.dart';
import 'package:riviera23/data/models/event_model.dart';
import 'package:riviera23/presentation/methods/show_event_details.dart';

void main() {
  EventModel withinADayEvent = EventModel(
    id: "63c8052255adcdaf54c8824e",
    name: "Dream World Film Festival",
    organizingBody: "VIT Film Society",
    imageUrl: "https://i.imgur.com/2CYjT5y.png",
    start: "2023-02-25T04:30:00.000Z",
    end: "2023-02-25T10:30:00.000Z",
    description:
        "Dream World Film Festival (DWFF) is an annual 2-day event conducted by VIT Film Society. It acts as an interactive platform for aspiring filmmakers and cinema aficionados to exhibit their skills while gaining a plethora of knowledge. Exhilarating events on topics ranging from film-making technicalities to cinema trivia are also incorporated. DWFF 2023 will feature a line up of industry experts to bestow their knowledge and share their experiences in the various aspects of film making. The participants will be given time to shoot and produce their own movies, giving them first hand experience of film making and providing them a medium to use the knowledge they possess. For the final day, movies filmed and produced by the participants will be screened and judged by experienced film makers, hence declaring the winners who will be awarded prize money, bringing an end to the 2 day long film festival.",
    instructions: "towards left",
    eventType: "Art Drama",
    featured: false,
  );

  EventModel moreThanADayEvent = EventModel(
    id: "63c8054155adcdaf54c88262",
    name: "Escape: The Killer",
    organizingBody: "The Hindu Education Plus Club",
    start: "2023-02-24T04:30:00.000Z",
    end: "2023-02-25T11:30:00.000Z",
    description:
        "In this classic escape room with a horror theme, participants in teams of 5, are given 15 minutes to solve clues spread throughout the room before they fall victim and lose. This event tests the participants' ability to be quick thinking, clear minded, and problem solve while working together. It's an exciting and competitive event that allows participants to have fun in a frenzied short burst. The three teams to solve the room the fastest win a cash prize.",
    instructions: "hello there",
    eventType: "Informal",
    featured: false,
    imageUrl: "https://i.imgur.com/0tz6NFy.png",
  );

  group('Event Duration', () {
    test("Events spans within a day", () {
      String output = getDurationDateTimeString(withinADayEvent);
      String expectedOutput = "25 FEB, 2023 10:00 AM - 04:00 PM";
      expect(output, expectedOutput);
    });

    test("Events spans for more than a day", () {
      String output = getDurationDateTimeString(moreThanADayEvent);
      String expectedOutput = "24 FEB, 2023 10:00 AM - 25 FEB, 2023 05:00 PM";
      expect(output, expectedOutput);
    });
  });
}
