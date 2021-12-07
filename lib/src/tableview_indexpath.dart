class IDKitIndexPath {
  const IDKitIndexPath({
    required this.section,
    required this.row,
  });

  /// Subscript of list group.
  final int section;

  /// Corner label of each group element.
  final int row;
}
