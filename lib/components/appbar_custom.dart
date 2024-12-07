import 'package:flutter/material.dart';

class AppbarCustom extends StatelessWidget {
  const AppbarCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "Sensores", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
        const Row(
          children: [
             Icon(Icons.notifications_outlined, size: 30),
          SizedBox(width: 15),
            CircleAvatar(
              radius: 25, 
              backgroundImage:  NetworkImage(
                "https://images.unsplash.com/photo-1464746133101-a2c3f88e0dd9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fG1hbnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"
              ),
            ),
          ],
        ),
      ],
    );
  }
}