String convertToSnakeCase(String input) {
  String lowerCased = input.trim().toLowerCase();

  String snakeCased = lowerCased.replaceAll(' ', '_');

  return snakeCased;
}
