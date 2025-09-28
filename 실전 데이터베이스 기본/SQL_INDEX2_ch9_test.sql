use my_shop2;

-- INDEX2 문제와 풀이

-- 문제: 인덱스들을 만들어서 다음 쿼리 성능을 개선해라.
/* 문제의 쿼리
SELECT * FROM items
WHERE category = '전자기기' AND is_active = TRUE;

SELECT * FROM items
WHERE category = '전자기기' AND is_active = TRUE
ORDER BY stock_quantity DESC;

SELECT * FROM items
WHERE stock_quantity < 90 AND category = '전자기기' AND is_active = TRUE;

SELECT * FROM items
WHERE stock_quantity < 90 AND category = '전자기기' AND is_active = TRUE
ORDER by stock_quantity desc; */
create index idx_itmes_category_isActive_stockQuantity on items(category,is_active,stock_quantity desc);