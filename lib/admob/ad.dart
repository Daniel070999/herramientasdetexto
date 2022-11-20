import 'package:google_mobile_ads/google_mobile_ads.dart';

//anuncio del menú principal
final AdWidget adWidgetMenuPrincipal = AdWidget(ad: adBannerMenuPrincipal);
final BannerAd adBannerMenuPrincipal = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio lista de  notas
final AdWidget adWidgetListaNotas = AdWidget(ad: adBannerListNotas);
final BannerAd adBannerListNotas = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio creacion de nota
final AdWidget adWidgetNewNote = AdWidget(ad: adBannerNewNote);
final BannerAd adBannerNewNote = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
); 
//anuncio QR
final AdWidget adWidgetQR = AdWidget(ad: adBannerQR);
final BannerAd adBannerQR = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio traductor
final AdWidget adWidgetTraductor = AdWidget(ad: adBannerTraductor);
final BannerAd adBannerTraductor = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio imagen a texto
final AdWidget adWidgetImageText = AdWidget(ad: adBannerImageText);
final BannerAd adBannerImageText = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio voz a texto 
final AdWidget adWidgetSpeechToText = AdWidget(ad: adBannerSpeechToText);
final BannerAd adBannerSpeechToText = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio voz a texto 
final AdWidget adWidgetTextToSpeech = AdWidget(ad: adBannerTextToSpeech);
final BannerAd adBannerTextToSpeech = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
//anuncio PDF
final AdWidget adWidgetPDF = AdWidget(ad: adBannerPDF);
final BannerAd adBannerPDF = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
