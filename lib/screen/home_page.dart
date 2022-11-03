import 'package:chatapp_firebase/auth/login.dart';
import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/screen/profile_page.dart';
import 'package:chatapp_firebase/screen/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/shared/constant.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName="";
  String email="";
  Stream? groups;
  bool _isLoading=false;
  String groupName="";

  @override
  void initState() {
    super.initState();
    gettingUserData();

  }

  String getId(String res){
    return res.substring(0,res.indexOf('_'));
  }

  String getName(String res){
    return res.substring(res.indexOf('_')+1);
  }
  gettingUserData() async{
    await HelperFunctions.getUserEmailFromSF().then((value){

      setState(() {
        email=value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName=value!;
      });
    });

    //getting list of snapshot
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroup().then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });


  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(


      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, const SearchPage());
          }, icon:const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Groups',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,color: Colors.grey[700],),
            const SizedBox(height: 15,),
            Text(userName
              ,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 30,),
            const Divider(height: 2,color: Colors.grey,thickness: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups',style: TextStyle(
                color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                 nextScreenReplace(context, ProfilPage(userName: userName,email: email,));
              },

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

                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.cancel,color: Colors.red,) ),
                      IconButton(onPressed: ()async{await authService.signOut();Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Loginpage()), (route) => false);}, icon:const Icon(Icons.done,color: Colors.green,) )
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add,color: Colors.white,size: 30,),

      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(context: context,
        barrierDismissible: false,

        builder: (context){

      return StatefulBuilder(
        builder: (context,setState){


        return AlertDialog(
          title: const Text("Create a group",
            textAlign: TextAlign.left,

          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading==true?const Center(child: CircularProgressIndicator(color: Colors.redAccent,),):TextField(
                onChanged: (val){
                  setState(() {
                    groupName=val;
                  });

                },
                style: const TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                    ),
                    borderRadius: BorderRadius.circular(30)
                  ),
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor
                        ),
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const Text("Cancel"),style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),),
            ElevatedButton(onPressed: ()async{
              if(groupName!=""){
                setState(() {
                  _isLoading=true;
                });
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                  _isLoading=false;
                  Navigator.of(context).pop();
                });
                showSnackbar(context, Colors.green, "Group Created Successfully");
              }
            }, child: const Text("Create"),style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),)
          ],
        );}
      );


    });
  }
  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups']!=null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context,index){
                  int reverseIndex= snapshot.data['groups'].length-index-1;
                  return GroupTile(groupName: getName(snapshot.data['groups'][reverseIndex]), userName:snapshot.data['fullName'], groupId: getId(snapshot.data['groups'][reverseIndex]));

                },
              );

            }else{
              return noGroupWidget();
            }

          }else{
            return noGroupWidget();
            }

        }else{
          return const Center(child: CircularProgressIndicator(color: Colors.redAccent,),);
        }

      },
    );

  }
  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          GestureDetector(onTap:(){
            popUpDialog(context);
          },child: Icon(Icons.add_circle,color:Colors.grey[700],size: 75,)),
         const SizedBox(height: 20,),
          const Text('You have nto joined any group,tap on the icon to create a group or also search on the search button',textAlign: TextAlign.center,)
        ]
      ),
    );
  }
}
