class EventModel {
  EventModel({
    this.id,
    this.name,
    this.organizingBody,
    this.imageUrl,
    this.start,
    this.end,
    this.loc,
    this.totalCost,
    this.description,
    this.instructions,
    this.eventType,
    this.featured,
  });

  EventModel.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    organizingBody = json['organizing_body'];
    imageUrl = json['image_url'];
    start = json['start'];
    end = json['end'];
    loc = json['loc'];
    totalCost = json['total_cost'];
    description = json['description'];
    instructions = json['instructions'];
    eventType = json['event_type'];
    featured = json['featured'];
  }

  String? id;
  String? name;
  String? organizingBody;
  String? imageUrl;
  String? start;
  String? end;
  String? loc;
  String? totalCost;
  String? description;
  String? instructions;
  String? eventType;
  bool? featured;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['organizing_body'] = organizingBody;
    map['image_url'] = imageUrl;
    map['start'] = start;
    map['end'] = end;
    map['loc'] = loc;
    map['total_cost'] = totalCost;
    map['description'] = description;
    map['instructions'] = instructions;
    map['event_type'] = eventType;
    map['featured'] = featured;
    return map;
  }
}
