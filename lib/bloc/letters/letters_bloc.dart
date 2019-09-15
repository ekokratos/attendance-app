import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class LettersBloc extends Bloc<LettersEvent, LettersState> {
  @override
  LettersState get initialState => InitialLettersState();

  @override
  Stream<LettersState> mapEventToState(
    LettersEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
