use eatzzy;
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`id`	VARCHAR(14)	NOT NULL UNIQUE,
	`password`	VARCHAR(255)	NOT NULL,
	`birth_date`	VARCHAR(8)	NOT NULL,
	`name`	VARCHAR(10)	NOT NULL,
	`email`	VARCHAR(255)	NOT NULL UNIQUE,
	`postal_code`	VARCHAR(10)	NULL,
	`address`	VARCHAR(255)	NULL,
	`phone`	VARCHAR(13)	NOT NULL,
	`user_type`	ENUM ('ADMIN','SELLER','CUSTOMER')	NOT NULL
);

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`name`	VARCHAR(50)	NOT NULL,
	`description`	VARCHAR(500)	NOT NULL,
	`price`	INT	NOT NULL,
	`stock`	INT	NOT NULL,
	`category_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`store_id`	INT	NULL
);

DROP TABLE IF EXISTS `likes`;

CREATE TABLE `likes` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`user_id`	INT	NOT NULL,
	`store_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`quantity`	INT	NOT NULL,
	`price`	INT	NOT NULL,
	`message`	VARCHAR(30)	NULL,
	`user_id`	INT	NOT NULL,
    `status` enum('Pending', 'Processing', 'Completed', 'Cancelled') DEFAULT 'Pending' NOT NULL
);

DROP TABLE IF EXISTS `product_reviews`;

CREATE TABLE `product_reviews` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`star_point` INT NOT NULL,
	`content`	VARCHAR(200)	NOT NULL,
	`createdAt`	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`product_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `store_reviews`;

CREATE TABLE `store_reviews` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`createdAt`	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`star_point`	INT	NOT NULL,
	`visit_date`	DATETIME	NOT NULL,
	`content`	VARCHAR(200)	NOT NULL,
	`store_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `reservations`;

CREATE TABLE `reservations` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`date`	VARCHAR(10)	NOT NULL,
	`time`	VARCHAR(10)	NOT NULL,
	`headcount`	INT	NOT NULL,
	`request`	VARCHAR (30)	NULL,
	`store_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `payments`;

CREATE TABLE `payments` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`order_id`	INT	NOT NULL,
	`status`	ENUM('Cancelled','Refunded','Pending','Progress','Fail','Success')	NOT NULL,
	`price`	INT	NOT NULL,
	`payment_method_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `delivery`;

CREATE TABLE `delivery` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`delivery_status`	ENUM('Received' , 'Preparing', 'Ready', 'Transit', 'Delivered')	NOT NULL,
	`courier_company`	VARCHAR(20)	NULL,
	`tracking_number`	INT	NULL,
	`order_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `carts`;

CREATE TABLE `carts` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `products_category`;

CREATE TABLE `products_category` (
	`idx`	INT AUTO_INCREMENT PRIMARY KEY,
	`ref_id`	INT	NULL,
	`name`	VARCHAR(20)	NOT NULL
);

DROP TABLE IF EXISTS `stores`;

CREATE TABLE `stores` (
	`idx`	INT AUTO_INCREMENT PRIMARY KEY,
	`name`	VARCHAR(30)	NOT NULL,
	`description`	VARCHAR(200)	NULL,
	`address`	VARCHAR(255)	NOT NULL,
	`call_number`	VARCHAR(13)	NULL	COMMENT '010-xxxx-xxxx',
	`opening_hours`	VARCHAR(255)	NOT NULL,
	`start_time`	DATETIME	NULL	COMMENT 'HH:mm',
	`end_time`	DATETIME	NULL	COMMENT 'HH:mm',
	`allowed`	ENUM ('Yes','No','Wating')	NOT NULL,
	`category_id`	INT	NOT NULL,
	`closed_day`	SET('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')	NULL,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `order_products`;

CREATE TABLE `order_products` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`quantity`	INT	NOT NULL,
	`product_id`	INT	NOT NULL,
	`order_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `stores_category`;

CREATE TABLE `stores_category` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`ref_id`	INT	NULL,
	`name`	VARCHAR(20)	NOT NULL
);

DROP TABLE IF EXISTS `payment_method`;

CREATE TABLE `payment_method` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`name`	VARCHAR(20)	NOT NULL,
	`user_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `cart_products`;

CREATE TABLE `cart_products` (
	`idx`	INT AUTO_INCREMENT PRIMARY KEY,
	`quantity`	INT	NOT NULL,
	`cart_id`	INT	NOT NULL,
	`product_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `products_images`;

