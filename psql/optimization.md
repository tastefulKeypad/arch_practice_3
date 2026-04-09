# Методология проведения замеров
- EXPLAIN ANALYZE применялся не напрямую к функции, а к её внутреннему телу
- После каждого EXPLAIN ANALYZE запроса производился перезапуск docker контейнера для сброса кэша

# До оптимизации unoptimizedQueries.sql + отсутствие INDEXов
EXPLAIN ANALYZE SELECT * FROM GetUserByEmail('user2@example.com');
Index Scan using users_email_key on users u  (cost=0.14..8.16 rows=1 width=957) (actual time=0.031..0.032 rows=1.00 loops=1)
   Index Cond: ((email)::text = 'user2@example.com'::text)
   Index Searches: 1
   Buffers: shared hit=2
 Planning:
   Buffers: shared hit=85 read=2
 Planning Time: 0.396 ms
 Execution Time: 0.083 ms


EXPLAIN ANALYZE SELECT * FROM GetUserByNameAndSurname('Anatoly', 'Karpov');
Seq Scan on users u  (cost=0.00..10.75 rows=1 width=957) (actual time=0.104..0.105 rows=2.00 loops=1)
   Filter: (((name)::text = 'Anatoly'::text) AND ((surname)::text = 'Karpov'::text))
   Rows Removed by Filter: 8
   Buffers: shared read=1 dirtied=1
 Planning:
   Buffers: shared hit=58 read=19
 Planning Time: 0.331 ms
 Execution Time: 0.125 ms


EXPLAIN ANALYZE SELECT * FROM GetCarByClass(6);
 Sort  (cost=12.13..12.14 rows=1 width=434) (actual time=0.404..0.411 rows=2.00 loops=1)
   Sort Key: id
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3 read=1
   ->  Seq Scan on cars  (cost=0.00..12.12 rows=1 width=434) (actual time=0.358..0.366 rows=2.00 loops=1)
         Filter: (carclass = 6)
         Rows Removed by Filter: 8
         Buffers: shared read=1
 Planning:
   Buffers: shared hit=51 read=18
 Planning Time: 0.430 ms
 Execution Time: 0.453 ms


