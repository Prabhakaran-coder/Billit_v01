import 'dart:io';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/textOverFlowInvoice.dart';
import 'package:billit/pages/recordPayment.dart';
import 'package:billit/providers/paymentprovider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show Color, rootBundle;
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:billit/Email/emailscript.dart';
import '../utils/qr_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';


class invoicepdfview extends StatefulWidget {
  final String invoiceId;
   final String customerName;
   
  const invoicepdfview({required this.invoiceId,required this.customerName,super.key});

  @override
  State<invoicepdfview> createState() => _invoicepdfviewState();
}

class _invoicepdfviewState extends State<invoicepdfview> {
Future<List<Profile>>? _profile;
   late ProductDatabaseHelper _databaseHelper;
 late var profile;
   //late ProductDatabaseHelper _databaseHelper;
    double opacity = 0.0;
      bool isDrawerOpen = false;
    //bool _isDataLoaded = false;
   
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance; 
      _profile = _databaseHelper.getProfile();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {      
        opacity = 1.0; 
      });
    });
  }
void showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {   
     final provider = Provider.of<PaymentProvider>(context,listen: false); 
      final loadinvoices = provider.loadInvoicess(invoiceId: widget.invoiceId, customerName: widget.customerName);
      var totalbill = provider.totalbill;
     final fetchedpayments =provider.fetchPayments(widget.invoiceId);
          return Scaffold(
              body: 
              Stack(
                             clipBehavior: Clip.none,
                              children: [SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                     Container(              
                    height: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blue,  // Background color of the top bar
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                         IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);  // Go back when clicked
                      },
                    ),
                        Text("Invoice", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      ],
                    ),
                  ),
                    Container(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(                
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(padding: EdgeInsetsDirectional.only(start: 20),
                                      child:  Text("Invoice ${widget.invoiceId}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                      ),                                     
                                      Container(
                                      padding: EdgeInsets.all(5),
                                                                
                                      decoration: BoxDecoration(color: const Color.fromARGB(255, 74, 195, 104),borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child:  IconButton(                                       
                                        
                                      onPressed: () async {
                                      try {                                        
                                        await generateInvoicePDFs(context, profile);
                                        showSnackBar(context, '📄 Invoice PDF generated with active UPI QR.');
                                        } catch (e) {
                                        showSnackBar(context, '⚠️ Error generating invoice: $e', isError: true);
                                        print('Error generating invoice: $e');
                                      }
                                    },
                                      icon: Icon(Icons.print),color: Colors.white,                                      
                                      ),                                      
                                     ),//           
                                     ],
                                  ),
                                  
                                   SizedBox(height: 20),
                                  Container(
                                  decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                       BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            
                                            blurRadius: 50,
                                            spreadRadius: 10,
                                          ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      FutureBuilder<List<Profile>>(
                                        future: _profile,
                                        builder: (context,snapshot){
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const Center(child: CircularProgressIndicator());
                                                }

                                                if (snapshot.hasError) {
                                                  return Center(child: Text('Error: ${snapshot.error}'));
                                                }

                                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                  return const Center(child: Text('No profile found.'));
                                                }

                                                profile = snapshot.data!.first;

                                          return Container(    
                                          padding: EdgeInsets.all(10),                  
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(                            
                                                  children: [
                                                    Padding(padding: EdgeInsets.all(10),
                                                    child: Column(                                  
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      Text(profile.profileName,style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 16.0),),
                                                      SizedBox(height: 3.0,),
                                                      
                                                      Text(profile.profileAddress ,style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                       SizedBox(height: 2.0,),
                                                       Text('${profile.district}-${profile.pincode}' ,style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                       SizedBox(height: 2.0,),
                                                      Text('Contact No: ${profile.profileContact.toString()}',style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                       SizedBox(height: 2.0,),
                                                        Text('Email : ${profile.emailAddress.toString()}',style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                       SizedBox(height: 2.0,),
                                                      Text('GST No: ${profile.gst}',style: TextStyle(fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),),                                          
                                                  ],
                                                ),
                                              ),
                                              Column(                           
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFFF4F5F6)
                                                    ),
                                                    child: 
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(widget.invoiceId,style: TextStyle(fontWeight: FontWeight.bold),),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Text("Total Amount"),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.currency_rupee,size: 20,),
                                                      Text(totalbill.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                    ],
                                                  ),
                                                ],
                                              ),],                      
                                          ),                                            
                                        );
                                        }
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(                            
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(width: 1.0,color: const Color.fromARGB(255, 196, 196, 196)) ),
                                        child: 
                                        Column(
                                          children: [
                                            Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Bill Date",style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                       
                                                      Text(provider.formattedDate,style: TextStyle(fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 20,),
                                                      Text("Terms of Payments",style: TextStyle(color: Color(0xFF667085),fontSize: 12.0)),
                                                      Text("Within 15 days",style: TextStyle(fontWeight: FontWeight.bold))
                                                    ],),),
                                              SizedBox(width: 100.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Billing Address",style: TextStyle(color: Color(0xFF667085),fontSize: 11.5,)),
                                                    SizedBox(height: 5.0),
                                                    Text( provider.invoiceHeader.isNotEmpty ? provider.invoiceHeader[0].customerName : 'No Name',style: TextStyle(fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 5.0),
                                                    Text(provider.particularCustomerDetails.isNotEmpty? provider.particularCustomerDetails[0].customerAddress.toString():"No Customer Address",style: TextStyle(color: Color(0xFF667085),fontSize: 11.5,wordSpacing: 3.0)),
                                                    SizedBox(height: 5.0),
                                                    Text(provider.particularCustomerDetails.isNotEmpty? provider.particularCustomerDetails[0].customerContact.toString():"No customer Contact",style: TextStyle(color: Color(0xFF667085),fontSize: 11.5)),
                                                    SizedBox(height: 5.0),
                                                    Text(provider.particularCustomerDetails.isNotEmpty? 'Email: ${provider.particularCustomerDetails[0].customeremailContact.toString()}':"No customer Contact",style: TextStyle(color: Color(0xFF667085),fontSize: 11.5)),
                                                    SizedBox(height: 5.0),
                                                    Text("GST No:${provider.particularCustomerDetails.isNotEmpty? provider.particularCustomerDetails[0].gst.toString():"No customer Gst"}",style: TextStyle(color: Color(0xFF667085),fontSize: 11.0,fontWeight: FontWeight.bold)),
                                                  ],)
                                               ],
                                             ),
                                             SizedBox(height: 30,),
                                             DataTable(
                                               columnSpacing: 100.0,
                                              headingTextStyle: TextStyle(color: Color(0xFF667085),fontSize: 12.0),
                                              dataTextStyle:
                                                TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                                dividerThickness: 0.4,
                                                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                                                  (Set<WidgetState> states) {
                                                    return Color.fromARGB(255, 242, 242, 242);
                                                  },
                                                ),
                                               
                                              headingRowHeight: 35.0,
                                               columns: [
                              DataColumn(label: Text("No")),
                              DataColumn(label: Text("PRODUCT")),
                              DataColumn(label: Text("QUANTITY")),
                              DataColumn(label: Text("PRICE")),
                              DataColumn(label: Text("AMOUNT")), 
                            ],
                            rows: List.generate(
                              provider.invoiceDetails.length,
                              
                              (index) => _buildDataRow(
                                context,
                                 index,
                                provider.invoiceDetails[index].productName,
                                provider.invoiceDetails[index].quantity.toString(),
                                provider.invoiceDetails[index].price.toString(),
                                provider.invoiceDetails[index].amount.toString(),                    
                              ),
                             ),
                              ),
                               SizedBox(height:0.4,child: Container(decoration: BoxDecoration(color: Colors.black26),),),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 200,
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5.0,),
                                          Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [                            
                                        Text("SUBTOTAL",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085),fontSize: 12),),
                                        Text(
                                          provider.invoiceHeader.isNotEmpty
                                                  ? provider.invoiceHeader[0].subtotal.toString()
                                                  : 'No subtotal',style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 12),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                     
                                   if(provider.invoiceHeader.isNotEmpty&& provider.invoiceHeader[0].igst<1)...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("CGST",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085),fontSize: 12)),
                                        
                                        Text(provider.invoiceHeader.isNotEmpty
                                                  ? provider.invoiceHeader[0].cgst.toString()
                                                  : 'NO CGST',style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 12),),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("SGST",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085),fontSize: 12)),
                                        Text(provider.invoiceHeader.isNotEmpty
                                                  ? provider.invoiceHeader[0].sgst.toString()
                                                  : 'NO SGST',style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 12),),
                                      ],
                                    ),
                                     Divider(height: 5.0,),
                                      SizedBox(height: 5.0,),
                                   Row(                        
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                       
                                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                                        Row(
                                          children: [
                                            Icon(Icons.currency_rupee,size: 12,),
                                            Text(provider.invoiceHeader.isNotEmpty
                                                      ? provider.invoiceHeader[0].totalAmount.toString()
                                                      : 'NO TOTAL',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF333843),fontSize: 12),),
                                          ],
                                        ),
                                      ],
                                    ),
                                   ]
                                   else if(provider.invoiceHeader.isNotEmpty&& provider.invoiceHeader[0].igst>0)...[
                                     Divider(height: 5.0,),
                                   Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("IGST",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                                        Text(provider.invoiceHeader.isNotEmpty
                                                  ? provider.invoiceHeader[0].igst.toString()
                                                  : 'NO IGST',style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 12),),
                                      ],
                                    ),
                                    Divider(height: 5.0,),
                                   Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                                        Row(
                                          children: [
                                            Icon(Icons.currency_rupee,size: 12,),
                                            Text(provider.invoiceHeader.isNotEmpty
                                                      ? provider.invoiceHeader[0].totalAmount.toString()
                                                      : 'NO TOTAL',style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843),fontSize: 12),),
                                          ],
                                        ),
                                      ],
                                    ),
                                   ]
                                   else...[
                                     Divider(height: 5.0,),
                                     SizedBox(height: 5.0,),
                                   Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [                            
                                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                                        Row(
                                          children: [
                                            Icon(Icons.currency_rupee,size: 12,),
                                            Text(provider.invoiceHeader.isNotEmpty
                                                      ? provider.invoiceHeader[0].subtotal.toString()
                                                      : 'NO TOTAL',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF333843),fontSize: 12),),
                                          ],
                                        ),
                                      ],
                                    ),
                                   ]
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                                          ],
                                        ),
                                        ),
                                      ),                                  
                                    ],
                                  ),                    
                                   ),      
                                ],                       
                              ),
                            )
                            ),
                          Expanded(
                             flex:1,
                            child: 
                                Column(                                  
                                  children: [
                                      Row(
                                  children: [
                                        Container(
                                        margin: EdgeInsets.only(left: 20),
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                       
                                       borderRadius: BorderRadius.circular(5),
                                       //border: Border.all(color: Colors.green)
                                       ),
                                      child: 
                                          TextButton(
                                         style: TextButton.styleFrom(                            
                                        backgroundColor: Color.fromARGB(158, 235, 174, 245),
                                        foregroundColor: const Color.fromARGB(255, 48, 45, 45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0), // Set border radius
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0), // Optional padding
                                        ),
                                          onPressed: (){                                            
                                         if (!provider.paymentBtn) {
                                              setState(() => isDrawerOpen = true);    
                                             // provider.addPayments(invoiceId: widget.invoiceId,paymentMode: ,)                                          
                                              provider.fetchPayments(widget.invoiceId);
                                              
                                              provider.loadInvoicess(
                                                invoiceId: widget.invoiceId,
                                                customerName: widget.customerName,
                                              );
                                            }
                                             
                                          },
                                        child: Text("Record a Payment",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 16)
                                        )
                                        ),
                                        ),
                                      ],
                                      ),
                                      PaymentSummary(context),
                                  ],
                                ),
                                 
                             
                            ),
                            
                            
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        right: isDrawerOpen ? 30 : -MediaQuery.of(context).size.width * 0.35,
                                        top: 50,

                                        //bottom: 0,
                                        child: Material(
                                         elevation: 10,
                                          borderRadius: BorderRadius.circular(10),
                                          child:                                         
                                            Container(                                             
                                              margin: EdgeInsets.all(20),
                                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                            
                                            width: MediaQuery.of(context).size.width * 0.25,
                                            height: MediaQuery.of(context).size.height * 0.6, 
                                            child: PaymentRecord(                                                                             
                                              isDrawerOpen: isDrawerOpen,
                                              onClose: () => setState(() => isDrawerOpen = false),
                                              invoiceId: widget.invoiceId,
                                              payment: provider.invoiceHeader.isNotEmpty
                                                  ? provider.invoiceHeader[0].totalAmount.toString()
                                                  : '',
                                              pendingamount: provider.pendingamount.toDouble(),
                                            ),
                                          ),
                                        ),
                                      ),
                              ]),
          );
      
      
   
  }
 Container PaymentSummary(BuildContext context) {
   final provider = Provider.of<PaymentProvider>(context,listen: false); 
    return Container(
                                width: MediaQuery.of(context).size.width * 0.3,                      
                                margin: EdgeInsets.all(10),
                               
                                decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                child: Column(                        
                                  crossAxisAlignment: CrossAxisAlignment.start,                      
                                  children: [                         
                                    Container( 
                                       padding: EdgeInsets.all(20),
                                     width: double.maxFinite,
                                                            
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [ 
                                       Text("Payment Summary",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                                       Divider(),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Total",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13)),
                                          Row(
                                            children: [
                                              Icon(Icons.currency_rupee,size: 13,),
                                              Text(provider.totalbill.toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13)),
                                            ],
                                          ),
                                        ],
                                       ),
                                       SizedBox(height: 25,),
                        
                                        Row(children: [
                                          Container(
                                          width:  MediaQuery.of(context).size.width * 0.008,
                                          height:  MediaQuery.of(context).size.width * 0.008,
                                         // padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: Colors.green[400],borderRadius: BorderRadius.circular(10)),
                                        ),
                                        
                                          Container(
                                            padding: EdgeInsetsDirectional.only(start: 10),
                                            child: Text("Deposit No.${widget.invoiceId}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),),
                                     ],
                                     ),
                        
                                      Row(
                                            children: [
                                              Stack(
                                                 children: [
                                              LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints){
                                                
                                                  return Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 2),child: Flex(
                                                    direction: Axis.vertical,
                                                    children: List.generate(5, (index)=>
                                                    Container(decoration: BoxDecoration(color: Colors.grey[500]),width: 1,height: 4,margin: EdgeInsets.all(2),)),                                             
                                                  ));
                                              },
                                              ),                  
                                                ],
                                              ),
                                            ],
                                          ),
                                      for(int i=0;i<provider.paymentsData.length;i++)...[
                                          
                                        if(i<provider.paymentsData.length-1)...{
                                            Row(children: [
                                          Container(
                                          width:  MediaQuery.of(context).size.width * 0.008,
                                          height:  MediaQuery.of(context).size.width * 0.008,
                                         // padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: Colors.green[400],borderRadius: BorderRadius.circular(10)),
                                        ),
                                        
                                          Container(
                                            padding: EdgeInsetsDirectional.only(start: 10),
                                            child: Text(provider.paymentsData[i].paymentstatus,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),),
                                        ],),
                                          Row(
                                            children: [
                                              Stack(
                                                 children: [
                                              LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints){
                                               
                                                  return Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 2),child: Flex(
                                                    direction: Axis.vertical,
                                                    children: List.generate(5, (index)=>
                                                    Container(decoration: BoxDecoration(color: Colors.grey[500]),width: 1,height: 4,margin: EdgeInsets.all(2),)),
                                                    
                                                  ));
                                              },
                                              ),
                        
                                              //  for(int i=0;i<_paymentsData.length;i++)...[
                                                if(i>=0)...{
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.265,
                                            padding: EdgeInsetsDirectional.only(start: 20),
                                            //decoration: BoxDecoration(color: Colors.green),
                                            child: Column(
                                              children: [
                                                //Text("${_paymentsData[i-1].paymentstatus}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Date",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: const Color.fromARGB(255, 171, 171, 171))),
                                                    // ignore: unnecessary_string_interpolations
                                                    Text("${provider.paymentsData[i].dateofpayment.substring(0,10)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                 Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Text("Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: const Color.fromARGB(255, 171, 171, 171))),
                                                     Row(
                                                       children: [
                                                        Icon(Icons.currency_rupee,size: 11,),
                                                         Text("${provider.paymentsData[i].amountpaid}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                                       ],
                                                     ),
                                                   ],
                                                 ),                                            
                                              ],                                        
                                            ),),                                      
                                              }                                        
                                            ],
                                           ),
                                            ],
                                          )
                                        },
                                        if(i==provider.paymentsData.length-1)...{
                                    Row(children: [
                                          AnimatedOpacity(opacity: opacity, duration: Duration(milliseconds: 1000),
                                          child:Row(
                                            children: [
                                              Container(
                                          width:  MediaQuery.of(context).size.width * 0.008,
                                          height:  MediaQuery.of(context).size.width * 0.008,
                                         // padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: Colors.green[400],borderRadius: BorderRadius.circular(10)),
                                        ),
                                        
                                          Container(
                                            padding: EdgeInsetsDirectional.only(start: 10),
                                            child: Text(provider.paymentsData[i].paymentstatus,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),),
                                            ],
                                          ),
                                          )
                                        ],),
                                          AnimatedOpacity(opacity: opacity, duration: Duration(milliseconds: 800),
                                          child: Row(
                                            children: [
                                              Stack(
                                                 children: [
                                              LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints){
                                               
                                                  return Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 2),child: Flex(
                                                    direction: Axis.vertical,
                                                    children:[AnimatedOpacity(opacity: opacity, duration: Duration(milliseconds: 1400),
                                                    child: Column(
                                                      children: [
                                                        ...List.generate(5, (index)=>
                                                    Container(decoration: BoxDecoration(color: Colors.grey[500]),width: 1,height: 4,margin: EdgeInsets.all(2),)),
                                                    
                                                      ],
                                                    ),
                                                    )]
                                                  ));
                                              },
                                              ),
                        
                                              //  for(int i=0;i<_paymentsData.length;i++)...[
                                                if(i>=0)...{
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.265,
                                            padding: EdgeInsetsDirectional.only(start: 20),
                                            //decoration: BoxDecoration(color: Colors.green),
                                            child: Column(
                                              children: [
                                                //Text("${_paymentsData[i-1].paymentstatus}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Date",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: const Color.fromARGB(255, 171, 171, 171))),
                                                    // ignore: unnecessary_string_interpolations
                                                    Text("${provider.paymentsData[i].dateofpayment.substring(0,10)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                 Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Text("Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: const Color.fromARGB(255, 171, 171, 171))),
                                                     Row(
                                                       children: [
                                                        Icon(Icons.currency_rupee,size: 11,),
                                                         Text("${provider.paymentsData[i].amountpaid}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                                       ],
                                                     ),
                                                   ],
                                                 ),                                            
                                              ],                                        
                                            ),),                                      
                                              }                                        
                                            ],
                                           ),
                                            ],
                                          ),
                                          )
                                        }
                                      ],
                                        Divider(),
                                        Row(children: [
                                          SizedBox(
                                          width:  MediaQuery.of(context).size.width * 0.265,
                                          // height:  MediaQuery.of(context).size.width * 0.008,
                                         // padding: EdgeInsets.all(10),
                                          //decoration: BoxDecoration(color: Colors.green[400],borderRadius: BorderRadius.circular(10)),
                                         child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Pending Amount",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                                            if(provider.pendingamount!=0)...{
                                                Container(
                                                  padding: EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                                                 decoration: BoxDecoration(color: const Color.fromARGB(131, 243, 121, 121),borderRadius: BorderRadius.all(Radius.circular(3))),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.currency_rupee,size: 15,),
                                                      Text(provider.pendingamount.toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.black)),
                                                    ],
                                                  ),
                                                )
                                            }else...{
                                               Container(
                                                  padding: EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                                                 decoration: BoxDecoration(color: const Color.fromARGB(131, 164, 243, 121),borderRadius: BorderRadius.all(Radius.circular(3))),
                                                  child: Row(
                                                    children: [
                                                       Icon(Icons.currency_rupee,size: 15,),
                                                      Text(provider.pendingamount.toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.black)),
                                                    ],
                                                  ),
                                                )
                                            }
                                          ],
                                         ),
                                        ), 
                                     ],
                                     ),
                                      ],
                                    ),
                                                  ),
                                  ],
                                ),
                              );
  }
  
  DataRow _buildDataRow(
    BuildContext context,
    int index,
    String productName,
    String quantity,
    String price,
    String amount,
   
  ) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Tooltip(message: productName,child: TextOverflowByCharsInvoice(
        text:productName,
        maxCharactersPerLine: 25,
        fontSize: 12,
        maxLines: (productName.length / 25).ceil(),
      ))),
         DataCell(Tooltip(message: quantity,child: TextOverflowByCharsInvoice(
        text:quantity,
        maxCharactersPerLine: 6,
         fontSize: 12,
         maxLines: (quantity.length / 6).ceil(),
      ))),
         DataCell(Tooltip(message: price,child: TextOverflowByCharsInvoice(
        text:price,
        maxCharactersPerLine: 7,
         fontSize: 12,
         maxLines: (price.length / 7).ceil(),
      ))),
       DataCell(Tooltip(message: amount,child: TextOverflowByCharsInvoice(
        text:amount,
        maxCharactersPerLine: 7,
         fontSize: 12,
         maxLines: (amount.length / 7).ceil(),
      ))),
     
      ],
    );
  }

 //----------------------pdf generate---------------//

