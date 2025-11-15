import 'package:flutter/material.dart';

final List<Species> species = [
  Species(
    AssetImage('assets/tiger.png'),
    'Tiger',
    'Kucing terbesar di dunia, dikenal dengan pola garis\n-garis vertikal hitam pada bulu oranye-cokelatnya.\nHarimau adalah predator soliter dan teritorial.',
    Color(0xFF9BB168),
    AssetImage('assets/tiger_in_the_wild.jpeg'),
  ),
  Species(
    AssetImage('assets/lion.png'),
    'Lion',
    'Singa adalah satu-satunya kucing yang hidup secara berkelompok\n(*pride*). Singa jantan mudah dikenali dari\nsurainya yang lebat.',
    Color(0xFFED7E1C),
    AssetImage('assets/lion_in_the_wild.jpeg'),
  ),
  Species(
    AssetImage('assets/leopard.png'),
    'Leopard',
    'Macan Tutul dikenal karena pola bintik gelapnya\n(disebut *rosette*). Mereka adalah pemanjat yang sangat baik\ndan sering membawa hasil buruannya ke atas pohon.',
    Color(0xFFC2B1FF),
    AssetImage('assets/leopard_in_the_wild.jpeg'),
  ),
  Species(
    AssetImage('assets/puma.png'),
    'Puma',
    'Juga dikenal sebagai Cougar atau Mountain Lion. Puma\nadalah kucing besar yang sangat adaptif dan memiliki rentang\nhabitat terluas di antara semua mamalia darat liar di belahan Barat.',
    Color(0xFF8F8A7D),
    AssetImage('assets/puma_in_the_wild.jpeg'),
  ),
  Species(
    AssetImage('assets/cheetah.png'),
    'Cheetah',
    'Dikenal sebagai hewan tercepat di darat. Cheetah\nmemiliki tubuh ramping, dada dalam, dan bintik hitam padat yang\nmembantunya berburu di padang rumput terbuka.',
    Color(0xFFF9F7A2),
    AssetImage('assets/cheetah_in_the_wild.jpeg'),
  ),
];

class Species {
  final AssetImage img;
  final String name;
  final String desc;
  final Color colour;
  final AssetImage imgWild;

  Species(this.img, this.name, this.desc, this.colour, this.imgWild);
}
