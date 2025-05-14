import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkio/api/api.dart';
import 'package:talkio/components/MySearch.dart';
import 'package:talkio/components/myButton.dart';
import 'package:talkio/components/myInput.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/screens/singleChat.dart';
import 'package:talkio/utils/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ApiService apiService = ApiService();
  late final User? currentUser;
  late List<Map<String, dynamic>> contacts = [];
  bool _isOpen = false;


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
  void initState() {
    super.initState();
    currentUser = Supabase.instance.client.auth.currentUser;
    getContactInfo();
  }
  Future<void> getContactInfo() async {
    final response = await apiService.getContacts(currentUser?.email);
    setState(() {
      contacts = response;
    });
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getContactInfo,
      backgroundColor: Colors.transparent,
      color: apptextcolor,
      child: Scaffold(
        backgroundColor: appbackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: appbackground,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: "Talkio",
                  fontSize: 30,
                  textColor: apptextcolor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon:
                      const Icon(Icons.more_vert, color: apptextcolor, size: 30))
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      MySearch(
                        searchController: _controller,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      contacts.isNotEmpty ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => SingleChat(
                                            id: contact['id'],
                                            recipent_name: contact['recipent_name'],
                                            recipent_email: contact['recipent_email'],
                                          ),
                                      transition: Transition.cupertino,
                                      duration:
                                          const Duration(milliseconds: 500));
                                },
                                child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: const CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(
                                            'assets/image/profile.jpg'),
                                      ),
                                    ),
                                    title: MyText(
                                      text: contact['recipent_name'] ?? " ",
                                      fontSize: 20,
                                      textColor: apptextcolor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    subtitle: const MyText(
                                      text:
                                          "This is the last message send by you",
                                      fontSize: 15,
                                      textColor: apptextcolor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    trailing: const Column(
                                      children: [
                                        MyText(
                                          text: "10:00",
                                          fontSize: 15,
                                          textColor: apptextcolor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // Container(
                                        //   // padding: const EdgeInsets.all(10),
                                        //   width: 25,
                                        //   height: 25,
                                        //   decoration: BoxDecoration(
                                        //     color: backButton,
                                        //     borderRadius:
                                        //         BorderRadius.circular(100),
                                        //   ),
                                        //   child: const Center(
                                        //     child: MyText(
                                        //       text: "2",
                                        //       fontSize: 15,
                                        //       textColor: apptextcolor,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      ) : const Center(child:CircularProgressIndicator(color: apptextcolor, strokeWidth: 2,)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _isOpen = !_isOpen;
                          });
                        },
                        child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: backButton,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.add, color: apptextcolor, size: 30,),
                            ),
                      ),
                    ),
                  ),
                  if(_isOpen) Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: backButton,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const MyText(
                                  text: "Create Contact",
                                  fontSize: 28,
                                  textColor: apptextcolor,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 20,),
                                MyInput(controller: nameController, hintText: "Name",),
                                const SizedBox(height: 20,),
                                MyInput(controller: emailController, hintText: "Email",textColor: Colors.white,),
                                const SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Mybutton(text: "Cancel", onTap: (){
                                        setState(() {
                                          _isOpen = false;
                                        });
                                      }, width: 100, height: 50,backgroundColor: Colors.red,),
                                      Mybutton(text: "Create", onTap: () async {
                                        final status = await apiService.addContact(emailController.text, nameController.text, currentUser?.email);
                                        if(status == 200) {
                                          setState(() {
                                            _isOpen = false;
                                          });
                                          Get.showSnackbar(
                                            const GetSnackBar(
                                              title: 'Contact',
                                              message:
                                                  'Contact added successfully',
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 4),
                                              snackPosition: SnackPosition.BOTTOM,
                                            ),
                                          );
                                        }
                                      }, width: 100, height: 50,backgroundColor: backButtonIcon,),
                                    ],
                                  ),
                                )
                              ]
                            ),
                          ),
                          ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
