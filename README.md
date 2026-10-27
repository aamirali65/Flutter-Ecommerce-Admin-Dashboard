# Flutter-Ecommerce-Admin-Dashboard

The admin side of a Flutter storefront: manage products, promo slides and users, with the customer-facing cart state shared through a provider.

## Screens

| Area | Files |
|---|---|
| Auth | `lib/pages/login.dart`, `register.dart`, `splash.dart` |
| Dashboard | `lib/pages/home.dart` |
| Products | `addProduct.dart`, `editProduct.dart`, `allProducts.dart` |
| Promo slides | `addSlide.dart`, `editSlide.dart`, `allSlides.dart` |
| Users | `allUser.dart` |
| Other | `sharpServ.dart` (service request screen), `Contact.dart` |

Supporting pieces: `lib/models/product.dart` for the product shape, `lib/services/cart_provider.dart` for cart state, `lib/services/connection.dart` for the connectivity check, and `assets/products.json` as a local product seed.

## Stack

Flutter · Dart · Firebase (config committed in `lib/firebase_options.dart`) · `connectivity_plus` · product data seeded from a bundled JSON file

## Running

```bash
flutter pub get
flutter run
```

The Firebase configuration in the repo points at the project it was built with — swap in your own (`firebase.json`, `android/app/google-services.json`, `lib/firebase_options.dart`) before running against your own data.

## Notes

Built to pair with a customer-facing storefront app. The dashboard CRUD screens are the substance here; the bundled JSON is a fallback seed rather than a real data source.
