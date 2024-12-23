import 'package:billit/pages/customer.dart';
import 'package:billit/pages/dashboard.dart';
import 'package:billit/pages/invoice.dart';
import 'package:billit/pages/product.dart';
import 'package:flutter/material.dart';

class menuDetails{
  List menu = ["Dashboard", "Products", "Customers", "Invoice"];

List icons = [
  "assets/icons/Dashboard.svg",
  "assets/icons/Product.svg",
  "assets/icons/Customer.svg",
  "assets/icons/Invoice.svg"
];
List<Widget> pages=[
  const DashBoard(),
  const product(),
  const Customer(),
  const Invoice(),
];
}

