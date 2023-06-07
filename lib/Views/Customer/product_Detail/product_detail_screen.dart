import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class productDetailScreen extends StatefulWidget {
  final dynamic productData;

  const productDetailScreen({super.key, required this.productData});

  @override
  State<productDetailScreen> createState() => _productDetailScreenState();
}

class _productDetailScreenState extends State<productDetailScreen> {
  int _imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'fee',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                        widget.productData['imageUrls'][_imageIndex]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['imageUrls'].length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _imageIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.lightGreen.shade900,
                                ),
                              ),
                              height: 60,
                              width: 60,
                              child: Image.network(
                                  widget.productData['imageUrls'][index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                'Ksh' +
                    ' ' +
                    widget.productData['productPrice'].toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen.shade900,
                ),
              ),
            ),
            Text(
              widget.productData['productName'],
              style: TextStyle(
                fontSize: 22,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'product description',
                      style: TextStyle(
                        color: Colors.lightGreen.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'view more',
                      style: TextStyle(
                        color: Colors.lightGreen.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Text(
                  widget.productData['productDescription'],
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
