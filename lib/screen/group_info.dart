import 'package:chatapp_firebase/screen/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class GroupInfo extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({Key? key, required this.groupId, required this.groupName, required this.adminName}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    getMembers();

  }

  getMembers()async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((val){
      setState(() {
        members=val;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       elevation: 0,
       backgroundColor: Theme.of(context).primaryColor,
       title: Text('Group Info'),
       actions: [
         IconButton(onPressed: (){
           showDialog(barrierDismissible:false,context: context, builder: (context){
             return AlertDialog(

               title: Text('Logout'),
               content: Text('Are you sure you want to exit?'),
               actions: [
                 IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.cancel,color: Colors.red,) ),
                 IconButton(onPressed: ()async{
                   DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroup(widget.groupId, widget.adminName.split('_')[1], widget.groupName).whenComplete(() {
                     nextScreenReplace(context,const HomePage());
                   });
                 }, icon:Icon(Icons.done,color: Colors.green,) )
               ],
             );
           });
         }, icon: const Icon(Icons.exit_to_app))
       ],
     ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(widget.groupName.substring(0,1).toUpperCase(),
                    style: TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group: ${widget.groupName}',style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                      const SizedBox(height: 10,),
                      Text('Admin: ${widget.adminName.split('_')[1]}',style: const TextStyle(fontSize: 16),)
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members']!=null){
            if(snapshot.data['members'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(snapshot.data['members'][index].toString().split('_')[1].substring(0,1).toUpperCase(),
                        style:TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500) ,
                        ),
                      ),
                      title: Text(snapshot.data['members'][index].toString().split('_')[1],style: TextStyle(fontSize: 17),),
                      subtitle: Text((snapshot.data['members'][index].toString().split('_')[0])),)
                  );
                },
              );

            }else{
              return const  Center(child:Text('No members'),);
            }

          }else {
            return const  Center(child:Text('No members'),);
          }


        }else{
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
        }

      },
    );
  }
}
