import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProfileDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {

    var usercredential = FirebaseAuth.instance.currentUser;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/pimg.jpg'),
          ),
          SizedBox(height: 10),
          Text(
              usercredential?.email ?? 'No User Found',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'user123@example.com',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          _buildProfileOption(
            context,
            icon: Icons.person,
            title: 'Change Username',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeUsernamePage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.email,
            title: 'Change Email',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeEmailPage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.lock,
            title: 'Reset Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
    );
  }
}

class ChangeUsernamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'New Username'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle change username logic
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'New Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle change email logic
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle reset password logic
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}