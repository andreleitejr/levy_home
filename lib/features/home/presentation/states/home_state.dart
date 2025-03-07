import 'package:levy_shared_entities/shared_entities.dart';
import 'package:levy_theme/core/theme/theme.dart';

final class HomeState implements GenericStateBase {
  final UserEntity user;
  final ReservationEntity? reservation;
  final AddressEntity? departureAddress;
  final AddressEntity? returnAddress;
  final String? departureTime;
  final String? returnTime;

  @override
  final String errorMessage;

  @override
  final bool isLoading;

  const HomeState({
    this.user = const UserModel(),
    this.reservation,
    this.departureAddress,
    this.returnAddress,
    this.departureTime,
    this.returnTime,
    this.errorMessage = '',
    this.isLoading = false,
  });

  const HomeState.loading() : this(isLoading: true);

  const HomeState.success({
    required UserEntity user,
    ReservationEntity? reservation,
  }) : this(user: user, reservation: reservation);

  const HomeState.error(String message) : this(errorMessage: message);

  HomeState copyWith({
    UserEntity? user,
    AddressEntity? departureAddress,
    AddressEntity? returnAddress,
    String? departureTime,
    String? returnTime,
    String? errorMessage,
    bool? isLoading,
  }) {
    return HomeState(
      user: user ?? this.user,
      departureAddress: departureAddress ?? this.departureAddress,
      returnAddress: returnAddress ?? this.returnAddress,
      departureTime: departureTime ?? this.departureTime,
      returnTime: returnTime ?? this.returnTime,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


class HomeNavigationState {
  final int selectedIndex;
  const HomeNavigationState({this.selectedIndex = 0});

  HomeNavigationState copyWith({int? selectedIndex}) {
    return HomeNavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}