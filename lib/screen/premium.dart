import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  State<Premium> createState() => _Premium();
}

String name = 'Randy Censon';
int total = 0;
Container makeIcon(IconData id, double s) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black)),
    child: InkWell(
      child: Icon(
        id,
        size: s,
        color: Colors.blue,
      ),
      onTap: () {
        
      },
    ),
    
  );
}

class _Premium extends State<Premium> {
  void popDialog(BuildContext context, String s, String v) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation:'),
          content: SizedBox(
              width: 100,
              height: 200,
              child: Column(
                children: [
                  Image.asset(
                    s,
                    scale: 10,
                  ),
                  Row(
                    children: [
                      Text("    Review: $name"),
                      CircleAvatar(
                        backgroundImage: AssetImage(v),
                        radius: 10,
                        backgroundColor: Colors.transparent,
                      )
                    ],
                  )
                ],
              )),
          actions: [
            TextButton(
              onPressed: () {
                
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                changeTotal(total+1);
                Navigator.of(context).pop();
              },
              child: const Text('Buy'),
            ),
          ],
        );
      });
}

  void changeTotal(int t){
    setState(() {
      total = t;
    });
}
  
  String name = 'Monetisasi \$\$\$';
  final List<Widget> _carousel_slides = [
    Image.asset("assets/images/cat_cart.jpg"),
    Image.asset("assets/images/cat_ok.jpg"),
    Image.asset("assets/images/elon_tweet.png"),
  ];
  final List<String> _saleList = [
    "assets/images/tbg.jpeg",
    "assets/images/tbm.png",
    "assets/images/tby.png",
    "assets/images/nb.png",
    "assets/images/sb.png",
  ];
  final List<String> _verif_icon = [
    "assets/images/verif_emas.png",
    "assets/images/verif_biru.png",
    "assets/images/verif_biru.png",
    "assets/images/verif_netflix.png",
    "assets/images/verif_spotify.png",
  ];
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {setState(() {
                        total=0;
                      });},
                      icon: const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "$total",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            const SizedBox(width: 10),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Center(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        body: Container(
          
          width: _screenSize.width,
          height: _screenSize.height,
          decoration: const BoxDecoration(
              
              gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.black,
            Colors.black,
            Colors.black
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: _screenSize.width * 0.75,
                  height: _screenSize.height*0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 0, 134, 244)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CarouselSlider(
                    items: _carousel_slides,
                    options: CarouselOptions(
                      
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20, width: _screenSize.width),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _saleList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        
                        popDialog(
                            context, _saleList[index], _verif_icon[index]);
                       
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            (_saleList[index]),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}