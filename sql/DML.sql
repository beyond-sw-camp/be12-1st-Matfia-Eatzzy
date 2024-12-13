#------------------------------------------------------------------------------------------------
# 점주, 소비자 전용 
#------------------------------------------------------------------------------------------------

# 회원

1. 아이디 중복확인
	SELECT CASE WHEN count(*) = 0 THEN 'true' ELSE 'false' END AS result FROM users WHERE id = 'value';
        
2. 이메일 인증
	SELECT CASE WHEN count(*) = 0 THEN 'true' ELSE 'false' END AS result FROM users WHERE email = 'value';

3. 회원가입
   	 INSERT INTO users (id,password,birth_date,email,postal_code,address,phone,user_type) VALUES('','','','','','','','');
  
4. 일반 로그인
   	 SELECT CASE WHEN count(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE id = 'value' AND password = 'value';
    
5. 회원 정보 수정
    SELECT CASE WHEN count(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE id = 'value';
    SELECT id,birth_date,email,postal_code,address,phone FROM users WHERE id = 'value';
    UPDATE users
	SET
		password = CASE WHEN password != 'value' THEN 'value' ELSE password END,
		birth_date = CASE WHEN birth_date != 'value' THEN 'value' ELSE birth_date END,
		postal_code = CASE WHEN postal_code != 'value' THEN 'value' ELSE postal_code END,
		address = CASE WHEN address != 'value' THEN 'value' ELSE address END,
		phone = CASE WHEN phone != 'value' THEN 'value' ELSE phone END
	WHERE
		id = 'value' AND (password != 'value' OR birth_date != 'value' OR postal_code != 'value' OR address != 'value' OR phone != 'value');

6. 회원 탈퇴
	SELECT CASE WHEN count(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE id = 'value' AND password = 'value';
	DELETE FROM users WHERE id = 'value';
	
# 식당
## 전체식당조회

1. 좋아요순 정렬 식당조회
# 좋아요 순(default) : count_likes
# 평점순 : average_star_point
# 리뷰 많은 순 : count_reviews 
	
	SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   ROUND(AVG(store_reviews.star_point), 1) AS average_star_point,
		   COUNT(store_reviews.idx) AS count_reviews,
		   stores.address, COUNT(likes.idx) AS count_likes
	FROM stores
	JOIN stores_category ON stores_categ	ory.idx = stores.category_id
	JOIN store_reviews ON store_reviews.store_id = stores.idx
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN likes ON stores.idx = likes.store_id
	WHERE stores.allowed = 'Yes'
	GROUP BY stores.idx
	ORDER BY count_likes DESC;

2.  식당 상세 조회
SELECT stores.name, stores.description, stores.address,
       stores.call_number, stores.opening_hours, stores.start_time, stores.end_time,
       stores_category.name, reservations.date, reservations.time, store_images.image_path,
       ROUND(AVG(store_reviews.star_point), 1), COUNT(DISTINCT store_reviews.idx), products.idx
FROM stores
LEFT JOIN reservations ON stores.idx = reservations.store_id
JOIN store_images ON stores.idx = store_images.store_id
LEFT JOIN store_reviews ON stores.idx = store_reviews.store_id
LEFT JOIN products ON stores.idx = products.store_id
JOIN stores_category ON stores.category_id = stores_category.idx
WHERE stores.idx = 1 AND stores.allowed = 'Yes'
GROUP BY stores.idx;

3.  식당 리뷰 조회
SELECT store_reviews.idx, store_reviews.star_point, store_reviews.content, users.name,
	store_reviews.createdAt, store_reviews.visit_date
FROM store_reviews
JOIN users ON store_reviews.user_id = users.idx
ORDER BY store_reviews.createdAt DESC;

4. 검색어 조회
	SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   ROUND(AVG(store_reviews.star_point), 1), COUNT(store_reviews.idx), 
           stores.address
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
	WHERE stores.allowed = 'Yes' and stores.name LIKE '%Steven%'
	GROUP BY stores.idx;

5. 카테고리 기준 조회
SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   ROUND(AVG(store_reviews.star_point), 1), COUNT(store_reviews.idx), 
           stores.address
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
	WHERE stores.allowed = 'Yes' and stores_category.idx = 1
	GROUP BY stores.idx;

6. 지역 기준 조회
	SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   ROUND(AVG(store_reviews.star_point), 1), COUNT(store_reviews.idx), 
		   stores.address
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
    WHERE stores.allowed = 'Yes' and stores.address LIKE '%james%'
	GROUP BY stores.idx;

7. 평균 별점 기준 조회
SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   ROUND(AVG(store_reviews.star_point), 1) AS average_star_point, 
           COUNT(store_reviews.idx), stores.address
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
    WHERE stores.allowed = 'Yes'
	GROUP BY stores.idx
    HAVING average_star_point >= 3.5;
  
## 식당 랭킹
1. 좋아요 순 랭킹
		SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
			   stores.address, ROUND(AVG(store_reviews.star_point), 1) AS average_star_point,
			   COUNT(store_reviews.idx) AS count_reviews, COUNT(likes.idx) AS count_likes
		FROM stores
		JOIN stores_category ON stores_category.idx = stores.category_id
		JOIN store_images ON store_images.store_id = stores.idx
		JOIN store_reviews ON store_reviews.store_id = stores.idx
		JOIN likes ON stores.idx = likes.store_id
        WHERE stores.allowed = 'Yes'
		GROUP BY stores.idx
		ORDER BY count_likes DESC
		LIMIT 10;

2. 카테고리별 랭킹
	SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		   stores.address, ROUND(AVG(store_reviews.star_point), 1), 
           COUNT(store_reviews.idx), COUNT(likes.idx) AS count_likes
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
	JOIN likes ON stores.idx = likes.store_id
	WHERE stores.allowed = 'Yes' and stores_category.idx = 4
	GROUP BY stores.idx
	ORDER BY count_likes DESC
	LIMIT 10;

3. 지역별 랭킹
    SELECT stores.idx, store_images.image_path, stores.name, stores_category.name,
		stores.address, ROUND(AVG(store_reviews.star_point), 1), COUNT(store_reviews.idx), 
       COUNT(likes.idx) AS count_likes
	FROM stores
	JOIN stores_category ON stores_category.idx = stores.category_id
	JOIN store_images ON store_images.store_id = stores.idx
	JOIN store_reviews ON store_reviews.store_id = stores.idx
	JOIN likes ON stores.idx = likes.store_id
	WHERE stores.allowed = 'Yes' and stores.address LIKE "%Apt%"
	GROUP BY stores.idx
	ORDER BY count_likes DESC
	LIMIT 10;

# 상품
1. 모든 상품 조회
	SELECT products.name AS '상품명',
           products.price,
           stores_category.name AS '식당 카테고리',
           products_category.name AS '상품 카테고리',
           products_images.image_path
	  FROM products
 LEFT JOIN products_category
		ON products_category.idx = products.category_id
LEFT JOIN stores
		ON stores.idx = products.store_id
 LEFT JOIN stores_category
		ON stores_category.idx = stores.category_id
 LEFT JOIN products_images
		ON products.idx = products_images.product_id;
        
2. 상품 상세 확인
	SELECT products.name AS '상품명',
		   products.description,           
           products.price,
           stores_category.name AS '식당 카테고리',
           products_category.name AS '상품 카테고리',
           products_images.image_path
	  FROM products
 LEFT JOIN products_category
		ON products_category.idx = products.category_id
LEFT JOIN stores
		ON stores.idx = products.store_id
 LEFT JOIN stores_category
		ON stores_category.idx = stores.category_id
 LEFT JOIN products_images
		ON products.idx = products_images.product_id
	 WHERE products.idx = 1;
     
3. 상품 리뷰 확인
	SELECT product_reviews.star_point,
		   product_reviews.content,
           product_reviews.createdAt,
           products.name AS '상품명',
           users.name AS '회원명',
           product_review_images.image_path
      FROM product_reviews
 LEFT JOIN products
		ON products.idx = product_reviews.product_id
 LEFT JOIN users
		ON users.idx = product_reviews.user_id
 LEFT JOIN product_review_images
		ON product_reviews.idx = product_review_images.product_review_id;

#------------------------------------------------------------------------------------------------
# 점주 전용 
#------------------------------------------------------------------------------------------------

## 식당

1. 식당 예약 조회 
SELECT users.name, users.phone, reservations.request, reservations.date, reservations.time, reservations.headcount 
FROM reservations
JOIN stores 
ON reservations.store_id = stores.idx
JOIN users
ON reservations.user_id = users.idx 
WHERE stores.allowed = 'Yes' AND stores.idx = 10;

2.  식당 등록
INSERT INTO stores (name, description, address, call_number, opening_hours, start_time, end_time, allowed, category_id, closed_day, user_id) 
VALUES ('?', '?', '?', '?', '?', '?', '?', '?', ?, '?', ?);

SET @last_store_id = LAST_INSERT_ID();
INSERT INTO store_images (image_path, store_id)
VALUES	('?', @last_store_id);

3. 내 식당 조회 
SELECT stores.name, store_images.image_path 
FROM stores
JOIN store_images
ON stores.idx = store_images.store_id
WHERE  stores.user_id = 59475 AND stores.allowed = 'Yes';

4. 식당 정보 수정
UPDATE stores
SET name = '?', description = '?', address = '?', call_number = '?', opening_hours = '?', start_time = '?', end_time = '?', category_id = ?, closed_day='?'
WHERE idx =  ?;

5. 식당 삭제 
DELETE FROM stores
WHERE idx = ?;

6. 식당 메뉴 추가 (메뉴명, 메뉴사진, 메뉴소개, 가격) #식당번호 
INSERT INTO menus (name, image_path, price, info, store_id)
VALUES ('?', '?', ?, '?', ?);

7. 식당 메뉴 수정
UPDATE menu
SET name = '?', image_path = '?', info = '?', price = ?
WHERE idx = ?;

8. 식당 메뉴 삭제
DELETE FROM menu
WHERE idx = ?;

## 상품

1. 상품 등록(상품명, 상품 설명, 가격, 재고 수량, 카테고리, 회원 번호, 식당 번호) 
INSERT INTO products (name, description, price, stock, category_id, user_id, store_id)
VALUES ('?', '?', ?, ?, ?, ?, ?);

2. 상품 수정
UPDATE products
SET name = '?', description = '?', price = ?, stock = ?, category_id = ? 
WHERE idx = ? AND store_id =?;

3. 상품 삭제
DELETE FROM products 
WHERE idx = ?;

## 주문
 
1. 주문 현황 확인
    SELECT U.name, U.phone, U.address, O.idx, P.name, OD.quantity, O.price, M.status, A.name, O.message
    FROM users U
    JOIN orders O ON U.idx = O.user_id
    JOIN payments M ON O.idx = M.order_id
    JOIN order_products OD ON O.idx = OD.order_id
    JOIN products P ON OD.product_id = P.idx
    JOIN payment_method A ON M.payment_method_id = A.idx
    WHERE O.idx = '주문 확인할 번호';

## 배송
1. 배송 등록
        INSERT INTO delivery (courier_company, tracking_number, order_id)
        VALUES ('택배회사', '운송장 번호', '주문번호(orders 테이블에 존재)')
2. 배송 조회
        SELECT courier_company, tracking_number, order_id, delivery_status
        FROM delivery;

#------------------------------------------------------------------------------------------------
# 소비자 전용 
#------------------------------------------------------------------------------------------------

## 식당

1. 좋아요한 식당 조회
SELECT stores.name, stores_category.name, ROUND(AVG(store_reviews.star_point), 1), COUNT(DISTINCT store_reviews.idx) FROM likes
JOIN stores ON likes.store_id = stores.idx
JOIN stores_category ON stores_category.idx = stores.category_id
JOIN store_reviews ON stores.idx = store_reviews.store_id
JOIN store_images ON stores.idx = store_images.store_id
JOIN users ON users.idx = likes.user_id
WHERE users.idx = 17406;

2. 내가 작성한 리뷰 목록 조회 
SELECT stores.name, store_reviews.content, store_reviews.star_point, store_reviews.visit_date  FROM store_reviews
JOIN stores ON stores.idx = store_reviews.store_id
JOIN users ON stores.user_id = users.idx
WHERE users.idx = 32475;

3. 식당 예약
INSERT INTO reservations (date, time, headcount, request, store_id, user_id) 
VALUES (     );

4. 식당 예약 조회
SELECT users.name, users.phone, reservations.request, reservations.date, reservations.time, reservations.headcount
FROM reservations
JOIN stores 
ON reservations.store_id = stores.idx
JOIN users
ON reservations.user_id = users.idx 
WHERE stores.allowed = 'Yes' AND reservations.store_id = 5498;

5 식당 예약 취소
DELETE FROM reservations 
WHERE user_id = [ ? ];

6. 식당 좋아요
INSERT INTO likes (user_id, store_id)
VALUES (    );

7. 식당 리뷰 작성
INSERT INTO stores_reviews (createdAt, star_point, content, visit_date, store_id, user_id)
VALUES (    );

8. 식당 리뷰 삭제
DELETE FROM store_reviews
WHERE user_id = [ ? ];

9. 식당 리뷰 수정
UPDATE store_reviews
SET content = [ ? ], start_point = [?]
WHERE user_id = [ ? ] ;

## 상품
1. 장바구니 조회
  SELECT 
    U.idx AS user_id,
    products.idx AS product_id,
    products.name AS product_name,
    cart_products.quantity AS quantity,
    products.price AS price,
    (cart_products.quantity * products.price) AS total_price
FROM users U
JOIN carts ON U.idx = carts.user_id
JOIN cart_products ON cart_products.cart_id = carts.idx
JOIN products ON products.idx = cart_products.product_id
 WHERE U.idx = 6436 ; 

2. 장바구니 담기
-- Step 1: 사용자 장바구니 확인 또는 생성
INSERT INTO carts (user_id)
VALUES (1)
ON DUPLICATE KEY UPDATE idx = LAST_INSERT_ID(idx);

-- Step 2: 상품 추가 또는 수량 업데이트
INSERT INTO cart_products (cart_id, product_id, quantity)
VALUES (LAST_INSERT_ID(), 101, 2)
ON DUPLICATE KEY UPDATE
quantity = quantity + 2;

3.  장바구니 상품 삭제
  DELETE FROM cart_products
WHERE cart_id = 1 AND product_id = 101;

4.  장바구니 수량 수정  
UPDATE cart_products cp
JOIN carts c ON c.idx = cp.cart_id
SET cp.quantity = cp.quantity + 2
WHERE c.user_id = 1 AND cp.product_id = 101;

5. 상품 리뷰 등록
    INSERT INTO product_reviews (star_point,content, createdAt, product_id, user_id)
VALUES (3,'Great product! Fast delivery.', NOW(), 101, 1);

6. 유저의 리뷰 확인
SELECT 	
	product_reviews.idx,
    product_reviews.content,
    product_reviews.createdAt,
    product_review_images.image_path
FROM users
JOIN product_reviews ON users.idx = product_reviews.user_id
LEFT JOIN product_review_images ON product_reviews.idx = product_review_images.product_review_id
WHERE users.idx = 2 ; 

7. 특정 상품 ID
SELECT 
    product_reviews.content,
    product_reviews.createdAt,
    product_review_images.image_path
FROM product_reviews
LEFT JOIN product_review_images ON product_reviews.idx = product_review_images.product_review_id
WHERE product_reviews.product_id = 101; 

8. 상품 리뷰 수정
UPDATE product_reviews
SET content = 'Updated review content',
    star_point = 4
WHERE idx = 1 -- 리뷰 ID
  AND user_id = 10266; -- 사용자 ID 확인

9 상품 리뷰 삭제
  DELETE FROM product_reviews
	WHERE idx = 1; 

## 주문

1. 전체 주문 내역 조회
SELECT 
    orders.idx AS order_id,
    users.idx AS user_id,
    users.id AS username,
    orders.quantity AS total_quantity,
    orders.price AS total_price,
    orders.message AS order_message
FROM orders
JOIN users ON orders.user_id = users.idx
WHERE users.idx = 893 ;

2. 주문 내역 상세 조회
  SELECT * FROM users
  JOIN orders on orders.user_id = users.idx
  JOIN order_products on orders.idx = order_products.order_id
  JOIN products on products.idx = order_products.product_id
  JOIN delivery on orders.idx = delivery.order_id
  JOIN payments on payments.order_id = orders.idx
  JOIN payment_method on payment_method.idx = payments.payment_method_id
  where users.idx = 343;

3. 장바구니 물품 주문
-- Step 1: 주문 생성
INSERT INTO orders (quantity, price, message, user_id)

-- Step 2: 주문 상세 생성
INSERT INTO order_products (quantity, product_id, order_id)

-- Step 3: 재고 업데이트
UPDATE products p
JOIN cart_products cp ON p.idx = cp.product_id
SET p.stock = p.stock - cp.quantity
WHERE cp.idx = 1;

-- Step 4: 장바구니 비우기
DELETE FROM cart_products
WHERE idx = 1;

4. 상품 바로 구매
-- Step 1: 주문 생성
INSERT INTO orders (quantity, price, message, user_id)
VALUES (1, 4300, 'Can not wait', 2);

-- Step 2: 주문 상세 생성
INSERT INTO order_products (quantity, product_id, order_id)
VALUES (2, 101, 9983);

-- Step 3: 재고 감소
UPDATE products
SET stock = stock - 2
WHERE idx = 101;

5. 주문 취소
  # 주문 상태 컬럼 추가 필요 
  UPDATE orders
SET status = 'Pending'
WHERE idx = 9983 AND user_id = 1;

## 결제
1. 결제 수단 선택
-- Step 1: 사용자 결제 수단 확인
SELECT pm.idx AS payment_method_id, pm.name AS payment_method_name
FROM payment_method pm
WHERE pm.user_id = 1;

-- Step 2: 결제 데이터 저장
INSERT INTO payments (order_id, status, price, payment_method_id)
VALUES (
    101,                     -- 주문 ID
    'Pending',               -- 초기 상태
    50000,                   -- 결제 금액
    3                        -- 선택된 결제 수단 ID);

UPDATE payments
SET status = 'Success'
WHERE idx = LAST_INSERT_ID();

2. 카드 등록
  INSERT INTO payment_method (name, user_id)
VALUES
('Visa Credit Card', 1); 

3. 결제 정보 입력
 INSERT INTO payments (order_id, status, price, payment_method_id)
VALUES
(101, 'Success', 50000, 1);
#------------------------------------------------------------------------------------------------
# 관리자 전용 
#------------------------------------------------------------------------------------------------

## 식당

1. 식당 등록 수락
        UPDATE stores
        SET allowed = 'Yes'
        WHERE idx = '수락할 식당 번호' AND allowed = 'Waiting';

2. 식당 등록 거절
        UPDATE stores
        SET allowed = 'No'
        WHERE idx = '거절할 식당 번호' AND allowed = 'Waiting';

3. 식당 카테고리 등록
        INSERT INTO stores_category (idx, name) VALUES ('카테고리 번호','카테고리명');


## 상품

1. 상품 카테고리 등록
        INSERT INTO products_category (idx, name) VALUES ('카테고리 번호', '카테고리명');