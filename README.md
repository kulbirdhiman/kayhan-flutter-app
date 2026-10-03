# Kayhan Audio — Flutter app

Car audio & accessories store (stereos, CarPlay modules, cameras, audio) for
Android, iOS and web, backed by `api.kayhanaudio.com.au`.

## Run with Docker (web)

```bash
docker compose up --build        # → http://localhost:8080
```

or without compose:

```bash
docker build -t kayhan-app .
docker run --rm -p 8080:8080 kayhan-app
```

The image is a two-stage build: Flutter compiles the web bundle, then an
unprivileged nginx serves it on port 8080 (`/healthz` for health checks).

The API and CDN only allow CORS from `kayhanaudio.com.au`, so the web build
calls same-origin `/api` and `/cdn`, and nginx proxies them. To point at a
different backend, set the upstreams at runtime (no rebuild):

```bash
docker run -p 8080:8080 \
  -e API_UPSTREAM=https://staging-api.example.com \
  -e CDN_UPSTREAM=https://cdn.example.com \
  kayhan-app
```

## Run natively (mobile / desktop)

```bash
flutter pub get
flutter run                                   # uses production API directly
flutter run --dart-define=API_BASE_URL=https://staging-api.example.com
```

| `--dart-define`    | Default                                  |
| ------------------ | ---------------------------------------- |
| `API_BASE_URL`     | `https://api.kayhanaudio.com.au`         |
| `CDN_BASE_URL`     | `https://d198m4c88a0fux.cloudfront.net`  |
| `ONESIGNAL_APP_ID` | current OneSignal app                    |

Checks: `flutter analyze` and `flutter test`.

## Project structure

Feature-first layout: each feature owns its data and UI; shared code lives in `core/`.

```
lib/
├── main.dart                  # bootstrap
├── app/
│   ├── app.dart               # MaterialApp.router, themes
│   ├── dependencies.dart      # composition root (repositories + providers)
│   └── router/                # route paths, GoRouter config, bottom-nav shell
├── core/
│   ├── config/                # AppConfig (env), StoreConfig (shipping, GST)
│   ├── network/               # ApiClient (Dio), endpoints, ApiException
│   ├── storage/               # LocalStorage (SharedPreferences wrapper)
│   ├── services/              # push notifications
│   ├── theme/                 # colours, spacing, light/dark theme
│   ├── utils/                 # formatters, validators, HTML helpers
│   └── widgets/               # shared UI (images, prices, states, steppers)
└── features/
    └── <feature>/
        ├── data/              # models + repository (API / storage access)
        └── presentation/      # <feature>_controller.dart, screens/, widgets/
```

Features: `home`, `catalog` (shop, search, listing, product detail),
`vehicle` (shop by vehicle, my garage), `cart`, `wishlist`, `checkout`,
`orders`, `account` (profile, addresses), `auth`, `support`.

State management is `provider` + `ChangeNotifier`. Screens never call Dio
directly; they go through a controller or repository.

## Screens

Home · Shop (departments / product types / car makes) · Search · Product list ·
Product detail · Shop by vehicle · My garage · Wishlist · Cart · Checkout ·
Order success · My orders · Order detail · Account · Profile & security ·
Addresses · Address form · Help & FAQs · Sign in · Create account · Reset password

## Known gaps / TODO before release

- **Payments & orders are not wired to the backend.** Checkout saves orders on
  the device (`LocalOrderRepository`). Implement `OrderRepository` against the
  real order/payment API (PayPal/Stripe).
- **Cart, wishlist, garage and addresses are device-local.** The backend has
  `/v1/cart/*` endpoints that could sync the cart for signed-in users.
- **Category/vehicle filtering uses keyword search.** `/v1/product/list/shop`
  accepts `search` but no category filter was found; swap in a proper filter
  endpoint when one exists.
- **Unverified payloads:** sign-up (`first_name`, `last_name`, `email`, `phone`,
  `password`), password reset (`email`, `otp`, `password`) and change password
  (`old_password`, `new_password`). Confirm these field names with the backend.
- **Placeholder content:** shipping rates in `StoreConfig`, FAQ answers and
  perk copy ("warranty included", etc.) need review by the business.
