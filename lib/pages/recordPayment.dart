import 'package:billit/providers/paymentprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentRecord extends StatefulWidget {
  final String payment;
  final String invoiceId;
  final double pendingamount;
  final bool isDrawerOpen;
  final VoidCallback onClose;

  const PaymentRecord({
    Key? key,
    required this.isDrawerOpen,
    required this.onClose,
    required this.invoiceId,
    required this.payment,
    required this.pendingamount,
  }) : super(key: key);

  @override
  State<PaymentRecord> createState() => _PaymentRecordState();
}

class _PaymentRecordState extends State<PaymentRecord> {
  int selectedButtonIndex = 0;
  String paymentMode = "Full";
  final TextEditingController _paymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
      final provider = Provider.of<PaymentProvider>(context,listen: false);
    return           
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close icon
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_right,
                      size: 28, color: Colors.black54),
                  onPressed: widget.onClose,
                ),
              ),

              const SizedBox(height: 10),

              // Title
              const Center(
                child: Text(
                  "Record Payment",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Full / Partial Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPaymentTypeButton(0, "Full"),
                  const SizedBox(width: 20),
                  _buildPaymentTypeButton(1, "Partial",),
                ],
              ),

              const SizedBox(height: 20),

              // Total & Pending Info
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: ₹${widget.payment}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text("Pending: ₹${widget.pendingamount}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Enter Amount Label
              const Text(
                "Enter the Amount",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),

              // TextField
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _paymentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                  ),
                ),
              ),

              const Spacer(),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton("SAVE", Colors.green, Colors.white, () {
                    if (_formKey.currentState?.validate() ?? true) {
                      
                      provider.addPayments(invoiceId: widget.invoiceId,paymentMode:paymentMode,pendingAmount:widget.pendingamount.toString(), cash: _paymentController.text);
                      widget.onClose(); // your save logic here
                    }
                  },context),
                  _buildActionButton("CANCEL", Colors.red, Colors.white, () {
                    widget.onClose();
                  },context),
                ],
              ),
            ],
          );
        
    
  }

  Widget _buildPaymentTypeButton(int index, String label,) {
    bool isSelected = selectedButtonIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButtonIndex = index;
          paymentMode = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade400),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed,BuildContext context) {
        
    return Expanded(
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
