part of './contacts_cubit.dart';




abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsLoading extends ContactsState {}

class ContactsSuccess extends ContactsState {
  final List<Contact> contactsList;

  ContactsSuccess({required this.contactsList});

  @override
  List<Object> get props => [contactsList];
}

class ContactsFailed extends ContactsState {
  final String error;

  ContactsFailed({required this.error});
}
