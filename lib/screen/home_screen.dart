
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/beranda.dart';

import 'package:flutter_application_1/screen/globals.dart' as globals;

import 'package:flutter_application_1/screen/pengaturan.dart';
import 'package:flutter_application_1/screen/premium.dart';
import 'package:flutter_application_1/screen/profile.dart';
import 'package:flutter_application_1/screen/user.dart';
import 'package:flutter_application_1/utils/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Beranda(),
    const MailScreen(),

  ];

  

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
IconData NAMA=Icons.abc;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:globals.warna1,
        currentIndex: _currentIndex,
        items:  [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex==0 ? homeFilledIcon : homeOutlinedIcon,
              color: globals.warna2,
              width: 24,
              height: 24,
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex==3 ? envelopeFilledIcon : envelopeOutlinedIcon,
              color: globals.warna2,
              height: 24,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}


class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:  const WidgetDrawer(),
        backgroundColor: globals.warna1,
        appBar:AppBar(
            elevation: 1,
            backgroundColor: globals.warna1,
            leading: Builder(builder:(context){
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child:Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              globals.url,
              fit: BoxFit.cover,
            ),
          ),
        ), 
        );
        } ),
            actions: <Widget>[
               IconButton(
              icon:  Icon(Icons.settings,color: globals.warna2),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pengaturan()));
              },
            )
            ],
            title: Container(
              decoration: BoxDecoration(
                  color: globals.warna3,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child:  TextField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintText: "   Search Direct Messages",
                  hintStyle: TextStyle(
                    color: globals.warna2,
                  ),
                  border: InputBorder.none,
                ),
              ),
            )),
        body: Stack(
          children: <Widget>[
            Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom+300,
                left: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: globals.warna1,
                  child:  Text(
                  "Welcome to your inbox!",
                  style: TextStyle(
                    color: globals.warna2,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ))),
              Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom+225,
                  left: 20,
                  child:
                  Container(
                  width: MediaQuery.of(context).size.width,
                  color: globals.warna1,
                  child:const Text(
                  "Drop a line, share Tweets and more with private conversations between you and others on Twitter.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 80, 79, 79),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                )
                  )
                  
                ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom+160,
              left: 20,
              child:
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>user()))
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.blue
                ),
                child: const Text("Write a message",style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom+30,
              right :MediaQuery.of(context).viewInsets.right+25,
                child: Container(
                  decoration:const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      )),
                ),
            ),
            
          ],
        ));
  }
}

class WidgetDrawer extends StatefulWidget {
  const WidgetDrawer({super.key});

  @override
  State<WidgetDrawer> createState() => _WidgetDrawerState();
}

class _WidgetDrawerState extends State<WidgetDrawer> {

  bool tombol=false;
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      width: MediaQuery.of(context).size.width-110,
      backgroundColor: globals.warna1,
      child:Stack(
      children: <Widget>[
        Positioned(
          top: 40,
          left: 10,
          child: Container(
                                width: 50,
                                height: 50,
                                decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(globals.url),
                                    fit: BoxFit.cover
                                  )
                                ),
                              )
        ),
        Positioned(
          top: 100,
          left: 10,
          child: Text(globals.nama,style: TextStyle(
                color: globals.warna2,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),),
            ),
        Positioned(
          top:100,
          left: 110,
          child: Icon(Icons.lock,color: globals.warna2,size: 20,),
        ),
        const Positioned(
          top: 125,
          left: 10,
          child: Text("@randygantengbanget",style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),),
            ),
        Positioned(
          top: 160,
          left: 10,
          child: Text("4",style: TextStyle(
                color: globals.warna2,
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),),
            ),
        const Positioned(
          top: 160,
          left: 25,
          child: Text("Mengikuti",style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 16,
                fontWeight: FontWeight.normal
              ),),
            ),
        Positioned(
          top: 160,
          left: 105,
          child: Text("18",style: TextStyle(
                color: globals.warna2,
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),),
            ),
        const Positioned(
          top: 160,
          left: 129,
          child: Text("Pengikut",style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 16,
                fontWeight: FontWeight.normal
              ),),
            ),
        Positioned(
          top: 240,
          left: 10,
          child: Icon(Icons.account_box,color: globals.warna2,size: 30,),
        ),
        Positioned(
          top: 234,
          left: 50,
          
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=> const Profile()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor: globals.warna1
            ),
            child:Text("Profil",style: TextStyle(
            color: globals.warna2,
            fontSize: 25,
            ),),
          ),
        ),
        Positioned(
          top: 304,
          left: 10,
          child: Icon(FontAwesomeIcons.xTwitter,color: globals.warna2,size: 30,),
        ),
        Positioned(
          top: 295,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Premium()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor: globals.warna1,
              
            ),
            child:Text("Premium",style: TextStyle(
            color: globals.warna2,
            fontSize: 25,
            ),),
          ),
        ),
        Positioned(
          top: 350,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor: globals.warna1
            ),
            child:Text("Markah",style: TextStyle(
            color: globals.warna2,
            fontSize: 25,
            ),),
          ),
        ),
        Positioned(
          top: 410,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor: globals.warna1
            ),
            child:Text("Daftar",style: TextStyle(
            color: globals.warna2,
            fontSize: 25,
            ),),
          ),
        ),
        Positioned(
          top: 465,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor: globals.warna1
            ),
            child:Text("Monetisasi",style: TextStyle(
            color: globals.warna2,
            fontSize: 25,
            ),),
          ),
        ),
        Positioned(
          top: 210,
          left: 10,
          child: Container(
            width: 290,
            height: 2,
            color: const Color.fromARGB(255, 107, 103, 103),
          ),
        ),
        Positioned(
          top: 580,
          left: 10,
          child: Container(
            width: 290,
            height: 2,
            color: const Color.fromARGB(255, 107, 103, 103),
          ),
        ),
        Positioned(
          top: 600,
          left: 10,
          child:Text("Alat Profesional",style: TextStyle(
            color: globals.warna2,
            fontSize: 17,
            ),),
        ),
        Positioned(
          top: 650,
          left: 10,
          child:Text("Pengaturan & Dukungan",style: TextStyle(
            color: globals.warna2,
            fontSize: 17,
            ),),
        ),
        Positioned(
          top: 585,
          left: 240,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor:globals.warna1,
              shape: const CircleBorder(),
            ),
            child: Icon(Icons.arrow_drop_down_outlined,size: 30,color: globals.warna2,),
          ),
        ),
        Positioned(
          top: 635,
          left: 240,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 114, 112, 112),
              elevation: 0,
              backgroundColor:globals.warna1,
              shape: const CircleBorder(),
            ),
            child: Icon(Icons.arrow_drop_down_outlined,size: 30,color: globals.warna2,),
          ),
        ),
        Positioned(
          top: 358,
          left: 10,
          child: Icon(Icons.bookmark_border,color: globals.warna2,size:35 ),
        ),
        Positioned(
          top: 416,
          left: 10,
          child: Icon(Icons.library_books,color: globals.warna2,size: 35,),
        ),
        Positioned(
          top: 470,
          left: 10,
          child: Icon(Icons.money,color: globals.warna2,size: 35,),
        )
        
      ],
    ));
  }
}

