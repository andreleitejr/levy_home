import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levy_home/home.dart';
import 'package:levy_reservation/reservation.dart';
import 'package:levy_user/user.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  final getReservationUseCase = ref.read(getReservationUseCaseProvider);

  return HomeNotifier(getUserUseCase, getReservationUseCase);
});


final homeNavigationProvider = StateNotifierProvider<HomeNavigationNotifier, HomeNavigationState>((ref) {
  return HomeNavigationNotifier();
});