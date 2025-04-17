import 'package:http/http.dart' as http;
import 'dart:convert';

class WompiService {
  // URLs para los diferentes entornos
  static const String _sandboxUrl = 'https://sandbox.wompi.co/v1';
  static const String _productionUrl = 'https://production.wompi.co/v1';
  
  // Claves - deberías obtenerlas de tu backend en producción
  static const String _sandboxPublicKey = 'pub_prod_LHzMssXRjlwbRFAmBJzKUErxTbtTaPNx';
  static const String _productionPublicKey = 'prv_prod_qtQUfB0CnMuHVI2zFci2mCgoGh5ESHFF';

  // Configuración
  static bool _isSandbox = true;
  
  // Métodos para configurar el entorno
  static void setSandboxMode(bool isSandbox) {
    _isSandbox = isSandbox;
  }

  // Helper para obtener la URL base
  static String get _baseUrl => _isSandbox ? _sandboxUrl : _productionUrl;
  
  // Helper para obtener la public key
  static String get _publicKey => _isSandbox ? _sandboxPublicKey : _productionPublicKey;

  // 1. Obtener acceptance token (necesario para transacciones)
  static Future<String> getAcceptanceToken() async {
    final url = Uri.parse('$_baseUrl/merchants/$_publicKey');
    
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['presigned_acceptance']['acceptance_token'];
    } else {
      throw Exception('Error al obtener acceptance token: ${response.body}');
    }
  }

  // 2. Crear transacción mejorada
  static Future<Map<String, dynamic>> createTransaction({
    required double amount,
    required String customerEmail,
    required String reference,
    String? paymentMethodId, // Para pagos con método guardado
    String? token, // Para pagos con token de tarjeta
    int installments = 1,
  }) async {
    final url = Uri.parse('$_baseUrl/transactions');
    
    // Obtener acceptance token
    final acceptanceToken = await getAcceptanceToken();
    
    // Construir el cuerpo de la petición
    final body = {
      'amount_in_cents': (amount * 100).toInt(),
      'currency': 'COP',
      'customer_email': customerEmail,
      'reference': reference,
      'acceptance_token': acceptanceToken,
    };

    // Agregar payment method según lo disponible
    if (paymentMethodId != null) {
      body['payment_method_id'] = paymentMethodId;
    } else if (token != null) {
      body['payment_method'] = {
        'type': 'CARD',
        'token': token,
        'installments': installments,
      };
    } else {
      body['payment_method'] = {
        'type': 'CARD',
        'installments': installments,
      };
    }
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_publicKey',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear transacción: ${response.body}');
    }
  }

  // 3. Verificar estado de una transacción
  static Future<Map<String, dynamic>> getTransactionStatus(String transactionId) async {
    final url = Uri.parse('$_baseUrl/transactions/$transactionId');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_publicKey',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al verificar transacción: ${response.body}');
    }
  }

  // 4. Generar token de tarjeta (para pagos con tarjeta)
  static Future<Map<String, dynamic>> createCardToken({
    required String cardNumber,
    required String cvc,
    required String expMonth,
    required String expYear,
    required String cardHolder,
  }) async {
    final url = Uri.parse('$_baseUrl/tokens/cards');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_publicKey',
      },
      body: json.encode({
        'number': cardNumber,
        'cvc': cvc,
        'exp_month': expMonth,
        'exp_year': expYear,
        'card_holder': cardHolder,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear token de tarjeta: ${response.body}');
    }
  }

  // 5. Generar URL de checkout para redirección
  static String generateCheckoutUrl({
    required double amount,
    required String reference,
    required String redirectUrl,
    String? customerEmail,
  }) {
    final params = {
      'public-key': _publicKey,
      'currency': 'COP',
      'amount-in-cents': (amount * 100).toInt().toString(),
      'reference': reference,
      'redirect-url': redirectUrl,
      if (customerEmail != null) 'customer-email': customerEmail,
    };

    return Uri(
      scheme: 'https',
      host: _isSandbox ? 'checkout.wompi.co' : 'checkout.wompi.co',
      path: '/p/',
      queryParameters: params,
    ).toString();
  }
}