
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

```json
{
    "id": 12,
    "products": [
        {
            "id": 1,
            "name": "Samsung Galaxy S24 Ultra",
            "quantity": 3,
            "unit_price": "12999.99",
            "total_price": "38999.97"
        },
        {
            "id": 3,
            "name": "Xiamo Mi 27 Pro Plus Master Ultra",
            "quantity": 5,
            "unit_price": "999.99",
            "total_price": "4999.95"
        }
    ],
    "total_price": "43999.92"
}
```

### ```DELETE /cart/:product_id```

Remove a product from the cart.

**Request:**
```bash
curl --location --request DELETE 'http://localhost:3000/cart/1'
```

**Response:**
```json
{
    "id": 12,
    "products": [
        {
            "id": 3,
            "name": "Xiamo Mi 27 Pro Plus Master Ultra",
            "quantity": 5,
            "unit_price": "999.99",
            "total_price": "4999.95"
        }
    ],
    "total_price": "4999.95"
}
```

### ```GET /products```

Get all products from the database.

**Request:**
```bash
curl --location 'http://localhost:3000/products'
```

**Response:**
```json
[
    {
        "id": 1,
        "name": "Samsung Galaxy S24 Ultra",
        "price": "12999.99",
        "created_at": "2025-01-28T12:01:07.906Z",
        "updated_at": "2025-01-28T12:01:07.906Z",
        "cart_id": null
    },
    {
        "id": 2,
        "name": "iPhone 15 Pro Max",
        "price": "14999.99",
        "created_at": "2025-01-28T12:01:07.908Z",
        "updated_at": "2025-01-28T12:01:07.908Z",
        "cart_id": null
    },
    {
        "id": 3,
        "name": "Xiamo Mi 27 Pro Plus Master Ultra",
        "price": "999.99",
        "created_at": "2025-01-28T12:01:07.910Z",
        "updated_at": "2025-01-28T12:01:07.910Z",
        "cart_id": null
    }
]
```

### ```GET /products/:product_id```

Get a single product from the database.


**Request**
```bash
curl --location 'http://localhost:3000/products/1' \
--data ''
```

**Response**

```json 
{
    "id": 1,
    "name": "Samsung Galaxy S24 Ultra",
    "price": "12999.99",
    "created_at": "2025-01-28T12:01:07.906Z",
    "updated_at": "2025-01-28T12:01:07.906Z",
    "cart_id": null
}
```

### ```POST /products```

Create a product.

**Request**

```bash
curl --location 'http://localhost:3000/products/' \
--header 'Content-Type: application/json' \
--data '{
    "name": "Toshiba Handbook",
    "price": "124.99"
}
'
```


**Response**
```json
{
    "id": 129,
    "name": "Toshiba Handbook",
    "price": "124.99",
    "created_at": "2025-01-29T16:35:08.427Z",
    "updated_at": "2025-01-29T16:35:08.427Z",
    "cart_id": null
}
```


### ```PUT /products/:product_id```

Edit a product.

**Request**
```bash
curl --location --request PUT 'http://localhost:3000/products/129' \
--header 'Content-Type: application/json' \
--data '{
    "price": "824.99"
}
'
```

**Response**
```json
{
    "price": "824.99",
    "id": 129,
    "name": "Toshiba Handbook",
    "created_at": "2025-01-29T16:35:08.427Z",
    "updated_at": "2025-01-29T16:36:44.938Z",
    "cart_id": null
}
```

### ```DELETE /products/:product_id```

Delete a product.

**Request**
```bash
curl --location --request DELETE 'http://localhost:3000/products/129' \
--data ''
```

**Response**
```204 No Content```


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

<p>This is a 100% dockerized application!</p>

#### Install Docker for Mac
<ul>
    <li>Install Docker Desktop: https://docs.docker.com/desktop/install/mac-install </li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Uninstall docker engine: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine</li>
    <li>Install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository</li>
    <li>Config docker as a non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user</li>
    <li>Config docker to start on boot: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot</li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Do you use Windows? I'm sorry, docker doesn't work well on Windows. </li>
</ul>

#### Docker steps reminders

- Start terminal
- Make sure of permissions of your OS and terminal system are on point. (Don't be afraid to change the shebang in case you need)
- If you're not installing for the first time, don't overwrite archives
- If you're installing a new gem, be always sure to rebuild.
- This application use a series of shell scripts in order to simplify docker and rails commands, they're all written inside the devops folder.


### Build the container and start the DB


```bash
  sh devops/chmod.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
  ./devops/rails/restart.sh
  ./devops/rails/spec.sh
  ./devops/compose/down.sh
```

### Run Rails server

```bash
    ./devops/compose/up.sh
    ./devops/rails/server.sh
    # CTRL + C
    ./devops/compose/down.sh
```

### Run Rails console

```bash
    ./devops/compose/up.sh
    ./devops/rails/console.sh
    # CTRL + C
    ./devops/compose/down.sh
```

### Update DB and Rails

```bash
    ./devops/compose/up.sh
    ./devops/rails/update.sh
    # CTRL + C
    ./devops/compose/down.sh
```

### Uninstall

```bash
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
```

## DB reminders

- If you're having trouble when opening on a DB management system (like Beekeeper, DBeaver, PG Admin, etc.), don't forget that you need to run the container and use localhost as your host. 
- If any role issues appear Don't be afraid to pkill postgres and brew services stop postgresql (If you're running in homebrew).
- If you are having trouble with users accessing the DB, rebuild the container.

<h2>That's it. Happy coding :computer:</h2> 