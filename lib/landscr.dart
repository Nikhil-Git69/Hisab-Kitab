import 'package:expensetracker/dashboard.dart';
import 'package:expensetracker/navPages.dart';
import 'package:flutter/material.dart';



class landscr extends StatefulWidget {
  const landscr({super.key});

  @override
  State<landscr> createState() => _landscrState();
}

class _landscrState extends State<landscr> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Column(
          children: [
            SizedBox(height: 175,),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Image.asset("assets/hisab2.png"),
              ),
            ),

            SizedBox(height: 75,),

            Center(
              child: OutlinedButton.icon(onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => navPages()));
              },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFF215977),
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.arrow_right_alt, size: 40),



                label: Text("Get Started",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,

                  ),),
              ),
            ),
            SizedBox(height: 10,),





          ],
        ),


      ),
    );
  }
}
