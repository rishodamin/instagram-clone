import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDefaultProfPic();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> loadDefaultProfPic() async {
    ByteData bytes = await rootBundle.load('assets/defaultProfPic.jpg');
    setState(() {
      _image = bytes.buffer.asUint8List();
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
      name: _nameController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'succes') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //flex box 1
                        //Flexible(flex: 1, child: Container()),

                        //Logo
                        SvgPicture.asset(
                          'assets/ic_instagram.svg',
                          color: primaryColor,
                          height: 64,
                        ),
                        const SizedBox(height: 64),

                        //circular widget to access and show our selected file
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: blueColor,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 24),

                        // username
                        TextFieldInput(
                          hintText: 'Enter a Username',
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _usernameController,
                        ),

                        const SizedBox(height: 24),

                        // email
                        TextFieldInput(
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                        ),

                        const SizedBox(height: 24),

                        // password
                        TextFieldInput(
                          hintText: 'Enter a password',
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                          isPass: true,
                        ),

                        const SizedBox(height: 24),

                        // Name
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              hintText: 'Your Name (Optional)'),
                        ),

                        const SizedBox(height: 24),

                        // Bio
                        TextField(
                          maxLength: 40,
                          controller: _bioController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: 'Something about you (Optional)'),
                        ),

                        const SizedBox(height: 24),

                        //button
                        InkWell(
                          onTap: signUpUser,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              color: blueColor,
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // flex box 2
                        // Flexible(flex: 1, child: Container()),

                        // Transitioning to sign up

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text("Already have an account? "),
                            ),
                            GestureDetector(
                              onTap: navigateToLogin,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const Text(
                                  "Login.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
