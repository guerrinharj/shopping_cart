
# CONTACT LIST API

This is an API I built as a challenge for RD Station. It is a shopping cart management system.

## Models

This API works with three models: ```Cart```, ```Product```, and ```CartItem```.  
```CartItem``` acts as an **association model** between ```Cart``` and ```Product```.  
Users can add products to the cart, creating a cart item. However, **products are not directly associated with a cart**—they are seeded into the database independently.

### Cart

- ```Cart``` has an ```id```, a ```total_price```, an ```abandoned_at``` timestamp, and a ```last_interaction_at``` timestamp.
- ```Cart``` is associated with ```CartItem```, which links it to multiple ```Product``` records.
- ```total_price``` must be a number equal to or greater than ```0```.
- ```Cart``` is considered **abandoned** if ```abandoned_at``` is not ```nil```.
- ```Cart``` is considered **not abandoned** if ```abandoned_at``` is ```nil```.
- ```Cart``` is **ready for abandonment** if it has not been abandoned and ```last_interaction_at``` was more than ```3 hours ago```.
- ```Cart``` is **ready for deletion** if it has been abandoned for more than ```7 days```.
- ```total_price``` is updated by summing the ```total_price``` of all its ```cart_items```.
- Before saving, ```last_interaction_at``` is set to the current timestamp if it is ```nil```.
- If a ```Cart``` has been abandoned for more than ```7 days```, it will be automatically removed.

### Product

- ```Product``` has an ```id```, a ```name```, and a ```price```.
- ```name``` must be present.
- ```price``` must be a number equal to or greater than ```0```.

### CartItem

- ```CartItem``` has an ```id```, a ```cart_id```, a ```product_id```, a ```quantity```, and a ```total_price```.
- ```CartItem``` belongs to a ```Cart``` and a ```Product```.
- ```quantity``` must be a number greater than ```0```.
- ```total_price``` must be a number equal to or greater than ```0```.
- ```total_price``` is automatically calculated as ```product.price * quantity``` before saving.

## Routes

### ```GET /cart```

Retrieve the cart information with products and total price.

**Request:**
```bash
curl --location 'http://localhost:3000/cart'
```

**Response:**
```json
{
  "id": 12,
  "products": [
      {
          "id": 3,
          "name": "Xiaomi Mi 27 Pro Plus Master Ultra",
          "quantity": 5,
          "unit_price": 999.99,
          "total_price": 4999.95
      }
  ],
  "total_price": 4999.95
}
```

### ```POST /cart```

Create a cart and add products to it.

**Request:**
```bash
curl --location 'http://localhost:3000/cart'
```

**Response:** *(Same as GET /cart response)*

### ```DELETE /cart```

Delete a cart.

**Request:**
```bash
curl --location --request DELETE 'http://localhost:3000/cart'
```

**Response:**
```204 No Content```

### ```POST /cart/add_item```

Add a product to an existing cart. If the product already exists, the quantity is updated.

**Request:**
```bash
curl --location 'http://localhost:3000/cart/add_item' \
    --header 'Content-Type: application/json' \
    --data '{
      "product_id": 3,
      "quantity": 4
    }'
```

**Response:**

### ```DELETE /cart/:product_id```

Remove a product from the cart.

**Request:**
```bash
curl --location --request DELETE 'http://localhost:3000/cart/1'
```

**Response:**

### ```GET /products```

Get all products from the database.

**Request:**
```bash
curl --location 'http://localhost:3000/products'
```

**Response:** *(Array of product objects)*

### ```GET /products/:product_id```

Get a single product from the database.

### ```POST /products```

Create a product.

### ```PUT /products/:product_id```

Edit a product.

### ```DELETE /products/:product_id```

Delete a product.

## Abandonment System

- This API includes an **abandoned cart system** that automatically processes inactive carts.
- If a ```Cart``` has **no interactions for 3 hours**, it is labeled as **abandoned**.
- If a ```Cart``` remains **abandoned for 7 days**, it is permanently **deleted** from the database.

### **Background Job: `MarkCartAsAbandonedJob`**
- This API uses ```Sidekiq``` to schedule the ```MarkCartAsAbandonedJob```.
- ```MarkCartAsAbandonedJob``` finds all ```Cart``` records **ready for abandonment** and updates their ```abandoned_at``` timestamp.
- It finds all ```Cart``` records **ready for deletion** and permanently removes them.
- Ensures carts inactive for more than ```3 hours``` are marked as abandoned.
- Ensures carts abandoned for more than ```7 days``` are deleted.

## Versions :gem:
* **Ruby:** 3.3.1
* **Rails:** 7.1.3

## Setup :monorail:
1. Run `bundle install`.
2. Set up `config/database.yml`.
3. Set up `.env`.
4. Run `./bin/rails db:drop db:create db:migrate db:seed`.
5. Run `./bin/rails s`.

## Docker :whale:

### **Install Docker**
- **Mac**: [Install Docker Desktop](https://docs.docker.com/desktop/install/mac-install)
- **Linux**: Follow [this guide](https://docs.docker.com/engine/install/ubuntu/)
- **Windows**: Use [WSL2](https://docs.docker.com/docker-for-windows/wsl/)

### **Docker Commands**
```bash
sh devops/chmod.sh
./devops/compose/build.sh --no-cache
./devops/compose/up.sh
./devops/rails/restart.sh
./devops/rails/spec.sh
./devops/compose/down.sh
```

## DB Reminders
- Run the container and use `localhost` as the host for database management tools.
- If DB role issues occur, try `pkill postgres` and `brew services stop postgresql` (Mac).
- If DB access issues persist, rebuild the container.

## That's it! Happy coding! :computer:

