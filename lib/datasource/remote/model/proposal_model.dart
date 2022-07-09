class ProposalModel {
  final int id;
  final String creator;
  final String recipient;
  final String quantity;
  final String staked;
  final int executed;
  final int total;
  final int favour;
  final int against;
  final String title;
  final String summary;
  final String description;
  final String image;
  final String url;
  final String status;
  final String stage;
  final String fund;
  final int creationDate;
  final List<int> payPercentages;
  final int passedCycle;
  final int age;
  final String currentPayout;
  final String campaignType;
  final String maxAmountPerInvite;
  final String planted;
  final String reward;
  final int campaignId;

  ProposalModel({
    required this.id,
    required this.creator,
    required this.recipient,
    required this.quantity,
    required this.staked,
    required this.executed,
    required this.total,
    required this.favour,
    required this.against,
    required this.title,
    required this.summary,
    required this.description,
    required this.image,
    required this.url,
    required this.status,
    required this.stage,
    required this.fund,
    required this.creationDate,
    required this.payPercentages,
    required this.passedCycle,
    required this.age,
    required this.currentPayout,
    required this.campaignType,
    required this.maxAmountPerInvite,
    required this.planted,
    required this.reward,
    required this.campaignId,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'],
      creator: json['creator'],
      recipient: json['recipient'],
      quantity: json['quantity'],
      staked: json['staked'],
      executed: json['executed'],
      total: json['total'],
      favour: json['favour'],
      against: json['against'],
      title: json['title'],
      summary: json['summary'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
      status: json['status'],
      stage: json['stage'],
      fund: json['fund'],
      creationDate: json['creation_date'],
      payPercentages: List<int>.from(json['pay_percentages']),
      passedCycle: json['passed_cycle'],
      age: json['age'],
      currentPayout: json['current_payout'],
      campaignType: json['campaign_type'],
      maxAmountPerInvite: json['max_amount_per_invite'],
      planted: json['planted'],
      reward: json['reward'],
      campaignId: json['campaign_id'],
    );
  }
}
