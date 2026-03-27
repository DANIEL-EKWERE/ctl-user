import 'dart:convert';

Banks banksFromJson(String x) =>
    Banks.fromJson(jsonDecode(x));



// class VendorCategoryModel {
//   String? message;
//   List<Data>? data;

//   VendorCategoryModel({this.message, this.data});

//   VendorCategoryModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? name;
//   String? description;
//   List<Ingredients>? ingredients;
//   String? createdAt;

//   Data({this.id, this.name, this.description, this.ingredients, this.createdAt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     if (json['products'] != null) {
//       ingredients = <Ingredients>[];
//       json['products'].forEach((v) {
//         ingredients!.add(new Ingredients.fromJson(v));
//       });
//     }
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     if (this.ingredients != null) {
//       data['products'] = this.ingredients!.map((v) => v.toJson()).toList();
//     }
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }

// class Products {
//   int? id;
//   String? name;
//   String? description;
//   String? price;
//   Null? discountPrice;
//   String? stock;
//   List<String>? preparationSteps;
//   Null? rating;
//   String? imageUrl;
//   List<Ingredients>? ingredients;
//   String? createdAt;

//   Products(
//       {this.id,
//       this.name,
//       this.description,
//       this.price,
//       this.discountPrice,
//       this.stock,
//       this.preparationSteps,
//       this.rating,
//       this.imageUrl,
//       this.ingredients,
//       this.createdAt});

//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     price = json['price'];
//     discountPrice = json['discount_price'];
//     stock = json['stock'];
//     preparationSteps = json['preparation_steps'].cast<String>();
//     rating = json['rating'];
//     imageUrl = json['image_url'];
//     if (json['ingredients'] != null) {
//       ingredients = <Ingredients>[];
//       json['ingredients'].forEach((v) {
//         ingredients!.add(new Ingredients.fromJson(v));
//       });
//     }
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['price'] = this.price;
//     data['discount_price'] = this.discountPrice;
//     data['stock'] = this.stock;
//     data['preparation_steps'] = this.preparationSteps;
//     data['rating'] = this.rating;
//     data['image_url'] = this.imageUrl;
//     if (this.ingredients != null) {
//       data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
//     }
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }

// class Ingredients {
//   int? id;
//   String? name;
//   String? description;
//   String? price;
//   String? discount_price;
//   String? unit;
//   List<String>? preparation_steps;
//   String? stock;
//   String? rating;
//   String? image_url;
//   String? createdAt;

//   Ingredients(
//       {this.id,
//       this.name,
//       this.description,
//       this.price,
//       this.unit,
//       this.preparation_steps,
//       this.discount_price,
//       this.rating,
//       this.stock,
//       this.image_url,
//       this.createdAt});

//   Ingredients.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     price = json['price'];
//     unit = json['unit'];
//     stock = json['stock'];
//     image_url = json['image_url'];
//     rating = json['rating'];
//     discount_price = json['discount_price'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['price'] = this.price;
//     data['unit'] = this.unit;
//     data['stock'] = this.stock;
//     data['image_url'] = this.image_url;
//     data['rating'] = this.rating;
//     data['discount_price'] = this.discount_price;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }


// class VendorCategoryModel {
//   final String message;
//   final List<Data> data;

//   VendorCategoryModel({
//     required this.message,
//     required this.data,
//   });

//   factory VendorCategoryModel.fromJson(Map<String, dynamic> json) {
//     return VendorCategoryModel(
//       message: json['message'] ?? '',
//       data: (json['data'] as List)
//           .map((e) => Data.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class Data {
//   final int id;
//   final String name;
//   final String? description;
//   final List<Ingredient> ingredients;
//   final String? createdAt;

//   Data({
//     required this.id,
//     required this.name,
//     this.description,
//     required this.ingredients,
//     this.createdAt,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       ingredients: (json['ingredients'] as List<dynamic>?)
//     ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
//     .toList() ?? [],
//       createdAt: json['created_at'],
//     );
//   }
// }

// class Ingredient {
//   final dynamic id;
//   final String name;
//   final String? description;
//   final double price;
//   final double? discountPrice;
//   final dynamic stock;
//   final List<dynamic> preparationSteps; // you can define this better if needed
//   final dynamic rating;
//   final String imageUrl;
//   final String? createdAt;

//   Ingredient({
//     required this.id,
//     required this.name,
//     this.description,
//     required this.price,
//     this.discountPrice,
//     required this.stock,
//     required this.preparationSteps,
//     this.rating,
//     required this.imageUrl,
//     this.createdAt,
//   });

//   factory Ingredient.fromJson(Map<String, dynamic> json) {
//     return Ingredient(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       price: (parseToDouble(json['price'])),
//       discountPrice: parseToDouble(json['discount_price']),
//       stock: json['stock'],
//       preparationSteps: json['preparation_steps'] ?? [],
//       rating: json['rating'],
//       imageUrl: json['image_url'],
//       createdAt: json['created_at'],
//     );
//   }


// }
//   double parseToDouble(dynamic value) {
//   if (value == null) return 0.0;
//   if (value is num) return value.toDouble();
//   if (value is String) return double.tryParse(value) ?? 0.0;
//   return 0.0;
// }





class Banks {
  bool? status;
  String? message;
  List<Data>? data;

  Banks({this.status, this.message, this.data});

  Banks.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? code;
  String? slug;

  Data({this.id, this.name, this.code, this.slug});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['slug'] = this.slug;
    return data;
  }
}
