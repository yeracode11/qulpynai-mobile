import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Product ids the user hearted. Local only until the backend has favorites.
class FavoritesController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  bool contains(String id) => state.contains(id);

  void toggle(String id) => state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
}

final favoritesProvider = NotifierProvider<FavoritesController, Set<String>>(FavoritesController.new);
