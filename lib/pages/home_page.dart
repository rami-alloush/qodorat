import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/db.dart';
import 'package:qodorat/models.dart';

class HomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          child: Image.asset('assets/dog.png'),
          width: 150,
        ),
        StreamProvider<List<Weapon>>.value(
          stream: db.streamWeapons(user),
          child: WeaponsList(),
        ),
        StreamBuilder<User>(
          stream: db.streamUser(user),
          builder: (context, snapshot) {
            var dbUser = snapshot.data;

            if (dbUser != null) {
              return Column(
                children: <Widget>[
                  Text('Equip ${dbUser.email}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Add Veggie'),
                        onPressed: () => db.addWeapon(user,
                            {'name': 'cucumber', 'hitpoints': 5, 'img': '🥒'}),
                      )
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: RaisedButton(
                    child: Text('Update Profile'),
                    onPressed: () => db.createUser(user)),
              );
            }
          },
        ),
        RaisedButton(child: Text('Sign out'), onPressed: auth.signOut),
      ],
    );
  }
}

class WeaponsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var weapons = Provider.of<List<Weapon>>(context);
    print(weapons);
    bool weaponsReady = (weapons != null && weapons.length > 0);
    var user = Provider.of<FirebaseUser>(context);

    return Container(
      height: 300,
      child: weaponsReady
          ? ListView(
              children: weapons.map((weapon) {
                return Card(
                  child: ListTile(
                    leading: Text(weapon.img, style: TextStyle(fontSize: 50)),
                    title: Text(weapon.name),
                    subtitle:
                        Text('Deals ${weapon.hitpoints} hitpoints of damage'),
                    onTap: () =>
                        DatabaseService().removeWeapon(user, weapon.id),
                  ),
                );
              }).toList(),
            )
          : Text("Loading ..."),
    );
  }
}
