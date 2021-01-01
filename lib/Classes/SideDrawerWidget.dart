import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/FirespacePages/auth.dart';
import 'package:RecipeApp/Pages/home_page.dart';
import 'package:RecipeApp/Pages/pantry_page.dart';
import 'package:RecipeApp/Pages/recipes_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();

  Widget _createHeader(User user) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/mountain-landscape.jpg'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 10.0,
              child: Text(user.email,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          _createHeader(user),
          new FlatButton.icon(
            label: Text('Home'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: const Offset(1.0, 0.0),
                          begin: Offset.zero,
                        ).animate(secondaryAnimation),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.home),
          ),
          Divider(),
          new FlatButton.icon(
              label: Text('Pantry'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PantryPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            end: const Offset(1.0, 0.0),
                            begin: Offset.zero,
                          ).animate(secondaryAnimation),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              icon: Icon(Icons.fastfood)),
          Divider(),
          new FlatButton.icon(
            label: Text('Recipes'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      RecipePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: const Offset(1.0, 0.0),
                          begin: Offset.zero,
                        ).animate(secondaryAnimation),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.book),
          ),
          Divider(),
          FlatButton.icon(
            onPressed: () async {
              await _authService.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Sign Out'),
          ),
          Divider(),
        ],
      ),
    );
  }
}

// class PantryReturn extends MaterialPageRoute<Null> {
//   PantryReturn()
//       : super(builder: (BuildContext context) {
//           return PantryPage();
//         });
// }
