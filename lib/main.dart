import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda Virtual',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[200],
        fontFamily: 'Montserrat',
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

  void _sendWhatsAppMessage() async {
    final String whatsappPhoneNumber = '+573224242416';
    final productList = _cart
        .map((product) =>
            '${product.name} - \$${NumberFormat('#,###', 'es_CO').format(product.price)}')
        .join('\n');
    final message =
        '¡Hola! Estos son los productos que he seleccionado:\n$productList';
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
        title: Text('Tienda Virtual'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CatalogPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Producto 1',
      description: 'Descripción del producto 1',
      price: 10000.0,
      imageUrl: 'assets/product1.jpg',
    ),
    Product(
      name: 'Producto 2',
      description: 'Descripción del producto 2',
      price: 20000.0,
      imageUrl: 'assets/product2.jpg',
    ),
  ];

  final Function(Product) addToCart;

  CatalogPage({required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        final product = products[index];
        return Card(
          elevation: 6.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: Image.asset(
              product.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            title: Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.deepPurple, // Color del texto
              ),
            ),
            subtitle: Text(
              product.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey, // Color del texto
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Color del texto
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    addToCart(product);
                  },
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text('Agregar al Carrito'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple, // Color del botón
                    onPrimary: Colors.white, // Color del texto del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        title: Text('Carrito de Compras'),
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
                  child: ListTile(
                    leading: Image.asset(
                      product.imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.deepPurple, // Color del texto
                      ),
                    ),
                    subtitle: Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey, // Color del texto
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // Color del texto
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            removeFromCart(product);
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Eliminar Producto'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Color del botón
                            onPrimary:
                                Colors.white, // Color del texto del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Valor Total: \$${NumberFormat('#,###', 'es_CO').format(calculateTotalPrice())}',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Color del texto
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendWhatsAppMessage();
            },
            child: Text('Enviar a WhatsApp'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Color del botón
              onPrimary: Colors.white, // Color del texto del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
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
