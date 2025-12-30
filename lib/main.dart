import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png",
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                "Flutter",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Flutter widget",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ComponentsListScreen()),
                  );
                },
                child: const Text("I'm ready"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ComponentsListScreen extends StatelessWidget {
  const ComponentsListScreen({super.key});

  Widget section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget item(BuildContext c, String title, String sub, Widget page) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          tileColor: Colors.blue.shade100,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title:
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sub),
          onTap: () =>
              Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UI Components List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            section("Display"),
            item(context, "Text", "Displays text",
                const TextDetailScreen()),
            item(context, "Image", "Displays an image",
                const ImageScreen()),
            const SizedBox(height: 12),
            section("Input"),
            item(context, "TextField", "Input field for text",
                const TextFieldScreen()),
            item(context, "PasswordField", "Input field for passwords",
                const PasswordFieldScreen()),
            const SizedBox(height: 12),
            section("Layout"),
            item(context, "Row", "Horizontal layout",
                const RowLayoutScreen()),
            item(context, "Column", "Vertical layout",
                const ColumnLayoutScreen()),
          ],
        ),
      ),
    );
  }
}

//text
class TextDetailScreen extends StatelessWidget {
  const TextDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Detail")),
      body: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, color: Colors.black),
            children: [
              TextSpan(
                text: "The quick ",
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(
                text: "Brown ",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: "fox jumps "),
              TextSpan(
                text: "over ",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: "the lazy dog.",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//image

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Images")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://picsum.photos/400/200",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 6),
            const Text(
              "https://picsum.photos/400/200",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/Screenshot 2025-12-30 015314.png",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 6),
            const Text(
              "In app",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

//textfield

class TextFieldScreen extends StatelessWidget {
  const TextFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TextField")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Thông tin nhập",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tự động cập nhật dữ liệu theo textfield",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

//password

class PasswordFieldScreen extends StatelessWidget {
  const PasswordFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PasswordField")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Nhập mật khẩu",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Password được ẩn khi nhập",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

//row

class RowLayoutScreen extends StatelessWidget {
  const RowLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Row Layout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            3,
                (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                      (i) => Container(
                    width: 90,
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                      i == 1 ? Colors.blue : Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//column
class ColumnLayoutScreen extends StatelessWidget {
  const ColumnLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Column Layout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            4,
                (_) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
