CREATE TABLE `products` (
  `id` int,
  `name` varchar(255),
  `category` ENUM ('prod_1', 'prod_2'),
  `description` varchar(255),
  `base_price` int,
  `sell_price` int,
  `discount` float
);

CREATE TABLE `product_details` (
  `id` int,
  `product_id` int,
  `size` int,
  `color` varchar(255),
  `stock` int
);

CREATE TABLE `transactions` (
  `id` int,
  `invoice_code` varchar(255),
  `date` datetime
);

CREATE TABLE `transaction_details` (
  `id` int,
  `transaction_id` int,
  `product_id` int,
  `price` int,
  `quantity` int,
  `discount` float
);

CREATE TABLE `users` (
  `id` int,
  `username` varchar(255),
  `password` password
);

CREATE TABLE `customers` (
  `id` int,
  `name` varchar(255)
);

ALTER TABLE `transactions` ADD FOREIGN KEY (`id`) REFERENCES `transaction_details` (`transaction_id`);

ALTER TABLE `products` ADD FOREIGN KEY (`id`) REFERENCES `transaction_details` (`product_id`);

ALTER TABLE `product_details` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);
