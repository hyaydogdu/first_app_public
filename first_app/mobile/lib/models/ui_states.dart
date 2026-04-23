class WorkoutUiState {
  final Map<String, bool> expanded = {}; // key -> expanded?

  bool isExpanded(String key) => expanded[key] ?? false;

  void toggle(String key) {
    expanded[key] = !(expanded[key] ?? false);
  }
}
