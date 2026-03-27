class Cartmodel {
  String? date;
  String? shippingFee;
  String? serviceCharge;
  String? addressId;
  String? vat;
  String? total;
  String? remark;
  List<Products>? products;
  String? packageType;
  String? vendorId;
  String? companyId;

  String? name;
  String? price;
  String? quantity;
  String? image;

  Cartmodel({
    this.date,
    this.shippingFee,
    this.serviceCharge,
    this.addressId,
    this.vat,
    this.total,
    this.remark,
    this.products,
    this.packageType,
    this.vendorId,
    this.companyId,
    this.name,
    this.price,
    this.quantity,
    this.image,
  });

  //  Cartmodel({this.name, this.price, this.quantity, this.image});
}

//[{"product_id":1,"quantity":3,"price":1200,"vendor_id":59,"company_id":3}]

class Products{
int? productId;
int? quantity;
int? price;
int? vendorId;
int? companyId;
Products({
  this.productId,
  this.quantity,
  this.price,
  this.vendorId,
  this.companyId,}); 

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'vendor_id': vendorId,
      'company_id': companyId,
    };
  }
}
