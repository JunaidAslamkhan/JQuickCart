import '../../features/products/data/models/product_model.dart';
import '../../features/products/data/models/category_model.dart';

class DummyData {
  DummyData._();

  // Categories
  static List<CategoryModel> get categories => [
        CategoryModel(
          id: '1',
          name: 'Sports',
          iconUrl: 'assets/icons/sports.png',
          productCount: 120,
        ),
        CategoryModel(
          id: '2',
          name: 'Furniture',
          iconUrl: 'assets/icons/furniture.png',
          productCount: 85,
        ),
        CategoryModel(
          id: '3',
          name: 'Electronics',
          iconUrl: 'assets/icons/electronics.png',
          productCount: 200,
        ),
        CategoryModel(
          id: '4',
          name: 'Clothes',
          iconUrl: 'assets/icons/clothes.png',
          productCount: 150,
        ),
        CategoryModel(
          id: '5',
          name: 'Shoes',
          iconUrl: 'assets/icons/shoes.png',
          productCount: 95,
        ),
      ];

  // Products
  static List<ProductModel> get products => [
        ProductModel(
          id: '1',
          name: 'iPhone 11 64GB',
          brand: 'Apple',
          price: 599,
          discountPrice: 399,
          discountPercent: 10,
          imageUrl: 'assets/images/iphone.png',
          category: 'Electronics',
          categoryId: '3',
          rating: 4.5,
          reviewCount: 120,
          inStock: true,
          colors: ['Black', 'White', 'Blue'],
          storageOptions: ['64GB', '128GB', '256GB'],
          description:
              'The iPhone 11 features a 6.1-inch Liquid Retina display, dual 12MP cameras, and A13 Bionic chip.',
        ),
        ProductModel(
          id: '2',
          name: 'iPhone 16 pro Max 256GB',
          brand: 'Apple',
          price: 599,
          discountPrice: 450,
          discountPercent: 10,
          imageUrl: 'assets/images/IPhone16pro Max.webp',
          category: 'Electronics',
          categoryId: '3',
          rating: 4.5,
          reviewCount: 120,
          inStock: true,
          colors: ['Black', 'White', 'Blue'],
          storageOptions: ['64GB', '128GB', '256GB'],
          description:
              'The iPhone 11 features a 6.1-inch Liquid Retina display, dual 12MP cameras, and A13 Bionic chip.',
        ),
        ProductModel(
          id: '3',
          name: 'iPhone 14 pro Max 256GB',
          brand: 'Apple',
          price: 599,
          discountPrice: 400,
          discountPercent: 10,
          imageUrl: 'assets/images/iphone 14 pro.jpeg',
          category: 'Electronics',
          categoryId: '3',
          rating: 4.5,
          reviewCount: 120,
          inStock: true,
          colors: ['Black', 'White', 'Blue'],
          storageOptions: ['64GB', '128GB', '256GB'],
          description:
              'The iPhone 11 features a 6.1-inch Liquid Retina display, dual 12MP cameras, and A13 Bionic chip.',
        ),
        ProductModel(
          id: '4',
          name: 'iPhone 17 Air 256GB',
          brand: 'Apple',
          price: 599,
          discountPrice: 400,
          discountPercent: 10,
          imageUrl: 'assets/images/iPhone 17 Air.webp',
          category: 'Electronics',
          categoryId: '3',
          rating: 4.5,
          reviewCount: 120,
          inStock: true,
          colors: ['Black', 'White', 'Blue'],
          storageOptions: ['64GB', '128GB', '256GB'],
          description:
              'The iPhone 11 features a 6.1-inch Liquid Retina display, dual 12MP cameras, and A13 Bionic chip.',
        ),
        ProductModel(
          id: '2',
          name: 'Shoes of Nike',
          brand: 'Nike',
          price: 389,
          discountPercent: 5,
          imageUrl: 'assets/images/nike_shoes.png',
          category: 'Shoes',
          categoryId: '5',
          rating: 4.8,
          reviewCount: 85,
          inStock: true,
          colors: ['Blue', 'Black', 'White'],
          sizes: ['S', 'M', 'L', 'XL'],
          description:
              'Premium Nike running shoes with advanced cushioning technology.',
        ),
        ProductModel(
          id: '3',
          name: 'Blue INDURE Shoes',
          brand: 'Adidas',
          price: 299,
          discountPrice: 199,
          discountPercent: 15,
          imageUrl: 'assets/images/blue_shoes.png',
          category: 'Shoes',
          categoryId: '5',
          rating: 4.2,
          reviewCount: 60,
          inStock: true,
          colors: ['Blue', 'White'],
          sizes: ['S', 'M', 'L'],
          description: 'Comfortable everyday shoes with modern design.',
        ),
        ProductModel(
          id: '4',
          name: 'Blue Beta Shoes',
          brand: 'Puma',
          price: 699,
          imageUrl: 'assets/images/beta_shoes.png',
          category: 'Shoes',
          categoryId: '5',
          rating: 4.6,
          reviewCount: 45,
          inStock: true,
          colors: ['Blue', 'Black'],
          sizes: ['M', 'L', 'XL'],
          description: 'High performance shoes for athletes.',
        ),
      ];

  // Banner Images
  static List<String> get banners => [
        'assets/images/banner1.png',
        'assets/images/banner2.png',
        'assets/images/banner3.png',
      ];
}
