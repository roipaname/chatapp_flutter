

import 'package:chatapp_firebase/screen/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../shared/constant.dart';

class ProfilPage extends StatefulWidget {
  String userName;
  String email;
   ProfilPage({Key? key,required this.email,required this.userName}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Profile',style: TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.bold
        ),),

      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,color: Colors.grey[700],),
            const SizedBox(height: 15,),
            Text(widget.userName.split(" ")[0],textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 30,),
            const Divider(height: 2,color: Colors.grey,thickness: 2,),
            ListTile(
              onTap: (){
                nextScreen(context, HomePage());
              },

              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups',style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){

              },
              selected: true,
              selectedColor: Theme.of(context).primaryColor,

              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text('Profile',style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: ()async{
                showDialog(barrierDismissible:false,context: context, builder: (context){
                  return AlertDialog(

                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.cancel,color: Colors.red,) ),
                      IconButton(onPressed: ()async{await authService.signOut();Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Loginpage()), (route) => false);}, icon:Icon(Icons.done,color: Colors.green,) )
                    ],
                  );
                });


              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout',style: TextStyle(
                  color: Colors.black
              ),),
            )

          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,color: Colors.grey[700],size: 200,),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name",style: TextStyle(
                  fontSize: 17,
                ),),
                 Text(widget.userName,style: const TextStyle(
                  fontSize: 17,
                ),)
              ],
            ),
            Divider(height: 20,thickness: 1,color: Colors.grey[700],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email",style: TextStyle(
                  fontSize: 17,
                ),),
                Text(widget.email,style: const TextStyle(
                  fontSize: 17,
                ),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
