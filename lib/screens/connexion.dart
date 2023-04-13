import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'inscription.dart';
import 'accueil.dart';

//------------------------------------------------------------------------------

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

/*
  //Pour se déconnecter de la session
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
  */
}

//------------------------------------------------------------------------------

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({Key? key}) : super(key: key);

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {

  String? errorMessage = '';
  bool isLogin = true;

  final _auth = FirebaseAuth.instance;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Si la connexion réussit, on affiche un message de succès.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );

      // On navigue vers la page d'accueil.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
      );
    } on FirebaseAuthException catch (e) {
      // Si la connexion échoue, on affiche un message d'erreur.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.message}')),
      );
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Container : parent
      body: Container(
        //Mettre l'image background
        width: double.infinity, //prend toute la largeur de l'écran
        height: double.infinity, //pareil pour la hauteur
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: Center(
          //permet de centrer le widget column dans le widget parent (container)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Text(
                'Bienvenue !',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 15), //Se réfère au widget Text


              const SizedBox(
                height:80,
                width: 210,
                child: Text(
                  'Veuillez vous connecter ou créer un nouveau compte pour utiliser l\'application.',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),


              SizedBox(
                width: 350,
                child: TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1E262C),
                      label: Center(
                        child: Text('E-mail'),
                      ),
                      labelStyle: TextStyle(color: Colors.white)

                  ),
                  style: TextStyle(color : Colors.white),
                ),
              ),
              const SizedBox(height: 20),


              SizedBox(
                width: 350,
                child: TextField(
                  controller: _controllerPassword,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1E262C),
                      label: Center(
                        child: Text('Mot de passe'),
                      ),
                      labelStyle: TextStyle(color: Colors.white)
                  ),
                  style: TextStyle(color : Colors.white),
                ),
              ),
              const SizedBox(height: 20),


              ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassword(_controllerEmail.text.trim(), _controllerPassword.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350, 55),
                  backgroundColor: const Color(0xFF636AF6),
                ),
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InscriptionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350, 55),
                  side: const BorderSide(width: 2, color: Color(0xff636AF6)),
                  backgroundColor: Colors.transparent,
                ),
                child: const Text('Créer un nouveau compte'),
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}

