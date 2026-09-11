<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - ShopEase</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background-color: #f4f6f8; }
        header { background-color: #2874f0; color: white; padding: 18px 60px; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 25px; font-weight: bold; }
        nav a { color: white; text-decoration: none; margin-left: 25px; font-weight: bold; }
        nav a:hover { text-decoration: underline; }
        .heading { text-align: center; padding: 35px 20px 20px; }
        .heading h1 { color: #2874f0; margin-bottom: 10px; }
        .heading p { color: #666; }
        .products { display: flex; justify-content: center; gap: 25px; flex-wrap: wrap; padding: 30px 60px; }
        .product { background-color: white; width: 240px; padding: 20px; text-align: center; border-radius: 8px; box-shadow: 0 2px 8px #ddd; }
        .product:hover { transform: translateY(-5px); box-shadow: 0 5px 15px #ccc; }
        .product-image { height: 150px; background-color: #eee; display: flex; align-items: center; justify-content: center; font-size: 60px; margin-bottom: 15px; border-radius: 5px; }
        .product h3 { margin-bottom: 8px; }
        .category { color: #777; font-size: 14px; margin-bottom: 4px; }
        .quantity { color: #555; font-size: 13px; margin-bottom: 8px; }
        .price { color: #388e3c; font-size: 19px; font-weight: bold; margin-bottom: 15px; }
        .buy-btn { background-color: #2874f0; color: white; border: none; padding: 10px 25px; cursor: pointer; border-radius: 4px; font-weight: bold; }
        .buy-btn:hover { background-color: #1255c7; }
        footer { background-color: #172337; color: white; text-align: center; padding: 20px; margin-top: 30px; }
    </style>
</head>

<body>
    <header>
        <div class="logo">ShopEase</div>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        </nav>
    </header>

    <section class="heading">
        <h1>Our Products</h1>
        <p>Explore our collection of popular products.</p>
    </section>

    <section class="products">

        <div class="product">
            <div class="product-image">📱</div>
            <h3>Smartphone</h3>
            <p class="category">Category: Electronics</p>
            <p class="quantity">Quantity: 50</p>
            <p class="price">₹24,999</p>
            <button class="buy-btn">Buy Now</button>
        </div>

        <div class="product">
            <div class="product-image">💻</div>
            <h3>Laptop</h3>
            <p class="category">Category: Electronics</p>
            <p class="quantity">Quantity: 20</p>
            <p class="price">₹59,999</p>
            <button class="buy-btn">Buy Now</button>
        </div>

        <div class="product">
            <div class="product-image">🎧</div>
            <h3>Wireless Headphones</h3>
            <p class="category">Category: Accessories</p>
            <p class="quantity">Quantity: 100</p>
            <p class="price">₹2,499</p>
            <button class="buy-btn">Buy Now</button>
        </div>

        <div class="product">
            <div class="product-image">👟</div>
            <h3>Sports Shoes</h3>
            <p class="category">Category: Footwear</p>
            <p class="quantity">Quantity: 75</p>
            <p class="price">₹1,999</p>
            <button class="buy-btn">Buy Now</button>
        </div>

        <div class="product">
            <div class="product-image">⌚</div>
            <h3>Smart Watch</h3>
            <p class="category">Category: Accessories</p>
            <p class="quantity">Quantity: 40</p>
            <p class="price">₹3,499</p>
            <button class="buy-btn">Buy Now</button>
        </div>

        <div class="product">
            <div class="product-image">📷</div>
            <h3>Digital Camera</h3>
            <p class="category">Category: Electronics</p>
            <p class="quantity">Quantity: 15</p>
            <p class="price">₹34,999</p>
            <button class="buy-btn">Buy Now</button>
        </div>

    </section>

    <footer>
        <p>© 2026 ShopEase | Online Shopping Management System</p>
    </footer>

</body>
</html>
