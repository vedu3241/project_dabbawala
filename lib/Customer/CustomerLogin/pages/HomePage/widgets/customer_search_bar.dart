import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CustomerSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;

  const CustomerSearchBar({super.key, this.onSearch});

  @override
  _CustomerSearchBarState createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends State<CustomerSearchBar> {
  final StreamController<String> _textChangeStreamController = StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    super.initState();

    // ✅ Apply debounce effect with 500ms delay
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(Duration(milliseconds: 500))
        .distinct()
        .listen((text) {
      if (widget.onSearch != null) {
        widget.onSearch!(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.black38),
        hintText: "Find Your Dabbawala",
        hintStyle: GoogleFonts.poppins(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      onChanged: _textChangeStreamController.add, // ✅ Send input to debounce stream
    );
  }

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
