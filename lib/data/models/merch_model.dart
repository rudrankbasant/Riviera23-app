class MerchList {
  List<Merch> merchList;

  MerchList({required this.merchList});

  factory MerchList.fromMap(Map<String, dynamic> map) {
    List<Merch> mMerchList = [];
    map['merch'].forEach((v) {
      mMerchList.add(Merch.fromMap(v));
    });
    return MerchList(merchList: mMerchList);
  }
}

class Merch {
  final String name;
  final String price;
  final String url;
  final String desc;

  Merch({
    required this.name,
    required this.price,
    required this.url,
    required this.desc,
  });

  factory Merch.fromMap(Map<String, dynamic> map) {
    return Merch(
      name: map['name'],
      price: map['price'],
      url: map['url'],
      desc: map['desc'],
    );
  }
}
