import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LettersState extends Equatable {
  LettersState([List props = const <dynamic>[]]) : super(props);
}

class InitialLettersState extends LettersState {}
