import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmanaFloral',
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Times New Roman',
          ),
          bodyText2: TextStyle(
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
      home: CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [];
  List<Product> _cart = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(),
      CatalogPage(addToCart: _addToCart),
      CartPage(
        cart: _cart,
        removeFromCart: _removeFromCart,
        sendWhatsAppMessage: _sendWhatsAppMessage,
      ),
    ]);
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.remove(product);
    });
  }

  double calculateTotalPrice(List<Product> cart) {
    double total = 0.0;
    for (final product in cart) {
      total += product.price;
    }
    return total;
  }

  void _sendWhatsAppMessage() async {
    final String whatsappPhoneNumber = '+573185846022';

    final Map<String, double> productTotals = {};

    for (final product in _cart) {
      final productName = product.name;
      final productPrice = product.price;

      if (productTotals.containsKey(productName)) {
        productTotals[productName] =
            (productTotals[productName] ?? 0) + productPrice;
      } else {
        productTotals[productName] = productPrice;
      }
    }

    final productsText = productTotals.entries.map((entry) =>
        '${entry.key} x${_cart.where((p) => p.name == entry.key).length} - \$${NumberFormat('#,###', 'es_CO').format(entry.value)}');

    final totalText =
        'Total: \$${NumberFormat('#,###', 'es_CO').format(calculateTotalPrice(_cart))}';

    final message =
        '¡Hola Emana! Estos son los productos que he seleccionado:\n${productsText.join('\n')}\n\n$totalText';

    final whatsappUrl =
        'https://wa.me/$whatsappPhoneNumber/?text=${Uri.encodeQueryComponent(message)}';

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        print('No se pudo abrir WhatsApp.');
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EmanaFloral',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        selectedItemColor: Colors.pink[300],
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/Principal.png',
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '¡Bienvenidos a EmanaFloral!',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Somos Emana, para nosotros significa soltar, irradiar, contagiar, despertar, evocar; Las flores en Emana, emanan color, alegría, agradecimiento y amor.',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '¡Nos encontramos muy felices! Esperamos seguir inspirándolos, compartiendo alegrías y llenando sus hogares de flores Emana.',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CatalogPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Amor Mamá',
      description:
          'Base esférica de ceramica de 14 de diámetro color blanco diseñada con flores secas y preservadas 100% naturales.',
      price: 85000,
      imageUrl: 'assets/AmorMama.png',
    ),
    Product(
      name: 'Amor Mamá eterno',
      description:
          'Base esférica de ceramica de 14 de diámetro color blanco diseñada con flores secas y preservadas100% naturales.',
      price: 95000,
      imageUrl: 'assets/AmorMamaEterno.png',
    ),
    Product(
      name: 'Ana',
      description:
          'Diseño en canasto tejido de 16x12x18cm, elaborado con variedad en colores, texturas y más de diez tipos de flor',
      price: 120000,
      imageUrl: 'assets/Ana.png',
    ),
    Product(
      name: 'Cristal',
      description:
          'Diseño en base de florero transparente con un hermoso jardín que iluminará los espacios de tu hogar.',
      price: 80000,
      imageUrl: 'assets/Cristal.png',
    ),
    Product(
      name: 'Mamá',
      description:
          'Diseño floral en canasto de mimbre (disponibilidad en color blanco de 20 cm) con selección de flores frescas en la tonalidad de tu preferencia,así creamos una composición hermosa para ti.',
      price: 175000,
      imageUrl: 'assets/Mama.png',
    ),
    Product(
      name: 'Bouquet',
      description:
          'Bouquet envuelto en papel, elaborado con diversidad de flores naturales del color de su preferencia y follajes finos. (30 tallos de flor)',
      price: 90000,
      imageUrl: 'assets/Bouquet.png',
    ),
    Product(
      name: 'Flower Box',
      description:
          'Selecciona el color que más te guste para la tonalidad que llevará tu arreglo. Encontrarás infinidad de flores, llenas de color, aroma y estilo.',
      price: 110000,
      imageUrl: 'assets/FlowerBox.png',
    ),
    Product(
      name: 'Aro de oro',
      description:
          'Caja circular de cartón piedra con diversidad floral, acompañado de fresas con chocolate, bombones de chocolate, alfajores,medians de chocolate con arándonos y frutos secos',
      price: 110000,
      imageUrl: 'assets/AroDeOro.png',
    ),
    Product(
      name: 'Chesse Box',
      description:
          '· 4 tipos de quesos (Mozarella, Paipa, Gouda y Colby-Jack). · Carnes frias (Jamón de cerdo, Jamón Serrano, Salami, Chorizo español, Cabano). · 4 frutas ( Uvas, Fresas, Arándanos, Kiwi) · Aceitunas, dip de queso crema, chocolate oscuro. · Galletas y tostadas de finas hierbas.',
      price: 25000.0,
      imageUrl: 'assets/ChesseBox.png',
    ),
  ];

  final Function(Product) addToCart;

  CatalogPage({required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Catálogo Emana',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Times New Roman',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final product = products[index];
              return Card(
                elevation: 6.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.pink[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              addToCart(product);
                            },
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.pink[300],
                            ),
                            label: Text(
                              'Agregar al Carrito',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.pink[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Precio: \$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) removeFromCart;
  final Function() sendWhatsAppMessage;

  CartPage(
      {required this.cart,
      required this.removeFromCart,
      required this.sendWhatsAppMessage});

  double calculateTotalPrice() {
    double total = 0.0;
    for (final product in cart) {
      total += product.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito de Compras',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black, // Fondo negro
        centerTitle: true, // Centrar el título
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (ctx, index) {
                final product = cart[index];
                return Card(
                  elevation: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  color: Colors.pink[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        product.imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            Text(
                              'Precio: \$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                removeFromCart(product);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.pink[300],
                              ),
                              label: Text(
                                'Eliminar Producto',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.pink[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor Total: \$${NumberFormat('#,###', 'es_CO').format(calculateTotalPrice())}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendWhatsAppMessage();
                  },
                  child: Text(
                    'Compra por WhatsApp',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 0, 168, 8),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
