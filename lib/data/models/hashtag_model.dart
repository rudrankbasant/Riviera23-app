class HashtagModel {
  HashtagModel({
    this.permalink,
    this.caption,
    this.commentsCount,
    this.likeCount,
    this.mediaType,
    this.mediaUrl,
    this.id,
  });

  HashtagModel.fromJson(dynamic json) {
    permalink = json['permalink'];
    caption = json['caption'];
    commentsCount = json['comments_count'];
    likeCount = json['like_count'];
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    id = json['id'];
  }

  String? permalink;
  String? caption;
  int? commentsCount;
  int? likeCount;
  String? mediaType;
  String? mediaUrl;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['permalink'] = permalink;
    map['caption'] = caption;
    map['comments_count'] = commentsCount;
    map['like_count'] = likeCount;
    map['media_type'] = mediaType;
    map['media_url'] = mediaUrl;
    map['id'] = id;
    return map;
  }
}
