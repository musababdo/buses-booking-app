class Search {
  final String id;
  final String city;
  final String price;

  Search({this.id, this.city,this.price});

  factory Search.formJson(Map <String, dynamic> json){
    return new Search(
      id: json['id'],
      city: json['city'],
      price: json['price'],
    );
  }
}
