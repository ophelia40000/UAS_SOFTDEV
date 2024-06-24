import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/edit_profile.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/post_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: globals.warna1,
        body:
        Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: 600,
                height: 132,
                color: Colors.blue,
              ),
            ),
            Positioned(
              left: 10,
              top: 90,
              width:80,
              height:80,
              child:Container(                
                decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: globals.warna2,
                image: DecorationImage(
                image: NetworkImage(globals.url),
                fit: BoxFit.cover
                  )
                    ),
                    )
            ),
            Positioned(
                right: MediaQuery.of(context).viewInsets.right+15,
                top: 140,
                width: 105,
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: globals.warna2,
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      side:  BorderSide(color: globals.warna2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(30, 30)
                    ),
                    child: const Text(
                      "Edit Profile",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
                Positioned(
                  top: 26,
                  child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 33, 33, 48),
                  ),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>const BottomNavBar()));
                  },
                  child:  Positioned(
              top: 20,
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
                ), 
                ),
             Positioned(
              top: 26,
              right: MediaQuery.of(context).viewInsets.left+40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 33, 33, 48),
                ),
                onPressed: () {
                  
                },
                child:  const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
              ),
              
            ),
            
             Positioned(
              top: 26,
              right: MediaQuery.of(context).viewInsets.right-5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 33, 33, 48),
                ),
                onPressed: () {
                  
                },
                child: const Icon(
                Icons.more_vert,
                size: 30,
                color: Colors.white,
              ),
              ),
            ),
            
            
            const Positioned(
              top: 245,
              left: 10,
              child: Icon(
                Icons.egg_outlined,
                size: 20,
                color: Color.fromARGB(252, 121, 106, 106),
              ),
            ),
            const Positioned(
              top: 275,
              left: 10,
              child: Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: Color.fromARGB(252, 121, 106, 106),
              ),
            ),
             Positioned(
              top: 184,
              left: 10,
              child: Text(
                globals.nama,
                style: TextStyle(
                    fontSize: 30,
                    color: globals.warna2,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 225,
              left: 10,
              child: Text(
                '@${globals.nama}',
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal),
              ),
            ),
             Positioned(
              top: 400,
              left: 20,
              child: Text(
                "belum ada postingan",
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 19,
                fontWeight: FontWeight.normal),
              ),
            ),
            const Positioned(
              top: 247,
              left: 40,
              child: Text(
                'Lahir 11 Agustus 2003',
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal),
              ),
            ),
            const Positioned(
              top: 277,
              left: 40,
              child: Text(
                'Bergabung Desember 2021',
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal),
              ),
            ),
            const Positioned(
              top: 310,
              left: 45,
              child: Text(
                ' Mengikuti',
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal),
              ),
            ),
            const Positioned(
              top: 310,
              left: 150,
              child: Text(
                ' Pengikut',
                style: TextStyle(
                color: Color.fromARGB(255, 80, 79, 79),
                fontSize: 15,
                fontWeight: FontWeight.normal),
              ),
            ),
            Positioned(
              top: 308,
              left: 13,
              child: Text(
                '100',
                style: TextStyle(
                    fontSize: 17, color: globals.warna2,),
              ),
            ),
             Positioned(
              top: 308,
              left: 126,
              child: Text(
                '97',
                style: TextStyle(
                    fontSize: 17, color: globals.warna2),
              ),
            ),
            
             Positioned(
                    top: 335,
                    child: Container(
                      width: 395,
                      height: 50,
                      color: globals.warna1,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(50, 0)),
                    ),
                    onPressed: () => {},
                    child:  Text(
                      "Postingan",
                      style: TextStyle(
                        color: globals.warna2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(50, 0)),
                    ),
                    onPressed: () => {},
                    child:  Text(
                      "Balasan",
                      style: TextStyle(
                        color: globals.warna2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(50, 0)),
                    ),
                    onPressed: () => {},
                    child:  Text(
                      "Sorotan",
                      style: TextStyle(
                        color: globals.warna2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(50, 0)),
                    ),
                    onPressed: () => {},
                    child:Text(
                      "Media",
                      style: TextStyle(
                        color: globals.warna2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(50, 0)),
                    ),
                    onPressed: () => {},
                    child:  Text(
                      "Suka",
                      style: TextStyle(
                        color: globals.warna2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                        ],
                      ),
                    ),
                  ),
          Positioned(
              top: 660,
              left: 320,
              child:ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const PostScreen()));
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.blue,
                ),
                child:const Icon(Icons.add,color: Colors.white,),
              ),
              ),
          ],
        )
        );
  }
}
