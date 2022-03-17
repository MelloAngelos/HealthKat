import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../Components/SearchBar.dart';
import '../../current_user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

bool notifications = true;

class _ProfileState extends State<Profile> {
  Widget build(BuildContext context) {
    bool _loading = false;
    bool loading_ = false;

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      loading_ = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<CurrentUser>(context, listen: false).getInfo();
        setState(() {
          loading_ = false;
        });
      });
    }

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
            inAsyncCall: _loading,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            '/Homepage', (Route<dynamic> route) => false)),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: Container(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                Provider.of<CurrentUser>(context, listen: false)
                                            .photoUrl !=
                                        null
                                    ? FadeInImage(
                                        image: NetworkImage(
                                            Provider.of<CurrentUser>(context,
                                                    listen: false)
                                                .photoUrl),
                                        placeholder: AssetImage(
                                            'assets/images/placeholder.png'),
                                      )
                                    : Icon(
                                        Icons.supervised_user_circle,
                                        size: 120,
                                        color: Colors.green[700],
                                      ),
                          ),
                        ),
                      ),
                      Container(
                          child: Center(
                        child: Text(
                          '${Provider.of<CurrentUser>(context, listen: false).displayName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      )),
                      Center(
                        child: Text(Provider.of<CurrentUser>(context,
                                        listen: false)
                                    .isDoctor ==
                                true
                            ? Provider.of<CurrentUser>(context, listen: false)
                                        .speciality !=
                                    null
                                ? Provider.of<CurrentUser>(context,
                                        listen: false)
                                    .speciality
                                : 'Doctor'
                            : 'Patient'),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 4),
                            Container(
                              child: Text('Phone Number : '),
                            ),
                            Container(
                              child: Text(
                                  '${Provider.of<CurrentUser>(context, listen: false).phoneNumber}'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 4),
                            Container(
                              child: Text('Address : '),
                            ),
                            Container(
                              child: Text(
                                  '${Provider.of<CurrentUser>(context, listen: false).address}'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200),
                      Text("More Actions",
                          style: TextStyle(color: Colors.grey)),
                      SearchBar(),
                      Divider(),
                      Text("Privacy", style: TextStyle(color: Colors.grey)),
                      TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            final snackBar = SnackBar(
                                content: notifications
                                    ? Text("Notifications turned off")
                                    : Text("Notifications turned on"));
                            setState(() {
                              notifications = !notifications;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Notifications",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                              Icon(notifications == true
                                  ? Icons.notifications
                                  : Icons.notifications_off)
                            ],
                          )),
                      Divider()
                    ]),
              ),
            )));
  }
}
