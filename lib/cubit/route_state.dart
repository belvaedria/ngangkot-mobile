import '../models/route_recommendation.dart';

abstract class RouteState {
  const RouteState();
}

class RouteInitial extends RouteState {
  const RouteInitial();
}

class RouteLoading extends RouteState {
  const RouteLoading();
}

class RouteLoaded extends RouteState {
  final List<RouteRecommendation> items;
  const RouteLoaded(this.items);
}

class RouteError extends RouteState {
  final String message;
  const RouteError(this.message);
}
