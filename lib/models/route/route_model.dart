class RouteModel {
    final int? routeId;
    final String? routeName;

    RouteModel({
        this.routeId,
        this.routeName,
    });

    factory RouteModel.fromJson(Map<dynamic, dynamic> json) => RouteModel(
        routeId: json["routeId"],
        routeName: json["routeName"],
    );

    Map<dynamic, dynamic> toJson() => {
        "routeId": routeId,
        "routeName": routeName,
    };
}