CREATE TABLE `products_images` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`image_path`	VARCHAR(255)	NOT NULL,
	`product_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `product_review_images`;

CREATE TABLE `product_review_images` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`image_path`	VARCHAR(255)	NOT NULL,
	`product_review_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `store_review_images`;

CREATE TABLE `store_review_images` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`image_path`	VARCHAR(255)	NOT NULL,
	`store_review_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `store_images`;

CREATE TABLE `store_images` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`image_path`	VARCHAR(255)	NOT NULL,
	`store_id`	INT	NOT NULL
);

DROP TABLE IF EXISTS `menus`;

CREATE TABLE `menus` (
	`idx`	INT	AUTO_INCREMENT PRIMARY KEY,
	`name`	VARCHAR(30)	NOT NULL,
	`image_path`	VARCHAR(225)	NOT NULL,
	`price`	VARCHAR(255)	NULL,
	`info`	VARCHAR(150)	NOT NULL,
	`store_id`	INT	NOT NULL
);


ALTER TABLE `products` ADD CONSTRAINT `FK_products_category_TO_products_1` FOREIGN KEY (
	`category_id`
)
REFERENCES `products_category` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `products` ADD CONSTRAINT `FK_users_TO_products_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `products` ADD CONSTRAINT `FK_stores_TO_products_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `likes` ADD CONSTRAINT `FK_users_TO_likes_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `likes` ADD CONSTRAINT `FK_stores_TO_likes_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `orders` ADD CONSTRAINT `FK_users_TO_orders_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `product_reviews` ADD CONSTRAINT `FK_products_TO_product_reviews_1` FOREIGN KEY (
	`product_id`
)
REFERENCES `products` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `product_reviews` ADD CONSTRAINT `FK_users_TO_product_reviews_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `store_reviews` ADD CONSTRAINT `FK_stores_TO_store_reviews_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `store_reviews` ADD CONSTRAINT `FK_users_TO_store_reviews_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `reservations` ADD CONSTRAINT `FK_stores_TO_reservations_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `reservations` ADD CONSTRAINT `FK_users_TO_reservations_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `payments` ADD CONSTRAINT `FK_orders_TO_payments_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `orders` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `payments` ADD CONSTRAINT `FK_payment_method_TO_payments_1` FOREIGN KEY (
	`payment_method_id`
)
REFERENCES `payment_method` (
	`idx`
);

ALTER TABLE `delivery` ADD CONSTRAINT `FK_orders_TO_delivery_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `orders` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `carts` ADD CONSTRAINT `FK_users_TO_carts_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `stores` ADD CONSTRAINT `FK_stores_category_TO_stores_1` FOREIGN KEY (
	`category_id`
)
REFERENCES `stores_category` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `stores` ADD CONSTRAINT `FK_users_TO_stores_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `order_products` ADD CONSTRAINT `FK_products_TO_order_products_1` FOREIGN KEY (
	`product_id`
)
REFERENCES `products` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `order_products` ADD CONSTRAINT `FK_orders_TO_order_products_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `orders` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `payment_method` ADD CONSTRAINT `FK_users_TO_payment_method_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `cart_products` ADD CONSTRAINT `FK_carts_TO_cart_products_1` FOREIGN KEY (
	`cart_id`
)
REFERENCES `carts` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `cart_products` ADD CONSTRAINT `FK_products_TO_cart_products_1` FOREIGN KEY (
	`product_id`
)
REFERENCES `products` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `products_images` ADD CONSTRAINT `FK_products_TO_products_images_1` FOREIGN KEY (
	`product_id`
)
REFERENCES `products` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `product_review_images` ADD CONSTRAINT `FK_product_reviews_TO_product_review_images_1` FOREIGN KEY (
	`product_review_id`
)
REFERENCES `product_reviews` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `store_review_images` ADD CONSTRAINT `FK_store_reviews_TO_store_review_images_1` FOREIGN KEY (
	`store_review_id`
)
REFERENCES `store_reviews` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `store_images` ADD CONSTRAINT `FK_stores_TO_store_images_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `menus` ADD CONSTRAINT `FK_stores_TO_menus_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `stores` (
	`idx`
) ON DELETE CASCADE;

ALTER TABLE `stores_category` 
ADD CONSTRAINT `FK_stores_category_self` FOREIGN KEY (`ref_id`)
REFERENCES `stores_category` (`idx`)
ON DELETE CASCADE;

ALTER TABLE `products_category` 
ADD CONSTRAINT `FK_products_category_self` FOREIGN KEY (`ref_id`)
REFERENCES `products_category` (`idx`)
ON DELETE CASCADE;

