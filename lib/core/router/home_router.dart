import 'package:auto_route/auto_route.dart';
import 'package:levy_home/core/router/router.dart';

@AutoRouterConfig()
final class PaymentRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page),
  ];
}