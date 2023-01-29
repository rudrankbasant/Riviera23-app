class FavouriteModel {
  final String uniqueUserId;
  final List<String> favouriteEventIds;

  FavouriteModel({
    required this.uniqueUserId,
    required this.favouriteEventIds,
  });

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      uniqueUserId: map['uniqueUserId'],
      favouriteEventIds: map['favouriteEventIds'].cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uniqueUserId'] = uniqueUserId;
    map['favouriteEventIds'] = favouriteEventIds;
    return map;
  }
}

class FavoriteEventIds {
  List<String> favEventIds;

  FavoriteEventIds({required this.favEventIds});

  factory FavoriteEventIds.fromMap(Map<String, dynamic> map) {
    List<String> mFavEventIds = [];
    map['faveventids'].forEach((v) {
      mFavEventIds.add(v);
    });
    return FavoriteEventIds(favEventIds: mFavEventIds);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['favEventIds'] = favEventIds;
    return map;
  }
}
