use market;

-- 가격이 낮은 4개의 누적 매출을 조회
select name as '상품명', price as '가격', sum(price * count) as '누적 매출'
from order_details
join orders on order_details.order_id = orders.id
join products on order_details.product_id = products.id and status = '배송 완료' -- 장바구니 상품은 제외해야함
group by name,price
order by price asc
limit 4;