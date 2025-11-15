import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/models/species.dart';

class HistoryResult extends StatelessWidget {
  const HistoryResult({
    super.key,
    required this.dark,
    required this.width,
    required this.height,
  });

  final ThemeData dark;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 25,
        bottom: width <= 600 && width < height ? 110 : 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("History", style: dark.textTheme.headlineLarge),
          Divider(color: Colors.white54, thickness: 0.5),
          SizedBox(height: 5),
          Expanded(
            child:
                width <= 600 && width < height
                    ? ListView.builder(
                      primary: true,
                      itemCount: species.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Species s = species[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                              color: dark.primaryColorDark,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 1,
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 5,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Text(
                                              s.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          s.desc,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'Serif',
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.watch_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            SizedBox(width: 1),
                                            Text(
                                              "4.35 AM",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(7),
                                              decoration: ShapeDecoration(
                                                shape: StadiumBorder(),
                                                color: Color(0xFF58B82B),
                                              ),
                                              child: Text(
                                                "Lihat kembali",
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Serif',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: Image(
                                          image: s.imgWild,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        right: 3,
                                        bottom: 0,
                                        child: Transform.rotate(
                                          angle: -90 * 3.14159 / 180,
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3 / 1,
                      ),
                      primary: true,
                      itemCount: species.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Species s = species[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                              color: dark.primaryColorDark,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 1,
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 5,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Text(
                                              s.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          s.desc,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'Serif',
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.watch_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            SizedBox(width: 1),
                                            Text(
                                              "4.35 AM",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(7),
                                              decoration: ShapeDecoration(
                                                shape: StadiumBorder(),
                                                color: Color(0xFF58B82B),
                                              ),
                                              child: Text(
                                                "Lihat kembali",
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Serif',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: Image(
                                          image: s.imgWild,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        right: 3,
                                        bottom: 0,
                                        child: Transform.rotate(
                                          angle: -90 * 3.14159 / 180,
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
