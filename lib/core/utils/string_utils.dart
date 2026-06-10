extension CityFlowStringUtils on String {
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
        .join(' ');
  }
}
