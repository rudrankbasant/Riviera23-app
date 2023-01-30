part of './version_cubit.dart';

abstract class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object> get props => [];
}

class VersionLoading extends VersionState {}

class VersionSuccess extends VersionState {
  final int remoteVersion;

  VersionSuccess({required this.remoteVersion});

  @override
  List<Object> get props => [remoteVersion];
}

class VersionFailed extends VersionState {
  final String error;

  VersionFailed({required this.error});
}
