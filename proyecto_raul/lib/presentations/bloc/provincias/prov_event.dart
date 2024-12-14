import 'package:equatable/equatable.dart';

abstract class ProvEvent extends Equatable {
  const ProvEvent();

  @override
  List<Object?> get props => [];
}

class ProvDataRequest extends ProvEvent {
  const ProvDataRequest();

  @override
  List<Object?> get props => [];
}
