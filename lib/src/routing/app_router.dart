import 'package:ecommerce_app_miki/src/features/authentication/account/account_screen.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_screen.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_screen.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/wish_list_screen.dart';
import 'package:ecommerce_app_miki/src/features/checkout/checkout_screen.dart';
import 'package:ecommerce_app_miki/src/features/leave_review_page/leave_review_screen.dart';
import 'package:ecommerce_app_miki/src/features/not_found/not_found_screen.dart';
import 'package:ecommerce_app_miki/src/features/orders/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/product_list_screen.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'go_router_refresh_stream.dart';

enum AppRoute {
  home,
  cart,
  wishList,
  orders,
  account,
  checkout,
  product,
  review,
  signIn,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        /// there is no reason to open signIn page if we are already logged in
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        /// if we are not a signed in we do not want to show account or orders page
        if (state.location == '/account' || state.location == '/orders') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: AppRoute.product.name,
            builder: (context, state) {
              final productId = state.params['id']!;
              return ProductScreen(productId: productId);
            },
            routes: [
              GoRoute(
                path: 'review',
                name: AppRoute.review.name,
                pageBuilder: (context, state) {
                  final productId = state.params['id']!;
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: LeaveReviewScreen(productId: productId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'cart',
            name: AppRoute.cart.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const ShoppingCartScreen(),
            ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: AppRoute.checkout.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: ValueKey(state.location),
                  fullscreenDialog: true,
                  child: const CheckoutScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'wishList',
            name: AppRoute.wishList.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const WishListScreen(),
            ),
          ),
          GoRoute(
            path: 'orders',
            name: AppRoute.orders.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const OrdersListScreen(),
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const EmailPasswordSignInScreen(
                formType: SignInFormType.signIn,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
