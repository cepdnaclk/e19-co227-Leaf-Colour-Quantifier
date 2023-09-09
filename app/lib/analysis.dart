import 'package:flutter/material.dart';
import 'package:leaf_spectrum/components/histogram.dart';

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Analysis",

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
              const SizedBox(height: 20,),
              AspectRatio(
                aspectRatio: 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromRGBO(
                          64, 72, 80, 0.4196078431372549)
                  ),
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: const Histogram(),
                ),
              ),
              const SizedBox(height: 40,),
              Center(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.black),
                    onPressed: () {},
                    label: const Text('Analyse another leaf'),
                    icon: const Icon(
                        Icons.restart_alt_sharp
                    )
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
