// Updated: customer_hireform.dart (Complete version)
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/controller/hire_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/dabbawala_model.dart';
import 'Pending_request.dart';
import '../../HireHistory/controller/hire_history_controller.dart';
import '../../Hire/model/hire_dabbawala_model.dart';

class CustomerFormScreen extends StatefulWidget {
  final Dabbawala dabbawala;
  final String dabbawalaId;
  final String customerId;

  const CustomerFormScreen({
    super.key,
    required this.dabbawala,
    required this.dabbawalaId,
    required this.customerId,
  });

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedSubscription = 'Monthly';

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HireController controller = Get.find<HireController>();
    final HireHistoryController historyController = Get.find<HireHistoryController>();

    return Scaffold(
      appBar: AppBar(
        title:  Text('hire_dabbawala'.tr, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 243, 245, 244),
        foregroundColor: const Color.fromARGB(255, 14, 13, 13),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dabbawala info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: widget.dabbawala.profilePicUrl != null && 
                                    widget.dabbawala.profilePicUrl!.isNotEmpty
                        ? NetworkImage(widget.dabbawala.profilePicUrl!)
                        : const AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dabbawala.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.dabbawala.city,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'customer_information'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 32, 32, 33),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('name'.tr, Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _surnameController,
                      decoration: _inputDecoration('surname'.tr, Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your surname';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: _inputDecoration('address'.tr, Icons.home),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('phone_number'.tr, Icons.phone,),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                     Text(
                      'subscription_plan'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSubscription,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Color(0xFF2D3748), fontSize: 16),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSubscription = newValue!;
                            });
                          },
                          items: <String>['Weekly', 'Monthly', 'Yearly']
                              .map<DropdownMenuItem<String>>((String value) {
                            IconData icon;
                            switch (value) {
                              case 'weekly':
                                icon = Icons.calendar_view_week;
                                break;
                              case 'monthly':
                                icon = Icons.calendar_month;
                                break;
                              case 'yearly':
                                icon = Icons.calendar_today;
                                break;
                              default:
                                icon = Icons.calendar_month;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, color: const Color(0xFF507dbc), size: 20),
                                  const SizedBox(width: 12),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.currentCustomerInfo.value = {
                      "name": "\${_nameController.text} \${_surnameController.text}",
                      "address": _addressController.text,
                      "mobileNo": _phoneController.text,
                      "city": "",
                    };

                    controller.sendHireRequest(
                      widget.dabbawalaId,
                      widget.customerId,
                      _selectedSubscription,
                      widget.dabbawala,
                    );

                    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
                    final newRequest = HireRequest(
                      requestId: requestId,
                      dabbawalaId: widget.dabbawalaId,
                      customerId: widget.customerId,
                      schedule: _selectedSubscription,
                      status: 'Pending',
                      dabbawalaDetails: widget.dabbawala,
                      requestDate: DateTime.now().toIso8601String(), fromDate: '', expiryDate: '', customerDetails: {}, id: '', subscriptionType: '',
                    );

                    historyController.addHireRequest(newRequest);

                    Get.offAll(() => const PendingRequestsScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF507dbc),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  'submit_request'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF507dbc)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF38A169), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
