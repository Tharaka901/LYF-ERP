enum GetRouteCardItemType {
  rcSummary,
  rcDetails,
}

extension GetRouteCardItemTypeExt on GetRouteCardItemType {
  String get value {
    switch (this) {
      case GetRouteCardItemType.rcSummary:
        return "rc-summary";
      default:
        return "";
    }
  }
}
