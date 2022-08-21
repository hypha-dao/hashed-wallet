class SubstrateChainModel {
  String name;
  String endpoint;
  int ss58;

  SubstrateChainModel({required this.name, required this.endpoint, required this.ss58});

  factory SubstrateChainModel.fromJson(Map<String, dynamic> json) =>
      SubstrateChainModel(name: json["name"], endpoint: json["endpoint"], ss58: json['ss58']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'endpoint': endpoint,
        'ss58': ss58,
      };
}
