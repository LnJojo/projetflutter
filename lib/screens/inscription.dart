import 'package:flutter/material.dart';
import 'connexion.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {

  //instancie FirebaseAuth grâce à _auth qui pourra être réutilisé
  final _auth = FirebaseAuth.instance;

  //Gestion des champs de texte saisis par l'utilisateur
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  bool arePasswordsTheSame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center (
          child: SingleChildScrollView(
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  height:80,
                  width: 300,
                  child: const Text(
                    'Veuillez saisir ces différentes informations, afin que vos listes soient sauvegardées.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 5),

                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _controllerUserName,
                    decoration: const InputDecoration(
                      label: Center(
                        child: Text("Nom d\'utilisateur"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: InputBorder.none,

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                    ),
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _controllerEmail,
                    decoration: const InputDecoration(
                      label: Center(
                        child: Text("E-mail"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: InputBorder.none,

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                    ),
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _controllerPassword,
                    decoration: InputDecoration(
                      label: const Center(
                        child: Text("Mot de passe"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      //On vérifie si les mots de passe correspondent avec le booléen initialisé à false
                      enabledBorder: arePasswordsTheSame ? InputBorder.none : OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                      suffixIcon: _controllerConfirmPassword.text.isNotEmpty
                          ? Icon(
                        //si les mdps sont différents on affiche un "!" sinon un "V"
                        arePasswordsTheSame ? Icons.check : Icons.error,
                        color: arePasswordsTheSame ? Colors.green : Colors.red,
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        //la valeur du booléen change si les mots de passe correspondent
                        arePasswordsTheSame = (_controllerPassword.text == _controllerConfirmPassword.text);
                      });
                    },
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                    obscureText: true,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 350,
                  child:
                  TextField(
                    controller: _controllerConfirmPassword,
                    decoration: const InputDecoration(
                      label: Center(
                        child: Text("Vérification du mot de passe"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: InputBorder.none,

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                    ),
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        arePasswordsTheSame = (_controllerPassword.text == _controllerConfirmPassword.text);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 73),

                ElevatedButton(
                  onPressed: () async {
                    try {

                      // Récupérer les valeurs saisies par l'utilisateur
                      final username = _controllerUserName.text.trim();
                      final email = _controllerEmail.text.trim();
                      final password = _controllerPassword.text.trim();
                      final confirmPassword = _controllerConfirmPassword.text.trim();

                      if (password != confirmPassword) {
                        throw 'Veuillez entrer le même mot de passe';
                      }

                      //On vérifie si tous les champs sont remplis
                      if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        throw 'Saisissez vos informations pour tous les champs svp';
                      }

                      else{
                        //on crée le compte
                        await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                      }

                      // Naviguer vers la page de connexion
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ConnexionScreen()),
                      );


                    } catch (e) {
                      // Afficher une erreur en cas d'échec de la création du compte
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 50),
                    backgroundColor: const Color(0xFF636AF6),
                  ),
                  child: const Text('S\'inscrire'),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
