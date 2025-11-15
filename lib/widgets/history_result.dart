import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/models/species.dart';

class HistoryResult extends StatefulWidget {
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
  State<HistoryResult> createState() => _HistoryResultState();
}

class _HistoryResultState extends State<HistoryResult> {
  String formatTimestamp(Timestamp data) {
    Timestamp ts = data;
    DateTime dt = ts.toDate();
    return "${dt.hour}:${dt.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 25,
        bottom: widget.width <= 600 && widget.width < widget.height ? 110 : 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("History", style: widget.dark.textTheme.headlineLarge),
          Divider(color: Colors.white54, thickness: 0.5),
          SizedBox(height: 5),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('species_collection')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Belum ada data",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return widget.width <= 600 && widget.width < widget.height
                    ? ListView.builder(
                      itemCount: docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        Uint8List imageBytes = base64Decode(data['img_class']);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                              color: widget.dark.primaryColorDark,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              data['species'] ?? 'Unknown',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.watch_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 1),
                                            Text(
                                              formatTimestamp(
                                                data['createdAt'],
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Serif',
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            GestureDetector(
                                              onTap: () async {
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                        'species_collection',
                                                      )
                                                      .doc(docs[index].id)
                                                      .delete();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Data berhasil dihapus!",
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Gagal menghapus data: $e",
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                                size: 25,
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
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 1,
                          ),
                      itemCount: docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        Uint8List imageBytes = base64Decode(data['img_class']);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                              color: widget.dark.primaryColorDark,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data['species'] ?? 'Unknown',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: 'Serif',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
