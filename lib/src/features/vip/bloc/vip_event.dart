part of 'vip_bloc.dart';

@immutable
sealed class VipEvent {}

final class CheckVip extends VipEvent {
  CheckVip({this.identifier = ''});

  final String identifier;
}
