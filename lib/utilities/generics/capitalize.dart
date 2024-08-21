extension StringExtension on String {
  String capitalize() {
    return this.isNotEmpty ? this[0].toUpperCase() + this.substring(1) : '';
  }
}
