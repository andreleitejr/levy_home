import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levy_home/home.dart';
import 'package:levy_core/core.dart';
import 'package:levy_map/map.dart';
import 'package:levy_reservation/reservation.dart';
import 'package:levy_shared_entities/shared_entities.dart';
import 'package:levy_theme/core/theme/theme.dart';
import 'package:levy_user/user.dart';

@RoutePage()
final class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNotifierProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final navigationState = ref.watch(homeNavigationProvider);

    return ThemeStateBuilder(
      state: homeState,
      loading: const HomeShimmer(),
      success: Scaffold(
        body: IndexedStack(
          index: navigationState.selectedIndex,
          children: [
            _buildHomeWidget(homeState),
            const ReservationPage(),
            const MapPage(),
            const UserPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationState.selectedIndex,
          onTap: (index) => ref.read(homeNavigationProvider.notifier).setSelectedIndex(index),
          items: _buildBottomNavigationBarItems(homeState),
        ),
      ),
      error: ThemeErrorWidget(message: homeState.errorMessage),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(HomeState state) {
    return [
      _buildBottomNavItem(ThemeIcons.home),
      _buildBottomNavItem(ThemeIcons.ticket),
      _buildBottomNavItem(ThemeIcons.map),
      BottomNavigationBarItem(
        icon: CircleAvatar(
          backgroundImage: AssetImage(_getUserImage(state)),
          radius: 18,
        ),
        label: '',
      ),
    ];
  }

  BottomNavigationBarItem _buildBottomNavItem(String icon) {
    return BottomNavigationBarItem(
      icon: ThemeIconWidget(icon: icon),
      activeIcon: ThemeIconWidget(
        icon: icon,
        color: ThemeColors.primary,
      ),
      label: '',
    );
  }

  Widget _buildHomeWidget(HomeState state) {
    final user = state.user;
    final reservation = state.reservation;

    if (reservation != null) {
      return HomeReservationWidget(
        user: user,
        reservation: reservation,
        onNotificationButtonPressed: () =>
            context.router.pushNamed('/notification'),
        onViewMapButtonPressed: () => context.router.pushNamed('/map'),
        bus: ref.read(homeNotifierProvider.notifier).getNextBus(),
        arrivalTime: _getArrivalTimeText(ref
            .read(homeNotifierProvider.notifier)
            .calculateTimeUntilNextBus()),
      );
    } else {
      return _buildHomeSearchWidget(state);
    }
  }

  Widget _buildHomeSearchWidget(HomeState state) {
    final router = context.router;
    return HomeSearchWidget(
      user: state.user,
      departureAddress: state.departureAddress?.street,
      returnAddress: state.returnAddress?.street,
      departureTime: state.departureTime,
      returnTime: state.returnTime,
      onNotificationButtonPressed: () => router.pushNamed('/notification'),
      onDepartureAddressSelect: () async {
        final departureAddress =
            await router.pushNamed<AddressEntity>('/address');
        if (departureAddress != null) {
          ref
              .read(homeNotifierProvider.notifier)
              .updateDepartureAddress(departureAddress);
        }
      },
      onReturnAddressSelect: () async {
        final returnAddress = await router.pushNamed<AddressEntity>('/address');
        if (returnAddress != null) {
          ref
              .read(homeNotifierProvider.notifier)
              .updateReturnAddress(returnAddress);
        }
      },
      onDepartureTimeSelect: () async {
        final departureTime = await router.pushNamed<String>('/time');
        if (departureTime != null) {
          ref
              .read(homeNotifierProvider.notifier)
              .updateDepartureTime(departureTime);
        }
      },
      onReturnTimeSelect: () async {
        final returnTime = await router.pushNamed<String>('/time');
        if (returnTime != null) {
          ref.read(homeNotifierProvider.notifier).updateReturnTime(returnTime);
        }
      },
      onButtonPressed: () {
        final departureAddress = state.departureAddress;
        final returnAddress = state.returnAddress;
        final departureTime = state.departureTime;
        final returnTime = state.returnTime;
        if (departureAddress != null &&
            returnAddress != null &&
            departureTime != null &&
            returnTime != null) {
          final search = SearchModel(
            departureAddress: departureAddress as AddressModel,
            returnAddress: returnAddress as AddressModel,
            departureTime: departureTime,
            returnTime: returnTime,
          );
          ref.read(searchProvider.notifier).state = search;
          router.pushNamed('/bus');
        }
      },
    );
  }

  String _getArrivalTimeText(Duration? duration) {
    if (duration == null) return '';

    if (duration.inHours > 0) {
      final unit = (duration.inHours == 1
              ? CommonsTranslation.time.hour
              : CommonsTranslation.time.hours)
          .toLowerCase();
      return '${duration.inHours} $unit';
    } else {
      final unit = (duration.inMinutes == 1
              ? CommonsTranslation.time.minute
              : CommonsTranslation.time.minutes)
          .toLowerCase();
      return '${duration.inMinutes} $unit';
    }
  }

  String _getUserImage(HomeState state) {
    final user = state.user;
    return ThemeImages.getImageByString(user.image);
  }
}
