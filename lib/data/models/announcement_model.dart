class AnnouncementList {
  List<Announcement> announcementList;

  AnnouncementList({required this.announcementList});

  factory AnnouncementList.fromMap(Map<String, dynamic> map) {
    List<Announcement> mAnnouncementList = [];
    map['announcements'].forEach((v) {
      mAnnouncementList.add(Announcement.fromMap(v));
    });
    return AnnouncementList(announcementList: mAnnouncementList);
  }
}

class Announcement {
  final int id;
  final String date;
  final String heading;
  final String desc;
  final String? url;

  Announcement({
    required this.id,
    required this.date,
    required this.heading,
    required this.desc,
    this.url,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      date: map['date'],
      heading: map['heading'],
      desc: map['desc'],
      url: map['url'],
    );
  }
}
