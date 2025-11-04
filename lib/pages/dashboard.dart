import 'package:billit/Email/emailscript.dart';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/invoicegraph.dart';
import 'package:billit/models/piechart.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/providers/paymentprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
late ProductDatabaseHelper _databaseHelper=ProductDatabaseHelper.instance;
class DashBoard extends StatefulWidget {
  const DashBoard({super.key});
  

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  
  @override
  void initState(){
    super.initState();
    startEmailSyncService(ProductDatabaseHelper.instance);
  }
  int touchedIndex = -1;
   List<String> menu = ["Total Invoices", "Paid Invoices", "Pending Invoices", "No.of Customers"];
   List<IconData> icons = [
      Icons.receipt_long, // for "Total Invoices"
      Icons.check_circle, // for "Paid Invoices"
      Icons.access_time,  // for "Pending Invoices"
      Icons.people_alt,   // for "No. of Customers"
    ];
   
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context); 
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: List.generate(menu.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            icons[index],
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(height: 12),
                          Text(
                            menu[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          
                         if(index==0)...{
                           SizedBox(height: 12),
                           FutureBuilder<int?>(
                      future: provider.fetchFullRecord(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData) {
                          return const Text("0");
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    )
          
                         },
                         
                         if(index==1)...{
                           SizedBox(height: 12),
                          FutureBuilder<int?>(
                      future: provider.fetchPayedInvoices(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData) {
                          return const Text("0");
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                         },
          
                         if(index==2)...{
                           SizedBox(height: 12),
                          FutureBuilder<int?>(
                      future: provider.fetchPendingInvoices(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData) {
                          return const Text("0");
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                         },
                         if(index==3)...{
                           SizedBox(height: 12),
                          FutureBuilder<int?>(
                      future: provider.getCustomerNames(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData) {
                          return const Text("0");
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                         }
                         
                        ],
                      ),
                    ),
                  );
                }),
              ),
               SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                                height: 400,
                               
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: FutureBuilder<List<InvoiceSummary>>(
                                future: fetchInvoiceSummary(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text('No invoices found');
                                  } else {
                                    return InvoiceSummaryChart(summary: snapshot.data!);
                                  }
                                },
                              ),
                              ),
                  ),
          
          Expanded(
            flex: 1,
            child: 
          
          Container(
            height: 300,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
            ),
              ]
            ),
            child: Padding(padding: 
            const EdgeInsets.all(12),
            child: FutureBuilder<List<ProductSales>>(
            future: fetchProductSales(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No sales data found');
              }
          
              return SizedBox(
                height: 300,
                child: ProductPieChart(sales: snapshot.data!),
              );
            },
          ),
            ),
          )
          ) ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F6F8),
    
    );
  }
  
}
Future<List<InvoiceSummary>> fetchInvoiceSummary() async {
  final data = await _databaseHelper.getInvoiceTotalsByMonth();
  return data.map((row) {
    return InvoiceSummary(
      month: row['month'],
      total: (row['total'] as num).toDouble(),
    );
  }).toList();
}
Future<List<ProductSales>> fetchProductSales() async {
  final data = await _databaseHelper.getProductSalesData();
  return data.map((row) {
    return ProductSales(
      name: row['name'],
      count: (row['soldCount'] as num).toInt(),
    );
  }).toList();
}
