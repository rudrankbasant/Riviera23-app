part of './announcements_cubit.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object> get props => [];
}

class AnnouncementsLoading extends AnnouncementsState {}

class AnnouncementsSuccess extends AnnouncementsState {
  final List<Announcement> announcementsList;

  const AnnouncementsSuccess({required this.announcementsList});

  @override
  List<Object> get props => [announcementsList];
}

class AnnouncementsFailed extends AnnouncementsState {
  final String error;

  const AnnouncementsFailed({required this.error});
}
