import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkio/auth/authentication.dart';
import 'package:talkio/auth/welcome.dart';
import 'package:talkio/components/myProfileItems.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final User? currentUser;
  Authentication api = Authentication();

  @override
  void initState() {
    super.initState();
    currentUser = Supabase.instance.client.auth.currentUser;
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: appbackground,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Handle Profile tap here
                },
              ),
              ListTile(
                title: const Text('Settings',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Handle Settings tap here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appbackground,

        appBar: AppBar(
          backgroundColor: appbackground,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: backButton, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: backButtonIcon,
                    size: 20,
                  )),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.3 - 10,),
                  const MyText(
                  text: "Profile",
                  fontSize: 30,
                  textColor: apptextcolor,
                  fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 60,
                              child:
                                  currentUser?.userMetadata?['avatar_url'] !=
                                          null
                                      ? Image.network(
                                          "${currentUser?.userMetadata?['avatar_url']}",
                                          scale: 0.1,
                                        )
                                      : Image.asset('assets/image/profile.jpg'),
                            ),
                        ),
                        const SizedBox(height: 10,),
                        MyText(
                            text: "${currentUser?.userMetadata?['name']}",
                            fontSize: 30,
                            textColor: apptextcolor,
                            fontWeight: FontWeight.bold,
                          ),
                        MyText(
                            text: "${currentUser?.email}",
                            fontSize: 20,
                            textColor: backButtonIcon,
                            fontWeight: FontWeight.bold,
                          ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                MyProfileItems(iconData: Icons.person_rounded,text: "Edit Bio",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.settings,text: "Preferences",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.lock,text: "Account Security",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.edit,text: "Customize Profile ",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.language,text: "Change Language",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.security,text: "Two-Factor Authentication",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.info,text: "Customer Support",onPressed: () => _showBottomSheet(context)),
                MyProfileItems(iconData: Icons.logout,text: "Logout",onPressed: () async  {
                  int status = await api.logOutUser();
                  if(status == 200){
                    Get.to(()=> const Welcome(), transition: Transition.cupertino, duration: const Duration(milliseconds: 500));
                  }
                }),
              ],
            )
          ),
        ),
      ),
    );
  }
}
