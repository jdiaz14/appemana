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
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            textStyle: TextStyle(
              color: Colors.white,
            ),
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

  List<Product> _cart = [];

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
    final whatsappPhoneNumber = '+573224242416';

    final productList = _cart
        .map((product) =>
            '${product.name} - \$${NumberFormat('#,###', 'es_CO').format(product.price)}')
        .join('\n');

    final message =
        '¡Hola! Estos son los productos que he seleccionado:\n$productList';

    final whatsappUrl =
        'https://wa.me/$whatsappPhoneNumber/?text=${Uri.encodeQueryComponent(message)}';

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      print('No se pudo abrir WhatsApp.');
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
        selectedItemColor: Theme.of(context).primaryColor,
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
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: ListTile(
            leading: Image.asset(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text(product.description),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                ElevatedButton(
                  onPressed: () {
                    addToCart(product);
                  },
                  child: Text('Agregar al Carrito'),
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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (ctx, index) {
              final product = cart[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: ListTile(
                  leading: Image.asset(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          removeFromCart(product);
                        },
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Text(
          'Valor Total: \$${NumberFormat('#,###', 'es_CO').format(calculateTotalPrice())}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            sendWhatsAppMessage();
          },
          child: Text('Enviar a WhatsApp'),
        ),
      ],
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
