import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/models/species.dart';

class SpeciesCard extends StatelessWidget {
  SpeciesCard({super.key, required this.dark, required this.onSelected});

  final ThemeData dark;
  final Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255,
      child: ListView.builder(
        primary: false,
        itemCount: species.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Species s = species[index];
          return Padding(
            padding: EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: s.colour,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    spacing: 10,
                    children: [
                      Text(s.name, style: dark.textTheme.bodyMedium),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Image(image: s.img, width: 160, height: 160),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