EXPLAIN ANALYZE SELECT * FROM GetAvailableCars('2026-03-01 00:00:00', '2026-05-01 00:00:00');
 Merge Anti Join  (cost=33.08..33.95 rows=169 width=434) (actual time=0.149..0.151 rows=6.00 loops=1)
   Merge Cond: (c.id = r.carid)
   Buffers: shared read=2 dirtied=1
   ->  Sort  (cost=18.00..18.42 rows=170 width=434) (actual time=0.079..0.080 rows=10.00 loops=1)
         Sort Key: c.id
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared read=1
         ->  Seq Scan on cars c  (cost=0.00..11.70 rows=170 width=434) (actual time=0.071..0.072 rows=10.00 loops=1)
               Buffers: shared read=1
   ->  Sort  (cost=15.08..15.09 rows=1 width=4) (actual time=0.068..0.068 rows=4.00 loops=1)
         Sort Key: r.carid
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared read=1 dirtied=1
         ->  Seq Scan on rents r  (cost=0.00..15.07 rows=1 width=4) (actual time=0.059..0.059 rows=4.00 loops=1)
               Filter: ((datestart < '2026-05-01 00:00:00'::timestamp without time zone) AND (dateend > '2026-03-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'Active'::text))
               Rows Removed by Filter: 6
               Buffers: shared read=1 dirtied=1
 Planning:
   Buffers: shared hit=93 read=20
 Planning Time: 0.413 ms
 Execution Time: 0.207 ms


EXPLAIN ANALYZE SELECT * FROM GetRentActiveByUserId(10);
 Sort  (cost=14.36..14.37 rows=1 width=246) (actual time=0.134..0.135 rows=1.00 loops=1)
   Sort Key: datestart
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3 read=1
   ->  Seq Scan on rents  (cost=0.00..14.35 rows=1 width=246) (actual time=0.098..0.098 rows=1.00 loops=1)
         Filter: ((userid = 10) AND ((status)::text = 'Active'::text))
         Rows Removed by Filter: 9
         Buffers: shared read=1
 Planning:
   Buffers: shared hit=67 read=21
 Planning Time: 0.328 ms
 Execution Time: 0.154 ms


EXPLAIN ANALYZE SELECT * FROM GetRentHistoryByUserId(2);
 Sort  (cost=13.63..13.64 rows=1 width=246) (actual time=0.093..0.093 rows=2.00 loops=1)
   Sort Key: datestart
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3 read=1
   ->  Seq Scan on rents  (cost=0.00..13.62 rows=1 width=246) (actual time=0.076..0.077 rows=2.00 loops=1)
         Filter: (userid = 2)
         Rows Removed by Filter: 8
         Buffers: shared read=1
 Planning:
   Buffers: shared hit=66 read=20
 Planning Time: 0.392 ms
 Execution Time: 0.112 ms


# После оптимизации queries.sql
EXPLAIN ANALYZE SELECT * FROM GetUserByEmail('user2@example.com');
 Index Scan using idxusersemail on users u  (cost=0.14..8.16 rows=1 width=957) (actual time=0.023..0.023 rows=1.00 loops=1)
  Index Cond: ((email)::text = 'user2@example.com'::text)
   Index Searches: 1
   Buffers: shared read=2
 Planning:
   Buffers: shared hit=84 read=21
 Planning Time: 0.395 ms
 Execution Time: 0.044 ms


EXPLAIN ANALYZE SELECT * FROM GetUserByNameAndSurname('Anatoly', 'Karpov');
 Index Scan using idxusersnamesurname on users u  (cost=0.14..8.16 rows=1 width=957) (actual time=0.024..0.024 rows=2.00 loops=1)
   Index Cond: (((name)::text = 'Anatoly'::text) AND ((surname)::text = 'Karpov'::text))
   Index Searches: 1
   Buffers: shared read=2
 Planning:
   Buffers: shared hit=84 read=21
 Planning Time: 0.359 ms
 Execution Time: 0.045 ms


EXPLAIN ANALYZE SELECT * FROM GetCarByClass(6);
Sort  (cost=8.17..8.18 rows=1 width=434) (actual time=0.040..0.041 rows=2.00 loops=1)
   Sort Key: id
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3 read=2
   ->  Index Scan using idxcarscarclass on cars  (cost=0.14..8.16 rows=1 width=434) (actual time=0.024..0.024 rows=2.00 loops=1)
         Index Cond: (carclass = 6)
         Index Searches: 1
         Buffers: shared read=2
 Planning:
   Buffers: shared hit=62 read=19
 Planning Time: 0.365 ms
 Execution Time: 0.064 ms


EXPLAIN ANALYZE SELECT * FROM GetAvailableCars('2026-03-01 00:00:00', '2026-05-01 00:00:00');
 Merge Anti Join  (cost=32.35..33.21 rows=169 width=434) (actual time=0.145..0.148 rows=6.00 loops=1)
   Merge Cond: (c.id = r.carid)
   Buffers: shared hit=3 read=3
   ->  Sort  (cost=18.00..18.42 rows=170 width=434) (actual time=0.078..0.079 rows=10.00 loops=1)
         Sort Key: c.id
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared read=1
         ->  Seq Scan on cars c  (cost=0.00..11.70 rows=170 width=434) (actual time=0.068..0.068 rows=10.00 loops=1)
               Buffers: shared read=1
   ->  Sort  (cost=14.35..14.35 rows=1 width=4) (actual time=0.065..0.065 rows=4.00 loops=1)
         Sort Key: r.carid
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared hit=3 read=2
         ->  Index Scan using idxrentsstatus on rents r  (cost=0.15..14.34 rows=1 width=4) (actual time=0.047..0.048 rows=4.00 loops=1)
               Index Cond: ((status)::text = 'Active'::text)
               Filter: ((datestart < '2026-05-01 00:00:00'::timestamp without time zone) AND (dateend > '2026-03-01 00:00:00'::timestamp without time zone))
               Index Searches: 1
               Buffers: shared hit=3 read=2
 Planning:
   Buffers: shared hit=177 read=28
 Planning Time: 0.611 ms
 Execution Time: 0.234 ms


EXPLAIN ANALYZE SELECT * FROM GetRentActiveByUserId(10);
 Index Scan using idxrentsuseriddatestart on rents  (cost=0.15..8.17 rows=1 width=246) (actual time=0.016..0.017 rows=1.00 loops=1)
   Index Cond: (userid = 10)
   Filter: ((status)::text = 'Active'::text)
   Index Searches: 1
   Buffers: shared read=2
 Planning:
   Buffers: shared hit=130 read=25
 Planning Time: 0.508 ms
 Execution Time: 0.038 ms


EXPLAIN ANALYZE SELECT * FROM GetRentHistoryByUserId(2);
 Index Scan using idxrentsuseriddatestart on rents  (cost=0.15..8.17 rows=1 width=246) (actual time=0.024..0.025 rows=2.00 loops=1)
   Index Cond: (userid = 2)
   Index Searches: 1
   Buffers: shared read=2 dirtied=1
 Planning:
   Buffers: shared hit=136 read=25
 Planning Time: 0.401 ms
 Execution Time: 0.043 ms
