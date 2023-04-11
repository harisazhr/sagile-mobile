part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProjectFetched extends ProjectEvent {}
