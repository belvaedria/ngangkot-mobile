abstract class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final List<String> locations;
  const LocationLoaded(this.locations);
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
}
