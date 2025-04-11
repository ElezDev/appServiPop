import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

Future<void> initPusher() async {
  try {
    await pusher.init(
      apiKey: 'db10337f0535d207d710', 
      cluster: 'us2',        
    );
    await pusher.connect();
    print("Conexión exitosa a Pusher");
  } catch (e) {
    print("Error al conectar a Pusher: $e");
  }
}

Future<void> subscribeToChannel() async {
  try {
    // Suscríbete a un canal (público o privado)
    PusherChannel channel = await pusher.subscribe(
      channelName: 'serviPop',
    );

    // Escucha eventos en el canal
    // channel.on('mi-evento', (event) {
    //   print("Evento recibido: ${event.data}");
    // });
  } catch (e) {
    print("Error al suscribirse: $e");
  }
}

Future<void> disconnectPusher() async {
  await pusher.unsubscribe(channelName: 'serviPop');
  await pusher.disconnect();
}