// provider file

Future<void> generateInvoicePDFs(BuildContext context,Profile profile) async {
  final provider = Provider.of<PaymentProvider>(context, listen: false);

  try {
    // Load assets (logo + footer) and font
    final Uint8List logoBytes =
        (await rootBundle.load('assets/Images/FullLogo.jpg')).buffer.asUint8List();
    // final Uint8List footerBytes =
    //     (await rootBundle.load('assets/Images/InvoiceFooter.JPG')).buffer.asUint8List();
    final fontBytes =
        (await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));

    final pw.Font ttf = pw.Font.ttf(fontBytes);

    final pdf = pw.Document();

    // Prepare invoice meta (fallbacks if missing)
    final header = (provider.invoiceHeader != null && provider.invoiceHeader.isNotEmpty)
        ? provider.invoiceHeader[0]
        : null;
    final invoiceNo = header?.invoiceId ?? 'INV_${DateTime.now().millisecondsSinceEpoch}';
    final invoiceDate = header?.date ?? provider.formattedDate ?? '';
   
    final billTo = provider.particularCustomerDetails != null && provider.particularCustomerDetails.isNotEmpty
        ? provider.particularCustomerDetails[0]
        : null;
    final items = provider.invoiceDetails ?? <dynamic>[];
  
    //final taxHeader  = provider.invoiceHeader?? <dynamic>[];

    // Layout constants & colors
    final PdfColor orange = PdfColor.fromInt(0xFFFFA500); // orange
    final PdfColor lightGrey = PdfColor.fromInt(0xFFF7F7F7);
    final PdfColor tableHeaderGrey = PdfColor.fromInt(0xFFEFEFEF);
    const int rowsPerPage = 13;
    final int totalPages = (items.length / rowsPerPage).ceil().clamp(1, 9999);
    
     //final columnColor = (columnIndex % 2 == 0) ? PdfColors.white : PdfColors.grey200;


    // Build pages
    for (int page = 0; page < totalPages; page++) {
      final start = page * rowsPerPage;
      final end = ((page + 1) * rowsPerPage > items.length) ? items.length : (page + 1) * rowsPerPage;
      final rowsOnThisPage = items.sublist(start, end);
     final emptyRowCount = rowsPerPage - rowsOnThisPage.length;

     //final pdf = pw.Document();

  final upiUrl = generateUpiUrl(
    upiId: "newveeralabels@kvb",
    upiName: profile.profileName,
    invoiceId: invoiceNo,
    amount: provider.pendingamount,
    //refId: refid
  );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(28, 18, 28, 18),
          theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttf, fontSize: 10)),
          header: (pw.Context ctx) {
            // Header with logo left and invoice title right
            return pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // logo
                  pw.Container(
                    width: 80,
                    height: 80,
                    child: pw.Image(pw.MemoryImage(logoBytes)),
                  ),
                  pw.SizedBox(width: 8),
                  // Spacer then right aligned invoice block
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Original for Recipient', style: pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 4),
                      pw.Text('INVOICE $invoiceNo', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: orange)),
                      pw.SizedBox(height: 4),
                      pw.Text('Date: ${invoiceDate.substring(0,10)}', style: pw.TextStyle(fontSize: 9)),
                    ],
                  )
                ],
              ),
            );
          },
           footer: (pw.Context ctx) {
            if (page == totalPages - 1){
              return pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left: Authorized sign area
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('AUTHORIZED SIGNATORY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.SizedBox(height: 24),
                        pw.Container(
                          width: 140,
                          height: 50,
                          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
                          child: pw.Center(child: pw.Text('Signature')),
                        ),
                      ],
                    ),
                  ),
                    pw.Expanded(
                      flex: 1,
                      child:
                           pw.Column(
                            children: [
                               pw.Text("Scan to Pay:"),
                            pw.SizedBox(height: 10),
                            pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: upiUrl,
                              width: 100,
                              height: 100,
                            ),
                            pw.SizedBox(height: 10),
                            if (provider.pendingamount == 0.0)
                              pw.Center(
                                child: pw.Text("PAID",
                                    style: pw.TextStyle(fontSize: 22, color: PdfColors.green)),
                              ),
                            ],
                           )),
                  // Right: Totals box
                  pw.SizedBox(width:100),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Container(                      
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          rowKeyValue('TOTAL BEFORE TAX', header?.subtotal.toStringAsFixed(2) ?? '0.00'),
                          rowKeyValue('TOTAL TAX AMOUNT', (header != null ? ((header.cgst ?? 0) + (header.sgst ?? 0) + (header.igst ?? 0)).toStringAsFixed(2) : '0.00')),
                          //rowKeyValue('ROUNDED OFF', (header?.roundOff != null) ? header.roundOff.toStringAsFixed(2) : '0.00'),
                          pw.Divider(),
                          rowKeyValueBold('TOTAL AMOUNT', header?.totalAmount?.toStringAsFixed(2) ?? '0.00'),
                          pw.SizedBox(height: 4),
                          rowKeyValueBold('AMOUNT DUE', provider?.pendingamount?.toStringAsFixed(2) ?? '0.00'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
              else return pw.Container();
          //   // Footer wave image
          //   return pw.Container(
          //     margin: const pw.EdgeInsets.only(top: 8),
          //     child: pw.Image(pw.MemoryImage(footerBytes), width: PdfPageFormat.a4.width, height: 80, fit: pw.BoxFit.cover),
          //   );
           },
          build: (pw.Context ctx) => [
            // Company / Bill to / Ship to row
            if(page<1)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Company info (left)
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(profile.profileName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.orange)),
                        pw.SizedBox(height: 6),
                        pw.Text(profile.profileAddress ,style: pw.TextStyle(color: PdfColors.black,fontSize:9.0)),
                                                       pw.SizedBox(height: 6.0,),
                                                       pw.Text('${profile.district}-${profile.pincode}' ,style: pw.TextStyle(color: PdfColors.black,fontSize:9.0)),
                                                       pw.SizedBox(height: 6.0,),
                                                      pw.Text('Contact No: ${profile.profileContact.toString()}',style: pw.TextStyle(color: PdfColors.black,fontSize: 9.0)),
                                                       pw.SizedBox(height: 6.0,),
                                                      pw.Text('GST No: ${profile.gst}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10.0)),
                      ],
                    ),
                  ),

                  // Bill to (middle)
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Bill to:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11,color: PdfColors.orange)),
                        pw.SizedBox(height: 6),
                        pw.Text(billTo?.customerName ?? provider.invoiceHeader?.firstWhere((_) => true)?.customerName ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text('${billTo?.customerAddress ?? ''}-${billTo?.state ?? ''}', style: pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 4),
                         pw.Text(billTo?.customerContact.toString() ?? '', style: pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 4),
                         pw.Text('@ ${billTo?.customeremailContact.toString() ?? ''}', style: pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 4),
                        pw.Text('GST: ${billTo?.gst ?? ''}', style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),

                  // Ship to (right)
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Ship to:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11,color: PdfColors.orange)),
                        pw.SizedBox(height: 6),
                        // For simplicity using same as billTo (adjust if provider has separate ship details)
                        pw.Text(billTo?.customerName ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text('${billTo?.customerAddress ?? ''}-${billTo?.state ?? ''}', style: pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 4),
                        pw.Text('PIN Code: ${billTo?.customerPincode?? ''}', style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 8),

            // Table header row
            pw.Container(
  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300, width: .5)),
  child: pw.Table(
    columnWidths: {
      0: pw.FixedColumnWidth(30), // NO
      1: pw.FlexColumnWidth(1), // PRODUCT
      2: pw.FixedColumnWidth(40), // QTY
      3: pw.FixedColumnWidth(50), // UNIT PRICE
      4: pw.FixedColumnWidth(70), // CGST
      5: pw.FixedColumnWidth(70), // SGST
      6: pw.FixedColumnWidth(80), // AMOUNT
    },
    // border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
    children: [
      // Header
      pw.TableRow(
        decoration: pw.BoxDecoration(color: tableHeaderGrey),
        children: [
          cell('NO', isHeader: true),
          cell('PRODUCT / SERVICE NAME', isHeader: true),
          cell('QTY', isHeader: true),
          cell('UNIT PRICE', isHeader: true),
          cell('CGST', isHeader: true),
          cell('SGST', isHeader: true),
          cell('AMOUNT', isHeader: true),
        ],
      ),

      // Data rows
      ...List.generate(rowsOnThisPage.length, (i) {
        final r = rowsOnThisPage[i];
        final bg = (i % 2 == 0) ? PdfColors.white : lightGrey;
        return pw.TableRow(
          decoration: pw.BoxDecoration(color: bg),
          children: [
            cell((start + i + 1).toString()),
            cell(r.productName ?? ''),
            cell(r.quantity?.toString() ?? '0'),
            cell((r.price ?? 0).toStringAsFixed(2)),
            cell((r.cgstPerProduct ?? 0).toStringAsFixed(2)),
            cell((r.sgstPerProduct ?? 0).toStringAsFixed(2)),
            cell((r.amount ?? 0).toStringAsFixed(2)),
          ],
        );
      }),

      // Grand total (only on last page)
      if (page == totalPages - 1)
      if(emptyRowCount>0)
       for (int k = 0; k < emptyRowCount; k++)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: (rowsOnThisPage.length + k) % 2 == 0 ? PdfColors.white : lightGrey),
                        children: List.generate(6, (index) => 
                         pw.Container(
                        //color: (index % 2 == 0) ? PdfColors.white : lightGrey,
                        height: 30,
                        child: cell(''),
                      ),
                        ),                        
                      ),
        (() {
          final totalQty =
              items.fold<double>(0, (sum, e) => sum + (e.quantity ?? 0));
          final totalPrice =
              items.fold<double>(0, (sum, e) => sum + (e.price ?? 0));
          final totalCgst =
              items.fold<double>(0, (sum, e) => sum + (e.cgstPerProduct ?? 0));
          final totalSgst =
              items.fold<double>(0, (sum, e) => sum + (e.sgstPerProduct ?? 0));
          final totalAmount =
              items.fold<double>(0, (sum, e) => sum + (e.amount ?? 0));

          return pw.TableRow(
            decoration: pw.BoxDecoration(border: pw.Border.symmetric(horizontal: pw.BorderSide(color: PdfColors.lime400,width: 2))),
            children: [
              pw.Container(
                height: 30,
                alignment: pw.Alignment.centerRight,
                padding: const pw.EdgeInsets.only(right: 4),
                //child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ),
              cells('Total', isBold: true),
              cells(totalQty.toString(), isBold: true),
              cells(totalPrice.toStringAsFixed(2), isBold: true),
              cells(totalCgst.toStringAsFixed(2), isBold: true),
              cells(totalSgst.toStringAsFixed(2), isBold: true),
              cells(totalAmount.toStringAsFixed(2), isBold: true),
            ],
          );
        }()),
    ],
  ),
),
            // Footer summary & signature on last page            
          ],
        ),
      );
      
    }

    // Save to Downloads/Invoices/Invoice_<invoiceNo>.pdf
    Directory downloadsDir;
    try {
      downloadsDir = (await getDownloadsDirectory()) ?? await getApplicationDocumentsDirectory();
    } catch (_) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final invoicesDir = Directory(p.join(downloadsDir.path, 'Invoices'));
    if (!await invoicesDir.exists()) {
      await invoicesDir.create(recursive: true);
    }

    final safeInvoiceNo = invoiceNo.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    final fileName = 'Invoice_$safeInvoiceNo.pdf';
    final filePath = p.join(invoicesDir.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show snack and open file
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invoice saved: $filePath')));
    // Try to open file automatically on desktop
    try {
      if (Platform.isWindows) {
        await Process.run('start', [filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } catch (_) {
      // ignore if open fails
    }
    
       //final pdfUrl = await ProfileSyncService.uploadInvoicesToFirebase(file,invoiceNo);

         await sendInvoiceEmailWithAttachment(
        pdfPath: file.path ,toEmail:  billTo?.customeremailContact.toString() ?? '',customerName:  billTo?.customerName.toString()??'valued Customer',
        invoiceNo:  invoiceNo,totalAmount:  header?.totalAmount?.toStringAsFixed(2) ?? '0.00'
           );

  } catch (e, st) {
    print('Error generating invoice PDF: $e\n$st');
    debugPrint('Error generating invoice PDF: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
  }
  

  }

/// Helper to produce consistent table cells
pw.Widget cells(String text, {bool isHeader = false, bool isBold = false}) {
  return pw.Container(
    //decoration: pw.BoxDecoration(border: pw.Border(top: )),
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight: isBold || isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        fontSize: isHeader ? 9 : 9,
      ),
    ),
  );
}

pw.Widget cell(String text, {bool isHeader = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: isHeader ? 9 : 9,
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

/// Helper for key-value rows in totals box
pw.Widget rowKeyValue(String key, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(key, style: pw.TextStyle(fontSize: 9)),
        pw.Text('$value', style: pw.TextStyle(fontSize: 9,)),
      ],
    ),
  );
}

pw.Widget rowKeyValueBold(String key, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(key, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.Text(' $value', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
}
}

Widget buildUpiQr(String upiId, String name, double amount, String refId) {
  final upiUrl =
      "upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR&tn=Invoice Payment&tr=$refId"; 

  return QrImageView(
    data: upiUrl,
    version: QrVersions.auto,
    size: 200.0,
  );
}