import 'dart:convert';

import 'package:dabbawala/features/MyCustomers/controller/api_service.dart';
import 'package:dabbawala/features/MyCustomers/model/hireReqModel.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DabbawalaHireRequestsScreen extends StatefulWidget {
  final String dabbawalaId;
  final String dabbawalaName;

  const DabbawalaHireRequestsScreen({
    Key? key,
    required this.dabbawalaId,
    required this.dabbawalaName,
  }) : super(key: key);

  @override
  State<DabbawalaHireRequestsScreen> createState() =>
      _DabbawalaHireRequestsScreenState();
}

class _DabbawalaHireRequestsScreenState
    extends State<DabbawalaHireRequestsScreen> {
  late Future<List<HireRequest>> _hireRequests;
  String _filterStatus = 'All';
  final List<String> _statusOptions = [
    'All',
    'pending',
    'accepted',
    'rejected'
  ];

  @override
  void initState() {
    super.initState();
    _hireRequests = DabbawalaHireRequestsApiService().fetchHireRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hire Requests"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _hireRequests =
                    DabbawalaHireRequestsApiService().fetchHireRequests();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // _buildDabbawalaInfo(),
          _buildFilterBar(),
          Expanded(
            child: FutureBuilder<List<HireRequest>>(
              future: _hireRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hire requests found'));
                } else {
                  final filteredRequests = _filterStatus == 'All'
                      ? snapshot.data!
                      : snapshot.data!
                          .where((req) => req.status == _filterStatus)
                          .toList();

                  return filteredRequests.isEmpty
                      ? Center(
                          child: Text('No ${_filterStatus} requests found'))
                      : ListView.builder(
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            return _buildRequestCard(filteredRequests[index]);
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDabbawalaInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.orange.shade50,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange.shade100,
            child: Icon(Icons.delivery_dining,
                size: 35, color: Colors.orange.shade800),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dabbawalaName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: ${widget.dabbawalaId.substring(0, 8)}...',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('Filter by status:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusOptions.map((status) {
                  final isSelected = status == _filterStatus;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(status),
                      onSelected: (selected) {
                        setState(() {
                          _filterStatus = status;
                        });
                      },
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.orange.shade200,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(HireRequest request) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    // Get customer name (in a real app, this would come from API)
    final customerName = 'Customer ${request.customerId.substring(0, 5)}';

    // Status color indicators
    Color getStatusColor() {
      switch (request.status) {
        case 'pending':
          return Colors.orange;
        case 'accepted':
          return Colors.green;
        case 'rejected':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to request details page
          // For now, just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'View details for request ${request.id.substring(0, 8)}')));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    customerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      request.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: getStatusColor(),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today,
                  'Schedule: ${request.schedule.toUpperCase()}'),
              _buildInfoRow(Icons.date_range,
                  'From: ${dateFormatter.format(request.fromDate)}'),
              _buildInfoRow(Icons.access_time,
                  'Requested: ${dateFormatter.format(request.createdAt)} at ${timeFormatter.format(request.createdAt)}'),
              if (request.note != null && request.note!.isNotEmpty)
                _buildInfoRow(Icons.note, 'Note: ${request.note}'),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (request.status == 'pending') ...[
                    _buildActionButton(
                      label: 'Reject',
                      color: Colors.red.shade100,
                      textColor: Colors.red.shade700,
                      onPressed: () {
                        // rejection logic
                        DabbawalaHireRequestsApiService()
                            .updateStatus(request.id, "rejected", context);
                      },
                    ),
                    SizedBox(width: 8),
                    _buildActionButton(
                      label: 'Accept',
                      color: Colors.green.shade100,
                      textColor: Colors.green.shade700,
                      onPressed: () {
                        // accept logic
                        DabbawalaHireRequestsApiService()
                            .updateStatus(request.id, "accepted", context);
                      },
                    ),
                  ] else if (request.status == 'accepted') ...[
                    _buildActionButton(
                      label: 'Contact',
                      color: Colors.blue.shade100,
                      textColor: Colors.blue.shade700,
                      onPressed: () {
                        // Handle contact logic
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Contacting customer')));
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}
