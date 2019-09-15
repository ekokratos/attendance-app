import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LettersEvent extends Equatable {
  LettersEvent([List props = const <dynamic>[]]) : super(props);
}
