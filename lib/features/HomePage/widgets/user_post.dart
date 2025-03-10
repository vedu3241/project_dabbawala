import 'package:flutter/material.dart';

class UserPost extends StatelessWidget {
  const UserPost({super.key, required this.name});

  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // User PFP and name
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[300], shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              //more option
              Icon(Icons.more_horiz)
            ],
          ),
        ),
        // Post image
        Container(
          height: 400,
          color: Colors.grey[300],
        ),
        // Below post buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(Icons.favorite_border),
              ),
              Text("223"),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(Icons.chat_bubble_outline),
              ),
              Text("7"),
              const SizedBox(width: 12),
              Icon(Icons.send)
            ],
          ),
        ),

        //Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: [
              TextSpan(
                  text: "$name ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "Delivering happiness, one meal at a time! 🚲✨ #DabbawalaDiaries #MumbaiMagic #TiffinTales",
                  style: TextStyle(
                    color: Colors.black,
                  ))
            ],
          )),
        )
      ],
    );
  }
}
